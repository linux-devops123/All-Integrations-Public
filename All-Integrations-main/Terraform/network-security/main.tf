
provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/files/credentials"
   
}
#to create vpc
resource "aws_vpc" "terraform_vpc" {
 
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Environment = "dev"
    Name = "terraform-vpc"
  }
}



#to create subnet
resource "aws_subnet" "terraform_subnet" {
 
  vpc_id           = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
  Name = "terraform-subnet"
  }
}

#now do terraform apply
#it will create vpc and subnet
#to delete vpc and subnet  -terraform destroy

#create internet gateway
resource "aws_internet_gateway" "terraform_gateway" {
  
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-gateway"
  }
}

#create route-table
resource "aws_route_table" "terraform_route_table" {
  
  vpc_id   = aws_vpc.terraform_vpc.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }

  route{
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }

  tags = {
    Name = "terraform-route-table"
  }
} 

#associate subnet with route table
resource "aws_route_table_association" "route_table_association" {
   
  subnet_id     = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.terraform_route_table.id
}

#security group to allow web traffic
resource "aws_security_group" "terraform_security_group" {
  
  name        = "terraform_security_group"
  description = "Allow TLS inbound traffic for terraform"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = "https from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
   ingress {
    description      = "winrm-https"
    from_port        = 5986
    to_port          = 5986
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
    ingress {
    description      = "rdp"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
    ingress {
    description      = "icmp"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "terraform_security_group"
  }
}

#aws network interface
resource "aws_network_interface" "terraform_network_interface" {
 
  subnet_id       = aws_subnet.terraform_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.terraform_security_group.id]
  tags ={
    Name = "terraform-network-interface"
  }
}

#elastic ip
#through elastic ip created  and attached to the ec2 instance created , the instance ip address will remain same and will never change on stop or start of the servers
resource "aws_eip" "elastic_ip" {
  
 
  vpc                       = true
  network_interface         = aws_network_interface.terraform_network_interface.id
  associate_with_private_ip = "10.0.1.50" 
  #elastic ip depends on internet gateway
  depends_on = [aws_internet_gateway.terraform_gateway]
  tags ={
    Name = "terraform-elasticip"
  }
}
