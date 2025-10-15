include {
  path = "${path_relative_from_include()}/../../root.hcl"
}

# Choose backend type by uncommenting the desired block

# --- LOCAL BACKEND ---
# remote_state {
#   backend = "local"
#   config = {
#     path = "terraform.tfstate"
#   }
# }

# --- REMOTE BACKEND (S3) ---
remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-state-jak-course"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    # dynamodb_table = "terraform-locks"  # optional if using S3 native locking
  }
}

terraform {
  source = "../../../modules/backend"
}

inputs = {
  bucket_name = "terraform-state-jak-course"
  region      = "us-east-2"
}


