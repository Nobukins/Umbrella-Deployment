<#
.SYNOPSIS  
    Deploy Umbrella together with prereq
.DESCRIPTION  
    This powershell script does download prereq with umbrella itself, then execute silently.
    It automatically reboot machine with 10 seconds timeout range.
.NOTES  
    File Name  : DevOps_Umbrella-Deployment.ps1
.LINK  
    https://technet.microsoft.com/en-us/sysinternals/autologon.aspx
    https://gallery.technet.microsoft.com/scriptcenter/a6b10a18-c4e4-46cc-b710-4bd7fa606f95
.EXAMPLE  
    .\DevOps_Umbrella-Deployment.ps1 -DOTNET462_DLUrl "http://url01/xxx.exe" -vcredist2013_x86_DLUrl "http://url02/xxx.exe" -vcredist2013_x64_DLUrl "http://url03/xxx.exe" -UMBRELLA_DLUrl "http://url03/xxx.msi" -DOTNET462_DLFilePath "C:\DLFile01.exe" -vcredist2013_x86_DLFilePath "C:\DLFile02.exe" -vcredist2013_x64_DLFilePath "C:\DLFile03.exe" -UMBRELLA_DLFilePath "C:\DLFile04.msi" -ROOTURL="" -MANIFEST_BASEURL="" -MANIFEST_VERSION="" -INSTALL_AS_SERVICE=""

.PARAMETER DOTNET462_DLUrl
   Download File URL of .Net 4.6.2
.PARAMETER vcredist2013_x86_DLUrl
   Download File URL of Microsoft Visual C++ 2013 x86
.PARAMETER vcredist2013_x64_DLUrl
   Download File URL of Microsoft Visual C++ 2013 x64
.PARAMETER UMBRELLA_DLUrl
   Download File URL of Umbrella

.PARAMETER DOTNET462_DLFilePath  
   Destination path of downloaded file to be stored
.PARAMETER vcredist2013_x86_DLFilePath  
   Destination path of downloaded file to be stored
.PARAMETER vcredist2013_x64_DLFilePath  
   Destination path of downloaded file to be stored
.PARAMETER UMBRELLA_DLFilePath  
   Destination path of downloaded file to be stored

.PARAMETER ROOTURL  
   Root URL of target server
.PARAMETER MANIFEST_VERSION 
   Media repository sub dir name
.PARAMETER MANIFEST_BASEURL  
   Media repository URL
.PARAMETER INSTALL_AS_SERVICE  
   If you set 1, it install Umbrella agent as Windows Service
   
.PARAMETER CNNAME  
   If you configure Umbrella to Certificate authentication mode, enter valid Common name your cert was issued to.
.PARAMETER NOCERTS  
   If NOCERTS is true, the default service config will be replaced by one that supports http binding and message security only. 
   No certs necessary in this case, and true is Umbrella's default value.
   (false as default for DSMInstallationService)
#>
param (
    [string]$DOTNET462_DLUrl = "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe",
    [string]$vcredist2013_x86_DLUrl = "https://download.microsoft.com/download/0/5/6/056DCDA9-D667-4E27-8001-8A0C6971D6B1/vcredist_x86.exe",
    [string]$vcredist2013_x64_DLUrl = "https://download.microsoft.com/download/0/5/6/056DCDA9-D667-4E27-8001-8A0C6971D6B1/vcredist_x64.exe",
    [string]$UMBRELLA_DLUrl = "https://directsmile.blob.core.windows.net/installer/umbrella.msi",

    [string]$DOTNET462_DLFilePath = "C:\NDP47-KB3186497-x86-x64-AllOS-ENU.exe",
    [string]$vcredist2013_x86_DLFilePath = "C:\vcredist_x86.exe",
    [string]$vcredist2013_x64_DLFilePath = "C:\vcredist_x64.exe",
    [string]$UMBRELLA_DLFilePath = "C:\umbrella.msi",
    
    [string]$ROOTURL = "http://localhost",
    [string]$MANIFEST_VERSION = "public",
    [string]$MANIFEST_BASEURL = "https://dsmstore.directsmile.de/umbrella",
    [string]$INSTALL_AS_SERVICE = "0",
    
    [string]$CNNAME = "",
    [string]$NOCERTS = ""
)
<# -------------- File Download -------------- #>

Write-Progress -activity "Download File(s)" -status "10% Complete:" -percentcomplete 10

<# 1. Download Visual C++ 2013 x86 Offline installer #>
#Microsoft Visual C++ 2013 x86 Minimum Runtime - 12.0.40660 for DirectSmile Crossmedia
#https://support.microsoft.com/ja-jp/help/3179560/update-for-visual-c-2013-and-visual-c-redistributable-package
Write-Host "Start Download - Visual C++ 2013 x86 Offline Installer"
(New-Object Net.WebClient).DownloadFile($vcredist2013_x86_DLUrl,$vcredist2013_x86_DLFilePath)
Write-Host "Complete Download"

Write-Progress -activity "Download File(s)" -status "20% Complete:" -percentcomplete 20

<# 2. Download Visual C++ 2013 x64 Offline installer #>
#Microsoft Visual C++ 2013 x64 Minimum Runtime - 12.0.40660 for DirectSmile Crossmedia
#https://support.microsoft.com/ja-jp/help/3179560/update-for-visual-c-2013-and-visual-c-redistributable-package
Write-Host "Start Download - Visual C++ 2013 x64 Offline Installer"
(New-Object Net.WebClient).DownloadFile($vcredist2013_x64_DLUrl,$vcredist2013_x64_DLFilePath)
Write-Host "Complete Download"

Write-Progress -activity "Download File(s)" -status "30% Complete:" -percentcomplete 30

<# 3. Download Umbrella installer #>
#EFI EPS Suite Umbrella deployment
Write-Host "Start Download - Umbrella Installer"
(New-Object Net.WebClient).DownloadFile($UMBRELLA_DLUrl,$UMBRELLA_DLFilePath)
Write-Host "Complete Download"

Write-Progress -activity "Download File(s)" -status "40% Complete:" -percentcomplete 40

<# 4. Download .Net Framework 4.6.2 Offline installer #>
Write-Host "Start Download - .Net 4.6.2 Offline Installer"
(New-Object Net.WebClient).DownloadFile($DOTNET462_DLUrl,$DOTNET462_DLFilePath)
Write-Host "Complete Download"


<# -------------- File Execution -------------- #>
Write-Progress -activity "Execute File(s)" -status "50% Complete:" -percentcomplete 50
<# 5. Use x86 Powershell.exe to run C++ 2013 x86 Installer #>
Write-Host "Start to install C++ 2013 x86"
Start-Process -FilePath "$ENV:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList "-Command `"& {Start-Process -FilePath $vcredist2013_x86_DLFilePath -ArgumentList '/q /norestart /log C:\temp\log.txt' -Wait -NoNewWindow}`"" -Wait -NoNewWindow
Write-Host "Complete installation of C++ 2013 x86"

Write-Progress -activity "Execute File(s)" -status "60% Complete:" -percentcomplete 60
<# 6. Use x86 Powershell.exe to run C++ 2013 x64 Installer #>
Write-Host "Start to install C++ 2013 x64"
Start-Process -FilePath "$ENV:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList "-Command `"& {Start-Process -FilePath $vcredist2013_x64_DLFilePath -ArgumentList '/q /norestart /log C:\temp\log.txt' -Wait -NoNewWindow}`"" -Wait -NoNewWindow
Write-Host "Complete installation of C++ 2013 x64"

Write-Progress -activity "Execute File(s)" -status "70% Complete:" -percentcomplete 70
<# 7. Install Umbrella over msiexec #>
Write-Host "Create Special install parameter based on given arguments"
if ($CNNAME -eq "") { 
    Write-Host "Make Umbrella default deployment"
    $UMBRELLA_CUSTOM_PARAMETERS = "ROOTURL=$ROOTURL MANIFEST_VERSION=$MANIFEST_VERSION MANIFEST_BASEURL=$MANIFEST_BASEURL INSTALL_AS_SERVICE=$INSTALL_AS_SERVICE"
    } else {
    Write-Host "Make Umbrella cusomized deployment"
    $UMBRELLA_CUSTOM_PARAMETERS = "ROOTURL=$ROOTURL MANIFEST_VERSION=$MANIFEST_VERSION MANIFEST_BASEURL=$MANIFEST_BASEURL INSTALL_AS_SERVICE=$INSTALL_AS_SERVICE NOCERTS=$NOCERTS CNNAME=$CNNAME"
    }
Write-Host "Start to install Umbrella"
Start-Process msiexec.exe -Wait -ArgumentList "/I $UMBRELLA_DLFilePath /log c:\dsc_Umbrella_Deployment.log $UMBRELLA_CUSTOM_PARAMETERS /qr"
Write-Host "Complete installation of Umbrella"

Write-Progress -activity "Execute File(s)" -status "80% Complete:" -percentcomplete 80
<# 8. Use x86 Powershell.exe to run .Net4.6.2 Installer #>
Write-Host "Start to install .Net462"
Start-Process -FilePath "$ENV:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList "-Command `"& {Start-Process -FilePath $DOTNET462_DLFilePath -ArgumentList '/q /norestart /log C:\temp\log.txt' -Wait -NoNewWindow}`"" -Wait -NoNewWindow
Write-Host "Complete installation of .Net462"


<# -------------- Restart within 1 min -------------- #>

Write-Progress -activity "Reboot server to ensure deployment" -status "90% Complete:" -percentcomplete 90
<# 9. Restart to confirm Autologin #>
# Restart Computer
Shutdown -r