# new file
variable "vpc_name" {
  default = "ula_terraform_vpc"
}

variable "pub_subnet_name" {
  default = "testing_subnet_ula"
}

variable "igw_name"{
  default = "terraform_ula_igw"
}

variable "pub_rt_name"{
  default = "terraform_ula_main_rt"
}

variable "pub_sec_name"{
  default = "eng84_ula_pub_sec"
}






variable "name" {
	default = "eng84_ula_terraform_app"
}

variable "webapp_ami_id" {
	default = "ami-0fef271f53d5912fe"
}

# variable "aws_subnet" {
# 	default = "terraform_code_testing_with_subnet_var_ula"
# }

variable "aws_key_name" {
	default = "eng84devops"
}

variable "aws_key_path" {
	default = "~/.ssh/eng84devops.pem"
}


