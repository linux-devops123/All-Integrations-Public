#the key concept of this terraform file is to create an ec2 instance which can be linux or windows on the basis of packer ami owner
#storing the state file in s3 because it contains confidential data
terraform{
    backend "s3"{
        bucket= "elasticbeanstalk-ap-south-1-941812274699"
        key= "ansible/packer-terraform/terraform.tfstate"
        region ="ap-south-1"                                                                                                                                                                                                                                    
        profile= "roshi"
        shared_credentials_file="/var/lib/jenkins/files/credentials"
    }
}

provider "aws"{
    region = var.region
    profile= "roshi"
    shared_credentials_files=["/var/lib/jenkins/files/credentials"]
   
}

#data source in terraform allows to use info outside terraform
data "aws_ami" "packerami"{
    most_recent=true
    owners=["941812274699"]
    tags={
        Name = "packer"
    }
}
resource "aws_instance" "packerterraform"{
    ami = data.aws_ami.packerami.id
    instance_type = var.instance_type
    availability_zone= var.availability_zone
    vpc_security_group_ids=["sg-0ce20a821c382ed22","sg-06f1716570c381e07"]
    key_name= var.key
    tags= var.tags
}

output "name"{
    value= aws_instance.packerterraform.id
}



#terraform init
#terraform apply -auto-approve
#terraform destroy -auto-approve
