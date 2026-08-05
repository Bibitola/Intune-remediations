# Remediate-TimeSync.ps1
#
# Restart the Windows Time service and force a resync. Context: SYSTEM, 64-bit.

Set-Service -Name w32time -StartupType Manual -ErrorAction Stop
Restart-Service -Name w32time -Force -ErrorAction Stop
Start-Sleep -Seconds 5

w32tm /resync /force | Out-Null
Write-Output "w32time restarted and resync forced"
exit 0
