# AWS Infrastructure Provisioning with Terraform

This project provides the Terraform scripts to provision an AWS environment including VPC, subnets, internet gateway, route tables, IAM roles, security groups and EC2 instances.

## Components

The main components of the infrastructure that are provisioned through this project include:

- A Virtual Private Cloud (VPC)
- Public and private subnets in different availability zones
- Internet Gateway
- Public and private Route Tables
- IAM role and instance profile
- EC2 instances in the public subnets
- Custom Security Group with specific inbound rules

*Please note that there is also the setup for EC2 instances in the private subnets, but these are currently commented out.*

## Pre-requisites

You need to have Terraform installed and configured to use this project.

## Usage

To use these scripts, you need to have your AWS credentials configured. You can do this by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables, or by using the AWS CLI `aws configure` command.

Once your AWS credentials are configured, navigate to the directory containing the Terraform scripts, and use the following commands:

- Initialize Terraform: 
```
terraform init
```
- Create a plan:
```
terraform plan
```
- Apply the changes:
```
terraform apply
```
You will be asked to confirm before the changes are applied.

## Module: Security Group

The Security Group module creates a security group in the specified VPC, with a set of specified inbound rules. Each inbound rule has a name, from_port, to_port, protocol and a list of CIDR blocks. By default, the script contains a set of inbound rules for services like Grafana, Node_Exporter, SSH, Http, Jenkins, Prometheus, Flask, and Https. 

The egress rule allows all outbound traffic.

The ID of the created security group is outputted, which can then be used when launching EC2 instances.

## Variables

This project uses a number of input variables and environment variables to allow customization and to pass the AWS credentials. 

- instance_count: Number of instances to create in each subnet
- availability_zones: List of availability zones where the subnets will be created
- security_group_name: Name of the security group
- security_group_description: Description of the security group
- final-proj-vpc: The ID of the VPC where the security group will be created
- inbound_rules: List of inbound rules for the security group

## Outputs

- final-proj-vpc: The ID of the created VPC
- my-security-group-id: The ID of the created security group

## Note

This is a sample project and is not meant for production use. Be sure to thoroughly review and test any scripts before using them in a production environment. Always follow the principle of least privilege and make sure to comply with all relevant compliance standards and best practices.
