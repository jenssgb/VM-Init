# Silent install MSTeams
# https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true

# Path for the workdir
$workdir = "c:\installer\"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
else
{ New-Item -Path $workdir  -ItemType directory }

# Download the installer

$source = "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true"
$destination = "$workdir\Teams_windows_x64.msi"

# Check if Invoke-Webrequest exists otherwise execute WebClient

if (Get-Command 'Invoke-Webrequest')
{
     Invoke-WebRequest $source -OutFile $destination
}
else
{
    $WebClient = New-Object System.Net.WebClient
    $webclient.DownloadFile($source, $destination)
}

# Start the installation


Start-Process msiexec.exe -Wait -ArgumentList "/I $destination /qn /norestart"  -PassThru


# Wait XX Seconds for the installation to finish

Start-Sleep -s 35

# Remove the installer
#rm -Force $workdir\Teams*

./configer-rekeys.ps1
