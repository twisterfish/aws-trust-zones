#--------------------------------------------------------------
              #### Data for policies ####
# Using a verb to name policies that have actions, like assuming roles
# or trusting another account
#--------------------------------------------------------------


#--------------------------------------------------------------
# This is the policy that is added to the 'auth_account_trust role' 
# in both of the staging and prod accounts to allow (trust) the auth 
# account to have access. 
#--------------------------------------------------------------
data "aws_iam_policy_document" "trusted_auth_account" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.auth_account_id}:root"]
    }
  }
}

#--------------------------------------------------------------
# The info for the staging account (account ID and role name). 
# Needed for the 'read_write_staging' and 'read_only_staging' groups 
# in the auth account to use the staging account role for access. It 
# will be attached to the roles of the same name in the auth account. 
#--------------------------------------------------------------
data "aws_iam_policy_document" "staging_read_write_role_info" {
    statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.staging_account_id}:role/${var.staging_account_read_write_role_policy_name}"]
    }
}

data "aws_iam_policy_document" "staging_read_only_role_info" {
    statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.staging_account_id}:role/${var.staging_account_read_only_role_policy_name}"]
    }
}

#--------------------------------------------------------------
# The info for the prod account (account ID and role name). 
# Needed for the 'read_write_prod' and 'read_only_prod' groups 
# in the auth account to use the prod account role for access. It will 
# be attached to the roles of the same name in the auth account. 
#--------------------------------------------------------------
data "aws_iam_policy_document" "prod_read_write_role_info" {
    statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.prod_account_id}:role/${var.prod_account_read_write_role_policy_name}"]
    }
}

data "aws_iam_policy_document" "prod_read_only_role_info" {
    statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.prod_account_id}:role/${var.prod_account_read_only_role_policy_name}"]
    }
}

#--------------------------------------------------------------
# Test data for a list of buckets in S3
#--------------------------------------------------------------
data "aws_iam_policy_document" "testing_buckets" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = ["*"]
  }
}
#--------------------------------------------------------------
# This is a custom policy data for the read_write group people that will be 
# coming into staging from the auth (trusted) account. It can also
# be used as a generic policy for other purposes.
# TODO: this needs to be tested and refined
#--------------------------------------------------------------
data "aws_iam_policy_document" "read_write_specifications" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:*",
      "kms:*",
      "application-autoscaling:*",
      "cloudwatch:*",
      "datapipeline:*",
      "dynamodb:*",
      "dax:*",
      "ec2:*",
      "iam:*",
      "codebuild:*",
      "codecommit:*",
      "cloudwatch:*",
      "events:*",
      "logs:*",
      "cloudwatch:*",
      "tag:*",
      "states:*",
      "xray:*",

    ]
    resources = ["*"]
  }
}

#--------------------------------------------------------------
# This is a custom policy data for the read_only group people that will be 
# coming into staging from the auth (trusted) account. It can also
# be used as a generic policy for other purposes.
# TODO: this needs to be tested and refined
#--------------------------------------------------------------
data "aws_iam_policy_document" "read_only_specifications" {
  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:ListAliases",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:DescribeScalingActivities",
      "application-autoscaling:DescribeScalingPolicies",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "datapipeline:DescribeObjects",
      "datapipeline:DescribePipelines",
      "datapipeline:GetPipelineDefinition",
      "datapipeline:ListPipelines",
      "datapipeline:QueryObjects",
      "dynamodb:BatchGetItem",
      "dynamodb:Describe*",
      "dynamodb:List*",
      "dynamodb:GetItem",
      "dynamodb:GetResourcePolicy",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PartiQLSelect",
      "dax:Describe*",
      "dax:List*",
      "dax:GetItem",
      "dax:BatchGetItem",
      "dax:Query",
      "dax:Scan",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopics",
      "resource-groups:ListGroups",
      "resource-groups:ListGroupResources",
      "resource-groups:GetGroup",
      "resource-groups:GetGroupQuery",
      "tag:GetResources",
      "kinesis:ListStreams",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:StartBuildBatch",
      "codebuild:StopBuildBatch",
      "codebuild:RetryBuild",
      "codebuild:RetryBuildBatch",
      "codebuild:BatchGet*",
      "codebuild:GetResourcePolicy",
      "codebuild:DescribeTestCases",
      "codebuild:DescribeCodeCoverages",
      "codebuild:List*",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:ListBranches",
      "cloudwatch:GetMetricStatistics",
      "events:DescribeRule",
      "events:ListTargetsByRule",
      "events:ListRuleNamesByTarget",
      "logs:GetLogEvents",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "cloudformation:DescribeStacks",
      "cloudformation:ListStacks",
      "cloudformation:ListStackResources",
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "kms:ListAliases",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:ListRoles",
      "logs:DescribeLogGroups",
      "states:DescribeStateMachine",
      "states:ListStateMachines",
      "tag:GetResources",
      "xray:GetTraceSummaries",
      "xray:BatchGetTraces",
    ]
    resources = ["*"]
  }
}
