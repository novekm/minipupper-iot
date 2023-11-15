# TODO - Add descriptions to all Roles, and Policies
# --- TRUST RELATIONSHIPS ---
# Cognito Trust Relationship (AuthRole)
data "aws_iam_policy_document" "mpc_cognito_authrole_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
  }
}
# Cognito Trust Relationship (UnauthRole)
data "aws_iam_policy_document" "mpc_cognito_unauthrole_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
  }
}
# Cognito Admin Group Trust Relationship
data "aws_iam_policy_document" "mpc_cognito_admin_group_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
  }
}
# Cognito Standard Group Trust Relationship
data "aws_iam_policy_document" "mpc_cognito_standard_group_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.mpc_identity_pool.id]
    }
  }
}
# AppSync Trust Relationship
data "aws_iam_policy_document" "mpc_appsync_trust_relationship" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}
# Amplify Trust Relationship
data "aws_iam_policy_document" "mpc_amplify_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}
# IoT Trust Relationship
data "aws_iam_policy_document" "mpc_iot_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["iot.amazonaws.com"]
    }
  }
}


# NEW
# IoT CredentialsTrust Relationship
data "aws_iam_policy_document" "mpc_iot_credentials_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["credentials.iot.amazonaws.com"]
    }
  }
}



# --- CUSTOMER MANAGED POLICIES (RESTRICTED ACCESS) ---
# - IoT Policies -
# Policy to allow AWS IoT Rule to PutItem in MPC MQTT DynamoDB Table
data "aws_iam_policy_document" "mpc_iot_to_dynamodb_restricted_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:PutItem"]
    resources = [aws_dynamodb_table.mpc_devices_mqtt.arn]
  }
}
resource "aws_iam_policy" "mpc_iot_to_dynamodb_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "mpc_iot_to_dynamodb_restricted_access_policy"
  description = "Policy granting DynamoDB 'PutItem' access for the mpc_devices_mqtt DynamoDB table."
  policy      = data.aws_iam_policy_document.mpc_iot_to_dynamodb_restricted_access_policy.json
}




# NEW
# Policy to allow for GreenGrassV2TokenExchange FIRST
data "aws_iam_policy_document" "mpc_greengrass_v2_token_exchange" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation",
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "mpc_greengrass_v2_token_exchange_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "GreengrassV2TokenExchangeRoleAccess"
  description = "First Policy for GreengrassV2TokenExchangeRole."
  policy      = data.aws_iam_policy_document.mpc_greengrass_v2_token_exchange.json
}
# Policy to allow for GreenGrassV2TokenExchange SECOND
data "aws_iam_policy_document" "mpc_greengrass_v2_token_exchange_2" {
  statement {
    effect = "Allow"
    actions = [
      "iot:DescribeCertificate",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iot:Publish",
      "iot:Receive",
      "iot:RetainPublish"
    ]
    resources = ["arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/device/MiniPupper_2/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iot:Subscribe"
    ]
    resources = ["arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topicfilter/device/MiniPupper_2/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iot:Connect"
    ]
    resources = ["arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:client/CLIENTID"]
  }
}
resource "aws_iam_policy" "mpc_greengrass_v2_token_exchange_restricted_access_policy_2" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "GreengrassV2TokenExchangeRoleAccess_2"
  description = "Seoncd Policy for GreengrassV2TokenExchangeRole."
  policy      = data.aws_iam_policy_document.mpc_greengrass_v2_token_exchange_2.json
}
# Policy for robot
data "aws_iam_policy_document" "mpc_robot" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "${aws_s3_bucket.mpc_greengrass_s3_bucket.arn}",
      "${aws_s3_bucket.mpc_greengrass_s3_bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.mpc_greengrass_s3_bucket.arn}",
      "${aws_s3_bucket.mpc_greengrass_s3_bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["greengrass:*"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["iot:*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "mpc_robot_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "RobotPolicy"
  description = "Policy for Robot."
  policy      = data.aws_iam_policy_document.mpc_robot.json
}






# - DynamoDB Policies -
# DynamoDB Customer Managed Policy (All Actions)
data "aws_iam_policy_document" "mpc_dynamodb_restricted_access_policy" {
  count = var.create_restricted_access_roles ? 1 : 0
  # description = "Policy granting full DynamoDB permissions for the mpc_devices DynamoDB table."
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]
    resources = [
      # "${aws_dynamodb_table.mpc_devices.arn}",
      "*",
    ]
  }
}
resource "aws_iam_policy" "mpc_dynamodb_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "mpc_dynamodb_restricted_access_policy"
  description = "Policy granting full DynamoDB permissions for the mpc_devices DynamoDB table."
  policy      = data.aws_iam_policy_document.mpc_dynamodb_restricted_access_policy[0].json

}

data "aws_iam_policy_document" "mpc_mqtt_dynamodb_restricted_access_policy" {
  count = var.create_restricted_access_roles ? 1 : 0
  # description = "Policy granting full DynamoDB permissions for the mpc_devices DynamoDB table."
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]
    resources = [
      # "${aws_dynamodb_table.mpc_devices_mqtt.arn}",
      "*",
    ]
  }
}
resource "aws_iam_policy" "mpc_mqtt_dynamodb_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "mpc_mqtt_dynamodb_restricted_access_policy"
  description = "Policy granting full DynamoDB permissions for the mpc_devices_mqtt DynamoDB table."
  policy      = data.aws_iam_policy_document.mpc_mqtt_dynamodb_restricted_access_policy[0].json

}

# DynamoDB Customer Managed Policy (Read Only Actions)
data "aws_iam_policy_document" "mpc_dynamodb_restricted_access_read_only_policy" {
  count = var.create_restricted_access_roles ? 1 : 0
  # description = "Policy granting full DynamoDB permissions for the mpc_devices DynamoDB table."
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
    ]
    resources = [
      # "${aws_dynamodb_table.mpc_devices.arn}",
      "*",
    ]
  }
}
resource "aws_iam_policy" "mpc_dynamodb_restricted_access_read_only_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "mpc_dynamodb_restricted_access_read_only_policy"
  description = "Policy granting restricted (read-only) DynamoDB permissions for the mpc_devices DynamoDB table."
  policy      = data.aws_iam_policy_document.mpc_dynamodb_restricted_access_read_only_policy[0].json

}

# --- IAM ROLES ---
# - Cognito Roles -
# Cognito AuthRole Restricted Access
# Role granting restricted access permissions to Cognito authenticated users
resource "aws_iam_role" "mpc_cognito_authrole_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count = var.create_restricted_access_roles ? 1 : 0

  name               = "mpc_authRole_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.mpc_cognito_authrole_trust_relationship.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AWSIoTConfigAccess",
    "arn:aws:iam::aws:policy/AWSIoTDataAccess",
    # aws_iam_policy.mpc_s3_restricted_access_policy[0].arn,
    # aws_iam_policy.mpc_ssm_restricted_access_policy[0].arn,
    # aws_iam_policy.mpc_iot_restricted_access_policy[0].arn,
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.mpc_app_name}/"
  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}
# Cognito UnAuth Role
# Role granting restricted access permissions to Cognito authenticated users
resource "aws_iam_role" "mpc_cognito_unauthrole_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "mpc_unauthRole_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.mpc_cognito_unauthrole_trust_relationship.json

  # Managed Policies
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.mpc_app_name}/"
  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}

# Cognito Admin Group Role (Restricted Access)
resource "aws_iam_role" "mpc_cognito_admin_group_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count = var.create_restricted_access_roles ? 1 : 0

  name               = "mpc_cognito_admin_group_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.mpc_cognito_admin_group_trust_relationship.json
  description        = "Role granting full DynamoDB permissions for the mpc_devicess DynamoDB table."
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AWSIoTConfigAccess",
    "arn:aws:iam::aws:policy/AWSIoTDataAccess",
    # aws_iam_policy.mpc_s3_restricted_access_policy[0].arn,
    aws_iam_policy.mpc_dynamodb_restricted_access_policy[0].arn,
    aws_iam_policy.mpc_mqtt_dynamodb_restricted_access_policy[0].arn,
    # aws_iam_policy.mpc_iot_restricted_access_policy[0].arn,
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.mpc_app_name}/"
  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}

# Cognito Standard Group Role (Restricted Access)
resource "aws_iam_role" "mpc_cognito_standard_group_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count = var.create_restricted_access_roles ? 1 : 0

  name               = "mpc_cognito_standard_group_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.mpc_cognito_standard_group_trust_relationship.json
  description        = "Role granting restricted (read-only) DynamoDB permissions for the mpc_devicess DynamoDB table."
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    aws_iam_policy.mpc_dynamodb_restricted_access_read_only_policy[0].arn
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.mpc_app_name}/"
  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}

# - AppSync Roles -
# AppSync Restricted Access Role
# Role granting AppSync DynamoDB restricted access, SSM restricted read-only access, and the ablity to access to CloudWatch Logs.
resource "aws_iam_role" "mpc_appsync_dynamodb_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "mpc_appsync_dynamodb_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.mpc_appsync_trust_relationship.json
  # Managed Policies
  managed_policy_arns = [
    aws_iam_policy.mpc_dynamodb_restricted_access_policy[0].arn,
    aws_iam_policy.mpc_mqtt_dynamodb_restricted_access_policy[0].arn,
    # aws_iam_policy.mpc_ssm_restricted_access_policy[0].arn,
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ]
  force_detach_policies = true
  path                  = "/${var.mpc_app_name}/"
  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}


# - IoT Roles -
# IoT Restricted Access Role
# Role granting IoT DynamoDB restricted access (PutItem).
resource "aws_iam_role" "mpc_iot_to_dynamodb_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "mpc_iot_to_dynamodb_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.mpc_iot_trust_relationship.json
  managed_policy_arns = [
    aws_iam_policy.mpc_iot_to_dynamodb_restricted_access_policy[0].arn
  ]
}


# NEW
# GreengrassV2TokenExchangeRole
resource "aws_iam_role" "mpc_iot_token_exchange_role_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "GreengrassV2TokenExchangeRole"
  assume_role_policy = data.aws_iam_policy_document.mpc_iot_credentials_trust_relationship.json
  managed_policy_arns = [
    aws_iam_policy.mpc_greengrass_v2_token_exchange_restricted_access_policy[0].arn,
    aws_iam_policy.mpc_greengrass_v2_token_exchange_restricted_access_policy_2[0].arn,
    aws_iam_policy.mpc_robot_restricted_access_policy[0].arn,
  ]
}


# Amplify

resource "aws_iam_role" "mpc_amplify_codecommit" {
  count               = var.mpc_create_codecommit_repo ? 1 : 0
  name                = "mpc_amplify_codecommit"
  assume_role_policy  = data.aws_iam_policy_document.mpc_amplify_trust_relationship.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}

# GitLab
resource "aws_iam_user" "mpc_gitlab_mirroring" {
  count         = var.mpc_enable_gitlab_mirroring ? 1 : 0
  name          = var.mpc_gitlab_mirroring_iam_user_name
  path          = "/${var.mpc_app_name}/"
  force_destroy = true // prevents DeleteConflict Error

  tags = merge(
    {
      "AppName" = var.mpc_app_name
    },
    var.tags,
  )
}
resource "aws_iam_user_policy" "mpc_gitlab_mirroring_policy" {
  count = var.mpc_enable_gitlab_mirroring ? 1 : 0
  name  = var.mpc_gitlab_mirroring_policy_name
  user  = aws_iam_user.mpc_gitlab_mirroring[0].name


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "MinimumGitLabMirroringPermissions"
      Action = ["codecommit:GitPull", "codecommit:GitPush"]
      Effect = "Allow"
      Resource = [
        "${aws_codecommit_repository.mpc_codecommit_repo[0].arn}"
      ]
    }]

  })

}







