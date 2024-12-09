provider "aws" {
  region = var.aws_region
}

module "s3" {
  source               = "./s3"
  s3_bucket_name       = var.s3_bucket_name
  lambda_name          = module.lambda.lambda_function_arn
  bucket_arn           = module.s3.bucket_arn
  sns_topic_arn        = module.sns.sns_topic_arn
  sns_topic_name       = module.sns.sns_topic_name
  sns_topic_policy_arn = module.iam.sns_topic_policy_arn
}

module "iam" {
  source        = "./iam"
  iam_role_name = var.iam_role_name

  s3_bucket_name = module.s3.bucket_name
  s3_bucket_arn  = module.s3.bucket_arn

  sns_topic_arn  = module.sns.sns_topic_arn
  sqs_queue_url  = module.sqs.sqs_queue_url
  sqs_policy_arn = module.sqs.sqs_queue_arn

  vpn_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
}

module "lambda" {
  source         = "./lambda"
  lambda_name    = var.lambda_name
  lambda_runtime = var.lambda_runtime
  db_user        = var.db_user
  db_password    = var.db_password
  db_name        = var.db_name
  db_host        = module.rds.rds_endpoint

  iam_role_name = module.iam.iam_role_name
  iam_role_arn  = module.iam.iam_role_arn
  sqs_queue_arn = module.sqs.sqs_queue_arn
  subnet_ids    = module.vpc.public_subnet_id
  secury_group  = [module.iam.rds_sg_id]
}


module "sns" {
  source         = "./sns"
  sns_topic_name = var.sns_topic_name

  sqs_queue_arn  = module.sqs.sqs_queue_arn
  sqs_policy_arn = module.sqs.sqs_queue_arn
}

module "sqs" {
  source                    = "./sqs"
  sqs_queue_notification_s3 = var.sqs_queue_notification_s3
}

module "vpc" {
  source = "./vpc"
}

module "rds" {
  source      = "./rds"
  db_password = var.db_password
}
