// Takes a long time when destroying. On AWS side, ThingType is marked as 'deprecated'
// and cane take some time to be deleted after (around 4-5min)
// Create IoT Thing Type for all Mini Puppers
# resource "aws_iot_thing_type" "minipupper" {
#   name = "MiniPupper"
#   properties {
#     description = "Mini Puppper Robotic Dog"

#   }

#   tags = merge(
#     # {
#     #   "AppName" = var.mpc_app_name
#     # },
#     var.tags,
#   )

# }

// Create IoT Thing for each Mini Pupper user defines
resource "aws_iot_thing" "mpc_minipuppers" {
  for_each = var.mpc_minipuppers == null ? {} : var.mpc_minipuppers
  name     = each.value.name
  # thing_type_name = aws_iot_thing_type.minipupper.name

  attributes = {
    short_name      = each.value.short_name
    computer_module = each.value.computer_module
  }
}
// Create IoT Thing for each Gas sensor user defines
resource "aws_iot_thing" "all_gas_sensors" {
  for_each = var.mpc_gas_sensors == null ? {} : var.mpc_gas_sensors
  name     = each.value.name
  # thing_type_name = aws_iot_thing_type.minipupper.name

  attributes = {
    short_name = each.value.short_name
  }
}

// Create IoT Thing Group for all Mini Puppers
resource "aws_iot_thing_group" "minipupper_fleet" {
  name = "MiniPupper_Fleet"
  properties {
    description = "Group containing all Mini Puppers."
  }
}
// Create IoT Thing Group for all gas sensors
resource "aws_iot_thing_group" "all_gas_sensors" {
  name = "All_Gas_Sensors"
  properties {
    description = "Group containing all Gas Sensors."
  }
}

// Assign Mini Puppers to IoT Thing Group
resource "aws_iot_thing_group_membership" "minipupper_fleet" {
  for_each         = var.mpc_minipuppers == null ? {} : var.mpc_minipuppers
  thing_name       = each.value.name
  thing_group_name = aws_iot_thing_group.minipupper_fleet.name

  override_dynamic_group = true

  depends_on = [
    aws_iot_thing.mpc_minipuppers
  ]
}

# Existing Mini Puppers (Only used if at AWS Workshop)
# TODO - Uncomment this if at AWS Event
# resource "aws_iot_thing_group_membership" "minipupper_fleet_existing_minipupper" {
#   count            = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
#   thing_name       = data.aws_ssm_parameter.mpc_existing_minipupper_thing_name_ssm[0].value
#   thing_group_name = aws_iot_thing_group.minipupper_fleet.name

#   override_dynamic_group = true

#   # depends_on = [
#   #   aws_iot_thing.mpc_minipuppers
#   # ]
# }
// Assign Gas Sensors to IoT Thing Group
resource "aws_iot_thing_group_membership" "mpc_gas_sensors" {
  for_each         = var.mpc_gas_sensors == null ? {} : var.mpc_gas_sensors
  thing_name       = each.value.name
  thing_group_name = aws_iot_thing_group.all_gas_sensors.name

  override_dynamic_group = true

  depends_on = [
    aws_iot_thing.all_gas_sensors
  ]
}

// Create IoT Certificate Dynamically for each minipupper
resource "aws_iot_certificate" "cert_minipuppers" {
  for_each = var.mpc_minipuppers == null ? {} : var.mpc_minipuppers
  active   = true
}
// Create IoT Certificate Dynamically for each gas sensor
resource "aws_iot_certificate" "cert_gas_sensors" {
  for_each = var.mpc_gas_sensors == null ? {} : var.mpc_gas_sensors
  active   = true
}

// Create IoT Policy - Mini Puppers
resource "aws_iot_policy" "pubsub_minipuppers" {
  name = "MiniPupperPubSubToAnyTopic"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
// Create IoT Policy - Gas Sensors
resource "aws_iot_policy" "pubsub_gas_sensors" {
  name = "GasSensorPubSubToAnyTopic"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
// Policies have targets - currently these can include certificates, identities, and
// thing groups. Device certificates are installed on each Gas Sensor via the
// .ino sketch. This allows the devices to use the policy and have permissions
// for what the policy permits.

// Policy Attachment - Mini Pupper
resource "aws_iot_policy_attachment" "att_minipuppers" {
  for_each = var.mpc_minipuppers == null ? {} : var.mpc_minipuppers

  policy = aws_iot_policy.pubsub_minipuppers.name
  target = aws_iot_certificate.cert_minipuppers[each.key].arn
}
// Policy Attachment - Mini Pupper
resource "aws_iot_policy_attachment" "att_gas_sensors" {
  for_each = var.mpc_gas_sensors == null ? {} : var.mpc_gas_sensors

  policy = aws_iot_policy.pubsub_gas_sensors.name
  target = aws_iot_certificate.cert_gas_sensors[each.key].arn
}


# Create IoT Rule to send MQTT from AWS IoT to DynamoDB Table
resource "aws_iot_topic_rule" "mpc_devices_iot_to_dynamodb" {
  name        = "IOT_TO_DYNAMODB"
  description = "IoT Rule to send MQTT from AWS IoT to DynamoDB Table"
  enabled     = true
  # sql         = "SELECT * FROM '${var.iot_topic_prefix}/1'"
  sql = "SELECT * FROM 'device/+/+'"

  sql_version = "2016-03-23"

  dynamodbv2 {
    put_item {
      table_name = aws_dynamodb_table.mpc_devices_mqtt.name
    }
    role_arn = aws_iam_role.mpc_iot_to_dynamodb_restricted_access[0].arn
  }

}
