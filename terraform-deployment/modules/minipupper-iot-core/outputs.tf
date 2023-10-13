# # AWS Current Region
# output "aws_current_region" {
#   value = data.aws_region.current

# }

# # S3
# output "mpc_input_bucket_id" {
#   value       = aws_s3_bucket.mpc_input_bucket
#   description = "The name of the S3 input bucket"
# }
# output "mpc_input_bucket_arn" {
#   value       = aws_s3_bucket.mpc_input_bucket
#   description = "The Arn of the S3 input bucket"
# }
# output "mpc_devices_bucket_id" {
#   value       = aws_s3_bucket.mpc_devices_bucket
#   description = "The name of the S3 output bucket"
# }
# output "mpc_devices_bucket_arn" {
#   value       = aws_s3_bucket.mpc_devices_bucket
#   description = "The Arn of the S3 input bucket"
# }
# output "mpc_app_storage_bucket_id" {
#   value       = aws_s3_bucket.mpc_app_storage_bucket
#   description = "The name of the S3 app storage bucket"
# }
# output "mpc_app_storage_bucket_arn" {
#   value       = aws_s3_bucket.mpc_app_storage_bucket
#   description = "The ARN of the S3 app storage bucket"
# }

# # Ampclify

# # Step Function
# output "mpc_step_function_arn" {
#   value = aws_sfn_state_machine.mpc_sfn_state_machine.arn

# }

# # IAM

# # DynamoDB
# output "mpc_dynamodb_output_table_name" {
#   value = aws_dynamodb_table.mpc_devices.name
# }



# # Cognito
# output "mpc_user_pool_region" {
#   value = data.aws_region.current
# }
# output "mpc_user_pool_id" {
#   value = aws_cognito_user_pool.mpc_user_pool
# }
# output "mpc_user_pool_client_id" {
#   value = aws_cognito_user_pool_client.mpc_user_pool_client
# }
# output "mpc_identity_pool_id" {
#   value = aws_cognito_identity_pool.mpc_identity_pool
# }


# # AppSync (GraphQL)
# output "mpc_appsync_graphql_api_region" {
#   value = data.aws_region.current
# }
# output "mpc_appsync_graphql_api_id" {
#   value = aws_appsync_graphql_api.mpc_appsync_graphql_api
# }
# output "mpc_appsync_graphql_api_uris" {
#   value = aws_appsync_graphql_api.mpc_appsync_graphql_api
# }
