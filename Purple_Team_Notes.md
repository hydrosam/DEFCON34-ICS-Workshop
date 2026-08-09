# Purple Team Notes

Use this worksheet throughout the ICS Hack 'N Track DEF CON OT workshop. Record information as you move through the Main Workshop Runbook, Terminal Server Runbook, Application Server Runbook, and Malcolm Blue Team Runbook.

> **Sensitive information:** This worksheet may contain lab credentials, IP addresses, agent details, and evidence references. Store it only in the approved workshop location and delete it when instructed.

## 1. Student and Workshop Assignment

- **Student name:**
- **Team or table:**
- **Workshop date:**
- **Assigned Terminal Server name:**
- **Assigned environment or lab number:**
- **Facilitator:**
- **Notes file location:**

## 2. Required Workshop Files

| Resource | Purpose | Download |
|---|---|---|
| Buffered IP List | List of known Terminal Server IP addresses used during public discovery | [Download Buffered IP List](INSERT_BUFFERED_IP_LIST_DOWNLOAD_LINK) |
| SSH Recon Script (`ssh-recon.sh`) | Searches the buffered IP list for the assigned Terminal Server | [Download SSH Recon Script](INSERT_SSH_RECON_SCRIPT_DOWNLOAD_LINK) |
| Password Dictionary (`dictionary.txt`) | Used during the authorized Hydra credential exercise | [Download Password Dictionary](INSERT_DICTIONARY_FILE_DOWNLOAD_LINK) |
| Data Sheet (`Data_sheet.txt`) | Used during Malcolm Exercise |
[Data Sheet](Data_sheet.txt) | Workshop data reference |

- **SSH Recon Script file name:** `ssh-recon.sh`
- **Password Dictionary file name:** `dictionary.txt`
- **Checksums, if provided:**
- **Preparation notes:**

## 3. Main Runbook: Public Discovery

- **Assigned Terminal Server name:**
- **Buffered IP list path:**
- **SSH Recon Script path:**
- **Terminal Server public IP:**
- **Terminal Server hostname identified by script:**
- **SSH port:**
- **Banner or identifying output:**
- **Discovery completed:** [ ]

### Recon Command

```bash
./ssh-recon.sh
```

- **Unique Terminal Server name entered:**
- **Buffered IP list path entered:**
- **Notes:**

## 4. Main Runbook: Terminal Server Credential Exercise

- **Hydra platform:** Windows WSL / Linux / macOS
- **Dictionary file path:**
- **Target username:**
- **Target IP:**
- **Output file path:**

### Hydra Command

```bash
hydra -l Administrator -P ./<dictionary_file>.txt ssh://<target_ip> -t 4 -f -o <output_file>.txt
```

- **Recovered Terminal Server username:**
- **Recovered Terminal Server password:**
- **Credential validated:** [ ]
- **Notes:**

## 5. Main Runbook: Terminal Server Access

### SSH Command

```bash
ssh <terminal_server_username>@<terminal_server_ip>
```

- **Connection accepted:** [ ]
- **Terminal Server hostname:**
- **Logged-in username:**
- **Terminal Server public IP:**
- **Terminal Server private IP:**
- **Terminal Server operating system:**
- **Alternate administrative path:**
- **Alternate access validated before stopping RDP:** [ ]
- **Notes:**

## 6. Workshop Access Information Found on the Terminal Server

### CALDERA

- **CALDERA URL:**
- **CALDERA username:**
- **CALDERA password:**
- **Login validated:** [ ]
- **Certificate warning observed:**

### Malcolm

- **Malcolm URL:**
- **Malcolm username:**
- **Malcolm password:**
- **Login validated:** [ ]

### Source Documents

- **Workshop access document path:**
- **Application Server credentials document path:**
- **Other relevant document paths:**

### Search Command

```powershell
Get-ChildItem -Path C:\Users\ -File -Recurse -ErrorAction SilentlyContinue | Select-String -Pattern "PASSWORD"
```

- **Notes:**

## 7. Application Server Information Discovered from the Terminal Server

- **Application Server hostname:**
- **Application Server private IP:**
- **Application Server SSH username:**
- **Application Server password:**
- **SSH port:**
- **ARP result:**
- **Nmap result:**
- **Open ports:**
- **Credentials validated:** [ ]
- **Notes:**

## 8. Terminal Server Runbook: Configuration Values

| Setting | Recorded value |
|---|---|
| CALDERA server |  |
| Agent executable | `C:\Users\Public\splunkd.exe` |
| CALDERA group | `pivot` |
| P2P listener | `0.0.0.0:3389` |
| Allowed downstream host |  |
| Firewall rule name | `CALDERA Sandcat P2P TCP 3389 (Lab)` |

### Local Variables

```powershell
$LabSandcatPath = 'C:\Users\Public\splunkd.exe'
$LabApplicationServerIp = '<APPLICATION_SERVER_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
$LabFirewallRuleName = 'CALDERA Sandcat P2P TCP 3389 (Lab)'
```

- **Application Server private IP substituted:**
- **Variables defined successfully:** [ ]
- **Notes:**

## 9. Terminal Server Runbook: Microsoft Defender

- **Recent detection reviewed:** [ ]
- **Threat name or ID:**
- **Affected resource:**
- **Affected resource confirmed as authorized lab payload:** [ ]
- **Exact-file exclusion added:** [ ]
- **Exclusion path:** `C:\Users\Public\splunkd.exe`
- **Exclusion verified:** [ ]
- **Broad folder exclusion avoided:** [ ]
- **Notes:**

## 10. Terminal Server Runbook: TCP/3389 Before Pivot Deployment

- **Listening address:**
- **Owning PID:**
- **Owning process:**
- **Executable path:**
- **Associated Windows service:**
- **`TermService` status:**
- **Alternate access confirmed:** [ ]
- **Notes:**

## 11. Terminal Server Runbook: Free TCP/3389

- **`TermService` stopped:** [ ]
- **`TermService` startup type disabled:** [ ]
- **TCP/3389 returned no listener before pivot deployment:** [ ]
- **RDP access loss expected and understood:** [ ]
- **Notes:**

## 12. Terminal Server Runbook: Restricted Firewall Rule

| Property | Recorded value |
|---|---|
| Display name |  |
| Direction |  |
| Action |  |
| Protocol |  |
| Local port |  |
| Program path |  |
| Remote address |  |
| Profile |  |

- **Rule created:** [ ]
- **Rule enabled:** [ ]
- **TCP/3389 verified:** [ ]
- **Remote address matches assigned Application Server:** [ ]
- **Program path matches exact Sandcat path:** [ ]
- **Notes:**

## 13. Terminal Server Runbook: Agent 1 Pivot Deployment

- **Deployment command copied directly from CALDERA:** [ ]
- **Deployment command executed without modification:** [ ]
- **CALDERA server:**
- **Agent name or paw:**
- **Terminal Server hostname shown in CALDERA:**
- **Agent group:** `pivot`
- **Platform:**
- **P2P listener enabled:** [ ]
- **P2P listen host:** `0.0.0.0`
- **P2P listen port:** `3389`
- **Agent output path:** `C:\Users\Public\splunkd.exe`
- **TLS behavior shown by CALDERA:**
- **Expected self-signed certificate warning observed:** [ ]
- **Process ID:**
- **Executable path:**
- **Command-line details:**
- **Listener address:**
- **TCP/3389 owning process:**
- **Agent healthy in CALDERA:** [ ]
- **Notes:**

### Agent 1 Final Expected State

- [ ] `TermService` is stopped and disabled.
- [ ] `splunkd.exe` is running.
- [ ] Listener is `0.0.0.0` or `::` on TCP/3389.
- [ ] `splunkd` owns TCP/3389.
- [ ] Firewall source is the assigned Application Server IP.
- [ ] Agent 1 appears in CALDERA in the `pivot` group.

## 14. Application Server Access

- **Connection command:**
- **Application Server hostname:**
- **Application Server private IP:**
- **Logged-in username:**
- **Operating system:** Windows Server 2022
- **Credential validation completed:** [ ]
- **Notes:**

## 15. Application Server Runbook: Target PLC Discovery

### Nmap Command

```powershell
nmap -sT -Pn --open 10.99.12.X
```

### ARP Command

```powershell
arp -a
```

- **Application Server OT-facing IP:**
- **Application Server OT-facing interface:**
- **PLC subnet examined:**
- **PLC simulator hostname:**
- **PLC simulator private IP:**
- **PLC MAC address, if observed:**
- **PLC TCP/102 open:** [ ]
- **Other open ports:**
- **PLC identified:** [ ]
- **Notes:**

## 16. Application Server Runbook: Configuration Values

| Setting | Recorded value |
|---|---|
| Agent executable | `C:\Users\Public\splunkd.exe` |
| CALDERA group | `red` |
| Callback host |  |
| Callback port | `3389` |
| Agent transport | HTTP P2P through Agent 1 |
| PLC destination |  |
| PLC port | `102` |

### Local Variables

```powershell
$LabSandcatPath = 'C:\Users\Public\splunkd.exe'
$LabPivotPrivateIp = '<TERMINAL_SERVER_PIVOT_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
$LabP2pPort = 3389
$LabPlcPrivateIp = '<PLC_SIMULATOR_PRIVATE_IP_FROM_DEPLOYMENT_OUTPUT>'
```

- **Terminal Server pivot private IP substituted:**
- **PLC simulator private IP substituted:**
- **Variables defined successfully:** [ ]
- **Notes:**

## 17. Application Server Runbook: Pivot Reachability

- **Tested destination:**
- **Tested port:** `3389`
- **Source address shown:**
- **`TcpTestSucceeded`:**
- **Pivot reachable:** [ ]
- **Stop condition cleared before deployment:** [ ]
- **Troubleshooting notes:**

## 18. Application Server Runbook: Microsoft Defender

- **Recent detection reviewed:** [ ]
- **Threat name or ID:**
- **Affected resource:**
- **Affected resource confirmed as authorized lab payload:** [ ]
- **Exact-file exclusion added:** [ ]
- **Exclusion path:** `C:\Users\Public\splunkd.exe`
- **Exclusion verified:** [ ]
- **Broad folder exclusion avoided:** [ ]
- **Notes:**

## 19. Application Server Runbook: Agent 2 Deployment

- **Deployment command copied directly from CALDERA:** [ ]
- **Deployment command executed without modification:** [ ]
- **Agent name or paw:**
- **Application Server hostname shown in CALDERA:**
- **Callback host:**
- **Callback port:** `3389`
- **Agent group:** `red`
- **Platform:** Windows
- **P2P/downstream bootstrap mode enabled:** [ ]
- **Agent output path:** `C:\Users\Public\splunkd.exe`
- **TLS behavior shown by CALDERA:**
- **Process ID:**
- **Executable path:**
- **Command-line details:**
- **Agent appears in CALDERA:** [ ]
- **Hostname and IP confirmed:** [ ]
- **Agent assigned to the `red` group:** [ ]
- **Notes:**

## 20. Application Server Runbook: PLC Network Path

- **PLC destination IP:**
- **Destination port:** `102`
- **Source address shown:**
- **Source interface shown:**
- **`TcpTestSucceeded`:**
- **TCP/102 reachable:** [ ]
- **Traffic originates through Application Server OT-facing interface:** [ ]
- **ICMP Echo Request narrowly allowed from Application Server:** [ ]
- **Snap7 SmartConnect requirement confirmed:** [ ]
- **Notes:**

### Agent 2 Final Expected State

- [ ] Pivot TCP/3389 is reachable.
- [ ] Microsoft Defender exclusion is exact-file only.
- [ ] `splunkd.exe` is running.
- [ ] CALDERA group is `red`.
- [ ] PLC TCP/102 is reachable.
- [ ] PLC ICMP Echo is narrowly allowed for Snap7 SmartConnect.

## 21. Main Runbook: Engineering Context and Artifact Locations

| Artifact | File or directory path | Relevant information | Reviewed |
|---|---|---|---|
| HMI tag export |  |  | [ ] |
| Commissioning notes |  |  | [ ] |
| Operator handoff notes |  |  | [ ] |
| Status map |  |  | [ ] |
| Troubleshooting document |  |  | [ ] |
| DB1 memory-layout reference |  |  | [ ] |
| DB10 memory-layout reference |  |  | [ ] |
| Other |  |  | [ ] |

### Engineering Details

- **PLC rack:** `0`
- **PLC slot:** `1`
- **DB1 purpose:**
- **DB10 purpose:**
- **Command area offset:**
- **Status area offset:**
- **Nonce location or format:**
- **Other relevant offsets or tags:**

## 22. Main Runbook: PLC Baseline

- **Agent used:** Agent 2
- **CALDERA operation ID:**
- **OT port-scan ability:**
- **S7 handshake completed:** [ ]
- **Rack:** `0`
- **Slot:** `1`
- **CPU state:**
- **DB10 status:**
- **DB1 baseline snapshot file name:**
- **DB1 baseline snapshot storage location:**
- **Snapshot time or marker:**

| Process value | Baseline value |
|---|---|
| Mode |  |
| Fuel flow |  |
| Turbine RPM |  |
| Fuel valve |  |
| Steam flow |  |
| Steam pressure |  |
| System status |  |
| Additional value |  |

- **Relevant command output:**
- **Screenshot or evidence path:**
- **Notes:**

## 23. Main Runbook: Process-Isolation Request

- **Agent used:** Agent 2
- **CALDERA operation ID:**
- **Ability name:**
- **DB10 command code:** `1`
- **Command nonce:**
- **Command written successfully:** [ ]
- **Updated DB10 status:**
- **CPU state after request:**
- **DB1 impact snapshot file name:**
- **DB1 impact snapshot storage location:**
- **Snapshot time or marker:**

| Process value | Impact value |
|---|---|
| Mode |  |
| Fuel flow |  |
| Turbine RPM |  |
| Fuel valve |  |
| Steam flow |  |
| Steam pressure |  |
| System status |  |
| Additional value |  |

- **Observed alarms:**
- **Observed process symptoms:**
- **Relevant command output:**
- **Screenshot or evidence path:**
- **Notes:**

## 24. Main Runbook: Recovery Verification

- **Process-isolation request cleared:** [ ]
- **Command code returned to zero:** [ ]
- **Nonce returned to zero:** [ ]
- **Recovered DB10 status:**
- **CPU state after recovery:**
- **Recovery DB1 snapshot file name:**
- **Recovery DB1 snapshot storage location:**
- **Snapshot time or marker:**

| Process value | Recovered value | Matches baseline |
|---|---|---|
| Mode |  | [ ] |
| Fuel flow |  | [ ] |
| Turbine RPM |  | [ ] |
| Fuel valve |  | [ ] |
| Steam flow |  | [ ] |
| Steam pressure |  | [ ] |
| System status |  | [ ] |
| Additional value |  | [ ] |

- **CALDERA operation ID:**
- **Relevant command output:**
- **Screenshot or evidence path:**
- **Notes:**

## 25. Optional PLC STOP and HOT START Branch

Complete this section only when directed by the workshop facilitator.

- **PLC STOP command issued:** [ ]
- **CPU state confirmed STOP:** [ ]
- **Evidence path:**
- **PLC HOT START command issued:** [ ]
- **CPU state confirmed RUN:** [ ]
- **Final S7 handshake successful:** [ ]
- **Simulator health verified:** [ ]
- **Evidence path:**
- **Notes:**

## 26. Malcolm Blue Team Runbook: Access and Investigation Setup

- **Malcolm URL:**
- **Malcolm username:**
- **Malcolm password:**
- **Login successful:** [ ]
- **Investigation start time or marker:**
- **Investigation end time or marker:**
- **Terminal Server public IP:**
- **Terminal Server private IP:**
- **Application Server private IP:**
- **PLC simulator private IP:**
- **Relevant hostnames:**
- **Agent 1 identifier:**
- **Agent 2 identifier:**
- **Relevant CALDERA operation IDs:**
- **Notes:**

## 27. Malcolm Timeline and Evidence

| Sequence | Activity | Source | Destination | Protocol or port | Time or marker | Malcolm evidence or saved view | Notes |
|---:|---|---|---|---|---|---|---|
| 1 | Public discovery |  |  |  |  |  |  |
| 2 | Terminal Server access |  |  |  |  |  |  |
| 3 | Credential discovery |  |  |  |  |  |  |
| 4 | Agent 1 pivot establishment |  |  | TCP/3389 |  |  |  |
| 5 | Application Server activity |  |  |  |  |  |  |
| 6 | Agent 2 activity |  |  | TCP/3389 |  |  |  |
| 7 | S7 communication |  |  | TCP/102 |  |  |  |
| 8 | Process-isolation activity |  |  | S7comm |  |  |  |
| 9 | Process recovery |  |  | S7comm |  |  |  |

### Malcolm Investigation Notes

- **Relevant dashboards or views:**
- **Filters used:**
- **Queries used:**
- **Terminal Server observations:**
- **Pivot traffic observations:**
- **Application Server observations:**
- **S7comm observations:**
- **Process-isolation evidence:**
- **Recovery evidence:**
- **Saved screenshots or exports:**
- **Additional notes:**

## 28. Attack Path Summary

```text
External Student System
        |
        v
Terminal Server Public IP: ______________________________
        |
        v
Terminal Server Private IP: _____________________________
        |
        | Agent 1 P2P pivot on TCP/3389
        v
Application Server Private IP: __________________________
        |
        | ICMP + TCP/102
        v
PLC Simulator Private IP: _______________________________
```

- **Initial access method:**
- **Credential source:**
- **Pivot method:**
- **Agent 1 group:**
- **Agent 2 group:**
- **OT protocol:**
- **Process action:**
- **Observed impact:**
- **Recovery action:**
- **Blue Team evidence summary:**

## 29. Issues and Troubleshooting Log

| Runbook and step | Issue | Error or symptom | Action taken | Result |
|---|---|---|---|---|
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## 30. Final Completion Checklist

### Preparation and Main Runbook

- [ ] Required workshop files downloaded.
- [ ] Assigned Terminal Server identified.
- [ ] Terminal Server credentials recovered.
- [ ] Terminal Server accessed successfully.
- [ ] CALDERA access information found.
- [ ] Malcolm access information found.
- [ ] Application Server credentials found.

### Terminal Server Runbook

- [ ] Alternate administrative path validated.
- [ ] Microsoft Defender exact-file exclusion verified.
- [ ] `TermService` stopped and disabled.
- [ ] Restricted firewall rule verified.
- [ ] Agent 1 deployed in the `pivot` group.
- [ ] Agent 1 owns TCP/3389.
- [ ] Terminal Server final verification completed.

### Application Server Runbook

- [ ] Application Server accessed successfully.
- [ ] Target PLC identified.
- [ ] Pivot TCP/3389 reachability validated.
- [ ] Microsoft Defender exact-file exclusion verified.
- [ ] Agent 2 deployed in the `red` group.
- [ ] Agent 2 verified in CALDERA.
- [ ] PLC TCP/102 path validated.
- [ ] PLC ICMP requirement validated.
- [ ] Application Server final verification completed.

### Main Runbook PLC Exercise

- [ ] Engineering context discovered.
- [ ] PLC baseline captured.
- [ ] Process-isolation request completed.
- [ ] Impact captured.
- [ ] Request cleared.
- [ ] Recovery verified against baseline.

### Malcolm Blue Team Runbook

- [ ] Malcolm access validated.
- [ ] Terminal Server activity identified.
- [ ] Agent 1 pivot activity identified.
- [ ] Application Server and Agent 2 activity identified.
- [ ] S7 activity identified.
- [ ] Process-isolation evidence identified.
- [ ] Recovery evidence identified.
- [ ] Investigation summary completed.

## 31. Final Findings and Lessons Learned

### What Happened



### How the Activity Moved from IT to OT



### Terminal Server Pivot Evidence



### Application Server and Agent 2 Evidence



### Process Impact



### Most Useful CALDERA Evidence



### Most Useful Malcolm Evidence



### Key Defensive Lesson



### Additional Notes


