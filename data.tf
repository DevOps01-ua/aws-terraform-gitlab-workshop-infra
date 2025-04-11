data "aws_s3_bucket" "selected" {
  bucket = "cdk-hnb659fds-assets-730335176685-eu-central-1"
}

data "aws_lambda_layer_version" "requests" {
  layer_name = "requests-layer"
}