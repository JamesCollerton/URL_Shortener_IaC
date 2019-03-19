module "s3" {
  source      		= "github.com/JamesCollerton/Terraform_Modules//s3"
  aws_s3_bucket_name 	= "${var.aws_s3_bucket_name}"
}
