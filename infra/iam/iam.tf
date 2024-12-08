variable "s3_bucket_arn" {
  description = "ARN do bucket S3"
}

# Role to allow Lambda function to read from S3 bucket
resource "aws_iam_role" "lambda_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Policy to allow Lambda function to read from S3 bucket
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.iam_role_name}-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Policy to publish messages to SNS topic
resource "aws_sns_topic_policy" "s3_event_topic_policy" {
  arn = var.sns_topic_arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = var.sns_topic_arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" : var.s3_bucket_arn
          }
        }
      }
    ]
  })
}


output "iam_role_name" {
  value = aws_iam_role.lambda_role.name
}
output "iam_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

