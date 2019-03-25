variable "api_gateway_name" {
  default 	= "url-shortener-api-gateway"
  description 	= "The name you would like to assign to your API gateway"
  type 		= "string" 
}

variable "api_gateway_description" {
  default 	= "API Gateway for the URL shortener project"
  description 	= "The description of your API gateway"
  type 		= "string" 
}

variable "api_gateway_body" {
  default 	= "./swaggeryaml/apidefinition.yml"
  description   = "The relative path to the OpenAPI YAML specification"
  type          = "string"
}

variable "create_short_url_lambda_api_gateway_path_part" {
  default 	= "shortened-url-information"
  description 	= "The path we want to make the request to"
  type 		= "string"
}

variable "create_short_url_lambda_api_gateway_http_method" {
  default 	= "POST"
  description 	= "The HTTP method we would like to trigger the request"
  type 		= "string"
}

#variable "redirect_short_url_lambda_api_gateway_path_part" {
#  default 	= "shortened-url-information/{short-url}/redirect"
#  description 	= "The path we want to make the request to"
#  type 		= "string"
#}

variable "redirect_short_url_lambda_api_gateway_path_part_root" {
  default 	= "shortened-url-information"
  description 	= "The root of the redirect request"
  type 		= "string"
}

variable "redirect_short_url_lambda_api_gateway_path_part_short_url_id" {
  default 	= "{short-url}"
  description 	= "The part of the redirect request identifying the short URL."
  type 		= "string"
}

variable "redirect_short_url_lambda_api_gateway_path_part_redirect" {
  default 	= "redirect"
  description 	= "The part of the redirect request informing us to redirect"
  type 		= "string"
}

variable "redirect_short_url_lambda_api_gateway_http_method" {
  default 	= "GET"
  description 	= "The HTTP method we would like to trigger the request"
  type 		= "string"
}

variable "aws_profile" {
  default 	= "urlshorteneradministrator"
  description 	= "Profile to be used"
  type        	= "string"
}

variable "aws_region" {
  default 	= "eu-west-1"
  description 	= "Region to be used"
  type        	= "string"
}

