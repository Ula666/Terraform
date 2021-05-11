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

# block of code to create a VPC
resource "aws_vpc" "ula_terraform_vpc" {
  cidr_block = "30.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eng84_ula_terraform_vpc"
  }
}
# block of code to create a default VPC


# create internet gateway
resource "aws_internet_gateway" "terraform_ula_igw" {
  vpc_id = aws_vpc.ula_terraform_vpc.id

  tags = {
    Name = var.igw_name
  }
}

# create main route table
resource "aws_default_route_table" "terraform_ula_public_rt" {
  default_route_table_id = aws_vpc.ula_terraform_vpc.default_route_table_id

    route {
      # associated subnet can reach everywhere
      cidr_block = "0.0.0.0/0"
      # ig to reach internet
      gateway_id = aws_internet_gateway.terraform_ula_igw.id
    } 

    tags = {
      Name = var.pub_rt_name
    } 
}


# create public subnet
resource "aws_subnet" "terraform_public_subnet" {
  #vpc_id = var.vpc_id
  vpc_id = aws_vpc.ula_terraform_vpc.id
  cidr_block = "30.0.3.0/24"
  tags = {
    Name = "Ula_Terraform_Subnet"
  }
}

# associate route table with public subnet
resource "aws_route_table_association" "rt_public_subnet_1" {
  subnet_id = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_vpc.ula_terraform_vpc.default_route_table_id
}

#security group
resource "aws_security_group" "public_sec_group" {
  name = var.pub_sec_name
  description = "app security group"
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


# Launching an EC2 instance from our Node_app AMI
# resource is the keyword that allows us to add aws resource 
# Resource block of code:
resource "aws_instance" "app_instance"{
  # add the AMI id between "" as below
  # var.name_of_the_resource
  ami = var.webapp_ami_id 
  # Let's add the type of instance we would like to launch
  instance_type = "t2.micro"
  # we need to enable public ip for our app
  associate_public_ip_address = true
  key_name = var.aws_key_name
  subnet_id = aws_subnet.terraform_public_subnet.id
  security_groups = [aws_security_group.public_sec_group.id]

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