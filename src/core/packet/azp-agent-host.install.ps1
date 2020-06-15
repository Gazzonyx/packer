#ps1_sysnative

# PowerShell
$ErrorActionPreference = "Stop"

Set-ExecutionPolicy RemoteSigned -Force
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Windows
Set-MpPreference -DisableRealtimeMonitoring $True -ExclusionPath "C:\"

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /d 1 /t REG_DWORD /f /reg:64
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /d 2 /t REG_DWORD /f /reg:64

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f

netsh advfirewall set allprofiles settings inboundusernotification enable

# AZP Agent
wget https://vstsagentpackage.azureedge.net/agent/2.170.1/vsts-agent-win-x64-2.170.1.zip -OutFile vsts-agent.zip
[Environment]::SetEnvironmentVariable("VSTS_AGENT_INPUT_URL", "https://dev.azure.com/gusztavvargadr/", "User")
[Environment]::SetEnvironmentVariable("VSTS_AGENT_INPUT_AUTH", "pat", "User")
# [Environment]::SetEnvironmentVariable("VSTS_AGENT_INPUT_TOKEN", "Token42-", "User")
## TODO Configure agents

# Provisioning
choco install chef-client --confirm --version 16.1.16 --prerelease
[Environment]::SetEnvironmentVariable("CHEF_LICENSE", "accept-silent", "User")
[Environment]::SetEnvironmentVariable("AZP_AGENT_CHEF_CLIENT", "16.1.16", "User")

choco install 7zip.portable -y --version 19.0

# Workstation
choco install -y googlechrome
choco install -y conemu
choco install -y far
choco install -y treesizefree
choco install -y vscode
choco install -y beyondcompare

# Development
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /NoAutoCrlf /NoShellIntegration /SChannel'"
choco install -y poshgit
choco install -y dotnetcore-sdk
& 'C:\Program Files\dotnet\dotnet.exe' tool install Cake.Tool --global

choco install -y vagrant --version 2.2.7 --ignore-package-exit-codes
[Environment]::SetEnvironmentVariable("AZP_AGENT_VAGRANT", "2.2.7", "User")

choco install -y packer --version 1.5.5
[Environment]::SetEnvironmentVariable("PACKER_CACHE_DIR", "C:\Users\Admin\.packer\cache", "User")
[Environment]::SetEnvironmentVariable("AZP_AGENT_PACKER", "1.5.5", "User")

choco install chef-workstation --confirm --version 20.6.62 --prerelease
[Environment]::SetEnvironmentVariable("CHEF_LICENSE", "accept-silent", "User")
[Environment]::SetEnvironmentVariable("AZP_AGENT_CHEF_WORKSTATION", "20.6.62", "User")

Get-WindowsOptionalFeature -Online | Where { $_.FeatureName -match "hyper" } | Where { $_.State -ne "Enabled" } | ForEach { Enable-WindowsOptionalFeature -Online -FeatureName $_.FeatureName -All -NoRestart }
[Environment]::SetEnvironmentVariable("AZP_AGENT_HYPERV", "9.0", "User")
[Environment]::SetEnvironmentVariable("VAGRANT_DEFAULT_PROVIDER", "hyperv", "User")
[Environment]::SetEnvironmentVariable("VAGRANT_PROVIDER_HYPERV_LINKED_CLONE", "true", "User")
[Environment]::SetEnvironmentVariable("VAGRANT_PROVIDER_HYPERV_VIRTUALIZATION", "true", "User")
[Environment]::SetEnvironmentVariable("VAGRANT_SYNCED_FOLDER_SMB_USERNAME", "Admin", "User")
# [Environment]::SetEnvironmentVariable("VAGRANT_SYNCED_FOLDER_SMB_PASSWORD", "Password42-", "User")

# New-VMSwitch -SwitchName HyperVNAT -SwitchType Internal
# New-NetIPAddress -IPAddress 192.168.238.1 -PrefixLength 24 -InterfaceAlias "vEthernet (HyperVNAT)"
# New-NetNat -Name HyperVNAT -InternalIPInterfaceAddressPrefix 192.168.238.0/24
## TODO Configure NAT external addresses
[Environment]::SetEnvironmentVariable("VAGRANT_PROVIDER_HYPERV_NETWORK_BRIDGE", "HyperVNAT", "User")
[Environment]::SetEnvironmentVariable("PACKER_VAR_hyperv_switch_name", "HyperVNAT", "User")
[Environment]::SetEnvironmentVariable("KITCHEN_HYPERV_SWITCH", "HyperVNAT", "User")

Get-WindowsOptionalFeature -Online | Where { $_.FeatureName -match "dhcp" } | Where { $_.State -ne "Enabled" } | ForEach { Enable-WindowsOptionalFeature -Online -FeatureName $_.FeatureName -All -NoRestart }
# Add-DhcpServerv4Scope -Name "192.168.238.0/24" -StartRange 192.168.238.100 -EndRange 192.168.238.199 -SubnetMask 255.255.255.0 -LeaseDuration "04:00:00"
# Set-DhcpServerv4OptionValue -ScopeId 192.168.238.0 -OptionId 3 -Value 192.168.238.1
# Set-DhcpServerv4OptionValue -ScopeId 192.168.238.0 -OptionId 6 -Value 8.8.8.8,8.8.4.4
## TODO Static IP, gateway, DNS

# choco install -y virtualbox --version 6.1.10 --params "/ExtensionPack"
# [Environment]::SetEnvironmentVariable("AZP_AGENT_VIRTUALBOX", "6.1.10", "User")
# [Environment]::SetEnvironmentVariable("VAGRANT_DEFAULT_PROVIDER", "virtualbox", "User")

# choco install -y docker-desktop --version 2.2.0.5
# choco install -y docker-desktop --version 2.3.0.3
# choco install -y docker-machine --version 0.16.2
# [Environment]::SetEnvironmentVariable("AZP_AGENT_DOCKER_LINUX", "19.03", "User")
# [Environment]::SetEnvironmentVariable("VAGRANT_DEFAULT_PROVIDER", "docker", "User")
