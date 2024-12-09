data "aws_lambda_function" "s3_event_lambda" {
  function_name = var.lambda_name
}

data "aws_lambda_function" "aws_lambda_permission" {
  function_name = var.lambda_name
}

resource "aws_s3_bucket" "ada_bucket" {
  bucket = var.s3_bucket_name
}

# event notification for S3 bucket to Lambda function
resource "aws_s3_bucket_notification" "ada_bucket_notifications" {
  bucket = aws_s3_bucket.ada_bucket.id

  # Notificação para Lambda
  lambda_function {
    lambda_function_arn = data.aws_lambda_function.s3_event_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  # Notificação para SNS
  topic {
    topic_arn = var.sns_topic_arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    data.aws_lambda_function.aws_lambda_permission,
    var.sns_topic_policy_arn
  ]
}

output "bucket_name" {
  value = aws_s3_bucket.ada_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.ada_bucket.arn
}
