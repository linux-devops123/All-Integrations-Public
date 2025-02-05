#!/bin/bash

for i in {1..3}
do
echo  $i
#if [$i -eq 9]
#then 
#sleep 10
cd WebApplication-ASP.NETCOREMVC/bin/Debug/net5.0
ls
dotnet WebApplication-ASP.NETCOREMVC.dll
#fi
done


#cmd to run is bash shell2.sh