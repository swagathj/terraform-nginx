AWS Auto Scaling Group (ASG) with ELB Terraform module
Terraform module which creates Auto Scaling resources on AWS.

These types of resources are supported:

Launch Configuration
Auto Scaling Group

Terraform versions
Terraform 0.12. Pin module version to ~> v3.0.

Usage

1) Virtual box or machine should have terraform installed before running any terraform commands

2) Place all these files in folder name anything like terraform_example_asg

3) First run "terraform init" ( This will install all the required plugins for terraform )

4) Second validate terraform ( "terraform validate .")

5) Third start plan of terraform ( "terraform plan .")

6) If plan went successfully then we are good to apply changes to AWS to create infrastructure ("terraform apply .")

Required variables:

region          - Required
public_key_path - Key file path to launch ec2 instance
key_name        - Name of the key file
amis            - ami-8da8d2e2 ( This value can be changed to any availaiblle ubuntu amis)
