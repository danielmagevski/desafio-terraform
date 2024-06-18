provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check = true
  endpoints {
    apigateway = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    iam        = "http://localhost:4566"
  }
}


variable "lambda_function_name" {
  default = "echo-server"
}

variable "api_gateway_name" {
  default = "echo-server-api"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "${var.lambda_function_name}_policy_attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "echo_server" {
  filename         = "lambda_function.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.8"
}

resource "aws_api_gateway_rest_api" "echo_api" {
  name        = var.api_gateway_name
  description = "API Gateway for echo server"
}

resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.echo_api.id
  parent_id   = aws_api_gateway_rest_api.echo_api.root_resource_id
  path_part   = "echo"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.echo_api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.echo_api.id
  resource_id             = aws_api_gateway_resource.root_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.echo_server.invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.echo_server.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:000000000000:*/test/POST/echo"
}

resource "aws_api_gateway_deployment" "echo_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.echo_api.id
  stage_name  = "test"
}

output "api_gateway_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.echo_api.id}/test/_user_request_/echo"
}
