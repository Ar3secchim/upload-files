variable "aws_region" {
  description = "Região AWS"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
}

variable "lambda_name" {
  description = "Nome da função Lambda"
}

variable "lambda_runtime" {
  description = "Runtime da função Lambda"
}

variable "iam_role_name" {
  description = "Nome da role IAM"
}
