## Application Server CALDERA Agent Setup

Prepare the Windows Server 2022 Application Server so its Sandcat agent can run in the downstream `red` group and communicate through the Terminal Server pivot on TCP/3389.

Run the commands from an elevated Windows PowerShell session on the Application Server.

> **Important:** Do not copy a stored downstream bootstrap command from this document. Copy the current downstream/P2P Windows deployment command directly from CALDERA so the pivot address, agent settings, and payload are current.

### 1. Confirm the Success Criteria

Successful completion means:

- The Application Server can reach the Terminal Server pivot on TCP/3389.
- Microsoft Defender has a narrow exact-file exclusion for the authorized lab payload.
- The downstream Sandcat command is copied directly from CALDERA and executed without modification.
- The downstream agent runs in the `red` group and points to the pivot callback.
- The Application Server retains direct OT network reachability to the PLC simulator.

### 2. Find the Target PLC

Run Nmap from the Application Server to identify the IP address of the target PLC:

```powershell
nmap -sT -Pn --open 10.99.12.X
```

The options used in this command are:

- `-sT`: Performs a TCP connect scan.
- `-Pn`: Skips host discovery and treats the target as online.
- `--open`: Displays only open ports.
- `10.99.12.X`: Replace this value with the potential PLC IP address on the OT-facing network.

Display the ARP cache for all network interfaces:

```powershell
arp -a
```

Compare the Nmap and ARP results to identify the target PLC IP address and port.

### 3. Define the Local Runbook Variables

Define only the variables used by the local Microsoft Defender and verification steps. The `Lab` prefix prevents these variables from colliding with variables in the CALDERA-generated deployment command.

```powershell
$LabSandcatPath = '<EXACT_SANDCAT_EXECUTABLE_PATH>'
$LabPivotPrivateIp = '<TERMINAL_SERVER_PIVOT_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
$LabP2pPort = 3389
$LabPlcPrivateIp = '<PLC_SIMULATOR_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
```

The source document does not provide a complete value for `$LabSandcatPath`. Replace `<EXACT_SANDCAT_EXECUTABLE_PATH>` with the authorized executable path before running the Microsoft Defender commands.

Replace the remaining placeholders with the Terminal Server pivot and PLC simulator private IP addresses from the deployment output.

> **Variable safety:** Do not define `$callback`, `$p2pPort`, `$tlsVerify`, `$url`, `$wc`, `$data`, or similarly named variables before pasting the CALDERA-generated command. The deployment command is self-contained.

### 4. Verify the Pivot Listener Is Reachable

Confirm that the Application Server can reach the Terminal Server pivot on TCP/3389 before attempting the downstream deployment:

```powershell
Test-NetConnection `
    -ComputerName $LabPivotPrivateIp `
    -Port $LabP2pPort `
    -InformationLevel Detailed
```

The required result is:

```text
TcpTestSucceeded : True
```

> **Stop condition:** If TCP/3389 is not reachable, do not run the downstream deployment command.

### 5. Inspect Microsoft Defender

Review recent Microsoft Defender detections and confirm that the affected resource is the intended lab payload:

```powershell
Get-MpThreatDetection |
    Sort-Object InitialDetectionTime -Descending |
    Select-Object -First 5 ThreatID,ActionSuccess,InitialDetectionTime,Resources

Get-MpThreat |
    Select-Object ThreatID,ThreatName,SeverityID
```

Add an exact-file exclusion only for the authorized Sandcat path, then verify it:

```powershell
if ((Get-MpPreference).ExclusionPath -notcontains $LabSandcatPath) {
    Add-MpPreference -ExclusionPath $LabSandcatPath
}

(Get-MpPreference).ExclusionPath |
    Where-Object { $_ -eq $LabSandcatPath }
```

> **Security boundary:** Do not disable Microsoft Defender globally and do not exclude `C:\Users\Public` or another broad directory. Limit the exception to the exact authorized Sandcat executable path.

**End of runbook**

Authorized isolated lab use only. Windows Server 2022 Application Host.
