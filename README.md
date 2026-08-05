# intune-remediations

Detection + remediation script pairs for Microsoft Intune (Devices →
Scripts and remediations), written for managing a Windows endpoint fleet.
This is the MDM-era continuation of my
[endpoint-provisioning](https://github.com/Bibitola/endpoint-provisioning)
kit — the same fleet problems that used to be solved with imaging-time
scripts, restated as continuously-enforced compliance pairs.

Each pair follows Intune's contract: the **detection** script exits `0`
(compliant, nothing happens) or `1` (non-compliant, Intune runs the
**remediation**); whatever the scripts `Write-Output` shows up in the
remediation report columns.

## The pairs

| Pair | Detects | Remediation | Context |
|---|---|---|---|
| `UsbStoragePolicy` | USB mass-storage driver start type matches fleet policy (blocked by default) | Sets the policy value back | SYSTEM |
| `ServiceHealth` | The org's in-house service (`insertservicenamehere`) is running | Stop, 20s settle, start — the restart pattern the service tolerates | SYSTEM |
| `LowDiskSpace` | System drive has ≥10% free | Clears week-old machine temp files and the recycle bin; never touches user documents | SYSTEM |
| `ScreenLockPolicy` | Machine inactivity lock set to ≤15 min and not disabled | Enforces the machine-wide timeout | SYSTEM |
| `DefenderSignatureAge` | Defender signatures ≤3 days old | Triggers a signature update | SYSTEM |
| `TimeSync` | w32time running with a recent successful sync (drift breaks Kerberos and MFA before anyone notices) | Restarts w32time and forces a resync | SYSTEM |

Thresholds and the service name are variables at the top of each script;
`insertservicenamehere` is a deliberate placeholder for the in-house
service the production fleet ran.

## Deploying a pair

1. Intune admin center → **Devices → Scripts and remediations → Create**.
2. Upload the `Detect-*.ps1` as the detection script and the matching
   `Remediate-*.ps1` as the remediation script.
3. Run in **64-bit PowerShell**, **SYSTEM** context (all pairs here),
   signature check off unless you sign them.
4. Assign to a device group with a schedule (daily fits most of these;
   hourly for `ServiceHealth` if the service is fragile).

## Conventions

- Detection never changes state — it only reads and reports.
- Remediations are narrow: each fixes exactly the condition its detection
  tests, so the report stays truthful.
- One `Write-Output` line per outcome, since Intune surfaces it in the
  console columns.

## Caveat

Authored and lint-checked (PSScriptAnalyzer via CI) against Intune's
documented contract; this public copy hasn't been run against a live
tenant. Review thresholds against your own baseline before assigning
broadly — especially `LowDiskSpace`, the only pair that deletes anything.
