resource "aws_sns_topic" "s3_event_topic" {
  name = var.sns_topic_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.s3_event_topic.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.s3_event_topic.name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.s3_event_topic.arn
  protocol  = "email"
  endpoint  = "renarasecchim@gmail.com"
}
