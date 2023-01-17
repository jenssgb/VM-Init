


if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator. Exiting the script."
    exit
}

$url = "https://download.sysinternals.com/files/BGInfo.zip"
$output = "C:\Program Files\BGInfo\"

if (-not (Test-Path $output)) {
    New-Item -ItemType Directory -Path $output | Out-Null
}

$file = $output + "BGInfo.zip"

if (Test-Path (Join-Path $output "BGInfo.exe")) {
    Write-Host "BGInfo is already installed. Exiting the script."
    exit
}

Invoke-WebRequest -Uri $url -OutFile $file
Expand-Archive -LiteralPath $file -DestinationPath $output
