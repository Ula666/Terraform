# Creating variables to apply DRY
# Variables can be called on main.tf
variable "aws_vpc_name" {
  default = "eng84_ula_terraform_vpc"
}

variable "webapp_name" {
  default = "eng84_ula_terraform_web"
}

variable "webapp_ami_id" {
  default = "ami-0fef271f53d5912fe"
}

variable "aws_subnet_name" {
  default = "eng84_ula_terraform_subnet"
}

variable "aws_key_name" {
  default = "eng84devops"
}

variable "aws_key_path" {
  default = "~/.ssh/eng84devops.pem"
}

variable "my_ip" {
  default = "94.0.131.111/32"
  #default = "192.168.56.1/32"
}





