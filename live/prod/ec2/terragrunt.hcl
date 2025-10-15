terraform {
  source = "../../../modules/ec2"
}

include {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  environment   = local.environment
  region        = "us-east-2"
  ami           = ""
  instance_type = "t3.micro"  # upgraded for production
  subnet_ids    = dependency.vpc.outputs.subnet_ids
  tags          = merge(local.common_tags, { "Environment" = local.environment })
}
# Note: Update the region and AMI as per your requirements