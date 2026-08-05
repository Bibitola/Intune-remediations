# Detect-DefenderSignatureAge.ps1
#
# Compliant when Microsoft Defender's signatures are fresher than the
# threshold. Context: SYSTEM, 64-bit.

$MaxAgeDays = 3

$status = Get-MpComputerStatus -ErrorAction Stop
$age = (New-TimeSpan -Start $status.AntivirusSignatureLastUpdated -End (Get-Date)).TotalDays

if ($age -le $MaxAgeDays) {
    Write-Output ("Compliant: signatures updated {0:N1} days ago" -f $age)
    exit 0
}

Write-Output ("Non-compliant: signatures are {0:N1} days old (max $MaxAgeDays)" -f $age)
exit 1
