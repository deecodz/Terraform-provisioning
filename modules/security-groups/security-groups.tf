
variable "security_group_name" {
  description = "my-security-group"
  type        = string
}

variable "security_group_description" {
  description = "My security group"
  type        = string
}

variable "final-proj-vpc" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "inbound_rules" {
  description = "List of inbound rules"
  type        = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
}))
  default = [
    {
      name         = "Grafana"
      from_port    = 3000
      to_port      = 3000
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "Node_Exporter"
      from_port    = 9100
      to_port      = 9100
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "SSH"
      from_port    = 22
      to_port      = 22
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "Http"
      from_port    = 80
      to_port      = 80
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "jenkins"
      from_port    = 8080
      to_port      = 8080
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "prometheus"
      from_port    = 9090
      to_port      = 9090
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "Flask"
      from_port    = 5000
      to_port      = 5000
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      name         = "Https"
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_security_group" "my-security-group" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.final-proj-vpc

  dynamic "ingress" {
    for_each = var.inbound_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.name
    }
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow all outbound traffic"
  }
}


output "my-security-group-id" {
  description = "ID of the security group"
  value       = aws_security_group.my-security-group.id
}

