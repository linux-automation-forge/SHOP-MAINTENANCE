provider "aws" {
region = "us-east-1"
}
resource "aws_security_group" "portfolio_firewall" {
name = "portfolio-web-firewall"
description = "Allow public traffic to reach our portfolio website"
ingress {
from_port = 80 
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 0 
to_port = 0 
protocol = -1
cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_instance" "portfolio_server" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.portfolio_firewall.id]
user_data = <<-EOF 
            #!/bin/bash
            sudo apt-get update -y
            sudo apt-get install apache2 -y
            sudo systemctl start apache2
            sudo systemctl enable apache2
            cat <<HTML > /var/www/html/index.html
            ${file("portfolio.html")}
            HTML
            EOF
}
output "portfolio_live_url" {
 value = "https://${aws_instance.portfolio_server.public_ip}"
description ="click this link to visit our portfolio website"
}
