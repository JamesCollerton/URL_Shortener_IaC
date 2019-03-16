variable "aws_s3_bucket_name" {
  default 	= "url-shortener-shared-remote-state-backend"
  description 	= "Name to be assigned to the S3 bucket"
  type        	= "string"
}

variable "aws_profile" {
  default 	= "s3administrator"
  description 	= "Profile to be used"
  type        	= "string"
}

variable "aws_region" {
  default 	= "eu-west-1"
  description 	= "Region to be used"
  type        	= "string"
}

