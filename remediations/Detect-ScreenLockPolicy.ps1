# Detect-ScreenLockPolicy.ps1
#
# Compliant when the machine inactivity limit is set and at most the policy
# maximum (0 means "never locks" and fails). Machine-wide policy value, so
# this runs correctly as SYSTEM. Context: SYSTEM, 64-bit.

$MaxSeconds = 900   # 15 minutes

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$value = (Get-ItemProperty -Path $path -Name "InactivityTimeoutSecs" -ErrorAction SilentlyContinue).InactivityTimeoutSecs

if ($null -ne $value -and $value -gt 0 -and $value -le $MaxSeconds) {
    Write-Output "Compliant: inactivity timeout is ${value}s"
    exit 0
}

Write-Output "Non-compliant: inactivity timeout is '$value' (policy: 1-$MaxSeconds seconds)"
exit 1
