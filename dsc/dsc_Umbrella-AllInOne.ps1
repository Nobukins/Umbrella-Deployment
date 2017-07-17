configuration UmbrellaDeployment
{ 
    node ("localhost") 
    { 
        #Configure Local Configuration Manager to support auto-restart while operation
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }
        #Microsoft Visual C++ 2013 x86 Minimum Runtime - 12.0.40660 for DirectSmile Crossmedia
        #https://support.microsoft.com/ja-jp/help/3179560/update-for-visual-c-2013-and-visual-c-redistributable-package
        Package vcredist2013_x86
        {
            Ensure = "Present"
            Path = "https://download.microsoft.com/download/0/5/6/056DCDA9-D667-4E27-8001-8A0C6971D6B1/vcredist_x86.exe"
            ProductId = 'E30D8B21-D82D-3211-82CC-0F0A5D1495E8'
            Name = "vcredist2013_x86"
            Arguments = "/Q"
        }
        #Microsoft Visual C++ 2013 x64 Minimum Runtime - 12.0.40660 for DirectSmile Crossmedia
        #https://support.microsoft.com/ja-jp/help/3179560/update-for-visual-c-2013-and-visual-c-redistributable-package
        Package vcredist2013_x64
        {
            Ensure = "Present"
            Path = "https://download.microsoft.com/download/0/5/6/056DCDA9-D667-4E27-8001-8A0C6971D6B1/vcredist_x64.exe"
            ProductId = 'CB0836EC-B072-368D-82B2-D3470BF95707'
            Name = "vcredist2013_x64"
            Arguments = "/Q"
        }
        #EFI EPS Suite Umbrella deployment
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