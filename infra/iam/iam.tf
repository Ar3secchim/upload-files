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
# Policy to allow Lambda function to access SQS
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
      },
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = var.sqs_policy_arn
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

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = var.sqs_queue_url

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action   = "SQS:SendMessage",
        Resource = var.sqs_policy_arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : var.sns_topic_arn
          }
        }
      }
    ]
  })
}

# Security group for RDS instance
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg"
  vpc_id      = var.vpn_id

  ingress {
    from_port   = 3306 # MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # Usar o CIDR do VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}



output "iam_role_name" {
  value = aws_iam_role.lambda_role.name
}
output "iam_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "sns_topic_policy_arn" {
  value = aws_sns_topic_policy.s3_event_topic_policy.arn
}

output "sqs_policy_arn" {
  value = aws_sqs_queue_policy.sqs_policy.policy
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
