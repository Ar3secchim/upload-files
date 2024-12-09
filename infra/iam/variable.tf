variable "iam_role_name" {
  description = "Nome da role IAM"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
}

variable "sns_topic_arn" {
  description = "ARN do tópico SNS para permissões"
  type        = string
}

variable "sqs_queue_url" {
  description = "ARN da fila SQS para permissões"
  type        = string
}

variable "sqs_policy_arn" {
  description = "ARN da política da fila SQS"
  type        = string
}
