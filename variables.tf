#---------------------------------------------------
# Static variables for the various environments
# TODO: possibly use modules instead of some of these
#---------------------------------------------------

#--------------------------------------------------------------
# Create user lists for staging and prod 
#--------------------------------------------------------------
variable "prod_read_write_userlist" {
  type        = list(string)
  description = "list of prod read-write IAM users to add to the auth account groups"
  default = [
    "testing_1_prod_RW@stuff.com",
    "testing_2_prod_RW@stuff.com",
  ]
}

variable "prod_read_only_userlist" {
  type        = list(string)
  description = "list of prod read-only IAM users to add to the auth account groups"
  default = [
    "testing_3_prod_RO@stuff.com",
    "testing_4_prod_RO@stuff.com",
  ]
}

variable "stage_read_write_userlist" {
  type        = list(string)
  description = "list of staging read-write IAM users to add to the auth account groups"
  default = [
    "testing_1_stage_RW@stuff.com",
    "testing_2_stage_RW@stuff.com",
  ]
}

variable "stage_read_only_userlist" {
  type        = list(string)
  description = "list of staging read-only IAM users to add to the auth account groups"
  default = [
    "testing_3_stage_RO@stuff.com",
    "testing_4_stage_RO@stuff.com",
  ]
}

#--------------------------------------------------------------
# The prod, staging, and auth account IDs involved
#--------------------------------------------------------------
variable "auth_account_id" {
  type        = string
  description = "The account ID for the central auth account"
  default = "00000000000001"
}

variable "staging_account_id" {
  type        = string
  description = "The account ID for the GAT staging account"
  default = "00000000000002"
}

variable "prod_account_id" {
  type        = string
  description = "The account ID for the GAT production account"
  default = "00000000000003"
}

#--------------------------------------------------------------
# Role and Policy names for staging and prod accounts to be assumed by
# the users in the auth account
#--------------------------------------------------------------

#--------------------------------------------------------------
## staging
#--------------------------------------------------------------
variable "staging_account_read_only_role_policy_name" {
  type        = string
  description = "The read-only role and policy name for the staging account"
  default = "auth-acct-read-only"
}

variable "staging_account_read_write_role_policy_name" {
  type        = string
  description = "The read-write role and policy name for the staging account"
  default = "auth-acct-read-write"
}

#--------------------------------------------------------------
## production
#--------------------------------------------------------------
variable "prod_account_read_only_role_policy_name" {
  type        = string
  description = "The read_only role name for the prod account"
  default = "auth-acct-read-only"
}

variable "prod_account_read_write_role_policy_name" {
  type        = string
  description = "The read_write role name for the prod account"
  default = "auth-acct-read-write"
}
