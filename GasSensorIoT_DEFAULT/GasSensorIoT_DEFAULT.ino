// Includes
#include <M5StickCPlus.h>
#include <Wire.h>
#include <Adafruit_SGP30.h>
#include <ArduinoJson.h>
#include <time.h>
#include <WiFiClientSecure.h>
#include <MQTTClient.h>
#include "Secrets-DEFAULT.h"

// NEW - OTA
#include <ElegantOTA.h>
// #include <WiFi.h>
// #include <WiFiClient.h>
#include <WebServer.h>

// Define parameters
#define SAMPLE_PERIOD   1  // Frequency to send telemetry updates, seconds
#define ALARM_OFF   false  // Value for no alarm
#define ALARM        true  // Value for alarm state
#define SENSOR_MAX  60000  // Max reading of gas sensor, used for converting to %
#define BATTERY_MIN  2300  // Min capacity reading of battery
#define BATTERY_MAX  2888  // Max capacity reading of battery
#define NET_DISC     "WiFi Disc"      // Text to display when WiFi is disconnected
#define NET_WIFI     "AWS Disc"       // WiFI connected, AWS disconnected
#define NET_AWS      "AWS Connected"  // WiFi/AWS is connected

// Init clients
WiFiClientSecure wifi_client = WiFiClientSecure();
MQTTClient mqtt_client = MQTTClient(1024);
Adafruit_SGP30 sgp;

WebServer server(80);

// Init variables
const char*     ntpServer        = "pool.ntp.org";    // Where to get NTP time, needed for TimeStream or SiteWise
const long      gmtOffset_sec    = 0;
const int       daylightOffset_sec = 3600;            // Offset correction for time
static uint16_t alarm_threshold  = 10;                // Threshold to go into alarm state locally
static bool     alarm_local      = false;             // Is device in alarm due to local sensor readings
static bool     alarm_remote     = false;             // Is there an alarm from another device
static float    gas_reading      = 0;                 // Current sensor readings
long int        start_time       = millis();
const char*     endpoint         = AWS_IOT_ENDPOINT;  // Phone-home endpoint
bool            got_endpoint     = true;              // Did I get a new endpoint yet
int             battery_capacity = -1;                // Battery capacity from device
int             battery_level    = -1;                // estimate battery percentage, very inaccurate
const char*     network_state    = NET_DISC;          // Network state to write on screen
bool            alarm_actioned   = false;             // Keep track if alarm has sent MiniPupper command yet
bool            alarm_prev       = false;             // Used to track when alarm is reset

// Define task handle names
TaskHandle_t CommunicationTaskHandle;     // Handles all WiFi and AWS connectivity and communication
TaskHandle_t SensorTaskHandle;            // Handles sensor readings
TaskHandle_t ButtonTaskHandle;            // Handles button presses, M5 button (on front) resets device

// const char* local_ip = WiFi.localIP().to;
// IPAddress local_ip = WiFi.localIP();


///////////////////////////////////////////////////////////////////////////////
// Setup

void setup(){
    Serial.begin(115200);
    M5.begin();  // Init M5StickCPlus

    // LCD display setup
    M5.Axp.ScreenBreath(15);
    M5.Lcd.setRotation(3);
    M5.Lcd.setTextSize(2);
    M5.Lcd.fillScreen(WHITE);
    M5.Lcd.setTextColor(BLACK);
    M5.Lcd.setCursor(10, 10);
    M5.Lcd.printf(THINGNAME);
    // M5.Lcd.printf(WiFi.localIP().c_str());

    M5.Lcd.setCursor(10, 50);
    M5.Lcd.print("Startup");

    // Init and get the time
    configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);

    // Start tasks
    xTaskCreatePinnedToCore(CommunicationTask, "CommunicationTask", 10000, NULL, 0, &CommunicationTaskHandle, 1);
    xTaskCreatePinnedToCore(SensorTask, "SensorTask", 10000, NULL, 0, &SensorTaskHandle, 0);
    xTaskCreatePinnedToCore(ButtonTask, "ButtonTask", 10000, NULL, 0, &ButtonTaskHandle, 0);
}


///////////////////////////////////////////////////////////////////////////////
// Loop & Tasks

// Using main loop for display and other misc tasks
void loop() {
  M5.Axp.ScreenBreath(15);

  // NEW - OTA
  server.handleClient();
  ElegantOTA.loop();

    // Set alarm state and configure LCD color and message
    if (alarm_local != alarm_prev) {
        if (!alarm_local) {
            alarm_actioned = false;
        }
    }
    alarm_prev = alarm_local;

    if(gas_reading > alarm_threshold) {
        alarm_local = ALARM;
        // M5.Axp.ScreenBreath(10);
        M5.Lcd.fillScreen(RED);
        M5.Lcd.setTextColor(WHITE);
        M5.Lcd.setCursor(120, 10, 2);
        M5.Lcd.printf("Danger!");
    } else if(alarm_remote == ALARM) {
        alarm_local = ALARM_OFF;
        // M5.Axp.ScreenBreath(10);
        M5.Lcd.fillScreen(YELLOW);
        M5.Lcd.setTextColor(BLACK);
        M5.Lcd.setCursor(120, 10, 2);
        M5.Lcd.printf("Caution!");
    } else {
        alarm_local = ALARM_OFF;
        // M5.Axp.ScreenBreath(10);
        M5.Lcd.fillScreen(GREEN);
        M5.Lcd.setTextColor(BLACK);
        M5.Lcd.setCursor(120, 10, 2);
        M5.Lcd.printf("Safe");
    }

    // Update Display
    M5.Lcd.setCursor(10, 10, 1);
    M5.Lcd.printf(THINGNAME);
    M5.Lcd.setCursor(10, 50, 1);
    M5.Lcd.printf("Gas: %3d/%3d", (uint16_t) gas_reading, (uint16_t) alarm_threshold);

    // // Battery reporting
    // battery_capacity = M5.Axp.GetVapsData();
    // if (battery_capacity < BATTERY_MIN) {battery_level = 0;}
    // else if (battery_capacity > BATTERY_MAX) {battery_level = 100;}
    // else {battery_level = ((battery_capacity - BATTERY_MIN) * 100) / (BATTERY_MAX - BATTERY_MIN);}
    // M5.Lcd.setCursor(10, 70, 1);
    // M5.Lcd.printf("IP: %3d/%3d", (uint16_t) battery_level, (uint16_t) battery_capacity);

    M5.Lcd.setCursor(10, 70, 1);
    M5.Lcd.printf("IP: ");
    M5.Lcd.print(WiFi.localIP().toString());

    // Network state
    M5.Lcd.setCursor(10, 90, 1);
    M5.Lcd.printf("Net: ");
    M5.Lcd.printf(network_state);

    // Wait before doing another loop
    delay(SAMPLE_PERIOD * 1000);
}


// Task for communicating with AWS
void CommunicationTask(void * parameter) {
    connectWiFi();
    //getEndpoint();
    connectAWS();

    for(;;) {
        // If Wifi loses connection, reconnect
        while (WiFi.status() != WL_CONNECTED){
            network_state = NET_DISC;
            Serial.print("WiFi disconnected, reconnecting to WiFi.");
            connectWiFi();
            delay(500);
        }
        network_state = NET_WIFI;

        // If lost connection to AWS, reconnect
        if(!mqtt_client.connected()){
            network_state = NET_WIFI;
            Serial.print("AWS disconnected, reconnecting to AWS.");
            connectAWS();
            delay(500);
        }
        network_state = NET_AWS;

        // Publish message to AWS
        publishMessage();

        // Request shadow
        triggerShadowGet();

        // Pull any messages on subscribed topics
        mqtt_client.loop();

        if (alarm_local) {
            if (!alarm_actioned) {
                publishActionSelf();
                delay(1000);
                publishActionGlobal();

                alarm_actioned = true;
            }
        }

        delay(SAMPLE_PERIOD * 1000);
    }
}


// Task for reading sensors
void SensorTask(void * parameter) {
      //Init the VOC sensor
    if (!sgp.begin()){
        M5.Lcd.println("Sensor not found");
        delay(1000);
    }

    for(;;) {
        // Commands the sensor to take a single eCO2/VOC measurement.
        if(! sgp.IAQmeasure()) {
            Serial.println("Measurement failed");
        }

        gas_reading = (sgp.TVOC * 100) / SENSOR_MAX;
        //Serial.print("TVOC="); Serial.println(sgp.TVOC);

        delay(SAMPLE_PERIOD * 1000);
    }
}


// Task for responding to buttons
void ButtonTask(void * parameter) {
    // Buttons
    pinMode(M5_BUTTON_HOME,INPUT_PULLUP);

    for(;;) {
        // Buttons
        if(digitalRead(M5_BUTTON_HOME) == LOW){
            ESP.restart();
        }

        delay(10);
    }
}


///////////////////////////////////////////////////////////////////////////////
// Functions

// Connects/Reconnects WiFi
void connectWiFi() {
    Serial.print("Connecting to Wi-Fi");

    WiFi.mode(WIFI_STA);

    int n = WiFi.scanNetworks();
    Serial.print(n); Serial.println(" network(s) found: ");
    // NEW - OTA
    // Print IP Address to Serial Monitor
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
    // Display message when visiting ESP32 Server via IP Address
    server.on("/", []() {
      server.send(200, "text/plain", "Welcome to Gas Sensor OTA Update Portal. To get started, visit <IP ADDRESS>/update.");
    });
    ElegantOTA.begin(&server); // Start ElegantOta
    server.begin();
    Serial.println("HTTP server started");


    for(int i = 0; i < n; i++) {
        Serial.print(i+1); Serial.print(". "); Serial.println(WiFi.SSID(i));
    }

    for(int i = 0; i < n; i++) {
        if(WiFi.SSID(i) == WIFI_SSID_1) {
            Serial.print("Connecting to "); Serial.print(WiFi.SSID(i));
            WiFi.begin(WIFI_SSID_1, WIFI_PASSWORD_1);
            while (WiFi.status() != WL_CONNECTED){
                delay(1000);
                Serial.print(".");
            }
            Serial.println("Wi-Fi connected!");
            Serial.print("IP Address: ");
            Serial.println(WiFi.localIP());
            network_state = NET_WIFI;
            return;
        } else if(WiFi.SSID(i) == WIFI_SSID_2) {
            Serial.print("Connecting to "); Serial.print(WiFi.SSID(i));
            WiFi.begin(WIFI_SSID_2, WIFI_PASSWORD_2);
            while (WiFi.status() != WL_CONNECTED){
                delay(1000);
                Serial.print(".");
            }
            Serial.println("Wi-Fi connected!");
            Serial.println("Wi-Fi connected!");
            Serial.print("IP Address: ");
            Serial.println(WiFi.localIP());
            network_state = NET_WIFI;
            return;
        } else if(WiFi.SSID(i) == WIFI_SSID_3) {
            Serial.print("Connecting to "); Serial.print(WiFi.SSID(i));
            WiFi.begin(WIFI_SSID_3, WIFI_PASSWORD_3);
            while (WiFi.status() != WL_CONNECTED){
                delay(1000);
                Serial.print(".");
            }
            Serial.println("Wi-Fi connected!");
            Serial.println("Wi-Fi connected!");
            Serial.print("IP Address: ");
            Serial.println(WiFi.localIP());
            network_state = NET_WIFI;
            return;
        } else if(WiFi.SSID(i) == WIFI_SSID_4) {
            Serial.print("Connecting to "); Serial.print(WiFi.SSID(i));
            WiFi.begin(WIFI_SSID_4, WIFI_PASSWORD_4);
            while (WiFi.status() != WL_CONNECTED){
                delay(1000);
                Serial.print(".");
            }
            Serial.println("Wi-Fi connected!");
            Serial.println("Wi-Fi connected!");
            Serial.print("IP Address: ");
            Serial.println(WiFi.localIP());
            network_state = NET_WIFI;
            return;
        }
    }
}


// Phone's home and gets a new endpoint
void getEndpoint() {
    // Configure WiFiClientSecure to use the AWS IoT device credentials
    wifi_client.setCACert(AWS_CERT_CA);
    wifi_client.setCertificate(AWS_CERT_CRT);
    wifi_client.setPrivateKey(AWS_CERT_PRIVATE);

    // Connect to the MQTT broker on the AWS endpoint we defined earlier
    mqtt_client.begin(AWS_IOT_ENDPOINT, 8883, wifi_client);

    // Create a message handler
    mqtt_client.onMessage(messageHandler);

    Serial.print("Connecting to AWS IOT for new endpoint");

    while (!mqtt_client.connect(THINGNAME)) {
        Serial.print(".");
        delay(100);
    }
    Serial.println("AWS IoT Connected!");

    // Subscribe to topic for new endpoint
    mqtt_client.subscribe(GET_ENDPOINT_SUB_TOPIC);

    // Craft message with needed values
    StaticJsonDocument<1024> doc;
    doc["device_id"] = THINGNAME;
    doc["device_no"] = DEVICE_NO;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer); // print to client
    mqtt_client.publish(GET_ENDPOINT_PUB_TOPIC, jsonBuffer);

    // Wait until received new endpoint before returning
    Serial.print("Waiting for endpoint response");
    while(!got_endpoint) {
        Serial.print(".");
        mqtt_client.loop();
        delay(500);
    }
    Serial.println("Got new endpoint.");
}


// Connect/reconnect to AWS
void connectAWS() {
    // Configure WiFiClientSecure to use the AWS IoT device credentials
    wifi_client.setCACert(AWS_CERT_CA);
    wifi_client.setCertificate(AWS_CERT_CRT);
    wifi_client.setPrivateKey(AWS_CERT_PRIVATE);

    // Connect to the MQTT broker on the AWS endpoint we defined earlier
    mqtt_client.begin(endpoint, 8883, wifi_client);

    // Create a message handler
    mqtt_client.onMessage(messageHandler);

    Serial.print("Connecting to AWS IOT");

    while (!mqtt_client.connect(THINGNAME)) {
        Serial.print(".");
        delay(100);
    }

    if(!mqtt_client.connected()){
        Serial.println("AWS IoT Timeout!");
        return;
    }

    // Subscribe to a topic
    mqtt_client.subscribe(SHADOW_GET_SUB_TOPIC);

    Serial.println("AWS IoT Connected!");
    network_state = NET_AWS;
}


// Publish message to AWS IoT with sensor readings and other info
void publishMessage() {
    StaticJsonDocument<1024> doc;

    doc["device_id"]        = THINGNAME;
    doc["time"]             = GetEpochTime();
    doc["gas_reading"]      = gas_reading;
    doc["alarm_local"]      = alarm_local;
    doc["alarm_threshold"]  = alarm_threshold;
    doc["battery_capacity"] = battery_capacity;
    doc["battery_level"]    = battery_level;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer); // print to client

    mqtt_client.publish(DATA_PUB_TOPIC, jsonBuffer);
}


// Publish message to assigned MiniPupper
void publishActionSelf() {
    StaticJsonDocument<1024> doc;

    doc["message"] = MP_ACTION_SELF;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer); // print to client

    mqtt_client.publish(MP_SUB_TOPIC, jsonBuffer);
}


// Publish message to MiniPupper group
void publishActionGlobal() {
    StaticJsonDocument<1024> doc;

    doc["message"] = MP_ACTION_GLOBAL;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer); // print to client

    mqtt_client.publish(MP_GLOBAL_SUB_TOPIC, jsonBuffer);
}


// Send message to Shadow Get topic to illicit a response with shadow data
void triggerShadowGet() {
    StaticJsonDocument<1024> doc;
    doc["device_id"] = THINGNAME;
    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer); // print to client
    mqtt_client.publish(SHADOW_GET_PUB_TOPIC, jsonBuffer);
}


// Handles incoming messages from subscribed topics
void messageHandler(String &topic, String &payload) {
    //Serial.println("Incoming: " + topic + " - " + payload);
    StaticJsonDocument<1024> doc;
    deserializeJson(doc, payload);

    // Handle shadow messages
    if(topic == SHADOW_GET_SUB_TOPIC) {
        alarm_remote = doc["state"]["desired"]["alarm_remote"];
        alarm_threshold = doc["state"]["desired"]["alarm_threshold"];
    }

    // Handle new endpoint message
    if(topic == GET_ENDPOINT_SUB_TOPIC) {
        endpoint = doc["endpoint"];
        got_endpoint = true;
    }
}


// Function that gets current epoch time
unsigned long GetEpochTime() {
    time_t now;
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
        //Serial.println("Failed to obtain time");
        return(0);
    }
    time(&now);
    return now;
}

