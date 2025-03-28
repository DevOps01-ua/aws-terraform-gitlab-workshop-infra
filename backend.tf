terraform {
  backend "s3" {
    bucket = "" #bucket name
    key    = "static-site-infra/tfstate"
    region = "eu-central-1"
    use_lockfile = true
  }
}