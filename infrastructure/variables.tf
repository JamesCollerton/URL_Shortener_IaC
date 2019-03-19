 variable "aws_profile" {
   default       = "apigatewaydynamodbadministrator"
   description   = "Profile to be used"
   type          = "string"
 }
 
 variable "aws_region" {
   default       = "eu-west-1"
   description   = "Region to be used"
   type          = "string"
 }

 variable "api_gateway_name" {
   default 	 = "url-shortener-api-gateway"
   description   = "The name you would like to assign to your API gateway"
   type          = "string"
 }
 
 variable "api_gateway_description" {
   default 	 = "This is the API gateway for all of the URL shortening functionality"
   description   = "The description of your API gateway"
   type          = "string"
 }
