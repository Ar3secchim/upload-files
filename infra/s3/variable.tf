variable "s3_bucket_name" {
  description = "Nome do bucket S3"
}

variable "lambda_name" {
  description = "Nome da função Lambda"
}

variable "bucket_arn" {
  description = "ARN do bucket S3"
}

variable "sns_topic_arn" {
  description = "ARN do tópico SNS"
}

variable "sns_topic_name" {
  description = "Nome do tópico SNS"
}
