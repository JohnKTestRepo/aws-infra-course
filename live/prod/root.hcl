include {
  path = find_in_parent_folders("common.hcl")
}

locals {
  environment = "prod"
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

