provider "aws" {
  region = var.aws_region
}

# Importa os arquivos individuais
module "s3" {
  source = "./s3.tf"
}
