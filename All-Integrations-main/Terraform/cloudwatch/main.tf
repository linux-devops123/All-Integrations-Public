#create cloud watch group
provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/files/credentials"
   
}
resource "aws_cloudwatch_log_group" "terraform_cloudwatch" {
  name = "/aws/terraform_cloudwatch"

}
