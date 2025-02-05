#befor this first install terraform on ubuntu
terraform {
    required_providers {
      aws = {
      source = "hashicorp/aws"
      version = "~> 4.6"
      }
    }

}
# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/files/credentials"
}


resource "aws_instance" "terraforminstance" {
  
  ami           = "ami-0f69bc5520884278e" 
  instance_type = "t2.micro"
  key_name = "roshi" 
  availability_zone = "ap-south-1b"
  security_groups = ["Security-Ansible2"]

   tags = {
    Name = "FirstAnsibleTerraformEC2"
  }

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key /var/lib/jenkins/files/roshi.pem -i ${aws_instance.terraforminstance.public_ip}, terraform-ansible.yaml"

  }

}


