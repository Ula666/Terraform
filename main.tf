# Let's initalise terraform 
# Providers?
# AWS


# This code will eventually launch an EC2 instance for us
# provider is a keyword in Terraform to define the name of cloud provider 
# syntax:

provider "aws"{
# define the region to launch the ec2 instance in Ireland
	region = "eu-west-1"
} 

# Launching an EC2 instance from our Node_app AMI
# resource is the keyword that allows us to add aws resource 
# Resource block of code:


resource "aws_instance" "app_instance"{
	# add the AMI id between "" as below
	# var.name_of_the_resource
	ami = var.webapp_ami_id 

	# Let's add the type of instance we would like to launch
	instance_type = "t2.micro"

	#AWS_ACCESS_KEY = "AWS_ACCESS_KEY_ID"
	#AWS_ACCESS_SECRET = "AWS_ACCESS_SECRET"

	# we need to enable public ip for our app
	associate_public_ip_address = true

	# Tags is to give name to our instnace
	tags = {
		Name = "${var.name}"
	}
}
#key_name = "eng84devops"
#public_key = var.key
# Resource block of code ends here 


# block of code to create a default VPC
#resource "aws_default_vpc" "Terraform_vpc_code_test"{
	#cidr_block = "10.0.0.0/16"
	#instance_tenancy = "default"


	#tags = {
	#	Name = "eng84ula_terraform_vpc"
	#}
#}

# block of code to create a VPC
resource "aws_vpc" "ula_terraform_vpc" {
  cidr_block = "30.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eng84_ula_terraform_vpc"
  }
}




# block of code to create a default VPC
#resource "aws_default_vpc" "default" {
	#cidr_block = "10.0.0.0/16"
	#instance_tenancy = "default"

	#tags = {
	#	Name = "Eng84_ula_vpc_terraform_NodeAPP"
	#	}
	#}

# Resource block of code for VPC ends here 

# subnet
resource "aws_subnet" "testing_subnet_ula" {
	#vpc_id = var.vpc_id
  vpc_id = aws_vpc.ula_terraform_vpc.id
	cidr_block = "30.0.3.0/24"
	availability_zone = "eu-west-1a"
	tags = {
		Name = "Ula_Terraform_Subnet"
	}
}




#security group
resource "aws_security_group" "ula_terraform_code_test_sg" {
	name = "ula_terrafomr_code_test"
	description = "app group"
	#vpc_id = var.vpc_id
  vpc_id = aws_vpc.ula_terraform_vpc.id



# inbound rules for our app
	ingress {
		from_port = "80"
		to_port = "80"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"] #a llow all
	}

# outbound rules

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"] #a llow all
	}

}

# terraform init
# terraform plan
# terraform apply 
# terraform destroy 