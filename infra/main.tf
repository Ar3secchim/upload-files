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
}

module "lambda" {
  source         = "./lambda"
  lambda_name    = var.lambda_name
  lambda_runtime = var.lambda_runtime

  iam_role_name = module.iam.iam_role_name
  iam_role_arn  = module.iam.iam_role_arn
  sqs_queue_arn = module.sqs.sqs_queue_arn
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
