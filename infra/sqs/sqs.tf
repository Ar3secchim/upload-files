
resource "aws_sqs_queue" "s3_event_queue" {
  name = var.sqs_queue_notification_s3
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.s3_event_queue.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.s3_event_queue.url
}
