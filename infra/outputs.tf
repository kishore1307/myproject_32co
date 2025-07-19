output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.static_assets.bucket
}

output "public_subnet_id" {
  value = aws_subnet.public_a.id
}
