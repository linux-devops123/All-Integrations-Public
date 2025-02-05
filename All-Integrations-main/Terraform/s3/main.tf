 //create s3 bucket
 provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/files/credentials"
  
   
}
 resource "aws_s3_bucket" "terraform-s3" {
  bucket = "terraform-bucket-roshi"
   acl    = "private"
  tags = {
    Name        = "Terraform bucket Roshi"
    Environment = "Dev"
  }
}
