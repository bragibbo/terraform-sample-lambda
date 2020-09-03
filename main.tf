provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

variable "region" {
  default = "us-west-2"
}

# Creates a zip file from the directory where the lambda code is contained
data "archive_file" "sample_lambda_zip" {
  type = "zip"
  source_dir = "./src"
  output_path = "sampleLambda.zip"
}

# Creates the actual lambda function and specifies the zip file for the code
# Specify any function environment variables below
resource "aws_lambda_function" "sample"{
  filename = data.archive_file.sample_lambda_zip.output_path
  function_name = "sample-lambda"
  role = aws_iam_role.sample_lambda.arn
  handler = "index.handler"
  runtime = "nodejs12.x"
  source_code_hash = base64sha256(data.archive_file.sample_lambda_zip.output_path)
  publish = true
  timeout = 15

  environment {
    variables = {
        LAMBDA_NAME = "sample-lambda"
    }
  }
}


# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "sample_lambda" {
  name = "sample_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Action": ["sts:AssumeRole"],
    "Principal": {
    "Service": [
      "lambda.amazonaws.com"
    ]
    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
 }
 EOF
}


resource "aws_iam_policy" "sample_lambda" {
  name        = "sample_lambda_policy"
  path        = "/"
  description = "TBD"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Action": ["logs:*"],
    "Resource": ["*"],
    "Sid": "",
    "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sample_lambda" {
  role       = aws_iam_role.sample_lambda.name
  policy_arn = aws_iam_policy.sample_lambda.arn
}

resource "aws_iam_instance_profile" "sample_lambda" {
  name = "sample_lambda_profile"
  role = aws_iam_role.sample_lambda.name
}