# # AWS Current Region
# output "aws_current_region" {
#   value = "AWS Region: ${module.minipupper-iot-core.aws_current_region.name}"
# }

# # S3
# output "mpc_input_bucket" {
#   value       = module.minipupper-iot-core.mpc_input_bucket_id.id
#   description = "The name of the S3 input bucket"
# }
# output "mpc_devices_bucket" {
#   value       = module.minipupper-iot-core.mpc_devices_bucket_id.id
#   description = "The name of the S3 output bucket"
# }
# output "mpc_app_storage_bucket" {
#   value       = module.minipupper-iot-core.mpc_app_storage_bucket_id.id
#   description = "The name of the S3 app storage bucket"
# }



# # Ampclify

# # Step Function

# # IAM

# # DynamoDB

# # Cognito
# output "mpc_user_pool_region" {
#   value = module.minipupper-iot-core.mpc_user_pool_region.name
# }
# output "mpc_user_pool_id" {
#   value = module.minipupper-iot-core.mpc_user_pool_id.id
# }
# output "mpc_user_pool_client" {
#   value = module.minipupper-iot-core.mpc_user_pool_client_id.id
# }
# output "mpc_identity_pool" {
#   value = module.minipupper-iot-core.mpc_identity_pool_id.id
# }

# # AppSync (GraphQL)
# output "mpc_appsync_graphql_api_region" {
#   value = module.minipupper-iot-core.mpc_appsync_graphql_api_region.name
# }
# output "mpc_appsync_graphql_api_id" {
#   value = module.minipupper-iot-core.mpc_appsync_graphql_api_id.id
# }
# output "mpc_appsync_graphql_api_uris" {
#   value = module.minipupper-iot-core.mpc_appsync_graphql_api_uris.uris
# }

