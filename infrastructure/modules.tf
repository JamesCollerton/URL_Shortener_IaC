# API Gateway

module "api_gateway" {
  source                        = "github.com/JamesCollerton/Terraform_Modules//api-gateway"
  api_gateway_name              = "${terraform.workspace}-${var.api_gateway_name}"
  api_gateway_description       = "${var.api_gateway_description}"
}

# Lambdas

module "iam_for_lambda" {
  source = "github.com/JamesCollerton/Terraform_Modules//aws-iam-lambda-role" 
}

module "create_short_url_lambda" {
  source 		= "github.com/JamesCollerton/URL_Shortener_Create_Short_URL_Lambda//infrastructure"
  lambda_function_name 	= "${terraform.workspace}-${var.create_short_url_lambda_function_name}"
  iam_for_lambda_arn 	= "${module.iam_for_lambda.arn}"
}

module "redirect_short_url_lambda" {
  source 		= "github.com/JamesCollerton/URL_Shortener_Redirect_Short_URL_Lambda//infrastructure"
  lambda_function_name  = "${terraform.workspace}-${var.redirect_short_url_lambda_function_name}"
  iam_for_lambda_arn 	= "${module.iam_for_lambda.arn}"
}

# End points for each lambda

module "create_short_url_lambda_end_point" {
  source 				= "github.com/JamesCollerton/Terraform_Modules//api-gateway-lambda-integration"
  api_gateway_id			= "${module.api_gateway.id}"
  api_gateway_root_id			= "${module.api_gateway.root_resource_id}"
  api_gateway_path_part 		= "${var.create_short_url_lambda_api_gateway_path_part}"
  api_gateway_http_method 		= "${var.create_short_url_lambda_api_gateway_http_method}"
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
  aws_lambda_function_invoke_arn 	= "${module.redirect_short_url_lambda.invoke_arn}"
}

# Dynamo db

module "dynamodb" {
  source 			= "github.com/JamesCollerton/Terraform_Modules//dynamodb"
  dynamo_db_table_name 		=  "${terraform.workspace}-${var.dynamo_db_table_name}"
  dynamo_db_read_capacity 	=  "${var.dynamo_db_read_capacity}"
  dynamo_db_write_capacity 	=  "${var.dynamo_db_write_capacity}"
  dynamo_db_hash_key	 	=  "${var.dynamo_db_hash_key}"
  dynamo_db_range_key 		=  "${var.dynamo_db_range_key}"
  dynamo_db_list_of_attributes  =  "${var.dynamo_db_list_of_attributes}"
}
