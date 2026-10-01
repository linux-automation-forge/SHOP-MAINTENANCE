provider "aws" {
    region = "us-east-1" 
}
data "aws_s3_bucket"  "my_demo_bucket" {
bucket = "kj-amazon-bucket"
}
output "bucket_secure_arn" {
value  = data.aws_s3_bucket.my_demo_bucket.arn
}
resource "aws_s3_object" "my_first_file" {
bucket = data.aws_s3_bucket.my_demo_bucket.id
key = "kj.txt"
content = "this file was created by terraform by m.manmohan"
}
