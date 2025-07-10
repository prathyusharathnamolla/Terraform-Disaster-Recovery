output "source_bucket_arn" {
  value       = aws_s3_bucket.source.arn
  description = "ARN of the source S3 bucket"
}

output "destination_bucket_arn" {
  value       = aws_s3_bucket.destination.arn
  description = "ARN of the destination S3 bucket"
}

output "replication_role_arn" {
  value       = aws_iam_role.replication_role.arn
  description = "ARN of the replication IAM role"
}
