# Remediate-LowDiskSpace.ps1
#
# Reclaim the safe, boring space first: machine temp, Windows temp, and the
# recycle bin. Deliberately does NOT touch user profiles or documents.
# Context: SYSTEM, 64-bit.

$before = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'").FreeSpace

foreach ($temp in @($env:TEMP, "$env:SystemRoot\Temp")) {
    Get-ChildItem -Path $temp -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

Clear-RecycleBin -DriveLetter $env:SystemDrive.Substring(0,1) -Force -ErrorAction SilentlyContinue

$after = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'").FreeSpace
$reclaimedMB = [math]::Round(($after - $before) / 1MB, 0)
Write-Output "Reclaimed ${reclaimedMB}MB from temp locations and recycle bin"
exit 0
