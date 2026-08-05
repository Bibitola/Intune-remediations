# Remediate-DefenderSignatureAge.ps1
#
# Pull fresh Defender signatures. Context: SYSTEM, 64-bit.

Update-MpSignature -ErrorAction Stop
Write-Output "Defender signature update triggered"
exit 0
