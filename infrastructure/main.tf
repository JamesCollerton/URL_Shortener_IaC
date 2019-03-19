resource "aws_api_gateway_rest_api" "aws_api_gateway_rest_api" {
  name        = "${var.api_gateway_name}"
  description = "${var.api_gateway_description}"
}
