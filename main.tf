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

  tags = {
    Name = "aws_kj_server"
  } # <-- Tag block is safely contained inside the server resource block!
}

# 3. The Print Output Block
output "server_public_ip" {
  value = aws_instance.my_first_server.public_ip # <-- Removed quotes and corrected the single underscore nickname!
}
