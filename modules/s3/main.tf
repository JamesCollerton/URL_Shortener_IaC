resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket 	= "${var.aws_s3_bucket_name}"
  acl    	= "private"
  force_destroy = "true"

  tags {
    Name        = "${var.aws_s3_bucket_name}"
  }
}
