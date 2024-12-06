resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = <<EOT
      cd ../lambda && \
      zip -r ../infra/lambda_handler.zip .
    EOT
  }
}

resource "aws_lambda_function" "s3_event_lambda" {
  filename         = "${path.module}/lambda_handler.zip"
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.lambda_runtime
  source_code_hash = filebase64sha256("${path.module}/lambda_handler.zip")

  environment {
    variables = {
      BUCKET_NAME = var.s3_bucket_name
    }
  }

  depends_on = [null_resource.zip_lambda]
}



resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_event_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.ada_bucket.arn
}
