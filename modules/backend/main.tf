terraform {
  backend "local" {} # placeholder, overridden by Terragrunt
}

provider "aws" {
  region = var.region
}

# Your resources (S3 bucket, etc.)
resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
}


