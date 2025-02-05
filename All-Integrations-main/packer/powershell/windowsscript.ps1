
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
