# Let's initialise Terraform
# This code will launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of the cloud provider
provider "aws" {
  # Define the region to launch the instance
  region = "eu-west-1"
}

# Create a VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "30.0.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = var.aws_vpc_name
  }
}

# Create and assign an Internet Gateway
resource "aws_internet_gateway" "terraform_ig" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "eng84_ula_terraform_ig"
  }
}

# Create and assign a subnet to the VPC
resource "aws_subnet" "subnet_for_vpc" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "30.0.1.0/24"
  map_public_ip_on_launch = true # Make it a public subnet

  tags = {
    Name = var.aws_subnet_name
  }
}
# private subnet for db
resource "aws_subnet" "subnet_for_vpc_private" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "30.0.30.0/24"
  #map_public_ip_on_launch = true # Make it a public subnet

  tags = {
    Name = "eng84_ula_terraform_private_subnet"
  }
}


# Create a route table
resource "aws_route_table" "terraform_public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
  }

  tags = {
    Name = "eng84_ula_terraform_public_rt"
  }
}

# Create a private route table
resource "aws_route_table" "terraform_private_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "eng84_ula_terraform_private_rt"
  }
}


# Add subnet associations for the public subnet
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.subnet_for_vpc.id
  route_table_id = aws_route_table.terraform_public_rt.id
}

resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.subnet_for_vpc_private.id
  route_table_id = aws_route_table.terraform_private_rt.id
}


# security group for app
resource "aws_security_group" "terraform_webapp_sg" {
  name = "eng84_ula_terraform_web_sg"
  description = "Security group for the webapp "
  vpc_id = aws_vpc.terraform_vpc.id


  # Inbound rules
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access from the browser"
  }

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
    description = "Allow admin to SSH"
  }

  # Outbound rules
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic out"
  }

  tags = {
    Name = "eng84_ula_terraform_web_sg"
  }
}

# security group for db
resource "aws_security_group" "terraform_db_sg" {
  name = "eng84_ula_terraform_db_sg"
  description = "Private security group"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port         = "22"
    to_port           = "22"
    protocol          = "tcp"
    cidr_blocks       = [var.my_ip]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "priv_vpc_access" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_db_sg.id
}



# Launching an EC2 instance from our web app AMI
# resource is the keyword that allows us to add AWS resource as task in Ansible
resource "aws_instance" "web_app_instance" {
  # var.name_of_resource loads the value from variable.tf
  ami = var.webapp_ami_id
  # Adding the instance type
  instance_type = "t2.micro"
  # Enabling a public IP for the web app
  associate_public_ip_address = true
  # Specifying the key (to SSH)
  key_name = var.aws_key_name
  #public_key = var.aws_key_path
  # Assigning a subnet
  subnet_id = aws_subnet.subnet_for_vpc.id
  # Security group
  vpc_security_group_ids = [aws_security_group.terraform_webapp_sg.id]

  tags = {
    Name = var.webapp_name
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.aws_key_path)
    #private_key = "${file("~/.ssh/eng84devops.pem")}"
    #host = aws_instance.web_app_instance.public_ip
    host = self.public_ip
  }

  # provisioner "remote-exec" {
  #   inline = [ "cd app/","DB_HOST=${aws_instance.db_instance.public_ip} pm2 start app.js"]
  # }

    # Move the provisions from local machine to the instance
  provisioner "file" {
    source = "./scripts/app/init.sh.tpl"
    destination = "/home/ubuntu/init.sh.tpl"
  }
  
  # Allow it to be executable and run it
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/init.sh",
      "sudo /home/ubuntu/init.sh"
    ]
  }
}

resource "aws_instance" "db_instance" {
  ami = var.db_ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.aws_key_name
  subnet_id = aws_subnet.subnet_for_vpc_private.id
  vpc_security_group_ids = [aws_security_group.terraform_db_sg.id]


  tags = {
    Name = var.db_name
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/eng84devops.pem")}"
    host = self.public_ip
    #host = aws_instance.db_instance.public_ip
    }
  provisioner "remote-exec" {
    inline = [ "sudo systemctl start mongod" ]
    }
}





# script for the app instance
data "template_file" "app_init" {
    template = "${file("./scripts/app/init.sh.tpl")}"
}



# # terraform init
# # terraform plan
# # terraform apply 
# # terraform destroy 