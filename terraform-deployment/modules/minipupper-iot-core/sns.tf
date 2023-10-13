# #  TODO - Create SNS notification for and failed jobs
# resource "aws_sns_topic" "mpc_sfn_status" {
#   # count = var.mpc_enable_sns ? 1 : 0
#   name = "mpc_sfn_status"
# }

# // ImpcORTANT - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
# resource "aws_sns_topic_subscription" "mpc_sfn_status_sqs_target" {
#   # count     = var.mpc_enable_sns ? 1 : 0
#   topic_arn = aws_sns_topic.mpc_sfn_status.arn
#   protocol  = "email"
#   # protocol  = "email-json"
#   endpoint = var.mpc_sns_email_endpoint
# }
