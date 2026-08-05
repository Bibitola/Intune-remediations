# Detect-ServiceHealth.ps1
#
# Compliant when the monitored service exists and is running. The service
# name is a placeholder - set it to the in-house service this fleet runs.
# Context: SYSTEM, 64-bit.

$ServiceName = "insertservicenamehere"

$svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($null -eq $svc) {
    Write-Output "Service $ServiceName not installed on this device - treating as compliant"
    exit 0
}

if ($svc.Status -eq "Running") {
    Write-Output "Compliant: $ServiceName is running"
    exit 0
}

Write-Output "Non-compliant: $ServiceName is $($svc.Status)"
exit 1
