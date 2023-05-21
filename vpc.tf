provider "aws" {
  region = "us-east-1"  
}

# Environment Variables and module
variable "instance_count" {
  default = 3
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1a"]  
}

module "my_security_groups" {
  source                    = "./modules/security-groups"
  security_group_name       = "my-security-group"
  security_group_description = "My Security Group"
  final-proj-vpc      = aws_vpc.final-proj-vpc.id
}

# Create VPC
resource "aws_vpc" "final-proj-vpc" {
  cidr_block           = "10.0.0.0/16"  
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "final-proj-vpc"
  }
}


# vpc output for ref
output "final-proj-vpc" {
  description = "The ID of the VPC"
  value       = aws_vpc.final-proj-vpc.id
}


# Create public subnets in each availability zone
resource "aws_subnet" "final-proj-pub-subnet" {
  count              = length(var.availability_zones)
  vpc_id             = aws_vpc.final-proj-vpc.id
  cidr_block         = "10.0.${count.index}.0/24"  
  map_public_ip_on_launch = true
  availability_zone  = element(var.availability_zones, count.index)

  tags = {
    Name = "final-proj-pub-subnet"
  }
}

# Create private subnets in each availability zone
resource "aws_subnet" "final-proj-pri-subnet" {
  count              = length(var.availability_zones)
  vpc_id             = aws_vpc.final-proj-vpc.id
  cidr_block         = "10.0.${count.index + 100}.0/24"  
  map_public_ip_on_launch = false
  availability_zone  = element(var.availability_zones, count.index)

  tags = {
    Name = "final-proj-pri-subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "final-proj-igw" {
  vpc_id = aws_vpc.final-proj-vpc.id

  tags = {
    Name = "final-proj-igw"
  }
}


# Create public route table
resource "aws_route_table" "final-proj-pub-RT" {
  vpc_id = aws_vpc.final-proj-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.final-proj-igw.id
  }

  tags = {
    Name = "final-proj-pub-RT"
  }
}

# Create private route table
resource "aws_route_table" "final-proj-pri-RT" {
  vpc_id = aws_vpc.final-proj-vpc.id
}

# Create default route for public route table
resource "aws_route" "final-proj-pub_default_route" {
  route_table_id         = aws_route_table.final-proj-pub-RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.final-proj-igw.id
}


# create IAM role for ec2
resource "aws_iam_role" "final-proj-admin-role" {
  name               = "admin-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# role profile
resource "aws_iam_instance_profile" "final-proj-admin-profile" {
  name  = "admin-profile"
  role = aws_iam_role.final-proj-admin-role.name
}

# Create EC2 instances in public subnets
resource "aws_instance" "final-proj-instance" {
  count                      = var.instance_count
  ami                        = "ami-053b0d53c279acc90" 
  instance_type              = "t2.medium" 
  key_name                   = "docs" 
  subnet_id                  = aws_subnet.final-proj-pub-subnet[count.index].id
  vpc_security_group_ids     = [module.my_security_groups.my-security-group-id]
  
  iam_instance_profile = aws_iam_instance_profile.final-proj-admin-profile.name
  
  tags = {
    Name = "final-proj-${count.index + 1}"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "final-proj-pub-subnet-ass" {
  count          = length(aws_subnet.final-proj-pub-subnet)
  subnet_id      = aws_subnet.final-proj-pub-subnet[count.index].id
  route_table_id = aws_route_table.final-proj-pub-RT.id
}

#  # Create EC2 instances in private subnets
#  resource "aws_instance" "final-proj-DB-" {
#   count = var.instance_count

#    ami           = "ami-007855ac798b5175e" 
#    instance_type = "t2.medium"  
#    key_name      = "docs"  

#    subnet_id              = aws_subnet.final-proj-pri-subnet[count.index].id
#    vpc_security_group_ids = [
#      module.my_security_groups.grafana,
#      module.my_security_groups.node_exporter,
#      module.my_security_groups.ssh,
#      module.my_security_groups.http,
#      module.my_security_groups.jenkins,
#      module.my_security_groups.prometheus,
#      module.my_security_groups.flask,
#      module.my_security_groups.https
#]    

#    tags = {
#      Name = "final-proj-DB-${count.index + 1}"
#    }
#  }

#  # Associate private subnets with private route table
#  resource "aws_route_table_association" "final-proj-pri-subnet-ass" {
#    count          = length(aws_subnet.final-proj-pri-subnet)
#    subnet_id      = aws_subnet.final-proj-pri-subnet[count.index].id
#    route_table_id = aws_route_table.final-proj-pri-RT.id
#  }

