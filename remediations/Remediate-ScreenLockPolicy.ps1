# Remediate-ScreenLockPolicy.ps1
#
# Enforce the machine inactivity lock. Takes effect at next policy refresh
# or logon. Context: SYSTEM, 64-bit.

$Seconds = 900   # 15 minutes

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $path -Name "InactivityTimeoutSecs" -Value $Seconds -Type DWord -ErrorAction Stop
Write-Output "Inactivity timeout set to ${Seconds}s"
exit 0
