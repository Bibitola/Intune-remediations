# Detect-TimeSync.ps1
#
# Compliant when the Windows Time service is running and the last successful
# sync is recent. Drifting clocks break Kerberos, MFA codes, and log
# correlation long before anyone notices. Context: SYSTEM, 64-bit.

$MaxAgeHours = 48

$svc = Get-Service -Name w32time -ErrorAction Stop
if ($svc.Status -ne "Running") {
    Write-Output "Non-compliant: w32time service is $($svc.Status)"
    exit 1
}

$statusText = w32tm /query /status 2>&1 | Out-String
$match = [regex]::Match($statusText, "Last Successful Sync Time:\s*(.+)")
if (-not $match.Success -or $statusText -match "unspecified") {
    Write-Output "Non-compliant: no successful time sync recorded"
    exit 1
}

$lastSync = [datetime]::Parse($match.Groups[1].Value.Trim())
$ageHours = (New-TimeSpan -Start $lastSync -End (Get-Date)).TotalHours

if ($ageHours -le $MaxAgeHours) {
    Write-Output ("Compliant: last sync {0:N1} hours ago" -f $ageHours)
    exit 0
}

Write-Output ("Non-compliant: last sync {0:N1} hours ago (max $MaxAgeHours)" -f $ageHours)
exit 1
