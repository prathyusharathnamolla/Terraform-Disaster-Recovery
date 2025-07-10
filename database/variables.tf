variable "source_subnet_ids" {
  type = list(string)
}

variable "destination_subnet_ids" {
  type = list(string)
}

variable "source_rds_sg_ids" {
  type = list(string)
}

variable "destination_rds_sg_ids" {
  type = list(string)
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

variable "allocated_storage" {
  type = number
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
