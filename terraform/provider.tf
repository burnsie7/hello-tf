terraform {
  required_version = ">= 1.4.7"
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
      version = "~> 4.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
