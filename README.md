# PXE Scripts Repository

A collection of PowerShell and automation scripts for PXE (Preboot Execution Environment) deployments, system configuration, and virtualization environments.

## Repository Structure

```
PXE-Scripts/
├── scripts/
│   ├── linux/                    # Linux automation scripts (placeholder)
│   └── windows/                  # Windows PowerShell scripts
│       ├── cyberrange/           # Cyber range specific scripts
│       ├── nnite/                # Ninite package installation scripts
│       ├── onlogin/              # User login automation scripts
│       ├── hostname.ps1          # Standard hostname generation
│       ├── hostname-cyberrange.ps1 # Cyber range hostname generation
│       └── vmtools.ps1           # Virtual machine guest tools installer
├── images/                       # PXE boot images and related files
└── README.md                     # This file
```

## Windows Scripts

### Hostname Generation Scripts

#### `hostname.ps1`
Generates standardized hostnames for Cypac environments based on Windows OS detection:
- **Windows 10**: `Cypac-Win10-XXX`
- **Windows 11**: `Cypac-Win11-XXX`
- **Windows Server 2016**: `Cypac-WS16-XXX`
- **Windows Server 2019**: `Cypac-WS19-XXX`
- **Windows Server 2022**: `Cypac-WS22-XXX`
- **Windows Server 2025**: `Cypac-WS25-XXX`

#### `hostname-cyberrange.ps1`
Similar to `hostname.ps1` but generates hostnames with "CR-" prefix for cyber range environments:
- **Windows 10**: `CR-Win10-XXX`
- **Windows 11**: `CR-Win11-XXX`
- **Windows Server 2016**: `CR-WS16-XXX`
- **Windows Server 2019**: `CR-WS19-XXX`
- **Windows Server 2022**: `CR-WS22-XXX`
- **Windows Server 2025**: `CR-WS25-XXX`

### Virtual Machine Tools

#### `vmtools.ps1`
Unified guest tools installer that automatically detects and installs virtualization platform tools:
- **VirtualBox Guest Additions**: Detects and installs VBoxWindowsAdditions.exe
- **VMware Tools**: Detects and installs VMware Tools setup.exe
- **VirtIO Guest Agent**: Installs both MSI and EXE versions of VirtIO tools
- **Timezone Configuration**: Sets timezone to Hawaiian Standard Time
- **Comprehensive Logging**: All operations logged to `C:\GuestToolsInstaller.log`

### Package Installation Scripts

#### `nnite/itpack.ps1`
Downloads and installs a comprehensive software package via Ninite:
- .NET Framework 4.8.1
- 7-Zip
- Google Chrome
- FileZilla
- Firefox
- Foxit Reader
- Notepad++
- Visual Studio Code
- WinDirStat

#### `nnite/7zip-chrome-firefox-foxit-vcredistx15-windirstat-zoom.ps1`
Downloads and installs a focused software package via Ninite:
- .NET Framework 4.8.1
- 7-Zip
- Google Chrome
- Firefox
- Foxit Reader
- Visual C++ Redistributable 2015
- WinDirStat
- Zoom

## Usage

### Running PowerShell Scripts

```powershell
# Set execution policy (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run hostname generation
.\scripts\windows\hostname.ps1

# Run VM tools installation
.\scripts\windows\vmtools.ps1

# Run package installation
.\scripts\windows\nnite\itpack.ps1
```

### PXE Integration

These scripts are designed to be integrated into PXE boot environments for automated system deployment and configuration. They can be executed during the Windows installation process or as part of post-installation automation.

## Features

- **OS Detection**: Automatic Windows version detection and appropriate configuration
- **Virtualization Support**: Multi-platform VM guest tools installation
- **Package Management**: Automated software installation via Ninite
- **Logging**: Comprehensive logging for troubleshooting and audit trails
- **Error Handling**: Robust error handling and status reporting
- **Standardization**: Consistent hostname and configuration patterns

## Requirements

- **PowerShell 5.1+**: Required for all Windows scripts
- **Internet Access**: Required for Ninite package downloads
- **Administrator Privileges**: Required for system configuration and software installation
- **Virtualization Platforms**: VirtualBox, VMware, or VirtIO for guest tools installation

## Contributing

This repository is maintained by Cypac Cybersecurity for internal PXE deployment automation. Scripts are designed for enterprise environments and cyber range deployments.

## License

Internal use only - Cypac Cybersecurity proprietary scripts.

---

*Last updated: $(Get-Date -Format 'yyyy-MM-dd')*