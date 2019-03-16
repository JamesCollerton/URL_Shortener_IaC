terraform {
  backend "s3" {
    bucket               = "url-shortener-shared-remote-state-backend"
    key                  = "shared-remote-state/url-shortener-shared-remote-state-backend/s3/terraform.tfstate"
    profile              = "s3administrator"
    region               = "eu-west-1"
  }
}

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}
