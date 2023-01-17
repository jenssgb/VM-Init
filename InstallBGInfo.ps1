#Download the RAR Git Script:
#(Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jenssgb/VM-Init/main/InstallBGInfo.ps1").Content | Out-File (Join-Path $PWD "InstallBGInfo.ps1")


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


#Download my BG Info Template: 



#Create the Task:

$action = New-ScheduledTaskAction -Execute 'C:\Program Files\BGInfo\BgInfo64.exe' -Argument 'C:\Program Files\BGInfo\JensBgInfoConfig.bgi /timer:0'
$trigger1 = New-ScheduledTaskTrigger -AtLogOn
$trigger2 = New-ScheduledTaskTrigger -SessionStateChange -State "SessionConnected"
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -Action $action -Trigger $trigger1,$trigger2 -TaskName "BGInfo at Logon and Session Connect" -Principal $principal


