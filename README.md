# Umbrella-Deployment
Umbrella-Deployment is the deployment script repository for Umbrella itself.
It first makes sure to install all prereqs, then install umbrell at the end.

* Microsoft Visual C++ 2013 x86
* Microsoft Visual C++ 2013 x64
* Microsoft .NetFramework (higher than 4.5.2 required)
* Umbrella

------------------------------------
## DSC version
dsc version is as literaly written to use dsc syntax written .ps1 files.

You can get .ps1 file from [DevOps](https://github.com/Nobukins/Umbrella-Deployment/tree/master/DevOps) directory.
1. Open Powershell ISE as Administrator
2. Open relevant .ps1 file
3. Execute it by copy & paste code into console window

------------------------------------
## Powershell version
Powershell version is probably more stable as it anyway run it on where you can run powershell.

------------------------------------
#### for Windows 2008 R2 (*)
PowerShell ISE (Integrated Scripting Environment) gets installed by default with Windows 7  or Windows Server 2008 R2 but doesn’t show in the start menu. There are two ways to enable PowerShell ISE.
Please refer more detail in this [MSDN article](https://blogs.msdn.microsoft.com/guruketepalli/2012/11/06/enable-powershell-ise-from-windows-server-2008-r2/)

Using PowerShell

1. Open Powershell Window
2. Execute following cmdlets.

```powershell
Import-Module ServerManager
Add-WindowsFeature PowerShell-ISE
```
