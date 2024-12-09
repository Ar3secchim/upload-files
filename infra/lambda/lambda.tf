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
      mkdir -p ../app/build && \
      pip install -r ../app/lambda/requirements.txt -t ../app/build && \
      cp ../app/lambda/lambda_function.py ../app/build && \
      cd ../app/build && \
      zip -r ../../infra/lambda_handler.zip .
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


  vpc_config {
    security_group_ids = var.secury_group
    subnet_ids         = var.subnet_ids
  }

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_USER     = var.db_user
      DB_PASSWORD = var.db_password
      DB_NAME     = var.db_name
    }
  }
  depends_on = [null_resource.zip_lambda]
}

# Mapeamento de eventos do SQS para Lambda
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.s3_event_lambda.arn
  batch_size       = 10

  depends_on = [var.sqs_queue_arn]
  lifecycle {
    ignore_changes        = [event_source_arn, function_name]
    create_before_destroy = true
  }
}


output "lambda_function_arn" {
  value = aws_lambda_function.s3_event_lambda.arn
}
