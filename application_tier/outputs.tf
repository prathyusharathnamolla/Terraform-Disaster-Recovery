output "source_asg_id" {
  value = aws_autoscaling_group.source.id
}

output "destination_asg_id" {
  value = aws_autoscaling_group.destination.id
}

output "source_alb_dns" {
  value = aws_lb.source.dns_name
}

output "destination_alb_dns" {
  value = aws_lb.destination.dns_name
}
