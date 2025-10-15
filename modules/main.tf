provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.environment}-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}
