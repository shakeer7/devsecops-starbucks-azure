terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAY4MLGAN3CACC7FEU"
  secret_key = "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"

}   