variable "iam_role_arn" {
  description = "ARN da role IAM"
}


data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../app/lambda"
  output_path = "lambda_handler.zip"
}

resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = <<EOT
      cd ../app/lambda && \
      zip -r ../../infra/lambda/lambda_handler.zip .
    EOT
  }

  triggers = {
    # Recria o ZIP apenas se o código mudar
    source_hash = data.archive_file.lambda.output_base64sha256
  }
}
resource "aws_lambda_function" "s3_event_lambda" {
  filename      = "lambda_handler.zip"
  function_name = var.lambda_name
  role          = var.iam_role_arn
  handler       = "lambda_function.lambda_handler"

  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda.output_base64sha256

  depends_on = [null_resource.zip_lambda]
}

# Mapeamento de eventos do SQS para Lambda
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.s3_event_lambda.arn
  batch_size       = 10

  depends_on = [var.sqs_queue_arn]
}


output "lambda_function_arn" {
  value = aws_lambda_function.s3_event_lambda.arn
}
