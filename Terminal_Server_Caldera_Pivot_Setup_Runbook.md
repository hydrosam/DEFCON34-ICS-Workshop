## Terminal Server CALDERA Pivot Setup

Windows Server • Sandcat Agent 1 • P2P Listener on TCP/3389

> **Purpose:** Prepare the Terminal Server so the CALDERA Sandcat agent runs as the pivot and owns TCP/3389 for downstream P2P communication.

| Setting | Value |
|---|---|
| CALDERA server | Assigned workshop CALDERA HTTPS URL |
| Agent executable | `C:\Users\Public\splunkd.exe` |
| CALDERA group | `pivot` |
| P2P listener | `0.0.0.0:3389` |
| Allowed downstream host | Application Server private IP from deployment output |

> **Critical access warning:** Stopping Remote Desktop Services frees TCP/3389 but can terminate an active RDP session. Confirm an alternate administration path, for example SSH or EC2 Systems Manager, before stopping `TermService`.

## 1. Runbook Scope and Success Criteria

Run the commands from an elevated Windows PowerShell session on the Terminal Server. This runbook ends when `splunkd.exe` is running and confirmed as the listener on TCP/3389.

Successful completion means:

- Remote Desktop Services no longer owns TCP/3389.
- A narrowly scoped Windows Firewall rule allows the Application Server to reach the pivot listener.
- The exact Sandcat executable path is allowlisted in Microsoft Defender for this authorized lab.
- `splunkd.exe` is running with the pivot and P2P listener arguments.
- TCP/3389 is owned by `splunkd.exe`.

## 2. Obtain Workshop Information

Locate the following workshop information:

- CALDERA URL
- CALDERA username and password
- Malcolm URL
- Malcolm username and password

In a real-world scenario, manually searching through many files and directories may not be feasible. Use PowerShell to recursively search files under `C:\Users\` for the keyword `PASSWORD`:

```powershell
Get-ChildItem -Path C:\Users\ -File -Recurse -ErrorAction SilentlyContinue | Select-String -Pattern "PASSWORD"
```

After identifying a potential password file, navigate to its location and read its contents with `Get-Content`:

```powershell
Get-Content <PATH_TO_POTENTIAL_PASSWORD_FILE>
```

Students must then identify the following Application Server credentials:

- Application Server private IP or hostname
- Application Server SSH username
- Application Server password

Run an ARP scan to display hosts for all network interfaces:

```powershell
arp -a
```

Run Nmap to identify open ports on the potential Application Server:

```powershell
nmap -sT -Pn --open 10.99.13.X
```

The options used in this command are:

- `-sT`: Performs a TCP three-way handshake.
- `-Pn`: Skips host discovery and tells Nmap to assume the target is online.
- `--open`: Displays only open ports.
- `10.99.13.X`: Replace this value with the potential Application Server IP address.

At this point, you should know the target Application Server IP address and which ports are open on that host.

## 3. Define the Lab Variables

Define only the variables used by the local Microsoft Defender and Windows Firewall preparation steps. These names are prefixed with `Lab` so they do not collide with variables inside the Sandcat deployment command copied from CALDERA.

```powershell
$LabSandcatPath = 'C:\Users\Public\splunkd.exe'
$LabApplicationServerIp = '<APPLICATION_SERVER_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
$LabFirewallRuleName = 'CALDERA Sandcat P2P TCP 3389 (Lab)'
```

Do not define `$server`, `$tlsVerify`, `$p2pHost`, `$p2pPort`, or similarly named variables before pasting the CALDERA-generated deployment command. The command is self-contained and supplies its own values.

> **Note:** TLS certificate verification is intentionally disabled by the supplied bootstrap because this isolated workshop uses a self-signed CALDERA certificate. Do not use this pattern as a general production configuration.

## 4. Inspect Defender Before Making a Narrow Exception

Review recent detections and confirm the affected resource is the intended lab payload:

```powershell
Get-MpThreatDetection |
    Sort-Object InitialDetectionTime -Descending |
    Select-Object -First 5 ThreatID,ActionSuccess,InitialDetectionTime,Resources

Get-MpThreat |
    Select-Object ThreatID,ThreatName,SeverityID
```

Add an exact-file exclusion only for the lab payload path, then verify it:

```powershell
if ((Get-MpPreference).ExclusionPath -notcontains $LabSandcatPath) {
    Add-MpPreference -ExclusionPath $LabSandcatPath
}

(Get-MpPreference).ExclusionPath |
    Where-Object { $_ -eq $LabSandcatPath }
```

> **Security boundary:** Do not disable Microsoft Defender globally and do not exclude `C:\Users\Public` or another broad directory. The exception is limited to `C:\Users\Public\splunkd.exe`.

## 5. Identify What Currently Owns TCP/3389

Identify the process currently listening on TCP/3389:

```powershell
Get-NetTCPConnection -State Listen -LocalPort 3389 -ErrorAction SilentlyContinue |
    Select-Object LocalAddress,LocalPort,OwningProcess,
        @{Name='ProcessName';Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
        @{Name='Path';Expression={(Get-Process -Id $_.OwningProcess).Path}}
```

If the owner is `svchost.exe`, map the process ID to its Windows service:

```powershell
$RdpPid = (Get-NetTCPConnection -State Listen -LocalPort 3389 -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty OwningProcess)

if ($RdpPid) {
    Get-CimInstance Win32_Service |
        Where-Object ProcessId -eq $RdpPid |
        Select-Object Name,DisplayName,State,ProcessId
}
```

In the captured setup session, TCP/3389 was owned by Remote Desktop Services (`TermService`).

## 6. Free TCP/3389 for the Pivot

> **Before continuing:** Confirm that losing RDP will not lock you out of the server.

Disable and stop Remote Desktop Services:

```powershell
Set-Service -Name TermService -StartupType Disabled
Stop-Service -Name TermService -Force
```

Verify that Remote Desktop Services no longer owns TCP/3389:

```powershell
Get-Service -Name TermService |
    Select-Object Name,Status,StartType

Get-NetTCPConnection -State Listen -LocalPort 3389 -ErrorAction SilentlyContinue |
    Select-Object LocalAddress,LocalPort,OwningProcess,
        @{Name='ProcessName';Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}
```

It is acceptable for the second command to return no rows at this stage. This means TCP/3389 is free and ready for Sandcat.

## 7. Create the Narrow Inbound Firewall Rule

Allow only the assigned Application Server to reach the Sandcat P2P listener. Bind the rule to the exact program path and TCP/3389:

```powershell
$LabFirewallRuleName = 'CALDERA Sandcat P2P TCP 3389 (Lab)'

if (-not (Get-NetFirewallRule -DisplayName $LabFirewallRuleName -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -DisplayName $LabFirewallRuleName `
        -Direction Inbound `
        -Action Allow `
        -Protocol TCP `
        -LocalPort 3389 `
        -Program $LabSandcatPath `
        -RemoteAddress $LabApplicationServerIp `
        -Profile Any
}
```

Verify the firewall rule:

```powershell
Get-NetFirewallRule -DisplayName $LabFirewallRuleName |
    Select-Object DisplayName,Enabled,Direction,Action,Profile

Get-NetFirewallRule -DisplayName $LabFirewallRuleName |
    Get-NetFirewallPortFilter |
    Select-Object Protocol,LocalPort

Get-NetFirewallRule -DisplayName $LabFirewallRuleName |
    Get-NetFirewallAddressFilter |
    Select-Object RemoteAddress
```

## 7. Download and Start the Pivot Agent

Open the CALDERA web interface and copy the Windows Sandcat deployment command for the Terminal Server pivot agent directly from CALDERA. Use the command generated for the `pivot` group with P2P listening enabled on TCP/3389.

Before pasting the command, confirm that it uses the following intended settings:

- CALDERA server: the assigned workshop CALDERA HTTPS URL
- Agent group: `pivot`
- P2P listener: enabled
- P2P listen host: `0.0.0.0`
- P2P listen port: `3389`
- Agent output path: `C:\Users\Public\splunkd.exe`
- TLS verification: use the workshop value shown by CALDERA for the self-signed lab certificate

Paste and run the command exactly as generated by CALDERA in the same elevated PowerShell session. The command is self-contained. Do not edit it to reuse the Lab-prefixed variables defined earlier in this runbook.

Expected lab behavior: CALDERA may warn that TLS certificate verification is disabled when using the workshop self-signed certificate. Confirm that this matches the approved lab configuration.

> **Expected warning:** The self-signed lab certificate causes a warning that TLS certificate verification is disabled. This is expected for the documented workshop configuration.

## 8. Confirm splunkd.exe Is Running

Confirm the process and its exact command line:

```powershell
Get-CimInstance Win32_Process -Filter "Name='splunkd.exe'" |
    Select-Object ProcessId,ExecutablePath,CommandLine
```

Confirm that `splunkd.exe` owns TCP/3389:

```powershell
Get-NetTCPConnection -State Listen -LocalPort 3389 -ErrorAction SilentlyContinue |
    Select-Object LocalAddress,LocalPort,OwningProcess,
        @{Name='ProcessName';Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
        @{Name='Path';Expression={(Get-Process -Id $_.OwningProcess).Path}}
```

## 9. Final Expected State

| Check | Expected result | Meaning |
|---|---|---|
| `TermService` | Stopped / Disabled | TCP/3389 is reserved for the lab pivot |
| `splunkd.exe` | Running | Agent 1 is active |
| Listener | `0.0.0.0` or `::` on TCP/3389 | P2P relay is accepting downstream traffic |
| Port owner | `splunkd` | RDP is no longer occupying the listener port |
| Firewall source | `<APPLICATION_SERVER_PRIVATE_IP>` | Only the Application Server is allowed inbound |

> **Stop point:** Once `splunkd.exe` is running and is confirmed as the owner of TCP/3389, the Terminal Server pivot preparation is complete.

## 10. Compact Verification Block

Use this read-only block at any time to verify the final state:

```powershell
Write-Host '=== Remote Desktop Services ==='
Get-Service TermService |
    Select-Object Name,Status,StartType

Write-Host '=== Sandcat Process ==='
Get-CimInstance Win32_Process -Filter "Name='splunkd.exe'" |
    Select-Object ProcessId,ExecutablePath,CommandLine

Write-Host '=== TCP/3389 Listener ==='
Get-NetTCPConnection -State Listen -LocalPort 3389 -ErrorAction SilentlyContinue |
    Select-Object LocalAddress,LocalPort,OwningProcess,
        @{Name='ProcessName';Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}

Write-Host '=== Firewall Rule ==='
Get-NetFirewallRule -DisplayName 'CALDERA Sandcat P2P TCP 3389 (Lab)' -ErrorAction SilentlyContinue |
    Select-Object DisplayName,Enabled,Direction,Action,Profile
```

## [SECTION BREAK - PLEASE RETURN TO THE ICS HACK 'N TRACK RUNBOOK](ICS_Hack_'n_Track_Runbook.md)

**End of runbook**

Authorized isolated lab use only • Windows Server Terminal/Pivot Host
