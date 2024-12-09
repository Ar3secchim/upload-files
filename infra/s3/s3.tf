data "aws_lambda_function" "s3_event_lambda" {
  function_name = var.lambda_name
}

data "aws_lambda_function" "aws_lambda_permission" {
  function_name = var.lambda_name
}

resource "aws_s3_bucket" "ada_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_notification" "sns_bucket_notifications" {
  bucket = var.s3_bucket_name

  topic {
    topic_arn = var.sns_topic_policy_arn
    events    = ["s3:ObjectCreated:*"]
  }
  depends_on = [
    var.sns_topic_policy_arn
  ]
}


output "bucket_name" {
  value = aws_s3_bucket.ada_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.ada_bucket.arn
}
