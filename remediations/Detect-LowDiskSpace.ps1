# Detect-LowDiskSpace.ps1
#
# Compliant when the system drive has at least the threshold percentage free.
# Context: SYSTEM, 64-bit.

$ThresholdPercent = 10

$drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'"
$freePercent = [math]::Round(($drive.FreeSpace / $drive.Size) * 100, 1)

if ($freePercent -ge $ThresholdPercent) {
    Write-Output "Compliant: $freePercent% free on $env:SystemDrive"
    exit 0
}

Write-Output "Non-compliant: $freePercent% free on $env:SystemDrive (threshold $ThresholdPercent%)"
exit 1
