module "api_gateway" {
  source                        = "github.com/JamesCollerton/Terraform_Modules//apigateway"
  api_gateway_name              = "${var.api_gateway_name}"
  api_gateway_description       = "${var.api_gateway_description}"
  api_gateway_body 		= "${data.template_file.swagger_api.rendered}"
}
