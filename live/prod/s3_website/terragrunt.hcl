terraform {
  source = "../../../modules/s3_website"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  region      = "us-east-2"
  bucket_name = "my-terraform-prod-website-${local.environment}"
  tags        = merge(local.common_tags, { "Environment" = "prod" })
}
