# Execute first: Set-ExecutionPolicy Unrestricted

$webClient = new-object System.Net.WebClient

function Get-UtilsScript ($script_name) {
    $url = "https://raw.githubusercontent.com/ecalder6/azure-gaming/master/$script_name"
    Write-Host "Downloading utils script from $url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    $webClient.DownloadFile($url, "C:\$script_name")
}

function Install-GPUDriver {
    Write-Output "Installing Nvidia Driver"
    $driver_file = "nvidia-driver.exe"
    $version = "391.03"
    $url = "http://us.download.nvidia.com/Windows/Quadro_Certified/$version/$version-quadro-grid-desktop-notebook-win10-64bit-international-whql.exe"

    Write-Output "Downloading Nvidia M60 driver from URL $url"
    $webClient.DownloadFile($url, "C:\$driver_file")

    Write-Output "Installing Nvidia M60 driver from file C:\$driver_file"
    Start-Process -FilePath "C:\$driver_file" -ArgumentList "-s", "-noreboot" -Wait
    Start-Process -FilePath "C:\NVIDIA\DisplayDriver\$version\Win10_64\International\setup.exe" -ArgumentList "-s", "-noreboot" -Wait
}

$script_name = "utils.psm1"
Get-UtilsScript $script_name
Import-Module "C:\$script_name"
Update-Firewall
Disable-Defender
Disable-ScheduledTasks
Disable-IPv6To4
Disable-InternetExplorerESC
Edit-VisualEffectsRegistry
Add-DisconnectShortcut

Install-GPUDriver
Restart-Computer
