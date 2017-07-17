﻿configuration UmbrellaDeployment
{ 
    node ("localhost") 
    { 
        #Umbrella deployment
		Package Umbrella 
        { 
            Ensure = "Present" 
            Path = "https://directsmile.blob.core.windows.net/installer/umbrella.msi"
            Name = "EFI EPS Suite Umbrella"
            ProductId="47F4B030-ACA6-47E5-8C51-E240D5BC4114"
            Arguments = '/log c:\dsc_Umbrella_Deployment.log ROOTURL="http://localhost"'                        
        }
    }
}
#Register DSC script as function
UmbrellaDeployment

#Execute Desired State Configuration Script
Start-DscConfiguration -Wait -Force -Verbose -Path .\UmbrellaDeployment

<#All of exe installation cannot be tracked whether it successfully installed or not, because it is .exe, not .msi. So don't worry#>
<# If it throw error, try same command with -Force as additional parameter. It force to apply it again#>

<# Set ExecutionPolicy #>
# https://technet.microsoft.com/en-us/library/ee176961.aspx
Set-ExecutionPolicy -Force Unrestricted