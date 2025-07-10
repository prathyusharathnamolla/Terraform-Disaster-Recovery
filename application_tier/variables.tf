variable "source_sg_ids" {
  type = list(string)
}

variable "destination_sg_ids" {
  type = list(string)
}

variable "source_subnet_ids" {
  type = list(string)
}

variable "destination_subnet_ids" {
  type = list(string)
}

variable "source_vpc_id" {
  type = string
}

variable "destination_vpc_id" {
  type = string
}

variable "instance_ami_source" {
  type = string
}

variable "instance_ami_destination" {
  type = string
}

variable "instance_type" {
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
