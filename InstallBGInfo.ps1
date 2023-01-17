


$url = "https://download.sysinternals.com/files/BGInfo.zip"
$output = "C:\path\to\save\"
$file = $output + "BGInfo.zip"

Invoke-WebRequest -Uri $url -OutFile $file
Expand-Archive -LiteralPath $file -DestinationPath $output

