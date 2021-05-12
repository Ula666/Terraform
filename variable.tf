# Creating variables to apply DRY
# Variables are called on main.tf
variable "aws_vpc_name" {
  default = "eng84_ula_terraform_vpc"
}

variable "webapp_name" {
  default = "eng84_ula_terraform_web"
}

variable "db_name" {
  default = "eng84_ula_terraform_db"
}

variable "webapp_ami_id" {
  default = "ami-0fef271f53d5912fe"
}

variable "db_ami_id" {
  default = "ami-07045bfe1bab353dc"
}

variable "aws_subnet_name" {
  default = "eng84_ula_terraform_subnet"
}

# aws .pem key
variable "aws_key_name" {
  default = "eng84devops"
}

variable "aws_key_path" {
  default = "~/.ssh/eng84devops.pem"
}

variable "my_ip" {
  default = "94.0.131.111/32"
}





