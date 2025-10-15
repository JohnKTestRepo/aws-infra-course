# Common Terraform backend config for all environments
locals {
  environment   = "dev"
  common_tags = {
    Project   = "AWS Infra Automation Course"
    Owner     = "John Kennedy"
    ManagedBy = "Terragrunt"
  }

  # Choose backend locking type: "dynamodb" or "s3_native"
  # For dev, you can set "s3_native" to skip DynamoDB
  backend_lock_type = "s3_native"  # change to "dynamodb" for prod
}

remote_state {
  backend = "s3"

  config = local.backend_lock_type == "s3_native" ? {
    bucket = "terraform-state-jak-course"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    # No dynamodb_table needed
  } : {
    bucket         = "terraform-state-jak-course"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"   # DynamoDB locking enabled
  }
}

# Note: Update the region and bucket_name as per your requirements

