# Remediate-UsbStoragePolicy.ps1
#
# Set the USB mass-storage driver's start type back to the fleet policy.
# Context: SYSTEM, 64-bit. Keep $DesiredStart in sync with the detection script.

$DesiredStart = 4

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value $DesiredStart -ErrorAction Stop
Write-Output "USBSTOR start type set to $DesiredStart"
exit 0
