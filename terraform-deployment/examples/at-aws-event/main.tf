// This is a tempclate file for a basic deployment.
// Modify the parameters below with actual values
module "minipupper-iot-core" {
  // location of the module - can be local or git repo
  source = "./modules/minipupper-iot-core"

  # - Network Information -
  # Note: For added security, eventually these values could be stored in SSM parameter store,
  # and fetched via SSM Data Sources. However, that would require users to manually enter these
  # values before running Terraform apply to provision resources.
  # however that would require users to manually enter them before deploying the Terraform code.
  # For production workloads, we strongly advise against hardcoding sensitive values.

  # Primary WiFi - REQUIRED
  mpc_wifi_ssid_1     = "" // enter SSID for the primary local network you want devices to connect to
  mpc_wifi_password_1 = "" // enter password for the primary local network you want devices to

  # Conditional Data Source fetch of existing values in SSM Parameter store.
  # Note: Only use these variables if at an AWS Event, or you modify the module to use your own parameters.
  # If not at an AWS Event (using a provided AWS account) these values will not exist in your account
  # and the lookup will fail and throw and error.

  lookup_existing_general_ssm_parameters     = true
  lookup_existing_minipuppers_ssm_parameters = true


  # - IoT -
  # Dynamic Creation of IoT Things for Mini Puppers and Gas Sensors
  // Enter an object for each Mini Pupper you would like to connect/register
  mpc_gas_sensors = {
    // no spaces allowed in strings
    Gas1 : {
      name             = "Gas1"
      short_name       = "G1"
      computer_module  = "ESP32"
      manufacturer     = "M5Stack"
      model            = "M5StickC-Plus"
      device           = "Gas Sensor"
      registered_owner = "Lee Jeknis"
      primary_location = "re:Invent"
    },
    # Gas2 : {
    #   name             = "Gas2"
    #   short_name       = "G2"
    #   computer_module  = "ESP32"
    #   manufacturer     = "M5Stack"
    #   model            = "M5StickC-Plus"
    #   device           = "Gas Sensor"
    #   registered_owner = "Lee Jeknis" // Your Name
    #   primary_location = "re:Invent"
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