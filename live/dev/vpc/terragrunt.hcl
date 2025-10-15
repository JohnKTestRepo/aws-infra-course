include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  environment        = "dev"
  region             = "us-east-2"
  cidr_block         = "10.0.0.0/16"
  subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-2a", "us-east-2b"]
  tags        = merge(local.common_tags, { "Environment" = "dev" })
}


