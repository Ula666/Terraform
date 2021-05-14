#task

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
  availability_zone = "eu-west-1b"

  tags = {
    Name = var.aws_subnet_name
  }
}
# private subnet for db
resource "aws_subnet" "subnet_for_vpc_private" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "30.0.30.0/24"
  #availability_zone = "eu-west-1c"

  tags = {
    Name = "eng84_ula_terraform_private_subnet"
  }
}
#2rd public subnet 
resource "aws_subnet" "subnet_for_vpc_public2" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "30.0.60.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "eng84_ula_terraform_public_subnet2"
  }
}

#3rd public subnet 
resource "aws_subnet" "subnet_for_vpc_public3" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "30.0.90.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "eng84_ula_terraform_public_subnet3"
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
#2nd public subnet
resource "aws_route_table_association" "public_subnet_assoc2" {
  subnet_id      = aws_subnet.subnet_for_vpc_public2.id
  route_table_id = aws_route_table.terraform_public_rt.id
}

#3rd public subnet
resource "aws_route_table_association" "public_subnet_assoc3" {
  subnet_id      = aws_subnet.subnet_for_vpc_public3.id
  route_table_id = aws_route_table.terraform_public_rt.id
}



# public security groups
resource "aws_security_group" "terraform_webapp_sg" {
  name = "eng84_ula_terraform_web_sg"
  description = "Security group for the webapp "
  vpc_id = aws_vpc.terraform_vpc.id

}
  # Inbound rules
resource "aws_security_group_rule" "http_access" {
  #ingress {
  type = "ingress"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_webapp_sg.id
}

resource "aws_security_group_rule" "my_ssh" {
  #ingress {
  type = "ingress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = [var.my_ip]
    #description = "Allow admin to SSH"
  security_group_id = aws_security_group.terraform_webapp_sg.id
}

  
resource "aws_security_group_rule" "vpc_access" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1" # All traffic
  cidr_blocks = [var.vpc_cidr]
  security_group_id = aws_security_group.terraform_webapp_sg.id
}

resource "aws_security_group_rule" "outbound_traffic" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_webapp_sg.id
}


# security group for db
resource "aws_security_group" "terraform_db_sg" {
  name = "eng84_ula_terraform_db_sg"
  description = "Private security group"
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_security_group_rule" "priv_vpc_access" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.vpc_cidr]
  security_group_id = aws_security_group.terraform_db_sg.id
}

resource "aws_security_group_rule" "priv_ssh_access" {
  type = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.terraform_db_sg.id
}

resource "aws_security_group_rule" "priv_vpc_outbound" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_db_sg.id
}






# target group:
resource "aws_lb_target_group" "target_group" {
  name     = "eng84-ula-terraform-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.terraform_vpc.id
}


# Create a Load Balancer
resource "aws_lb" "load_balancer" {
  name               = "eng84-ula-terraform-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  security_groups    = [aws_security_group.terraform_webapp_sg.id]
  subnets            = [aws_subnet.subnet_for_vpc.id, aws_subnet.subnet_for_vpc_public2.id, aws_subnet.subnet_for_vpc_public3.id]
}


# Create a listener to forward traffic from load balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  depends_on = [aws_lb_target_group.target_group, aws_lb.load_balancer]
}



#create autoscaling
# firstly, create an AMI template
resource "aws_launch_template" "launch_template" {
  name = "eng84_ula_terraform_ltemplate"
  ebs_optimized = false

  image_id = var.webapp_ami_id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.terraform_webapp_sg.id]
  }

  depends_on = [aws_security_group.terraform_webapp_sg]
}

# Create an auto-scaling group
resource "aws_autoscaling_group" "auto_scale" {
  name = "eng84_ula_terraform_asg"
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  


  lifecycle {
    ignore_changes = [target_group_arns]
  }

  target_group_arns = [aws_lb_target_group.target_group.arn]

  vpc_zone_identifier = [aws_subnet.subnet_for_vpc.id, aws_subnet.subnet_for_vpc_public2.id]
                         
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}




# Launch db instance
resource "aws_instance" "terraform_db" {
  ami = var.db_ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.aws_key_name
  subnet_id = aws_subnet.subnet_for_vpc_private.id
  private_ip = var.db_ip
  vpc_security_group_ids = [aws_security_group.terraform_db_sg.id]


  tags = {
    Name = var.db_name
  }
}





