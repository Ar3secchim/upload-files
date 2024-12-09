
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

variable "db_user" {
  description = "Usuário do banco de dados"
}

variable "db_password" {
  description = "Senha do banco de dados"
}

variable "db_name" {
  description = "Nome do banco de dados"
}

variable "db_host" {
  description = "Host do banco de dados"
}

variable "secury_group" {
  description = "ID do security group"
}

variable "subnet_ids" {
  description = "IDs das subnets"
  type        = list(string)
}
