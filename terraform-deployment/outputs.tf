#  MODULE OUTPUTS - Only used at AWS Events. These values reference pre-existing
# SSM Parameter Store values that will exist in the provided AWS account.
# These outputs are dynamically generated if the following variables are defined in main.tf:

# lookup_existing_general_ssm_parameters = true
# lookup_existing_minipuppers_ssm_parameters = true

output "mpc_existing_s3_bucket_ssm" {
  value = module.minipupper-iot-core.mpc_existing_s3_bucket_ssm
}

output "mpc_existing_minipupper_thing_name_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_thing_name_ssm
}
output "mpc_existing_minipupper_device_id_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_device_id_ssm
}

output "mpc_existing_minipupper_device_name_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_device_name_ssm
}

output "mpc_existing_minipupper_short_name_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_short_name_ssm
}

output "mpc_existing_minipupper_computer_module_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_computer_module_ssm
}

output "mpc_existing_minipupper_manfacturer_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_manfacturer_ssm
}

output "mpc_existing_minipupper_model_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_model_ssm
}

output "mpc_existing_minipupper_device_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_device_ssm
}

output "mpc_existing_minipupper_registered_owner_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_registered_owner_ssm
}

output "mpc_existing_minipupper_primary_location_ssm" {
  value = module.minipupper-iot-core.mpc_existing_minipupper_primary_location_ssm
}
