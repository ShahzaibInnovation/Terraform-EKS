terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }

  backend "s3" {
    bucket         = "shahzaib-terraform-eks-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
