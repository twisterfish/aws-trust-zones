#--------------------------------------------------------------
    #### Staging Account Trust Roles and Policies ####
#--------------------------------------------------------------

#--------------------------------------------------------------
# This is tricky so pay attention to the order!
#--------------------------------------------------------------
# 1. First create the trust policy resource with the 'read_write_specifications' policy_data
resource "aws_iam_policy" "stage_auth_account_read_write_trust" {
  provider    = aws.staging
  name        = var.staging_account_read_write_role_policy_name
  path        = "/"
  description = "Policy that defines read_write access from the central authorization account."
  policy      = data.aws_iam_policy_document.read_write_specifications.json
}

# 2. Secondly, create the role resource that is instantiated with the policy data that
# identifies the auth account and allows it to assume this role
resource "aws_iam_role" "stage_auth_account_read_write_trust" {
  provider           = aws.staging
  name               = var.staging_account_read_write_role_policy_name
  description        = "Trust role that allows read-write access from the central auth AWS account."
  assume_role_policy = data.aws_iam_policy_document.trusted_auth_account.json
}

# 3. Lastly, create the aws_iam_role_policy_attachment resource to merge the 'stage_auth_account_read_write_trust' policy
# with the 'stage_auth_account_read_write_trust' role 
resource "aws_iam_role_policy_attachment" "stage_attach_read_write_role" {
  provider   = aws.staging
  role       = aws_iam_role.stage_auth_account_read_write_trust.name
  policy_arn = aws_iam_policy.stage_auth_account_read_write_trust.arn
}

#--------------------------------------------------------------
# Now create the read-only roles and attach policies
#--------------------------------------------------------------
# 1. First create the trust policy resource with the 'read_only_specifications' policy_data
resource "aws_iam_policy" "stage_auth_account_read_only_trust" {
  provider    = aws.staging
  name        = var.staging_account_read_only_role_policy_name
  path        = "/"
  description = "Policy that defines read-only access from the central authorization account."
  policy      = data.aws_iam_policy_document.read_only_specifications.json
}

# 2. Secondly, create the role resource that is instantiated with the policy data that
# identifies the auth account and allows it to assume this role
resource "aws_iam_role" "stage_auth_account_read_only_trust" {
  provider           = aws.staging
  name               = var.staging_account_read_only_role_policy_name
  description        = "Trust role that allows read-only access from the central auth AWS account."
  assume_role_policy = data.aws_iam_policy_document.trusted_auth_account.json
}

# 3. Lastly, create the aws_iam_role_policy_attachment resource to merge the 'stage_auth_account_read_only_trust' policy
# with the 'stage_auth_account_read_only_trust' role 
resource "aws_iam_role_policy_attachment" "stage_attach_read_only_role" {
  provider   = aws.staging
  role       = aws_iam_role.stage_auth_account_read_only_trust.name
  policy_arn = aws_iam_policy.stage_auth_account_read_only_trust.arn
}