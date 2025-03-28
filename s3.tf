resource "aws_s3_bucket" "s3_static_site" {
  bucket = "workshop-devops01"

  tags = {
    Name        = "terraform statebucket"
    Environment = "sandbox"
  }
}

resource "aws_s3_bucket_policy" "allow_from_cloudfront" {
  bucket = aws_s3_bucket.s3_static_site.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::workshop-devops01/*"
    ]
    sid       = "AllowCloudFrontServicePrincipal"
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        ""# cloudfront distribution #todo get from cloudfront resource attributes
      ]
    }
  }
}