resource "aws_db_instance" "rds_instance" {
  allocated_storage     = 20
  max_allocated_storage = 50
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = var.db_password
  parameter_group_name  = "default.mysql8.0"
  publicly_accessible   = false
  skip_final_snapshot   = true
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "rds_password" {
  value = var.db_password
}
