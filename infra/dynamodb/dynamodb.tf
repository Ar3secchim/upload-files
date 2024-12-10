resource "aws_dynamodb_table" "files_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "file_name"

  attribute {
    name = "file_name"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  global_secondary_index {
    name            = "CreatedAtIndex"
    hash_key        = "created_at"
    projection_type = "ALL"
  }

}
