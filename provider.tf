terraform {
  backend "s3" {        # tfstate file backup via S3 bucket (bucket already created)
    bucket = "terraform-tfstate-stockage"
    key = "key/production/terraform.tfstate"
    region = "eu-west-3"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}


