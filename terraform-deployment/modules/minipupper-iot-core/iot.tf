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
resource "aws_iot_thing" "all_minipuppers" {
  for_each = var.all_minipuppers == null ? {} : var.all_minipuppers
  name     = each.value.name
  # thing_type_name = aws_iot_thing_type.minipupper.name

  attributes = {
    short_name      = each.value.short_name
    computer_module = each.value.computer_module
  }
}
// Create IoT Thing for each Gas sensor user defines
resource "aws_iot_thing" "all_gas_sensors" {
  for_each = var.all_gas_sensors == null ? {} : var.all_gas_sensors
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
  for_each         = var.all_minipuppers == null ? {} : var.all_minipuppers
  thing_name       = each.value.name
  thing_group_name = aws_iot_thing_group.minipupper_fleet.name

  override_dynamic_group = true

  depends_on = [
    aws_iot_thing.all_minipuppers
  ]
}
// Assign Gas Sensors to IoT Thing Group
resource "aws_iot_thing_group_membership" "gas_sensors" {
  for_each         = var.all_gas_sensors == null ? {} : var.all_gas_sensors
  thing_name       = each.value.name
  thing_group_name = aws_iot_thing_group.all_gas_sensors.name

  override_dynamic_group = true

  depends_on = [
    aws_iot_thing.all_gas_sensors
  ]
}

// Create IoT Certificate Dynamically for each minipupper
resource "aws_iot_certificate" "cert_minipuppers" {
  for_each = var.all_minipuppers == null ? {} : var.all_minipuppers
  active   = true
}
// Create IoT Certificate Dynamically for each gas sensor
resource "aws_iot_certificate" "cert_gas_sensors" {
  for_each = var.all_gas_sensors == null ? {} : var.all_gas_sensors
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
// Policies have targets - these can include certificates, identities, and
// thing groups. Device certificates are installed on each ESP8266 via the
// .ino sketch. This allows the devices to use the policy and have permissions
// for what the policy permits.

// Policy Attachment - Mini Pupper
resource "aws_iot_policy_attachment" "att_minipuppers" {
  for_each = var.all_minipuppers == null ? {} : var.all_minipuppers

  policy = aws_iot_policy.pubsub_minipuppers.name
  target = aws_iot_certificate.cert_minipuppers[each.key].arn
}
// Policy Attachment - Mini Pupper
resource "aws_iot_policy_attachment" "att_gas_sensors" {
  for_each = var.all_gas_sensors == null ? {} : var.all_gas_sensors

  policy = aws_iot_policy.pubsub_gas_sensors.name
  target = aws_iot_certificate.cert_gas_sensors[each.key].arn
}
