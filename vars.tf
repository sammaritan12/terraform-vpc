variable "region" {
    type = string
    default = "eu-west-1"
}

variable "subnet_amount" {
  type    = number
  default = 2
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/20"
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/23", "10.0.2.0/23", "10.0.4.0/23"]
}

variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.6.0/23", "10.0.8.0/23", "10.0.10.0/23"]
}

variable "subnet_azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
