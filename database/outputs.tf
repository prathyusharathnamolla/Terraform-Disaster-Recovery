output "source_db_instance_id" {
  value = aws_db_instance.source.id
}

output "destination_db_instance_id" {
  value = aws_db_instance.destination.id
}
