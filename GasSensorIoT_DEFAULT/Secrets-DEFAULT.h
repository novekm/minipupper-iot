#include <pgmspace.h>

#define SECRET

#define THINGNAME "DEFAULT"

#define AWS_IOT_ENDPOINT        ""

#define MP_PUB_TOPIC        ""
#define MP_SUB_TOPIC        ""
#define MP_ACTION_SELF      ""

#define MP_GLOBAL_PUB_TOPIC ""
#define MP_GLOBAL_SUB_TOPIC ""
#define MP_ACTION_GLOBAL    ""

#define DATA_PUB_TOPIC          ""
#define DATA_SUB_TOPIC          ""
#define SHADOW_GET_PUB_TOPIC    ""
#define SHADOW_GET_SUB_TOPIC    ""
#define SHADOW_UPDATE_PUB_TOPIC ""

// Enter re:Invent WiFi Info Here
#define WIFI_SSID_1        ""
#define WIFI_PASSWORD_1    ""
#define WIFI_SSID_2        ""
#define WIFI_PASSWORD_2    ""
#define WIFI_SSID_3        ""
#define WIFI_PASSWORD_3    ""
#define WIFI_SSID_4        ""
#define WIFI_PASSWORD_4    ""


// Obsolete
#define DEVICE_NO "1"
#define GET_ENDPOINT_PUB_TOPIC  ""
#define GET_ENDPOINT_SUB_TOPIC  ""

// Insert AWS Root CA1 contents below
static const char AWS_CERT_CA[] PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----

-----END CERTIFICATE-----

)EOF";


// Copy contents from XXXXXXXX-certificate.pem.crt here ▼
// device certificate
static const char AWS_CERT_CRT[] PROGMEM = R"KEY(
-----BEGIN CERTIFICATE-----

-----END CERTIFICATE-----

)KEY";


// Copy contents from  XXXXXXXX-private.pem.key here ▼
// device private key
static const char AWS_CERT_PRIVATE[] PROGMEM = R"KEY(
-----BEGIN RSA PRIVATE KEY-----

-----END RSA PRIVATE KEY-----

)KEY";

