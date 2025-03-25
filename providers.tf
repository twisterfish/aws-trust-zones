#---------------------------------------------------
# Providers Section
#---------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    pgp = {
      source = "ekristen/pgp"
    }
  }
    backend "s3" {
    bucket = "google-ibm-adtech-terraform-state"
    key    = "centralauth/terraform.tfstate"
    region = "us-east-1"
    profile = "aws-auth"
  }
}

provider "aws" {
  alias = "staging"
  profile = "aws-staging"
  region  = "us-east-1"
}

provider "aws" {
  alias = "prod"
  profile = "aws-prod"
  region  = "us-east-1"
}

provider "aws" {
  alias = "auth"
  profile = "aws-auth"
  region  = "us-east-1"
}

provider "aws" {
  profile = "aws-auth"
  region  = "us-east-1"
}
