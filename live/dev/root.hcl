locals {
  environment      = "dev"
  common_tags = {
    Project   = "AWS Infra Automation Course"
    Owner     = "John Kennedy"
    ManagedBy = "Terragrunt"
  }

  backend_lock_type = "s3_native"  # no DynamoDB
}

remote_state {
  backend = "s3"

  config = {
    bucket  = "terraform-state-jak-course"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
    # no dynamodb_table needed
  }
}


# Note: Update the region and bucket_name as per your requirements

