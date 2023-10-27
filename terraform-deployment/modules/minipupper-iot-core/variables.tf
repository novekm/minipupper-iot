# SSM
variable "lookup_existing_general_ssm_parameters" {
  type    = bool
  default = false
}
variable "lookup_existing_minipuppers_ssm_parameters" {
  type    = bool
  default = false
}

variable "mpc_upload_docker_compose_to_existing_s3_bucket" {
  type    = bool
  default = false

}


# - Amplify -
variable "create_amplify_app" {
  type        = bool
  default     = true
  description = "Conditional creation of AWS Amplify Web Application"
}
variable "mpc_app_name" {
  type        = string
  default     = "mpc-App"
  description = "The name of the Amplify Application"
}
variable "mpc_enable_auto_branch_creation" {
  type        = bool
  default     = true
  description = "Enables automated branch creation for the Amplify app"

}
variable "mpc_enable_auto_branch_deletion" {
  type        = bool
  default     = true
  description = "Automatically disconnects a branch in the Amplify Console when you delete a branch from your Git repository"

}
variable "mpc_auto_branch_creation_patterns" {
  type        = list(any)
  default     = ["main", "dev", ]
  description = "Automated branch creation glob patterns for the Amplify app. Ex. feat*/*"

}
variable "mpc_enable_auto_build" {
  type        = bool
  default     = true
  description = "Enables auto-building of autocreated branches for the Amplify App."

}
variable "mpc_enable_amplify_app_pr_preview" {
  type        = bool
  default     = false
  description = "Enables pull request previews for the autocreated branch"

}
variable "mpc_enable_performance_mode" {
  type        = bool
  default     = false
  description = "Enables performance mode for the branch. This keeps cache at Edge Locations for up to 10min after changes"
}
variable "mpc_framework" {
  type        = string
  default     = "React"
  description = "Framework for the autocreated branch"

}
variable "mpc_existing_repo_url" {
  type        = string
  default     = null
  description = "URL for the existing repo"

}

variable "mpc_amplify_app_framework" {
  type    = string
  default = "React"

}
variable "create_mpc_amplify_domain_association" {
  type    = bool
  default = false

}
variable "mpc_amplify_app_domain_name" {
  type        = string
  default     = "example.com"
  description = "The name of your domain. Ex. naruto.ninja"

}


# CodeCommit
variable "mpc_create_codecommit_repo" {
  type    = bool
  default = false
}
variable "mpc_codecommit_repo_name" {
  type    = string
  default = "mpc_codecommit_repo"
}
variable "mpc_codecommit_repo_description" {
  type    = string
  default = "The CodeCommit repo created in the mpc deployment"
}
variable "mpc_codecommit_repo_default_branch" {
  type    = string
  default = "main"

}


# GitHub
variable "lookup_ssm_github_access_token" {
  type        = bool
  default     = false
  description = <<-EOF
  *ImpcORTANT!*
  Conditional data fetch of SSM parameter store for GitHub access token.
  To ensure security of this token, you must manually add it via the AWS console
  before using.
  EOF

}

variable "github_access_token" {
  type        = string
  default     = null
  description = "Optional GitHub access token. Only required if using GitHub repo."

}

variable "ssm_github_access_token_name" {
  type        = string
  default     = null
  description = "The name (key) of the SSM parameter store of your GitHub access token"

}


# GitLab Mirroring
variable "mpc_enable_gitlab_mirroring" {
  type        = bool
  default     = false
  description = "Enables GitLab mirroring to the option AWS CodeCommit repo."
}
variable "mpc_gitlab_mirroring_iam_user_name" {
  type        = string
  default     = "mpc_gitlab_mirroring"
  description = "The IAM Username for the GitLab Mirroring IAM User."
}
variable "mpc_gitlab_mirroring_policy_name" {
  type        = string
  default     = "mpc_gitlab_mirroring_policy"
  description = "The name of the IAM policy attached to the GitLab Mirroring IAM User"
}


# AppSync - GraphQL
variable "mpc_appsync_graphql_api_name" {
  type    = string
  default = "mpc-graphql-api"

}


# - IAM -

variable "create_restricted_access_roles" {
  type        = bool
  default     = true
  description = "Conditional creation of restricted access roles"

}


# - DynamoDB -
variable "dynamodb_ttl_enable" {
  type    = bool
  default = false
}
variable "dynamodb_ttl_attribute" {
  type    = string
  default = "TimeToExist"
}
variable "mpc_devices_billing_mode" {
  type    = string
  default = "PROVISIONED"
}
variable "mpc_devices_read_capacity" {
  type    = number
  default = 20

}
variable "mpc_devices_write_capacity" {
  type    = number
  default = 20

}


# - Cognito -
# User Pool
variable "mpc_user_pool_name" {
  type        = string
  default     = "mpc_user_pool"
  description = "The name of the Cognito User Pool created"
}
variable "mpc_user_pool_client_name" {
  type        = string
  default     = "mpc_user_pool_client"
  description = "The name of the Cognito User Pool Client created"
}
variable "mpc_identity_pool_name" {
  type        = string
  default     = "mpc_identity_pool"
  description = "The name of the Cognito Identity Pool created"

}
variable "mpc_identity_pool_allow_unauthenticated_identites" {
  type    = bool
  default = false
}
variable "mpc_identity_pool_allow_classic_flow" {
  type    = bool
  default = false

}
variable "mpc_email_verification_message" {
  type        = string
  default     = <<-EOF

  Thank you for registering with the Mini Pupper Control App. This is your email confirmation.
  Verification Code: {####}

  EOF
  description = "The Cognito email verification message"
}
variable "mpc_email_verification_subject" {
  type        = string
  default     = "mpc App Verification"
  description = "The Cognito email verification subject"
}
variable "mpc_invite_email_message" {
  type    = string
  default = <<-EOF
    You have been invited to the Mini Pupper Control App! Your username is "{username}" and
    tempcorary password is "{####}". Please reach out to an admin if you have issues signing in.

  EOF

}
variable "mpc_invite_email_subject" {
  type    = string
  default = <<-EOF
  Welcome to Mini Pupper Control!
  EOF

}
variable "mpc_invite_sms_message" {
  type    = string
  default = <<-EOF
    You have been invited to the Mini Pupper Control App! Your username is "{username}" and
    tempcorary password is "{####}".

  EOF

}
variable "mpc_password_policy_min_length" {
  type        = number
  default     = 8
  description = "The minimum nmber of characters for Cognito user passwords"
}
variable "mpc_password_policy_require_lowercase" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 lowercase character"

}
variable "mpc_password_policy_require_uppercase" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 uppercase character"

}
variable "mpc_password_policy_require_numbers" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 number"

}

variable "mpc_password_policy_require_symbols" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 special character"

}

variable "mpc_password_policy_temp_password_validity_days" {
  type        = number
  default     = 7
  description = "The number of days a tempc password is valid. If user does not sign-in during this time, will need to be reset by an admin"

}
# General Schema
variable "mpc_schemas" {
  description = "A container with the schema attributes of a user pool. Maximum of 50 attributes"
  type        = list(any)
  default     = []
}
# Schema (String)
variable "mpc_string_schemas" {
  description = "A container with the string schema attributes of a user pool. Maximum of 50 attributes"
  type        = list(any)
  default = [{
    name                     = "email"
    attribute_data_type      = "String"
    required                 = true
    mutable                  = false
    developer_only_attribute = false

    string_attribute_constraints = {
      min_length = 7
      max_length = 60
    }
    },
    {
      name                     = "given_name"
      attribute_data_type      = "String"
      required                 = true
      mutable                  = true
      developer_only_attribute = false

      string_attribute_constraints = {
        min_length = 1
        max_length = 25
      }
    },
    {
      name                     = "family_name"
      attribute_data_type      = "String"
      required                 = true
      mutable                  = true
      developer_only_attribute = false

      string_attribute_constraints = {
        min_length = 1
        max_length = 25
      }
    },
    {
      name                     = "IAC_PROVIDER"
      attribute_data_type      = "String"
      required                 = false
      mutable                  = true
      developer_only_attribute = false

      string_attribute_constraints = {
        min_length = 1
        max_length = 10
      }
    },
  ]
}
# Schema (number)
variable "mpc_number_schemas" {
  description = "A container with the number schema attributes of a user pool. Maximum of 50 attributes"
  type        = list(any)
  default     = []
}

# Admin Users
variable "mpc_admin_cognito_users" {
  type    = map(any)
  default = {}
}

variable "mpc_admin_cognito_user_group_name" {
  type    = string
  default = "Admin"

}
variable "mpc_admin_cognito_user_group_description" {
  type    = string
  default = "Admin Group"

}
# Standard Users
variable "mpc_standard_cognito_users" {
  type    = map(any)
  default = {}

}
variable "mpc_standard_cognito_user_group_name" {
  type    = string
  default = "Standard"

}
variable "mpc_standard_cognito_user_group_description" {
  type    = string
  default = "Standard Group"

}

# - IoT Core -
# IoT Things
variable "mpc_minipuppers" {
  type    = map(any)
  default = {}
}
variable "mpc_gas_sensors" {
  type    = map(any)
  default = {}
}

# - WiFi Information -
variable "mpc_wifi_ssid_1" {
  type        = string
  default     = ""
  description = "The SSID for the primary local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_password_1" {
  type        = string
  default     = ""
  description = "The password for the primary local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_ssid_2" {
  type        = string
  default     = ""
  description = "The SSID for the first backup local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_password_2" {
  type        = string
  default     = ""
  description = "The password for the first backup local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_password_3" {
  type        = string
  default     = ""
  description = "The password for the second backup local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_ssid_3" {
  type        = string
  default     = ""
  description = "The SSID for the second backup local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_password_4" {
  type        = string
  default     = ""
  description = "The password for the third backup local network you want MiniPupper to connect to."
  sensitive   = true

}
variable "mpc_wifi_ssid_4" {
  type        = string
  default     = ""
  description = "The SSID for the third backup local network you want MiniPupper to connect to."
  sensitive   = true

}


# Tagging
variable "tags" {
  type        = map(any)
  description = "Tags to apply to resources"
  default = {
    "IAC_PROVIDER" = "Terraform"
  }
}


