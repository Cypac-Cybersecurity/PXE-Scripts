# Unified Guest Tools Installer with VBox, VMware, VirtIO (MSI + EXE)
$logFile = 'C:\GuestToolsInstaller.log'

function Log-Message {
    param ([string]$msg)
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $msg"
}

try {
    Set-TimeZone -Id 'Hawaiian Standard Time'
    Log-Message "Timezone set to Hawaiian Standard Time"
} catch {
    Log-Message "Failed to set timezone: $_"
}


Log-Message "========== Starting guest tools installation check =========="

$drives = 'DEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()

# VBox Guest Additions
if (-not (Get-Process VBoxTray -ErrorAction SilentlyContinue)) {
    foreach ($letter in $drives) {
        $exe = "${letter}:\VBoxWindowsAdditions.exe"
        if (Test-Path -LiteralPath $exe) {
            Log-Message "Found VBox Guest Additions at $exe"
            $certs = "${letter}:\cert"
            $certUtil = "${certs}\VBoxCertUtil.exe"
            if (Test-Path $certUtil) {
                try {
                    Log-Message "Adding VBox certs..."
                    Start-Process -FilePath $certUtil -ArgumentList "add-trusted-publisher ${certs}\vbox*.cer", "--root ${certs}\vbox*.cer" -Wait
                    Log-Message "VBox certs added"
                } catch {
                    Log-Message "Failed to add VBox certs: $_"
                }
            }
            try {
                Start-Process -FilePath $exe -ArgumentList '/with_wddm', '/S' -Wait -PassThru | ForEach-Object {
                    Log-Message "VBox Guest Additions exited with code $($_.ExitCode)"
                }
                Log-Message "VBox Guest Additions installed"
            } catch {
                Log-Message "VBox Guest Additions failed to install: $_"
            }
            break
        }
    }
} else {
    Log-Message "VBox Guest Additions already running. Skipping."
}

# VMware Tools
if (-not (Get-Service VMTools -ErrorAction SilentlyContinue)) {
    foreach ($letter in $drives) {
        $exe = "${letter}:\setup.exe"
        if (Test-Path -LiteralPath $exe) {
            try {
                $productName = (Get-Item $exe).VersionInfo.ProductName
                if ($productName -eq 'VMware Tools') {
                    Log-Message "Found VMware Tools at $exe"
                    Start-Process -FilePath $exe -ArgumentList '/s /v /qn REBOOT=R' -Wait -PassThru | ForEach-Object {
                        Log-Message "VMware Tools exited with code $($_.ExitCode)"
                    }
                    Log-Message "VMware Tools installed"
                    break
                }
            } catch {
                Log-Message "VMware Tools failed to install: $_"
            }
        }
    }
} else {
    Log-Message "VMware Tools already installed. Skipping."
}

# VirtIO MSI Guest Agent Install
$virtioMsiInstalled = Get-WmiObject Win32_Product | Where-Object { $_.Name -like "*VirtIO*" -or $_.Name -like "*Red Hat*" }
if (-not $virtioMsiInstalled) {
    foreach ($letter in $drives) {
        $msi = "${letter}:\virtio-win-gt-x64.msi"
        if (Test-Path -LiteralPath $msi) {
            try {
                Log-Message "Installing VirtIO Guest Agent MSI at $msi"
                Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /qn /norestart" -Wait -PassThru | ForEach-Object {
                    Log-Message "VirtIO MSI exited with code $($_.ExitCode)"
                }
                Log-Message "VirtIO Guest Agent MSI installed"
            } catch {
                Log-Message "VirtIO Guest Agent MSI install failed: $_"
            }
            break
        }
    }
} else {
    Log-Message "VirtIO MSI tools already installed. Skipping."
}

# VirtIO Guest Tools EXE
foreach ($letter in $drives) {
    $exe = "${letter}:\virtio-win-guest-tools.exe"
    if (Test-Path -LiteralPath $exe) {
        try {
            Log-Message "Found VirtIO Guest Tools EXE at $exe"
            Start-Process -FilePath $exe -ArgumentList '/passive', '/norestart' -Wait -PassThru | ForEach-Object {
                Log-Message "VirtIO Guest Tools EXE exited with code $($_.ExitCode)"
            }
            Log-Message "VirtIO Guest Tools EXE installed"
        } catch {
            Log-Message "VirtIO Guest Tools EXE failed to install: $_"
        }
        break
    }
}

Log-Message "========== Guest tools installation check complete =========="
