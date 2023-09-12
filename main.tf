terraform {
  backend "s3" {
    encrypt        = true
    key            = "product/terraform.tfstate"
    bucket         = "devops-quoctran-terraform-state-s3"
    profile        = "default"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-dynamodb-table-lock"
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = format("%s%s", "devops-", terraform.workspace)
}