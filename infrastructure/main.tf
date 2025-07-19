provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-backend32co"
    key    = "devops-assessment/state"
    region = "us-east-1"
  }
}
