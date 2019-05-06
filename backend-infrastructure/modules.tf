########################################################################################
# API Gateway
########################################################################################

module "api_gateway" {
  source                        = "github.com/JamesCollerton/Terraform_Modules//api-gateway"
  api_gateway_name              = "${terraform.workspace}-${var.api_gateway_name}"
  api_gateway_description       = "${var.api_gateway_description}"
}

########################################################################################
# Lambda S3 Buckets 
########################################################################################

module "create_short_url_lambda_code_s3_bucket" {
  source      		= "github.com/JamesCollerton/Terraform_Modules//s3"
  aws_s3_bucket_name 	= "${terraform.workspace}-${var.create_short_url_lambda_code_s3_bucket_name}"
}

resource "aws_s3_bucket_object" "create_short_url_lambda_code_s3_jar" {
  bucket 	= "${module.create_short_url_lambda_code_s3_bucket.bucket}"
  key    	= "${var.create_short_url_lambda_s3_key}"
  source 	= "lambda-files/url-shortener-create-short-url-lambda.zip"
  depends_on 	= ["module.create_short_url_lambda_code_s3_bucket"]
}

module "redirect_short_url_lambda_code_s3_bucket" {
  source      		= "github.com/JamesCollerton/Terraform_Modules//s3"
  aws_s3_bucket_name 	= "${terraform.workspace}-${var.redirect_short_url_lambda_code_s3_bucket_name}"
}

resource "aws_s3_bucket_object" "redirect_short_url_lambda_code_s3_jar" {
  bucket 	= "${module.redirect_short_url_lambda_code_s3_bucket.bucket}"
  key    	= "${var.redirect_short_url_lambda_s3_key}"
  source 	= "lambda-files/url-shortener-redirect-short-url-lambda.zip"
  depends_on 	= ["module.redirect_short_url_lambda_code_s3_bucket"]
}

########################################################################################
# Lambdas
########################################################################################

module "iam_for_lambda" {
  source = "github.com/JamesCollerton/Terraform_Modules//aws-iam-lambda-role" 
}

# Need to rely on resource and not variable for transitive dependency
module "create_short_url_lambda" {
  source 		= "github.com/JamesCollerton/URL_Shortener_Create_Short_URL_Lambda//infrastructure"
  lambda_s3_bucket 	= "${var.create_short_url_lambda_code_s3_bucket_name}"
  lambda_s3_key 	= "${aws_s3_bucket_object.create_short_url_lambda_code_s3_jar.key}"
  lambda_function_name 	= "${terraform.workspace}-${var.create_short_url_lambda_function_name}"
  iam_for_lambda_arn 	= "${module.iam_for_lambda.arn}"
}

module "redirect_short_url_lambda" {
  source 		= "github.com/JamesCollerton/URL_Shortener_Redirect_Short_URL_Lambda//infrastructure"
  lambda_s3_bucket 	= "${var.redirect_short_url_lambda_code_s3_bucket_name}"
  lambda_s3_key 	= "${aws_s3_bucket_object.redirect_short_url_lambda_code_s3_jar.key}"
  lambda_function_name 	= "${terraform.workspace}-${var.create_short_url_lambda_function_name}"
  lambda_function_name  = "${terraform.workspace}-${var.redirect_short_url_lambda_function_name}"
  iam_for_lambda_arn 	= "${module.iam_for_lambda.arn}"
}

########################################################################################
# End points for each lambda
########################################################################################

module "create_short_url_lambda_end_point" {
  source 				= "github.com/JamesCollerton/Terraform_Modules//api-gateway-lambda-integration"
  api_gateway_id			= "${module.api_gateway.id}"
  api_gateway_root_id			= "${module.api_gateway.root_resource_id}"
  api_gateway_path_part 		= "${var.create_short_url_lambda_api_gateway_path_part}"
  api_gateway_http_method 		= "${var.create_short_url_lambda_api_gateway_http_method}"
  api_gateway_key_required 		= "${var.create_short_url_lambda_end_point_api_key_required}"
  api_gateway_timeout_milliseconds	= "${var.api_gateway_timeout_milliseconds}"
  aws_lambda_function_invoke_arn 	= "${module.create_short_url_lambda.invoke_arn}"
}

resource "aws_api_gateway_resource" "aws_api_gateway_resource_redirect_short_url_id" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${module.create_short_url_lambda_end_point.id}"
  path_part   = "${var.redirect_short_url_lambda_api_gateway_path_part_short_url_id}"
}

module "redirect_short_url_lambda_end_point" {
  source 				= "github.com/JamesCollerton/Terraform_Modules//api-gateway-lambda-integration"
  api_gateway_id			= "${module.api_gateway.id}"
  api_gateway_root_id			= "${aws_api_gateway_resource.aws_api_gateway_resource_redirect_short_url_id.id}"
  api_gateway_path_part 		= "${var.redirect_short_url_lambda_api_gateway_path_part_redirect}"
  api_gateway_http_method 		= "${var.redirect_short_url_lambda_api_gateway_http_method}"
  api_gateway_key_required 		= "${var.redirect_short_url_lambda_end_point_api_key_required}"
  api_gateway_timeout_milliseconds	= "${var.api_gateway_timeout_milliseconds}"
  aws_lambda_function_invoke_arn 	= "${module.redirect_short_url_lambda.invoke_arn}"
}

########################################################################################
# API Gateway deployment
########################################################################################

# Can't be a module as we need dependencies
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
        "module.create_short_url_lambda_end_point", 
        "module.redirect_short_url_lambda_end_point"
  ]

  rest_api_id = "${module.api_gateway.id}"
  stage_name  = "${var.api_gateway_deployment_stage_name}"
}

# Must use stage name above in order to introduce a transitive dependency
module "api_gateway_key_and_usage_plan" {
  source 				= "github.com/JamesCollerton/Terraform_Modules//api-gateway-key-and-usage-plan"
  aws_api_gateway_rest_api_id 		= "${module.api_gateway.id}"
  aws_api_gateway_deployment_stage_name = "${aws_api_gateway_deployment.api_gateway_deployment.stage_name}"
  aws_api_gateway_usage_plan_name 	= "basic"
  aws_api_gateway_api_key_name 		= "${terraform.workspace}-api-key"
}

########################################################################################
# Dynamo db
########################################################################################

module "dynamodb" {
  source 			= "github.com/JamesCollerton/Terraform_Modules//dynamodb"
  dynamo_db_table_name 		=  "${terraform.workspace}-${var.dynamo_db_table_name}"
  dynamo_db_read_capacity 	=  "${var.dynamo_db_read_capacity}"
  dynamo_db_write_capacity 	=  "${var.dynamo_db_write_capacity}"
  dynamo_db_hash_key	 	=  "${var.dynamo_db_hash_key}"
  dynamo_db_range_key 		=  "${var.dynamo_db_range_key}"
  dynamo_db_list_of_attributes  =  "${var.dynamo_db_list_of_attributes}"
}
