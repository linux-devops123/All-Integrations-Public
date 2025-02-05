
terraform{
  required_version = ">=1.1.6"
  backend "s3"{
        bucket= "elasticbeanstalk-ap-south-1-941812274699"
        key= "ansible/terraform.tfstate"
        region ="ap-south-1"                                                                                                                                                                                                                                    
        profile= "roshi"
        shared_credentials_file="/var/lib/jenkins/files/credentials"
    }

}

provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/files/credentials"
   
}



#created modules in terraform for code reusability

module "terraformwindowsinstance" {
  source ="../Modules/ec2"
  ami_id           = var.ami_id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name
  security_group_id = var.security_group_id
  instance_tags = var.instance_tags
  count_val = var.count_val

}


#terraform init
#terraform apply -auto-approve

#to delete ec2 instance -
#terraform destroy
#or 
#terraform destroy -auto-approve


#cmd=terraform
#terraform state
# terraform state list =to list the things we have created
# terraform state list aws_internet_gateway.terraform_gateway
# terraform state show aws_internet_gateway.terraform_gateway 









