provider "aws" {
  region = "us-east-1"
}

# 1. The Network Firewall
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

# 2. The Free-Tier Virtual Linux Server
resource "aws_instance" "portfolio_server" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t3.micro" # Free Tier size [Amazon EC2 12-Month Free Tier - Amazon Web Services]
  vpc_security_group_ids = [aws_security_group.portfolio_firewall.id]

  user_data = templatefile("setup.sh", {})

  tags = {
    Name = "Manmohan-Portfolio-Server"
  }
}

# 3. NEW BLOCK: Allocate a Permanent Static Elastic IP
resource "aws_eip" "static_ip" {
  domain = "vpc" # Configures it to work inside your default cloud network
}

# 4. NEW BLOCK: Bind the Elastic IP directly to your Server
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.portfolio_server.id
  allocation_id = aws_eip.static_ip.id
}

# 5. UPGRADED OUTPUTS: Prints your permanent text and number URLs
output "permanent_numeric_ip" {
  value       = aws_eip.static_ip.public_ip
  description = "Your permanent, static IP address number string."
}

output "permanent_aws_text_url" {
  value       = "http://${aws_instance.portfolio_server.public_dns}"
  description = "Your permanent free AWS text URL link!"
}
