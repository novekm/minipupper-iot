# - Data Sources -

# AWS - General
# Current AWS Region (for assumed identity)
data "aws_region" "current" {}
# Current AWS assumed identity (e.g. Role, IAM User, etc.)
data "aws_caller_identity" "current" {}
# .account_id - Account Id for assumed identity (e.g. data.aws_caller_identity.current.account_id)
# .arn - ARN for assumed identity (e.g. data.aws_caller_identity.current.arn)
# .user_id - User Id for assumed identity (e.g. data.aws_caller_identity.current.user_id)

# AWS IoT Endpoint (Data-ATS)
data "aws_iot_endpoint" "current" {
  endpoint_type = "iot:Data-ATS"
}

# Existing Mini Pupper SSM Parameters (Only relevant at an AWS Event)
data "aws_ssm_parameter" "mpc_existing_s3_bucket_ssm" {
  count = var.lookup_existing_general_ssm_parameters ? 1 : 0
  name  = "S3BucketName"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_thing_name_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperThingName"
}
data "aws_ssm_parameter" "mpc_existing_minipupper_device_id_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperDeviceId"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_device_name_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperDevice"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_short_name_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperShortName"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_computer_module_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperComputerModule"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_manfacturer_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperManufacturer"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_model_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperModel"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_device_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperDevice"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_registered_owner_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperRegisteredOwner"
}

data "aws_ssm_parameter" "mpc_existing_minipupper_primary_location_ssm" {
  count = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
  name  = "MiniPupperPrimaryLocation"
}

# GitHub Access Token (SSM Parameter) - Must exist in AWS account already
data "aws_ssm_parameter" "ssm_github_access_token" {
  count = var.lookup_ssm_github_access_token ? 1 : 0
  name  = var.ssm_github_access_token_name
}

