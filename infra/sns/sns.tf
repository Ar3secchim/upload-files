resource "aws_sns_topic" "s3_event_topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.s3_event_topic.arn
  protocol  = "sqs"
  endpoint  = var.sqs_queue_arn

  depends_on = [var.sqs_policy_arn]
}


output "sns_topic_name" {
  value = aws_sns_topic.s3_event_topic.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.s3_event_topic.arn
}
