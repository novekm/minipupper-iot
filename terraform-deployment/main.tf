// This is a tempclate file for a basic deployment.
// Modify the parameters below with actual values
module "minipupper-iot-core" {
  // location of the module - can be local or git repo
  source = "./modules/minipupper-iot-core"

  # - Network information -
  // note - for added security, eventually these could be values stored in parameter store
  // however that would require users to manually enter them before deploying the terraform code.

  # Primary WiFi - REQUIRED
  mpc_wifi_ssid_1     = "" // enter SSID for the primary local network you want devices to connect to
  mpc_wifi_password_1 = "" // enter password for the primary local network you want devices to connect to
  # Backup 1 - Optional
  # mpc_wifi_ssid_2     = ""    // enter SSID for the local network you want devices to connect to
  # mpc_wifi_password_2 = "" // enter password for the local network you want devices to connect to
  # Backup 2 - Optional
  # mpc_wifi_ssid_3     = ""    // enter SSID for the local network you want devices to connect to
  # mpc_wifi_password_3 = "" // enter password for the local network you want devices to connect to
  # Backup 3 - Optional
  # mpc_wifi_ssid_4     = ""           // enter SSID for the local network you want devices to connect to
  # mpc_wifi_password_4 = "" // enter password for the local network you want devices to connect to

  # - IoT -
  # Dynamic Creation of IoT Things for Mini Puppers and Gas Sensors

  // Enter an object for each Mini Pupper you would like to connect
  all_minipuppers = {
    MiniPupper1 : {
      // no spaces allowed in strings
      name             = "MiniPupper1"
      short_name       = "MP1"
      computer_module  = "RaspberryPi48"
      manufacturer     = "Mangdang"
      model            = "Mini Pupper 2"
      registered_owner = "John Smith"
      primary_location = "HOU14"
    },
    MiniPupper2 : {
      name             = "MiniPupper2"
      short_name       = "MP2"
      computer_module  = "RaspberryPi48"
      manufacturer     = "Mangdang"
      model            = "Mini Pupper 2"
      registered_owner = "John Smith"
      primary_location = "HOU14"
    },
    MiniPupper3 : {
      name             = "MiniPupper3"
      short_name       = "MP3"
      computer_module  = "RaspberryPi48"
      manufacturer     = "Mangdang"
      model            = "Mini Pupper 2"
      registered_owner = "John Smith"
      primary_location = "HOU14"
    },

  }
  // Enter an object for each gas sensor you would like to connect
  all_gas_sensors = {
    // no spaces allowed in strings
    Gas1 : {
      name             = "Gas1"
      short_name       = "G1"
      computer_module  = "ESP32"
      manufacturer     = "M5Stack"
      model            = "M5StickC-Plus"
      registered_owner = "Lee Jeknis"
      primary_location = "HOU16"
    },
    # Gas2 : {
    #   name       = "Gas2"
    #   short_name = "G2"
    # },
  }

  # - Cognito -
  # Admin Users to create
  mpc_admin_cognito_users = {
    // replace with your desired cognito users
    NarutoUzumaki : {
      username       = "nuzumaki"
      given_name     = "Naruto"
      family_name    = "Uzumaki"
      email          = "nuzumaki@hokage.com"
      email_verified = true // no touchy
    },
    # SasukeUchiha : {
    #   username       = "suchiha"
    #   given_name     = "Sasuke"
    #   family_name    = "Uchiha"
    #   email          = "suchiha@chidori.com"
    #   email_verified = true // no touchy
    # },
  }
  # Standard Users to create
  # mpc_standard_cognito_users = {
  #   // replace with your desired cognito users
  #   DefaultStandardUser : {
  #     username       = "default"
  #     given_name     = "Default"
  #     family_name    = "User"
  #     email          = "default@example.com"
  #     email_verified = true // no touchy
  #   }
  # }
}
