# Root Terragrunt Configuration
locals {
  project_name = "AWS Infra Automation Course"
  owner        = "John Kennedy"
  environment  = "dev"

  common_tags = {
    Project   = local.project_name
    Owner     = local.owner
    ManagedBy = "Terragrunt"
  }
}

# Remote S3 backend configuration
remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-jak-course"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}

# Note: Update the region and bucket_name as per your requirements
