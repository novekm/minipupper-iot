// This is a template file for a deployment connected to a GitHub repo.
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
    // no spaces allowed in strings
    MiniPupper1 : {
      name            = "MiniPupper1"
      short_name      = "MP1"
      computer_module = "RaspberryPi48"
    },
    # MiniPupper2 : {
    #   name            = "MiniPupper2"
    #   short_name      = "MP2"
    #   computer_module = "RaspberryPi48"
    # },
    # MiniPupper3 : {
    #   name            = "MiniPupper3"
    #   short_name      = "MP3"
    #   computer_module = "RaspberryPi48"
    # },
    # MiniPupper4 : {
    #   name            = "MiniPupper4"
    #   short_name      = "MP4"
    #   computer_module = "RaspberryPi48"
    # },
    # MiniPupper5 : {
    #   name            = "MiniPupper5"
    #   short_name      = "MP5"
    #   computer_module = "RaspberryPi48"
    # },
    # MiniPupper6 : {
    #   name            = "MiniPupper6"
    #   short_name      = "MP6"
    #   computer_module = "RaspberryPi48"
    # },
  }
  // Enter an object for each gas sensor you would like to connect
  all_gas_sensors = {
    // no spaces allowed in strings
    Gas1 : {
      name       = "Gas1"
      short_name = "G1"
    },
    # Gas2 : {
    #   name       = "Gas2"
    #   short_name = "G2"
    # },
  }

  # - Amplify App -
  # Connect Amplify to GitHub
  mpc_existing_repo_url          = "https://github.com/your-repo-url"
  lookup_ssm_github_access_token = true                      // set to true if the resource exists in your AWS Account
  ssm_github_access_token_name   = "your-ssm-parameter-name" // name of the paramater in SSM



  # - Cognito -
  # Admin Users to create
  mpc_admin_cognito_users = {
    NarutoUzumaki : {
      username       = "nuzumaki"
      given_name     = "Naruto"
      family_name    = "Uzumaki"
      email          = "nuzumaki@hokage.com"
      email_verified = true // no touchy
    },
    SasukeUchiha : {
      username       = "suchiha"
      given_name     = "Sasuke"
      family_name    = "Uchiha"
      email          = "suchiha@chidori.com"
      email_verified = true // no touchy
    },
  }
  # Standard Users to create
  mpc_standard_cognito_users = {
    DefaultStandardUser : {
      username       = "default"
      given_name     = "Default"
      family_name    = "User"
      email          = "default@example.com"
      email_verified = true // no touchy
    }
  }
}
