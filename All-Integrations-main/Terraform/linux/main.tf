terraform {
backend "s3"{
        bucket= "elasticbeanstalk-ap-south-1-941812274699"
        key= "ansible/linux/terraform.tfstate"
        region ="ap-south-1"                                                                                                                                                                                                                                    
        profile= "roshi"
        shared_credentials_file="/var/lib/jenkins/files/credentials"
    }
}

provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/files/credentials"
   
}
locals{
  now = timestamp()
  dates=formatdate("DD/MM/YYYY",local.now)
}
#used data in terraform to connect network-interface 
data "aws_network_interface" "any"{
  filter  {
      name = "tag:Name"
      values = ["terraform-network-interface"]
  
  }
 
}
#create ec2 instance of type ubuntu server of 20.4 lts and install apache in it
resource "aws_instance" "ubuntuinstance" {

  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key
  network_interface {
    network_interface_id = data.aws_network_interface.any.id
    device_index = 0
  }
  connection{
    type = "ssh"
    user = "ubuntu"
    host = aws_instance.ubuntuinstance.public_ip
    private_key= "${file("/var/lib/jenkins/files/roshi.pem")}"

  }
#install nginx web server and other softwares in the ubuntu server
provisioner "remote-exec"{
  inline = [
"sudo apt update -y",
"sudo apt install nginx -y",
"sudo systemctl start nginx",
"sudo bash -c 'echo The page was created by the user data > /var/www/html/index.html'",
"sudo apt install python3 -y",
"sudo apt install pip -y"

  ]
}  

 tags = {
    Name = "UbuntuEC2-${local.dates}"
  }   
}
