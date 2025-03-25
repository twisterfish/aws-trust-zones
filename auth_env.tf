#--------------------------------------------------------------
#### IAM Resources for the Authorization account ####
#--------------------------------------------------------------

#--------------------------------------------------------------
### Create the groups needed to separate the read-write from read-only 

#--------------------------------------------------------------
# Create read-write user groups in the Auth account that will 
# be used to allow access to staging and prod accounts.
#--------------------------------------------------------------
resource "aws_iam_group" "read_write_staging" {
  provider = aws.auth
  name     = "staging-read-write"
}

resource "aws_iam_group" "read_write_prod" {
  provider = aws.auth
  name     = "prod-read-write"
}

#--------------------------------------------------------------
# Create read-only user groups in the Auth account that will 
# be used to allow access to staging and prod accounts.
#--------------------------------------------------------------
resource "aws_iam_group" "read_only_staging" {
  provider = aws.auth
  name     = "staging-read-only"
}

resource "aws_iam_group" "read_only_prod" {
  provider = aws.auth
  name     = "prod-read-only"
}

#--------------------------------------------------------------
### Create the policies needed for read-write and read-only groups

#--------------------------------------------------------------
# Create the read-write policies for the read_write_staging 
# and read_write_prod groups which will identify the account IDs 
# and role names in staging and prod that are needed for access.
#--------------------------------------------------------------
resource "aws_iam_policy" "read_write_staging" {
  provider    = aws.auth
  name        = "read-write-staging"
  description = "This policy will be added to the read-write-gat-staging group"
  policy      = data.aws_iam_policy_document.staging_read_write_role_info.json
}

resource "aws_iam_policy" "read_write_prod" {
  provider    = aws.auth
  name        = "read-write-prod"
  description = "This policy will be added to the read-write-gat-prod group"
  policy      = data.aws_iam_policy_document.prod_read_write_role_info.json
}

#--------------------------------------------------------------
# Create the read-only policies for the read_only_staging 
# and read_only_prod groups which will identify the account IDs 
# and role names in staging and prod that are needed for access.
#--------------------------------------------------------------
resource "aws_iam_policy" "read_only_staging" {
  provider    = aws.auth
  name        = "read-only-staging"
  description = "This policy will be added to the read-only-gat-staging group"
  policy      = data.aws_iam_policy_document.staging_read_only_role_info.json
}

resource "aws_iam_policy" "read_only_prod" {
  provider    = aws.auth
  name        = "read-only-prod"
  description = "This policy will be added to the read-only-gat-prod group"
  policy      = data.aws_iam_policy_document.prod_read_only_role_info.json
}

#--------------------------------------------------------------
# Attach the policies to the read_write_staging, read_write_prod,
# read_only_staging, read_only_prod groups
# NOTE:  If the user has Admin privileges, these policies have NO
#        effect on them. They will have admin privileges in the 
#        target accounts as well.  This is an AWS thing.
#--------------------------------------------------------------
resource "aws_iam_group_policy_attachment" "read_write_staging_attach" {
  provider   = aws.auth
  group      = aws_iam_group.read_write_staging.name
  policy_arn = aws_iam_policy.read_write_staging.arn
}

resource "aws_iam_group_policy_attachment" "read_write_prod_attach" {
  provider   = aws.auth
  group      = aws_iam_group.read_write_prod.name
  policy_arn = aws_iam_policy.read_write_prod.arn
}

resource "aws_iam_group_policy_attachment" "read_only_staging_attach" {
  provider   = aws.auth
  group      = aws_iam_group.read_only_staging.name
  policy_arn = aws_iam_policy.read_only_staging.arn
}

resource "aws_iam_group_policy_attachment" "read_only_prod_attach" {
  provider   = aws.auth
  group      = aws_iam_group.read_only_prod.name
  policy_arn = aws_iam_policy.read_only_prod.arn
}

#--------------------------------------------------------------
# Now we create some IAM reader and writer users pulled from the
# variables.tf file
#--------------------------------------------------------------

# These are for prod account
resource "aws_iam_user" "prod_read_write_users" {
  provider      = aws.auth
  force_destroy = true
  # creates an implicit map from the variable
  for_each = toset(var.prod_read_write_userlist)
  name     = each.value

}

resource "aws_iam_user" "prod_read_only_users" {
  provider      = aws.auth
  force_destroy = true
  # creates an implicit map from the variable
  for_each = toset(var.prod_read_only_userlist)
  name     = each.value

}

# These are for staging
resource "aws_iam_user" "stage_read_write_users" {
  provider      = aws.auth
  force_destroy = true
  # creates an implicit map from the variable
  for_each = toset(var.stage_read_write_userlist)
  name     = each.value

}

resource "aws_iam_user" "stage_read_only_users" {
  provider      = aws.auth
  force_destroy = true
  # creates an implicit map from the variable
  for_each = toset(var.stage_read_only_userlist)
  name     = each.value

}

#--------------------------------------------------------------
# Create aws_iam_group_membership resources in order to add
# the users to the read_write_staging and read_only_staging groups. 
#--------------------------------------------------------------
resource "aws_iam_group_membership" "read_write_staging_group_membership" {
  provider = aws.auth
  name     = "read-write-gat-staging-group-members"
  group    = aws_iam_group.read_write_staging.name
  # pull the keys from the map created in the read_write_users resource
  users = keys(aws_iam_user.stage_read_write_users)
}

resource "aws_iam_group_membership" "read_only_staging_group_membership" {
  provider = aws.auth
  name     = "read-only-gat-staging-group-members"
  group    = aws_iam_group.read_only_staging.name
  # pull the keys from the map created in the read_only_users resource
  users = keys(aws_iam_user.stage_read_only_users)
}

#--------------------------------------------------------------
# Create aws_iam_group_membership resources in order to add
# the users to the read_write_prod and read_only_prod groups. 
#--------------------------------------------------------------
resource "aws_iam_group_membership" "read_write_prod_group_membership" {
  provider = aws.auth
  name     = "read-write-gat-prod-group-members"
  group    = aws_iam_group.read_write_prod.name
  # pull the keys from the map created in the read_write_users resource
  users = keys(aws_iam_user.prod_read_write_users)
}

resource "aws_iam_group_membership" "read_only_prod_group_membership" {
  provider = aws.auth
  name     = "read-only-gat-prod-group-members"
  group    = aws_iam_group.read_only_prod.name
  # pull the keys from the map created in the read_only_users resource
  users = keys(aws_iam_user.prod_read_only_users)
}


#--------------------------------------------------------------
# Add the users to the console
#--------------------------------------------------------------

#---------------------------
# 1. Create the access keys

resource "aws_iam_access_key" "prod_ro_access_key" {
  for_each = toset(var.prod_read_only_userlist)
  user       = each.value
  depends_on = [aws_iam_user.prod_read_only_users]
}

resource "aws_iam_access_key" "prod_rw_access_key" {
  for_each = toset(var.prod_read_write_userlist)
  user       = each.value
  depends_on = [aws_iam_user.prod_read_write_users]
}

resource "aws_iam_access_key" "stage_ro_access_key" {
  for_each = toset(var.stage_read_only_userlist)
  user       = each.value
  depends_on = [aws_iam_user.stage_read_only_users]
}

resource "aws_iam_access_key" "stage_rw_access_key" {
  for_each = toset(var.stage_read_write_userlist)
  user       = each.value
  depends_on = [aws_iam_user.stage_read_write_users]
}

#---------------------------
# 2. Create the logins
resource "pgp_key" "prod_ro_login_key" {
  for_each = toset(var.prod_read_only_userlist)

  name    = each.value
  email   = each.value
  comment = "PGP Key for ${each.value}"
}

resource "pgp_key" "prod_rw_login_key" {
  for_each = toset(var.prod_read_write_userlist)

  name    = each.value
  email   = each.value
  comment = "PGP Key for ${each.value}"
}

resource "pgp_key" "stage_ro_login_key" {
  for_each = toset(var.stage_read_only_userlist)

  name    = each.value
  email   = each.value
  comment = "PGP Key for ${each.value}"
}

resource "pgp_key" "stage_rw_login_key" {
  for_each = toset(var.stage_read_write_userlist)

  name    = each.value
  email   = each.value
  comment = "PGP Key for ${each.value}"
}


#---------------------------
# 3. Create the profiles
resource "aws_iam_user_login_profile" "prod_read_only_userlist_login" {
  provider                = aws.auth
  for_each                = toset(var.prod_read_only_userlist)
  user                    = each.value
  pgp_key                 = pgp_key.prod_ro_login_key[each.value].public_key_base64
  password_reset_required = true

  depends_on = [aws_iam_user.prod_read_only_users, pgp_key.prod_ro_login_key]
}

resource "aws_iam_user_login_profile" "prod_read_write_userlist_login" {
  provider                = aws.auth
  for_each                = toset(var.prod_read_write_userlist)
  user                    = each.value
  pgp_key                 = pgp_key.prod_rw_login_key[each.value].public_key_base64
  password_reset_required = true

  depends_on = [aws_iam_user.prod_read_write_users, pgp_key.prod_rw_login_key]
}

resource "aws_iam_user_login_profile" "stage_read_only_userlist_login" {
  provider                = aws.auth
  for_each                = toset(var.stage_read_only_userlist)
  user                    = each.value
  pgp_key                 = pgp_key.stage_ro_login_key[each.value].public_key_base64
  password_reset_required = true

  depends_on = [aws_iam_user.stage_read_only_users, pgp_key.stage_ro_login_key]
}

resource "aws_iam_user_login_profile" "stage_read_write_userlist_login" {
  provider                = aws.auth
  for_each                = toset(var.stage_read_write_userlist)
  user                    = each.value
  pgp_key                 = pgp_key.stage_rw_login_key[each.value].public_key_base64
  password_reset_required = true

  depends_on = [aws_iam_user.stage_read_write_users, pgp_key.stage_rw_login_key]
}

# variables
# prod_read_only_userlist
# prod_read_write_userlist
# stage_read_only_userlist
# stage_read_write_userlist
# IAM_USER resource names
# prod_read_only_users
# prod_read_write_users
# stage_read_only_users
# stage_read_write_users
# IAM profile names
# prod_read_only_userlist_login
# prod_read_write_userlist_login
# stage_read_only_userlist_login
# stage_read_write_userlist_login

#---------------------------
# 4. Decrypt the keys to print out IN CLEAR TEXT!
data "pgp_decrypt" "prod_ro_user_password_decrypt" {
  for_each = toset(var.prod_read_only_userlist)

  ciphertext          = aws_iam_user_login_profile.prod_read_only_userlist_login[each.value].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.prod_ro_login_key[each.value].private_key
}

data "pgp_decrypt" "prod_rw_user_password_decrypt" {
  for_each = toset(var.prod_read_write_userlist)

  ciphertext          = aws_iam_user_login_profile.prod_read_write_userlist_login[each.value].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.prod_rw_login_key[each.value].private_key
}

data "pgp_decrypt" "stage_ro_user_password_decrypt" {
  for_each = toset(var.stage_read_only_userlist)

  ciphertext          = aws_iam_user_login_profile.stage_read_only_userlist_login[each.value].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.stage_ro_login_key[each.value].private_key
}

data "pgp_decrypt" "stage_rw_user_password_decrypt" {
  for_each = toset(var.stage_read_write_userlist)

  ciphertext          = aws_iam_user_login_profile.stage_read_write_userlist_login[each.value].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.stage_rw_login_key[each.value].private_key
}

#--------------------------------------------------------------
# Output all the values - BE WARNED THIS IS CLEAR TEXT!
#--------------------------------------------------------------

output "prouser_profile_info" {
  value = {for k,v in data.pgp_decrypt.prod_ro_user_password_decrypt: k => v.plaintext}
}

output "prwuser_profile_info" {
  value = {for k,v in data.pgp_decrypt.prod_rw_user_password_decrypt: k => v.plaintext}
}

output "srouser_profile_info" {
  value = {for k,v in data.pgp_decrypt.stage_ro_user_password_decrypt: k => v.plaintext}
}

output "srwuser_profile_info" {
  value = {for k,v in data.pgp_decrypt.stage_rw_user_password_decrypt: k => v.plaintext}
}
