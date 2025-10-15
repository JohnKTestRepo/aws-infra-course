include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "s3_website" {
  config_path = "../s3_website"
}

terraform {
  source = "../../../modules/ec2"
}

inputs = {
  region         = "us-east-2"
  ami            = "" # lets Terraform pick the latest Amazon Linux 2 AMI
  instance_type  = "t2.micro"
  s3_bucket_name = dependency.s3_website.outputs.bucket_name
  subnet_ids     = dependency.vpc.outputs.subnet_ids
  tags        = merge(local.common_tags, { "Environment" = "dev" })
}
