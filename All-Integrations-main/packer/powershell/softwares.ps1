function InstallChocolatey
{
    #copied from chocolaty installation
    Write-Host "install choco and run the exe"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    choco feature enable -n allowGlobalConfirmation

}
function Installchrome{
    choco install googlechrome
}
function Installpython{
    choco install python

}

function Installdotnet{
choco install dotnet-5.0-sdk -y
}
function Installsql{
    
    choco install sql-server-management-studio
}
function Installunzip{
choco install unzip
}

function InstallVisualStudio{
    choco install visualstudio2019community
}

function InstallVisualStudioCode{
    choco install vscode
}
#currently if commented the package, it takes time 
InstallChocolatey
#Installchrome
Installpython
Installdotnet
#Installunzip
#Installsql
#InstallVisualStudio
#InstallVisualStudioCode
