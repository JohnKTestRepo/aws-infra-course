variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "s3_bucket_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

