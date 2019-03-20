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

variable "aws_profile" {
  default 	= "apigatewaydynamodbadministrator"
  description 	= "Profile to be used"
  type        	= "string"
}

variable "aws_region" {
  default 	= "eu-west-1"
  description 	= "Region to be used"
  type        	= "string"
}

