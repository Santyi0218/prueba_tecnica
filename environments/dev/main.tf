provider "aws" {
  region  = var.aws_region
  profile = var.profile_aws
  default_tags {
    tags = {
      Env           = "dev"
      Functionality = "infraestructura"
      Business      = "nequi"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64.0"
    }
  }
}

module "backend" {
  source      = "./../../modules/backend"
  name        = var.name
  aws_account = var.aws_account
  aws_region  = var.aws_region
}