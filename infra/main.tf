provider "aws" {
  region = var.aws_region
}

# Importa os arquivos individuais
module "s3" {
  source = "./s3.tf"
}

module "iam" {
  source = "./iam.tf"
}

module "lambda" {
  source = "./lambda.tf"
}
