variable "vpc_id" {
  type = string
}

variable "app_sg_name" {
  type = string
}

variable "rds_sg_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
