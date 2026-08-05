# Detect-UsbStoragePolicy.ps1
#
# Compliant when the USB mass-storage driver's start type matches the fleet
# policy set below. Exit 0 = compliant, exit 1 = remediation runs.
# Context: SYSTEM, 64-bit.

# Fleet policy: 4 = USB storage blocked, 3 = allowed on demand
$DesiredStart = 4

$current = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -ErrorAction Stop).Start

if ($current -eq $DesiredStart) {
    Write-Output "Compliant: USBSTOR start type is $current"
    exit 0
}

Write-Output "Non-compliant: USBSTOR start type is $current, policy requires $DesiredStart"
exit 1
