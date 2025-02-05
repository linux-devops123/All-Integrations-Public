#terraform is a devops activity and is infrastructure as code
#terraform documentation=https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# Configure the AWS Provider
terraform{
  required_version = ">=1.1.6"
}

provider "aws" {
  region = "ap-south-1"
 shared_credentials_file = "/var/lib/jenkins/files/credentials"
   
}

#do not create a folder path for this powershell 
#script , it dosent work rather than give it here only
data "template_file" "user_data"{
  template = <<-EOF

<powershell>
Set-ExecutionPolicy Unrestricted -Force
$instanceId = Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/instance-id

#changing ec2 instance password

netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
$admin = [adsi]("WinNT://./administrator, user")
$admin.psbase.invoke("SetPassword", "Roshi123!!!")



#for ansible
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file 
#install chocolatey
function InstallChocolatey
{
    #copied from chocolaty installation
    Write-Host "install choco and run the exe"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    choco feature enable -n allowGlobalConfirmation

}
InstallChocolatey
#install dotnet sdk
function Installdotnet{
choco install dotnet-5.0-sdk -y
}
Installdotnet
#install aws cli

function Installcli{

#choco install awscli 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"

$source = 'https://awscli.amazonaws.com/AWSCLIV2.msi'
$destination = 'C:\Users\Administrator\Downloads\AWSCLIV2.msi'

# Create web client
$webClient = [System.Net.WebClient]::new()

# Download the file
$webClient.DownloadFile($source, $destination)

Start-Process -FilePath C:\windows\system32\msiexec.exe -Args "/i $destination /passive" -Verb RunAs -Wait
$env:Path += ";C:\Program Files\Amazon\AWSCLIV2"
}

Installcli

aws --version
aws configure --list
aws s3 ls


#for exe

cd C:\
mkdir C:\app                                                                                        
mkdir C:\executables
mkdir C:\batfile
aws s3 cp s3://elasticbeanstalk-ap-south-1-941812274699/WebApplication-ASP.NETCOREMVC.zip C:/app
Expand-Archive "C:\app\WebApplication-ASP.NETCOREMVC.zip" -DestinationPath "C:\app"
cd C:\app\WebApplication-ASP.NETCOREMVC\bin\Debug\net5.0
#move file
#Copy-Item -Path "C:\app\WebApplication-ASP.NETCOREMVC\bin\Debug\net5.0\WebApplication-ASP.NETCOREMVC.exe" -Destination "C:\executables"
#create shortcut of exe
$source="C:\app\WebApplication-ASP.NETCOREMVC\bin\Debug\net5.0\WebApplication-ASP.NETCOREMVC.exe"
$shortcutpath="C:\executables\WebApplication-ASP.NETCOREMVC.lnk"
$script=New-Object -comObject WScript.Shell
$shortcut=$script.CreateShortcut($shortcutpath)
$shortcut.TargetPath=$source
$shortcut.Save()


#create file
New-Item -Path "C:\batfile\exes.bat"
#add data
Add-Content -Path C:\batfile\exes.bat -Value "C:\executables\WebApplication-ASP.NETCOREMVC.lnk"

#start the RDS db as the application db server is in rds


</powershell>
  EOF
}

locals{
  block_device = [
    {
      device_name = "/dev/sda1"
      volume_type = "gp2"
      volume_size = "30"
      
    }
  ]
}


resource "aws_instance" "terraformwindowsinstance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count = var.count_val
  availability_zone = var.availability_zone
  key_name = var.key_name
  tags =var.instance_tags
  vpc_security_group_ids = [var.security_group_id]
  user_data = "${data.template_file.user_data.rendered}"
  dynamic "ebs_block_device"{
    for_each = local.block_device
    content{
      delete_on_termination = true
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      device_name = ebs_block_device.value.device_name
    }
  }
}
#ec2 instance details
#username=administrator
#password=Roshi123!!!


#to delete ec2 instance -
#terraform destroy
#or 
#terraform destroy -auto-approve


#cmd=terraform
#terraform state
# terraform state list =to list the things we have created
# terraform state list aws_internet_gateway.terraform_gateway
# terraform state show aws_internet_gateway.terraform_gateway 









