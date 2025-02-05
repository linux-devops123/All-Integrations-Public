 terraform {
    required_version = ">=1.3.8"
  required_providers {
      aws = {
      source = "hashicorp/aws"
      version = "~> 4.6"
      }
    }

}
  
provider "aws" {
  region = "ap-south-1"
  shared_credentials_files = ["/var/lib/jenkins/files/credentials"]
   
}


resource "aws_instance" "windowsinstance" {
  count         = 2      
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
   tags = {
    Name = "Windows+Ansible"
  }
  security_groups = ["securitygroup-windows-ansible","Security-Ansible2"]
  key_name = "roshi"
  user_data= <<-EOF
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
resource "local_file" "inventory"{
  content = templatefile("inventory.tpl",{
    x = "${aws_instance.windowsinstance.*.public_ip}"
  })
  filename = "hosts.ini"
}

resource "null_resource" "provisioner"{
  provisioner "local-exec" {
   /*
    command = "sleep 120;cp inventory.ini hosts.ini; sed -e  's/PUBLICIP1/element('${self.public_ip}',0)/g' -e 's/PUBLICIP2/element('${self.public_ip}',1)/g' -e 's/PUBLICIP3/element('${self.public_ip}',2)/g' hosts.ini;ansible-playbook -i hosts.ini installsoftware.yaml"
   
   command = "sleep 120;cp inventory.ini hosts.ini; sed -i  's/PUBLICIP1/${element("${aws_instance.windowsinstance.*.public_ip}[0]",0)}/g' hosts.ini;ansible-playbook -i hosts.ini installsoftware.yaml"
  
  command = "sleep 120;cp inventory.ini hosts.ini; sed -i  's/PUBLICIP1/${aws_instance.windowsinstance.*.public_ip[count.index][0]}/g' hosts.ini;ansible-playbook -i hosts.ini installsoftware.yaml"
  */
  command = "sleep 120;ansible-playbook -i hosts.ini installsoftware.yaml"
  }

}

output "id"{

  value =  ["${aws_instance.windowsinstance.*.public_ip}"]
  
}
