resource "aws_s3_bucket" "s3_backend" {
  bucket = "workshop-terraform-backend-devops01"

  tags = {
    Name        = "terraform state bucket"
    Environment = "sandbox"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}