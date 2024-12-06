resource "aws_s3_bucket" "ada_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_notification" "ada_bucket_notification" {
  bucket = aws_s3_bucket.ada_bucket.id

}
