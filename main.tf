provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_first_server" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"

resource "aws_s3_bucket" "dummy_bucket" {
 bucket = "terrabox-manmohan-bucket-2026"
}

  tags = {
    Name = "aws_kj_server"
  }
}
