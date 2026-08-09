## Terminal Server CALDERA Pivot Setup

Prepare the Terminal Server so the CALDERA Sandcat agent can operate as the pivot and use TCP/3389 for downstream P2P communication.

Run the commands from an elevated Windows PowerShell session on the Terminal Server. This runbook ends when TCP/3389 is open for the pivot.

### 1. Confirm the Success Criteria

Successful completion means:

- Remote Desktop Services no longer owns TCP/3389.
- A narrowly scoped Windows Firewall rule allows the Application Server to reach the pivot listener.
- The exact Sandcat executable path is allowlisted in Microsoft Defender for this authorized lab.

### 2. Obtain the Workshop Information

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

### 3. Identify the Application Server

Locate the following Application Server information:

- Application Server private IP or hostname
- Application Server SSH username
- Application Server password

Display the ARP cache for all network interfaces to identify hosts on the local network:

```powershell
arp -a
```

Use Nmap to identify open TCP ports on a potential Application Server:

```powershell
nmap -sT -Pn --open 10.99.13.X
```

The options used in this command are:

- `-sT`: Performs a TCP three-way handshake.
- `-Pn`: Skips host discovery and tells Nmap to assume that the target is online.
- `--open`: Displays only open ports.
- `10.99.13.X`: Replace this value with the potential Application Server IP address.

At the end of this step, you should know the target Application Server IP address and which ports are open on that host.

### 4. Define the Lab Variables

Define only the variables used by the local Microsoft Defender and Windows Firewall preparation steps. The `Lab` prefix prevents these variables from colliding with variables in the Sandcat deployment command copied from CALDERA.

```powershell
$LabSandcatPath = '<EXACT_SANDCAT_EXECUTABLE_PATH>'
$LabApplicationServerIp = '<APPLICATION_SERVER_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
$LabFirewallRuleName = 'CALDERA Sandcat P2P TCP 3389 (Lab)'
```

The source document does not provide a complete value for `$LabSandcatPath`. Replace `<EXACT_SANDCAT_EXECUTABLE_PATH>` with the authorized executable path before running the Microsoft Defender or Windows Firewall commands.

Do not define `$server`, `$tlsVerify`, `$p2pHost`, `$p2pPort`, or similarly named variables before pasting the CALDERA-generated deployment command. The generated command is self-contained and supplies its own values.

> **Note:** TLS certificate verification is intentionally disabled by the supplied bootstrap because this isolated workshop uses a self-signed CALDERA certificate. Do not use this pattern as a general production configuration.

### 5. Inspect Microsoft Defender

Review the most recent Microsoft Defender detections and confirm that the affected resource is the intended lab payload:

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

> **Security boundary:** Do not disable Microsoft Defender globally and do not exclude `C:\Users\Public` or another broad directory. Limit the exception to the exact authorized Sandcat executable path.

### 6. Identify the Current TCP/3389 Listener

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

### 7. Free TCP/3389 for the Pivot

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

It is acceptable for the second command to return no rows. This means TCP/3389 is free and ready for Sandcat.

### 8. Create the Inbound Firewall Rule

Allow only the assigned Application Server to reach the Sandcat P2P listener. Bind the rule to the exact program path and TCP/3389:

```powershell
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

## Section Break: Open the Application Server Setup for the CALDERA Downstream Agent Runbook

**End of runbook**

Authorized isolated lab use only. Windows Server Terminal/Pivot Host.
