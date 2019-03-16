module "s3" {
  source      		= "../modules/s3"
  aws_s3_bucket_name 	= "${var.aws_s3_bucket_name}"
}
