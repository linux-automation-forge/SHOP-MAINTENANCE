# 1. Connect to AWS
provider "aws" {
  region = "us-east-1"
}

# 2. Re-add your storage bucket block
resource "aws_s3_bucket" "test_bucket" {
  bucket = "terrabox-manmohan-bucket-2026"
}

# 3. Create your virtual Linux computer using the CORRECT free-tier type
resource "aws_instance" "my_first_server" {
  ami           = "ami-0e2c8caa4b6378d8c" 
  instance_type = "t3.micro" # <-- FIX: Changed from t2 to t3 to match the Free Tier rules!

  tags = {
    Name = "aws_kj_server"
  }
}
