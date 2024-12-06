provider "aws" {
  region = var.aws_region
}

# Importa os arquivos individuais
module "s3" {
  source = "./s3"
  s3_bucket_name = var.s3_bucket_name
}

module "iam" {
  source = "./iam"
  iam_role_name = var.iam_role_name
}

module "lambda" {
  source = "./lambda"
  lambda_runtime = var.lambda_runtime
  s3_bucket_name = var.s3_bucket_name
  lambda_name = var.lambda_name
}
