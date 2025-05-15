provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
            Service = "lambda.amazonaws.com"
        }
    }]
  })
}

resource "aws_lambda_function" "container_lambda_py" {
  function_name = "lambda-container-py"
  package_type = "Image"
  image_uri = var.image_uri
  role = aws_iam_role.lambda_exec_role.arn
  timeout = 10
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
