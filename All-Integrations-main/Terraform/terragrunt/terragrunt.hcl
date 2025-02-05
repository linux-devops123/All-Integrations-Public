terraform{
   source = "../Modules/ec2" 
}

/*
generate "provider"{
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
  region = "ap-south-1"
  shared_credentials_files = ["/var/lib/jenkins/files/credentials"]
   
}
EOF
}
*/
inputs = {
availability_zone = "ap-south-1b"
instance_type = "t2.micro"
key_name = "roshi"
ami_id="ami-0ea5fe2202629c60b"
security_group_id="sg-0ce20a821c382ed22"
count_val = 2
instance_tags ={
Name = "WindowsTerragruntEC2",
Environment = "Dev",
Owner = "roshi"
}
}


#terragrunt init
#terragrunt apply -auto-approve
#terragrunt destroy -auto-approve
