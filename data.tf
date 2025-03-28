data "aws_s3_bucket" "selected" {
  bucket = "" #bucket_name
}

output "test" {
  value = data.aws_s3_bucket.selected.arn
}

