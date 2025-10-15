# Add IAM role and policy for EC2 to access S3 (production-ready)
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "ec2_s3_read_policy"
  description = "Allow EC2 to read S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:GetObject"]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_instance" "web" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.latest_amazon_linux[0].id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, 0) # Place in the first subnet
  iam_instance_profile = aws_iam_instance_profile.ec2_profile

  # User data to install Apache and fetch index.html from S3
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd awscli
              sudo systemctl enable httpd
              sudo systemctl start httpd

              # Fetch the index.html from S3 bucket
              aws s3 cp s3://${var.s3_bucket_name}/index.html /var/www/html/index.html
              EOF

  tags = {
    Name = "Terragrunt-EC2"
  }
}

