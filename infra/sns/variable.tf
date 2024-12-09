variable "sns_topic_name" {
  description = "The name of the SNS topic"
}
variable "sqs_queue_arn" {
  description = "ARN da fila SQS para assinatura do SNS"
  type        = string
}

variable "sqs_policy_arn" {
  description = "ARN da política de permissões da SQS"
  type        = string
}
