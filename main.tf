provider "aws" {
  region = "us-east-1"
}

# 1. Network Firewall
resource "aws_security_group" "portfolio_firewall" {
  name        = "portfolio-web-firewall"
  description = "Allow public traffic to reach our portfolio website"
  
  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Free-Tier Computing Server Instance
resource "aws_instance" "portfolio_server" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.portfolio_firewall.id]

  # ULTRA-CLEAN EXTENSION METHOD: Loads the external bash file safely with zero spacing bugs!
  user_data = templatefile("setup.sh", {})

  tags = {
    Name = "Manmohan-Portfolio-Server"
  }
}

# 3. Dynamic Browser Shortcut link
output "portfolio_live_url" {
  value       = "http://${aws_instance.portfolio_server.public_ip}"
  description = "Click this shortcut link to test and load your live portfolio website!"
}
