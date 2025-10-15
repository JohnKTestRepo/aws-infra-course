terraform {
  source = "../../../modules/vpc"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  environment        = local.environment
  region             = "us-east-2"
  cidr_block         = "10.1.0.0/16"
  subnet_cidrs       = ["10.1.1.0/24", "10.1.2.0/24"]
  availability_zones = ["us-east-2c", "us-east-2d"]
  tags               = merge(local.common_tags, { "Environment" = local.environment })
}

