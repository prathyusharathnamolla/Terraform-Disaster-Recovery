module "vpc_primary" {
  source           = "./network"
  providers        = { aws = aws.source }
  name             = "primary"
  vpc_cidr         = var.primary_vpc_cidr
  public_subnets   = var.primary_public_subnets
  private_subnets  = var.primary_private_subnets
  azs              = var.primary_azs
  enable_nat_gateway = var.enable_nat_gateway
}

module "vpc_secondary" {
  source           = "./network"
  providers        = { aws = aws.destination }
  name             = "secondary"
  vpc_cidr         = var.secondary_vpc_cidr
  public_subnets   = var.secondary_public_subnets
  private_subnets  = var.secondary_private_subnets
  azs              = var.secondary_azs
  enable_nat_gateway = var.enable_nat_gateway
}


module "security_groups_source" {
  source      = "./security_groups"
  providers = {aws = aws.source}
  vpc_id      = module.vpc_primary.vpc_id
  app_sg_name = "source-app-sg"
  rds_sg_name = "source-rds-sg"
  tags = {
    Environment = "source"
  }
}

module "security_groups_destination" {
  source      = "./security_groups"
providers = { aws = aws.destination }
  vpc_id      = module.vpc_secondary.vpc_id
  app_sg_name = "destination-app-sg"
  rds_sg_name = "destination-rds-sg"
  tags = {
    Environment = "destination"
  }
}

module "database" {
  source = "./database"

  providers = {
    aws.source      = aws.source
    aws.destination = aws.destination
  }

  source_subnet_ids       = module.vpc_primary.private_subnet_ids
  destination_subnet_ids  = module.vpc_secondary.private_subnet_ids

  source_rds_sg_ids       = [module.security_groups_source.rds_sg_id]
  destination_rds_sg_ids  = [module.security_groups_destination.rds_sg_id]

  source_db_identifier      = var.source_db_identifier
  destination_db_identifier = var.destination_db_identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  master_username   = var.master_username
  master_password   = var.master_password
  backup_retention_days = var.backup_retention_days
  backup_window     = var.backup_window
}


module "application_tier" {
  source = "./application_tier"

  providers = {
    aws.source      = aws.source
    aws.destination = aws.destination
  }

  source_sg_ids         = [module.security_groups_source.app_sg_id, module.security_groups_source.rds_sg_id]
  destination_sg_ids    = [module.security_groups_destination.app_sg_id, module.security_groups_destination.rds_sg_id]

  source_subnet_ids     = module.vpc_primary.private_subnet_ids
  destination_subnet_ids= module.vpc_secondary.private_subnet_ids

  source_vpc_id         = module.vpc_primary.vpc_id
  destination_vpc_id    = module.vpc_secondary.vpc_id

  instance_ami_source      = var.instance_ami_source
  instance_ami_destination = var.instance_ami_destination
  instance_type            = var.instance_type

  max_size              = var.max_size
  min_size              = var.min_size
  desired_capacity      = var.desired_capacity
  health_check_path     = var.health_check_path
}
