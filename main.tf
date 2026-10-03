provider "aws" {
  region = "us-east-1"
}

# 1. The Storage Bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "terrabox-manmohan-bucket-2026"
}

# 2. The Free-Tier Virtual Linux Server
resource "aws_instance" "my_first_server" {
  ami           = "ami-0e2c8caa4b6378d8c" 
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Welcome to Manmohan's Tech Startup Website!</h1><p>Deployed automatically via Terraform Cloud.</p>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "aws_kj_server"
  } 
}

# 3. The Print Output Block
output "server_public_ip" {
  value = aws_instance.my_first_server.public_ip 
}
