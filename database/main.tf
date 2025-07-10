terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
      configuration_aliases = [aws.source, aws.destination]
    }
  }
}

resource "aws_db_subnet_group" "source" {
  provider   = aws.source
  name       = "${var.source_db_identifier}-subnet-group"
  subnet_ids = var.source_subnet_ids

  tags = {
    Name = "source-db-subnet-group"
  }
}

resource "aws_db_subnet_group" "destination" {
  provider   = aws.destination
  name       = "${var.destination_db_identifier}-subnet-group"
  subnet_ids = var.destination_subnet_ids

  tags = {
    Name = "destination-db-subnet-group"
  }
}

resource "aws_db_instance" "source" {
  provider               = aws.source
  identifier             = var.source_db_identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.source.name
  vpc_security_group_ids = var.source_rds_sg_ids
  username               = var.master_username
  password               = var.master_password
  backup_retention_period= var.backup_retention_days
  backup_window          = var.backup_window
  publicly_accessible    = false
  skip_final_snapshot    = true
}

resource "aws_db_instance" "destination" {
  provider               = aws.destination
  identifier             = var.destination_db_identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.destination.name
  vpc_security_group_ids = var.destination_rds_sg_ids
  username               = var.master_username
  password               = var.master_password
  backup_retention_period= var.backup_retention_days
  backup_window          = var.backup_window
  publicly_accessible    = false
  skip_final_snapshot    = true
}
