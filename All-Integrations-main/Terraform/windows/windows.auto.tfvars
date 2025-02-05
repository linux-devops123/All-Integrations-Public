
availability_zone = "ap-south-1b"
instance_type = "t2.micro"
key_name = "roshi"
ami_id="ami-077d687accca02dc1"
count_val = 2
security_group_id="sg-0ce20a821c382ed22"
instance_tags ={
Name = "WindowsTerraformEC2",
Environment = "Dev",
Owner = "roshi"
}
#subnet_id= "subnet-03dc22388125cd2af"
