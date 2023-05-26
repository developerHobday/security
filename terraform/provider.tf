terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.59"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  # default tags
}

provider "snowflake" {
#   role             = "SYSADMIN"
  role = "ACCOUNTADMIN"
  username         = var.SNOWFLAKE_USER
  private_key_path = var.SNOWFLAKE_PRIVATE_KEY_PATH
  account          = var.SNOWFLAKE_ACCOUNT
  region           = var.SNOWFLAKE_REGION
}
