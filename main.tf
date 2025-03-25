#---------------------------------------------------------------------------------
# This Terraform module was created to configure the AWS staging account 
# (destination/trusting) to allow access from the centalized auth account (origin/trusted) on AWS. 
# As a test, it will create IAM users and add them to a group for further administration. 
#
# Using: Terraform version 1.9.3
# This module will do the following:
# 1. Create read/writer user groups in the auth account (origin/trusted)
# 2. Create the IAM users for each of them
# 3. Add the L2 and L3 support personnel to each group
# 4. Create the trust IAM Role in the staging account (destination/trusting) to allow them access
#    from the central AWS auth account that was created specifically for this.
# 5. Create the policies necessary for L2 and L3 personel and attach them to the
#    group in the Central Auth Account
#---------------------------------------------------------------------------------

#--------------------------------------------------------------
# Outputs for checking the stuff we just created 
#--------------------------------------------------------------
output "role_name_in_staging_for_auth" {
  value = aws_iam_role.stage_auth_account_read_write_trust.arn
}