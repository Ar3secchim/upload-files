
variable "lambda_name" {
  description = "Nome da função Lambda"
}

variable "lambda_runtime" {
  description = "Runtime da função Lambda"
}

variable "iam_role_name" {
  description = "Nome da role IAM"
}

variable "sqs_queue_arn" {
  description = "ARN da fila SQS"
}


variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
}
