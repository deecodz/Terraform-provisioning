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

# Define the Grafana security group
resource "aws_security_group" "grafana" {
  name        = "grafana"
  description = "Grafana Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the Node-exporter security group
resource "aws_security_group" "node_exporter" {
  name        = "node-exporter"
  description = "Node-exporter Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the SSH security group
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "SSH Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the HTTP security group
resource "aws_security_group" "http" {
  name        = "http"
  description = "HTTP Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the Jenkins and the likes security group
resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Jenkins Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the prometheus/nagios security group
resource "aws_security_group" "prometheus" {
  name        = "prometheus"
  description = "Prometheus Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the Flask security group
resource "aws_security_group" "flask" {
  name        = "flask"
  description = "Flask Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the HTTPS security group
resource "aws_security_group" "https" {
  name        = "https"
  description = "HTTPS Security Group"
  vpc_id      = var.final-proj-vpc

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "grafana_sg_id" {
  description = "ID of the Grafana security group"
  value       = aws_security_group.grafana.id
}

output "node_exporter_sg_id" {
  description = "ID of the Node-exporter security group"
  value       = aws_security_group.node_exporter.id
}

output "ssh_sg_id" {
  description = "ID of the SSH security group"
  value       = aws_security_group.ssh.id
}

output "http_sg_id" {
  description = "ID of the HTTP security group"
  value       = aws_security_group.http.id
}

output "jenkins_sg_id" {
  description = "ID of the Jenkins security group"
  value       = aws_security_group.jenkins.id
}

output "prometheus_sg_id" {
  description = "ID of the Prometheus security group"
  value       = aws_security_group.prometheus.id
}

output "flask_sg_id" {
  description = "ID of the Flask security group"
  value       = aws_security_group.flask.id
}

output "https_sg_id" {
  description = "ID of the HTTPS security group"
  value       = aws_security_group.https.id
}

