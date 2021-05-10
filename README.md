# Terraform
- AMI:
- App:   ami-0fef271f53d5912fe
- DB:    ami-07045bfe1bab353dc

# Terrfarom and Benefits
- Is part of IAC, specifically dealing with orchestration of infrastructure in the cloud.

## Terrafrom most used commands

### Terraform to launch ec2 with VPC, subents, SG services of AWS

### Terraform installation and setting up the path in env variable
- setting env variables for our aws keys
- system ( control panel) - advanced settings - enviroment variable - edit the system variable 
- name env var as `AWS_ACCESS_KEY_ID` for secret key `AWS_SECRET_ACCESS_KEY` 
- in the system variables


### Terraform commands:
```
# terraform init
# terraform plan
# terraform apply
# terraform destroy 
```

- we have to restart git bash after adding credentials in env var. 

### Securing AWS keys with Terraform



- ![image](https://user-images.githubusercontent.com/47173937/117649454-72396f00-b187-11eb-87fb-de7504d88994.png)



```
provider "aws"{
	region = "eu-west-1"
} 
resource "aws_instance" "app_instance"{
	ami = "ami-0fef271f53d5912fe"
	instance_type = "t2.micro"
	associate_public_ip_address = true
	tags = {
		Name = "eng84_ula_terraform_node_app"
	}

}
```
