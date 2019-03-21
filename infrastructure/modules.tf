# API Gateway

module "api_gateway" {
  source                        = "github.com/JamesCollerton/Terraform_Modules//apigateway"
  api_gateway_name              = "${var.api_gateway_name}"
  api_gateway_description       = "${var.api_gateway_description}"
  api_gateway_body 		= "${data.template_file.swagger_api.rendered}"
}

# Lambdas

module "create_short_url_lambda" {
  source = "github.com/JamesCollerton/URL_Shortener_Create_Short_URL_Lambda//infrastructure"
}

# End points for each lambda

module "create_short_url_lambda_end_point" {
  source 				= "github.com/JamesCollerton/Terraform_Modules//apigatewaylambdaintegration"
  api_gateway_id			= "${module.api_gateway.id}"
  api_gateway_root_id			= "${module.api_gateway.root_resource_id}"
  aws_lambda_function_invoke_arn 	= "${module.create_short_url_lambda.invoke_arn}"
}

# Dynamo db
