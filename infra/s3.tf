resource "aws_s3_bucket" "ada_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_notification" "ada_bucket_notification" {
  bucket = aws_s3_bucket.ada_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_event_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}
