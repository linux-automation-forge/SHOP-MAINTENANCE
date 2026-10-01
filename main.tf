provider "aws" {
    region = "us-east-1" 
}
data "aws_s3_bucket"  "my_demo_bucket" {
bucket = "kj-amazon-bucket"
}
output "bucket_secure_arn" {
value  = data.aws_s3_bucket.my_demo_bucket.arn
}
