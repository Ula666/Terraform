# Terraform


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


### In AWS US, they have data centres we can't buy.
- Renting the services - pay as you go
- Created gov cloud - for government sector only

-Five years ago, companies wanted to migrate to the cloud
-Secret services were not willing to integrate due to security

- Issues:
- Premises goes on fire
- Stealing data (hard drives)
- Physical security only

AWS created Gov cloud to solve these issues
### Tools available for automation:
- Jenkins, CircleCI, TeamCity, Bamboo, GitLab


### hybrid cloud:
- The combination of private and public cloud deployments  
- advantage of public cloud while doing heavy workloads and the information is secure as private cloud is incorporated within the same.
- the most expensive
- Better support for a remote workforce
- ![image](https://user-images.githubusercontent.com/47173937/117793239-f18c7880-b243-11eb-8e91-de5c5024e74a.png)

### private cloud:
- The cloud infrastructure is located inside the organization and it is not shared with anyone without the permission of the organization. 
- Secure - Private cloud as most secure among all the cloud deployments.
- Customization, scaling and flexibility control is higher in the private cloud. Hardware and software are built only for the owner.
- performance
- ![image](https://user-images.githubusercontent.com/47173937/117797403-e20f2e80-b247-11eb-9f3d-bece94562b5b.png)

### public cloud:
- Users over the internet use cloud services in which the infrastructure is based on the cloud computing company. - Public cloud is not that secure and the organizations with sensitive information are not ought to use this cloud. The information is available for everyone who uses the cloud.
- costs
- scalablility
- ![image](https://user-images.githubusercontent.com/47173937/117797453-f4896800-b247-11eb-9445-0c661860207b.png)


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

- AMI:
- App:   ami-0fef271f53d5912fe
- DB:    ami-07045bfe1bab353dc
