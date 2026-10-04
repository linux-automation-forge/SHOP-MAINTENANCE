# 1. Connect to the AWS North Virginia Data Center Hub
provider "aws" {
  region = "us-east-1"
}

# 2. Build the Network Perimeter Firewall Gatekeeper
resource "aws_security_group" "portfolio_firewall" {
  name        = "portfolio-web-firewall"
  description = "Allow public traffic to reach our portfolio website"
  
  # Allow all incoming web browser requests on Port 80
  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the entire public internet!
  }

  # Allow the machine to reach outward to securely download software packages
  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1" # Code shortcut meaning: Allow all outgoing network communications
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Provision the Free-Tier Virtual Linux Computing Instance
resource "aws_instance" "portfolio_server" {
  ami                    = "ami-0e2c8caa4b6378d8c" # Clean Ubuntu Linux Image
  instance_type          = "t3.micro"             # Locked into the AWS $0.00 Free Tier zone
  vpc_security_group_ids = [aws_security_group.portfolio_firewall.id] # Attaches the firewall above

  # Automated Background Boot Scripts: Executes your web server setup file
  user_data = templatefile("setup.sh", {})

  tags = {
    Name = "Manmohan-Portfolio-Server"
  }
}

# 4. Allocate a Permanent, Static Elastic IP Address from Amazon
resource "aws_eip" "static_ip" {
  domain = "vpc" # Configures the IP to map cleanly inside your default cloud network
}

# 5. Bind the Static Elastic IP Directly to Your Portfolio Server
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.portfolio_server.id
  allocation_id = aws_eip.static_ip.id
}

# 6. Generate Flawless Clickable Dynamic Browser Link Shortcuts
output "permanent_numeric_ip" {
  value       = aws_eip.static_ip.public_ip
  description = "Your permanent, static IP address number string."
}

output "permanent_aws_text_url" {
  value       = "http://${aws_eip.static_ip.public_dns}" # <-- FIX: Points directly to EIP to clear the URL string error!
  description = "Your permanent free AWS text URL link!"
}
