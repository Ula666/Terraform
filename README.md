# Terraform
- AMI:
- App:   ami-0fef271f53d5912fe
- DB:    ami-07045bfe1bab353dc

# Terrfarom and Benefits
- Terraform is an open source “Infrastructure as Code” tool, created by HashiCorp.
- Is part of IAC, specifically dealing with orchestration of infrastructure in the cloud.
- Orchestration tools to configure out instances and their AWS configurations remotely.
- Terraform files are created with .tf extension
-benfits: (Automation, review plan before deployment, )

### Tools available as IAC:
- Terraform
- Ansible
- AWS CloudFormation
- Azure Resource Manager
- Google Cloud Deployment Manager
- Chef
- Puppet
- Vagrant

### Tools available for automation:
- Jenkins, CircleCI, TeamCity, Bamboo, GitLab

### Terraform to launch ec2 with VPC, subents, SG services of AWS

### Terraform installation and setting up the path in env variable
- setting env variables for our aws keys
- system ( control panel) - advanced settings - enviroment variable - edit the system variable 
- name env var as `AWS_ACCESS_KEY_ID` for secret key `AWS_SECRET_ACCESS_KEY` 
- in the system variables


### Terraform commands:
```
# terraform init - to initialise the terraform with required dependencies of the provider mentioned in the main.tf
# terraform plan - to check the synstax of the code
# terraform apply - to run the code
# terraform destroy - to terminate the instnace
```

- we have to restart git bash after adding credentials in env var. 



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
