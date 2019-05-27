terraform {
  backend "s3" {
    bucket               = "url-shortener-remote-state-bucket"
    key                  = "shared-remote-state/url-shortener/shared-remote-state-s3/terraform.tfstate"
    profile              = "s3administrator"
    region               = "eu-west-1"
  }
}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}
