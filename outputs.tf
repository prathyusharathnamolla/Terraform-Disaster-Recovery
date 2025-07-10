output "primary_vpc_id" {
  value = module.vpc_primary.vpc_id
}

output "secondary_vpc_id" {
  value = module.vpc_secondary.vpc_id
}

output "source_app_alb_dns" {
  value = module.application_tier.source_alb_dns
}

output "destination_app_alb_dns" {
  value = module.application_tier.destination_alb_dns
}

output "source_db_instance_id" {
  value = module.database.source_db_instance_id
}

output "destination_db_instance_id" {
  value = module.database.destination_db_instance_id
}
