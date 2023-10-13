# TODO - Dynamically create item for each Mini Pupper defined. Metadata should include
# ThingName/Device Name, NyBoard Version, Device Status, Battery percentage, etc.

resource "random_uuid" "mpc_devices" {
}

// Generate random device ID for each defined Mini Pupper
resource "random_uuid" "minipupper_device_id" {
  for_each = var.all_minipuppers == null ? {} : var.all_minipuppers
}
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


  # ttl {
  #   attribute_name = "TimeToExist"
  #   enabled        = false
  # }

  # Workaround for "ValidationException: TimeToLive is already disabled"
  # when running terraform apply twice
  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = local.ttl[0].ttl_attribute
    }
  }

  # global_secondary_index {
  #   name               = "GameTitleIndex"
  #   hash_key           = "GameTitle"
  #   range_key          = "TopScore"
  #   write_capacity     = 10
  #   read_capacity      = 10
  #   projection_type    = "INCLUDE"
  #   non_key_attributes = ["UserId"]
  # }

  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}


resource "aws_dynamodb_table_item" "mpc_devices_item" {
  for_each   = var.all_minipuppers == null ? {} : var.all_minipuppers
  table_name = aws_dynamodb_table.mpc_devices.name
  hash_key   = aws_dynamodb_table.mpc_devices.hash_key

  item = jsonencode({
    "${aws_dynamodb_table.mpc_devices.hash_key}" : { "S" : "${random_uuid.minipupper_device_id[each.key].result}" },
    "DeviceName" : { "S" : "${each.value.name}" },
    "ShortName" : { "S" : "${each.value.short_name}" },
    "ComputerModule" : { "S" : "${each.value.computer_module}" },
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



