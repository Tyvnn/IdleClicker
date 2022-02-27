terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  //shared_credentials_file = "C:/Users/Ryan/.aws/credentials"
  //profile                 = "default"
}
