# live/common.hcl
locals {
  environment = basename(get_terragrunt_dir())
  common_tags = {
    Project   = "AWS Infra Automation Course"
    Owner     = "John Kennedy"
    ManagedBy = "Terragrunt"
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-jak-course"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
# Note: Update the region and bucket_name as per your requirements

