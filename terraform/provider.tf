terraform {
  required_version = ">= 0.15"
  backend "s3" {
    bucket         = "tf-state-labs-bx657"
    key            = "terraform"
    region         = "us-east-1"
    dynamodb_table = "tf_locks_more"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
