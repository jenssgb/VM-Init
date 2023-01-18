#
#
#Download THIS RAR Git Script via PowerShell: 
#(Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jenssgb/VM-Init/main/InstallBGInfo.ps1").Content | Out-File (Join-Path $PWD "InstallBGInfo.ps1")
#
#


# Prompt the user for confirmation before continuing
$confirm = Read-Host -Prompt "This script will install BGInfo and create a task in the Windows Task Scheduler. Do you want to continue? (Y/N)"

# Check the user's response and proceed or exit accordingly
if($confirm -eq "N")
{
    Write-Host "Script execution terminated by user."
    exit
}


Write-Host "Installing BGInfo..."

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


#Download my BG Info Template: 'JensBgInfoConfig.bgi'

$BGTemplateURL = 'https://github.com/jenssgb/VM-Init/blob/main/BgInfo/JensBgInfoConfig.bgi?raw=true'
$BGTemplateFile = $output + 'JensBgInfoConfig.bgi'

#$BGTemplateOutput = $output

Invoke-WebRequest -Uri $BGTemplateURL -OutFile $BGTemplateFile


#Expand-Archive -LiteralPath $file -DestinationPath $output

#Create the Task:

$action = New-ScheduledTaskAction -Execute '"C:\Program Files\BGInfo\BgInfo64.exe"' -Argument '"C:\Program Files\BGInfo\JensBgInfoConfig.bgi" /timer:0'
$trigger1 = New-ScheduledTaskTrigger -AtLogOn
$trigger2 = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId " $env:username " -LogonType Interactive
Register-ScheduledTask -Action $action -Trigger $trigger1,$trigger2 -TaskName "BGInfo at Logon and Session Connect" -Principal $principal

#Create a Desktop Icon:

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Run BGInfo.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-Command schtasks.exe /run /tn 'BGInfo at Logon and Session Connect'"
$Shortcut.Save()