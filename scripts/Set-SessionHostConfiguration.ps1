Param(
    [string]$HostPoolRegistrationToken,
    [string]$StorageSuffix
)

$ErrorActionPreference = 'Stop'

$Counter = 0
$FileName = 'Configuration.zip'

# Download configuration ZIP file from the AVD PG storage account
do {
    $URL = 'https://wvdportalstorageblob.blob.' + $StorageSuffix + '/galleryartifacts/Configuration_1.0.03519.1433.zip'
    Invoke-WebRequest -Uri $URL -OutFile $FileName -ErrorAction 'SilentlyContinue'
    if($Counter -gt 0)
    {
        Start-Sleep -Seconds 30
    }
    $Counter++
}
until((Test-Path $FileName) -or $Counter -eq 9)

# Extract the ZIP files
Expand-Archive -Path $FileName -Force
Set-Location .\Configuration\
Expand-Archive -Path 'DeployAgent.zip' -Force
Set-Location .\DeployAgent\

# Install the AVD Bootloader
$BootInstaller = (Get-ChildItem -Path 'RDAgentBootLoaderInstall').FullName
Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i $BootInstaller /quiet /qn /norestart /passive" -Wait -Passthru
Start-Sleep -Seconds 5

# Install the AVD Agent
$AgentInstaller = (Get-ChildItem -Path 'RDInfraAgentInstall').FullName
Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i $AgentInstaller /quiet /qn /norestart /passive REGISTRATIONTOKEN=$HostPoolRegistrationToken" -Wait -PassThru
Start-Sleep -Seconds 5