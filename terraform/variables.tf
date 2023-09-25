variable "ami_id" {
  type    = string
  default = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_size" {
  type    = string
  default = "t3.micro"
}

variable "cli_pem" {
  type    = string
  default = "pzn_cli"
}
