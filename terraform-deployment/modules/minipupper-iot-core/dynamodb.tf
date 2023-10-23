// Generate UUID for DynamoDB Table that stores Mini Puppers Metadata
resource "random_uuid" "mpc_devices" {
}
// Generate UUID for DynamoDB Table that stores GasSensors Metadata
resource "random_uuid" "mpc_gas_sensors" {
}

// DynamoDB Table for Mini Puppers Metadata
resource "aws_dynamodb_table" "mpc_devices" {
  name           = "mpc_devices-${random_uuid.mpc_devices.result}" // No touchy
  billing_mode   = var.mpc_devices_billing_mode
  read_capacity  = var.mpc_devices_read_capacity
  write_capacity = var.mpc_devices_write_capacity
  hash_key       = "DeviceId" // Partition Key
  # range_key      = "-" // Sort Key

  attribute {
    name = "DeviceId"
    type = "S"
  }

  # Workaround for "ValidationException: TimeToLive is already disabled"
  # when running terraform apply twice
  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = local.ttl[0].ttl_attribute
    }
  }

  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}
// DynamoDB Table for GasSensors Metadata
resource "aws_dynamodb_table" "mpc_gas_sensors" {
  name           = "mpc_gas_sensors-${random_uuid.mpc_gas_sensors.result}" // No touchy
  billing_mode   = var.mpc_devices_billing_mode
  read_capacity  = var.mpc_devices_read_capacity
  write_capacity = var.mpc_devices_write_capacity
  hash_key       = "DeviceId" // Partition Key
  # range_key      = "-" // Sort Key

  attribute {
    name = "DeviceId"
    type = "S"
  }

  # Workaround for "ValidationException: TimeToLive is already disabled"
  # when running terraform apply twice
  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = local.ttl[0].ttl_attribute
    }
  }

  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}

// DynamoDB Table for MICD Devices MQTT Messages
resource "aws_dynamodb_table" "mpc_devices_mqtt" {
  name           = "mpc_devices_mqtt-${random_uuid.micd_devices_dynamodb.result}" // No touchy
  billing_mode   = var.mpc_devices_billing_mode
  read_capacity  = var.mpc_devices_read_capacity
  write_capacity = var.mpc_devices_write_capacity
  hash_key       = "MessageId" // Partition Key
  range_key      = "DeviceId"  // Sort Key

  attribute {
    name = "MessageId"
    type = "S"
  }
  attribute {
    name = "DeviceId"
    type = "S"
  }

  # Workaround for "ValidationException: TimeToLive is already disabled"
  # when running terraform apply twice
  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = local.ttl[0].ttl_attribute
    }
  }

  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}

# Create item in DynamoDB table for each defined Mini Pupper
resource "aws_dynamodb_table_item" "mpc_devices_item" {
  for_each   = var.all_minipuppers == null ? {} : var.all_minipuppers
  table_name = aws_dynamodb_table.mpc_devices.name
  hash_key   = aws_dynamodb_table.mpc_devices.hash_key

  item = jsonencode({
    # "${aws_dynamodb_table.mpc_devices.hash_key}" : { "S" : "${random_uuid.minipupper_device_id[each.key].result}" },
    "${aws_dynamodb_table.mpc_devices.hash_key}" : { "S" : "${each.value.name}_${each.value.short_name}" },
    "DeviceName" : { "S" : "${each.value.name}" },
    "ShortName" : { "S" : "${each.value.short_name}" },
    "ComputerModule" : { "S" : "${each.value.computer_module}" },
    "Manufacturer" : { "S" : "${each.value.manufacturer}" },
    "Model" : { "S" : "${each.value.model}" },
    "RegisteredOwner" : { "S" : "${each.value.registered_owner}" },
    "PrimaryLocation" : { "S" : "${each.value.primary_location}" },
  })
}

# resource "aws_dynamodb_table" "customer_table" {
# name           = "customer"
# billing_mode   = "PAY_PER_REQUEST"
# hash_key       = "customerId"
# stream_enabled = false
# attribute {
#   name = "customerId"
#   type = "S"
#  }
# }

# resource "aws_dynamodb_table_item" "customer_table_item" {
#   table_name = aws_dynamodb_table.customer_table.name
#   hash_key   = aws_dynamodb_table.customer_table.hash_key
#   depends_on = [aws_dynamodb_table.customer_table]
#   item = jsonencode({
#   "customerId" : {
#     "S" : "1"
#  },
#   "firstName" : {
#     "S" : "John"
#   },
#   "lastName" : {
#     "S" : "Doe"
#   },
# })
# }



