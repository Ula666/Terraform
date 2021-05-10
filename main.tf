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
	ami = "ami-0fef271f53d5912fe"

	# Let's add the type of instance we would like to launch
	instance_type = "t2.micro"

	#AWS_ACCESS_KEY = "AWS_ACCESS_KEY_ID"
	#AWS_ACCESS_SECRET = "AWS_ACCESS_SECRET"

	# we need to enable public ip for our app
	associate_public_ip_address = true

	# Tags is to give name to our instnace
	tags = {
		Name = "eng84_ula_terraform_node_app"
	}
}
# Resource block of code ends here 



resource "aws_default_vpc" "Terraform_vpc_code_test"{
	#cidr_block = "10.0.0.0/16"
	#instance_tenancy = "default"


	tags = {
		Name = "eng84ula_terraform_vpc"
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





# terraform init
# terraform plan
# terraform apply 
# terraform destroy 