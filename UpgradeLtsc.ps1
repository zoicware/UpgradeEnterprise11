If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	
}

#download skus from github
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/zoicware/UpgradeEnterprise11/main/24H2%20skus.zip' -UseBasicParsing -OutFile "$env:TEMP\skus.zip" 
Expand-Archive -Path "$env:TEMP\skus.zip" -DestinationPath $env:TEMP
$folders = (Get-ChildItem -Path "$env:TEMP\24H2 skus" -Directory).FullName  
foreach ($folder in $folders) {
    Move-Item -Path $folder -Destination 'C:\Windows\System32\spp\tokens\skus' -Force
}

Write-Host 'Skus Installed...Updating...'
#upgrade 
cscript.exe $env:SystemRoot\system32\slmgr.vbs /rilc
cscript.exe $env:SystemRoot\system32\slmgr.vbs /upk 
cscript.exe $env:SystemRoot\system32\slmgr.vbs /ckms 
cscript.exe $env:SystemRoot\system32\slmgr.vbs /cpky 
cscript.exe $env:SystemRoot\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D

Write-Host 'Restart to Finish...'
pause
