provider "aws" {
  region = var.aws_region
}
module "s3" {
  source         = "./s3"
  s3_bucket_name = var.s3_bucket_name
  lambda_name    = module.lambda.lambda_function_arn
}

module "iam" {
  source         = "./iam"
  iam_role_name  = var.iam_role_name
  s3_bucket_name = module.s3.bucket_name
  s3_bucket_arn  = module.s3.bucket_arn
}

module "lambda" {
  source         = "./lambda"
  lambda_name    = var.lambda_name
  lambda_runtime = var.lambda_runtime

  s3_bucket_name = module.s3.bucket_name
  iam_role_name  = module.iam.iam_role_name
  iam_role_arn   = module.iam.iam_role_arn
  s3_bucket_arn  = module.s3.bucket_arn
}

