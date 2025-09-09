$osInfo = Get-CimInstance Win32_OperatingSystem
$osVersion = $osInfo.Version
$caption = $osInfo.Caption

# Detect if it's a Server or Workstation
if ($caption -like "*Server*") {
    switch -Wildcard ($osVersion) {
        "10.0.14393*" { $osName = "WS16" }  # Windows Server 2016
        "10.0.17763*" { $osName = "WS19" }  # Windows Server 2019
        "10.0.20348*" { $osName = "WS22" }  # Windows Server 2022
        "10.0.25*"    { $osName = "WS25" }  # Placeholder for future Server 2025 (adjust as needed)
        default       { $osName = "WS-Unknown" }
    }
} else {
    # Workstation OS detection
    switch -Wildcard ($osVersion) {
        "10.0.2*"     { $osName = "Win11" }
        "10.0.*"      { $osName = "Win10" }
        default       { $osName = "Win-Unknown" }
    }
}

return "CR-$osName-{0:D3}" -f (Get-Random -Minimum 0 -Maximum 999)
