#!/bin/bash
sudo apt-get update
wget -O packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm -rf packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-5.0
dotnet --version


#install aws cli and download the zip file from s3
sudo apt-get install awscli -y
aws --version
aws s3 ls
mkdir dll
aws s3 cp s3://elasticbeanstalk-ap-south-1-941812274699/WebApplication-ASP.NETCOREMVC.zip dll
pwd
sudo apt-get install -y unzip 
unzip /home/ubuntu/dll/WebApplication-ASP.NETCOREMVC.zip
pwd WebApplication-ASP.NETCOREMVC
ls


