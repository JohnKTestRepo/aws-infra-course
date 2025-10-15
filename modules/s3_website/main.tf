terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
 
  website {
    index_document = var.index_file
  }

  tags = var.tags
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.website.id
  key    = var.index_file
  content = <<-EOF
            <html>
            <body>
            <h1>Welcome to ${var.bucket_name}</h1>
            </body>
            </html>
            EOF
  acl = "public-read"
}

