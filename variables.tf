variable "source_region" {
  default = "ca-central-1"
}

variable "destination_region" {
  default = "us-west-2"
}

variable "primary_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "primary_public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "primary_private_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "primary_azs" {
  default = ["ca-central-1a", "ca-central-1b"]
}

variable "secondary_vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "secondary_public_subnets" {
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "secondary_private_subnets" {
  default = ["10.1.11.0/24", "10.1.12.0/24"]
}

variable "secondary_azs" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "enable_nat_gateway" {
  default = true
}


variable "source_bucket_name" {
  type = string
}

variable "destination_bucket_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_ami_source" {
  type = string
}

variable "instance_ami_destination" {
  type = string
}

variable "source_db_identifier" {
  type = string
}

variable "destination_db_identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "backup_retention_days" {
  type = number
}

variable "backup_window" {
  type = string
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "health_check_path" {
  type = string
}

variable "allocated_storage" {
  description = "The size of the DB"
  type        = number
  default     = 20
}
