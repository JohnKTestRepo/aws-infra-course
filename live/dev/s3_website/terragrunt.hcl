include {
  path = find_in_parent_folders()
}



# include {
#   path = "${path_relative_from_include()}/../../root.hcl"
# }

terraform {
  source = "../../../modules/s3_website"
}

# Define the locals here so we don’t rely on the parent
locals {
  common_tags = {
    Project   = "AWS Infra Automation Course"
    Owner     = "John Kennedy"
    ManagedBy = "Terragrunt"
  }
}

inputs = {
  environment = "dev"
  region      = "us-east-2"
  bucket_name = "aws-infra-course-dev-website-jak01"
  index_file  = "index.html"
  tags        = merge(local.common_tags, { "Environment" = "dev" })
}

# Note: Update the region and bucket_name as per your requirements