terraform {
  backend "s3" {
    bucket               = "url-shortener-remote-state-bucket"
    key                  = "shared-remote-state/s3/url-shortener-shared-remote-state/terraform.tfstate"
    profile              = "s3administrator"
    region               = "eu-west-1"
  }
}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}
