resource "aws_s3_bucket" "static_assets" {
  bucket = "devops-static-assets-${random_id.bucket_suffix.hex}"
  acl    = "private"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
