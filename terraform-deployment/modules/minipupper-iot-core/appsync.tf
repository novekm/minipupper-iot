# API Data Source (Metadata DynamoDB Table)
resource "aws_appsync_datasource" "mpc_appsync_dynamodb_datasource" {
  api_id           = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  name             = "mpc_device_metadata_dynamodb_datasource"
  service_role_arn = aws_iam_role.mpc_appsync_dynamodb_restricted_access[0].arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.mpc_devices.name
  }
}

# API Data Source (MQTT Messages DynamoDB Table)
resource "aws_appsync_datasource" "mpc_mqtt_appsync_dynamodb_datasource" {
  api_id           = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  name             = "mpc_device_mqtt_dynamodb_datasource"
  service_role_arn = aws_iam_role.mpc_appsync_dynamodb_restricted_access[0].arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.mpc_devices_mqtt.name
  }
}

# API
resource "aws_appsync_graphql_api" "mpc_appsync_graphql_api" {
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = var.mpc_appsync_graphql_api_name

  user_pool_config {
    aws_region     = data.aws_region.current.name
    default_action = "ALLOW"
    user_pool_id   = aws_cognito_user_pool.mpc_user_pool.id
  }


  schema = <<EOF
type MiniPupper  @aws_auth(cognito_groups: ["Admin", "Standard"])  {
  DeviceId: String!
  DeviceName: String
  DeviceStatus: String
  ShortName: String
  Battery: Float
  ComputerModule: String
  Manufacturer: String
  Model: String
  ResiteredOwner: String
  PrimaryLocation: String
}

type MiniPuppers {
  items: [MiniPupper]
  nextToken: String
  @aws_auth(cognito_groups: ["Admin", "Standard"])
}

type GasSensor  @aws_auth(cognito_groups: ["Admin", "Standard"])  {
  DeviceId: String!
  DeviceName: String
  DeviceStatus: String
  ShortName: String
  Battery: Float
  ComputerModule: String
  Manufacturer: String
  Model: String
  ResiteredOwner: String
  PrimaryLocation: String
}

type GasSensors {
  items: [GasSensor]
  nextToken: String
  @aws_auth(cognito_groups: ["Admin", "Standard"])
}

type Query {
  // REMOVE!!!
  getAllMiniPuppers(limit: Int, nextToken: String): MiniPupperPaginated @aws_auth(cognito_groups: ["Admin", "Standard"])
  getAllMiniPuppersPaginated(limit: Int, nextToken: String): MiniPupperPaginated @aws_auth(cognito_groups: ["Admin", "Standard"])
  getOneMiniPupper(DeviceId: String!): MiniPupper @aws_auth(cognito_groups: ["Admin", "Standard"])

  listMiniPuppers(limit: Int, nextToken: String): MiniPuppers @aws_auth(cognito_groups: ["Admin", "Standard"])
  getMiniPupper(DeviceId: String!): MiniPupper @aws_auth(cognito_groups: ["Admin", "Standard"])

  listGasSensors(limit: Int, nextToken: String): GasSensors @aws_auth(cognito_groups: ["Admin", "Standard"])
  getGetGasSensor(DeviceId: String!): GasSensor @aws_auth(cognito_groups: ["Admin", "Standard"])

  listIoTMessages(limit: Int, nextToken: String): IoTMessages @aws_auth(cognito_groups: ["Admin", "Standard"])
  getIoTMessage(MessageId: String!): IoTMessage @aws_auth(cognito_groups: ["Admin", "Standard"])
  }

# type Mutation {
#   deleteOneMiniPupper(DeviceId: String!): MiniPupper
#   @aws_auth(cognito_groups: ["Admin",])
# }

schema {
  query: Query
  # mutation: Mutation
}
EOF
}

# - APPSYNC JS RESOLVERS -
# Resolvers
# UNIT type resolver (default)
# Query - Get a single Mini Pupper (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_get_minipupper" {
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "getMiniPupper"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/getMiniPupper.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - List all Mini Puppers (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_list_minipuppers" {
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "listMiniPuppers"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/listMiniPuppers.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - Get a IoT Message (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_get_iot_message" {
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_mqtt_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "getIoTMessage"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/getIoTMessage.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - List all IoT Messages (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_list_iot_messages" {
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_mqtt_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "listIoTMessages"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/listIoTMessages.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}















