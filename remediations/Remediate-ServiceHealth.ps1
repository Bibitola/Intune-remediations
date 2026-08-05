# Remediate-ServiceHealth.ps1
#
# Restart the monitored service with a settle pause, the same stop/wait/start
# pattern the service tolerates in production. Context: SYSTEM, 64-bit.

$ServiceName = "insertservicenamehere"

$svc = Get-Service -Name $ServiceName -ErrorAction Stop

if ($svc.Status -eq "Running") {
    Stop-Service -Name $ServiceName -Force
    Start-Sleep -Seconds 20
}

Start-Service -Name $ServiceName
Write-Output "$ServiceName restarted"
exit 0
