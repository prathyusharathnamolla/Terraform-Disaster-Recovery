variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}
