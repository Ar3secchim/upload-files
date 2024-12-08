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
