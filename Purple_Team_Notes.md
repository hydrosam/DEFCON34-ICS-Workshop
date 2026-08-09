# Purple Team Notes

Use this document to record the information collected throughout the DEF CON OT workshop. Complete the fields as you progress through the Main Workshop, Terminal Server, Application Server, and Malcolm Blue Team runbooks.

> **Sensitive information:** This worksheet may contain credentials, IP addresses, and other lab access information. Store it only in the approved workshop location and delete it when instructed by the workshop facilitator.

---

## 1. Student and Workshop Assignment

- **Student name:**
- **Team or table:**
- **Workshop date:**
- **Assigned Terminal Server name:**
- **Assigned environment or lab number:**
- **Facilitator:**
- **Notes file location:**

---

## 2. Required Workshop Files

### Buffered IP List

- **Download location:** [Buffered IP List](INSERT_BUFFERED_IP_LIST_DOWNLOAD_LINK)
- **Downloaded file name:**
- **Local file path:**
- **Checksum, if provided:**
- **Notes:**

### SSH Recon Script

- **Download location:** [SSH Recon Script](INSERT_SSH_RECON_SCRIPT_DOWNLOAD_LINK)
- **Downloaded file name:** `ssh-recon.sh`
- **Local file path:**
- **Execute permission applied:**
- **Checksum, if provided:**
- **Notes:**

### Password Dictionary

- **Download location:** [Password Dictionary](INSERT_DICTIONARY_FILE_DOWNLOAD_LINK)
- **Downloaded file name:** `dictionary.txt`
- **Local file path:**
- **Checksum, if provided:**
- **Notes:**

---

## 3. Terminal Server Public Discovery

- **Assigned Terminal Server name:**
- **Buffered IP list path:**
- **SSH recon script path:**
- **Recon command used:**

```bash
./ssh-recon.sh
```

- **Terminal Server public IP:**
- **Terminal Server hostname identified by script:**
- **SSH port:**
- **Banner or identifying output:**
- **Discovery completed:** [ ]
- **Notes:**

---

## 4. Terminal Server Credential Exercise

- **Hydra platform:** Windows WSL / Linux / macOS
- **Dictionary file path:**
- **Target username:**
- **Target IP:**
- **Output file path:**
- **Hydra command used:**

```bash
hydra -l Administrator -P ./<dictionary_file>.txt ssh://<target_ip> -t 4 -f -o <output_file>.txt
```

- **Recovered Terminal Server username:**
- **Recovered Terminal Server password:**
- **Credential validated:** [ ]
- **Notes:**

---

## 5. Terminal Server Access

- **SSH command used:**

```bash
ssh <terminal_server_username>@<terminal_server_ip>
```

- **Connection accepted:** [ ]
- **Terminal Server hostname:**
- **Logged-in username:**
- **Terminal Server private IP:**
- **Terminal Server operating system:**
- **Alternate administrative access available before stopping RDP:**
- **Notes:**

---

## 6. Workshop Access Information Found on the Terminal Server

### CALDERA

- **CALDERA URL:**
- **CALDERA username:**
- **CALDERA password:**
- **Login validated:** [ ]
- **Certificate warning observed:**
- **Notes:**

### Malcolm

- **Malcolm URL:**
- **Malcolm username:**
- **Malcolm password:**
- **Login validated:** [ ]
- **Notes:**

### Source Documents

- **Workshop access document path:**
- **Application Server credentials document path:**
- **Other relevant document paths:**
- **Search command used:**

```powershell
Get-ChildItem -Path C:\Users\ -File -Recurse -ErrorAction SilentlyContinue | Select-String -Pattern "PASSWORD"
```

- **Notes:**

---

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

---

## 8. Terminal Server Pivot Preparation

### Local Variables

- **Exact authorized Sandcat executable path:**
- **Application Server private IP used in firewall rule:**
- **Firewall rule name:**

### Microsoft Defender

- **Recent detection reviewed:** [ ]
- **Threat name or ID:**
- **Affected resource:**
- **Exact-file exclusion added:** [ ]
- **Exclusion path verified:**
- **Notes:**

### TCP/3389 Before Preparation

- **Listening address:**
- **Owning PID:**
- **Owning process:**
- **Associated Windows service:**
- **Remote Desktop Services state:**
- **Alternate access confirmed before stopping RDP:** [ ]

### TCP/3389 After Preparation

- **Remote Desktop Services stopped:** [ ]
- **Remote Desktop Services disabled:** [ ]
- **TCP/3389 free before pivot deployment:** [ ]
- **Notes:**

### Firewall Rule

- **Rule display name:**
- **Direction:**
- **Action:**
- **Protocol:**
- **Local port:**
- **Program path:**
- **Allowed remote address:**
- **Profile:**
- **Rule verified:** [ ]
- **Notes:**

---

## 9. CALDERA Agent 1: Terminal Server Pivot

- **CALDERA server URL:**
- **Agent name or paw:**
- **Terminal Server hostname shown in CALDERA:**
- **Agent group:**
- **Platform:**
- **P2P listener enabled:** [ ]
- **P2P listen host:**
- **P2P listen port:**
- **Agent output path:**
- **TLS behavior shown by CALDERA:**
- **Deployment command copied directly from CALDERA:** [ ]
- **Deployment command executed without modification:** [ ]
- **Process ID:**
- **Executable path:**
- **Command-line details:**
- **TCP/3389 owning process after deployment:**
- **Listener address:**
- **Agent healthy in CALDERA:** [ ]
- **Notes:**

### Agent 1 Verification Checklist

- [ ] `TermService` is stopped and disabled
- [ ] Agent 1 process is running
- [ ] Listener is bound to TCP/3389
- [ ] Pivot process owns TCP/3389
- [ ] Firewall source is restricted to the Application Server
- [ ] Agent 1 appears correctly in CALDERA

---

## 10. Application Server Access

- **Connection command:**
- **Application Server hostname:**
- **Application Server private IP:**
- **Logged-in username:**
- **Operating system:**
- **Credential validation completed:** [ ]
- **Notes:**

---

## 11. Target PLC Discovery

- **Application Server OT-facing IP:**
- **Application Server OT-facing interface:**
- **PLC subnet examined:**
- **Nmap command used:**

```powershell
nmap -sT -Pn --open 10.99.12.X
```

- **ARP command used:**

```powershell
arp -a
```

- **PLC simulator hostname:**
- **PLC simulator private IP:**
- **PLC MAC address, if observed:**
- **PLC TCP/102 open:** [ ]
- **Other open ports:**
- **PLC identified:** [ ]
- **Notes:**

---

## 12. Application Server Preparation

### Local Variables

- **Exact authorized Sandcat executable path:**
- **Terminal Server pivot private IP:**
- **P2P port:**
- **PLC simulator private IP:**

### Pivot Reachability

- **Tested destination:**
- **Tested port:**
- **Source address shown:**
- **`TcpTestSucceeded`:**
- **Pivot reachable:** [ ]
- **Troubleshooting notes:**

### Microsoft Defender

- **Recent detection reviewed:** [ ]
- **Threat name or ID:**
- **Affected resource:**
- **Exact-file exclusion added:** [ ]
- **Exclusion path verified:**
- **Notes:**

---

## 13. CALDERA Agent 2: Application Server Downstream Agent

- **Agent name or paw:**
- **Application Server hostname shown in CALDERA:**
- **Callback host:**
- **Callback port:**
- **Agent group:**
- **Platform:**
- **P2P/downstream bootstrap mode enabled:** [ ]
- **Agent output path:**
- **TLS behavior shown by CALDERA:**
- **Deployment command copied directly from CALDERA:** [ ]
- **Deployment command executed without modification:** [ ]
- **Process ID:**
- **Executable path:**
- **Command-line details:**
- **Agent appears in CALDERA:** [ ]
- **Hostname and IP confirmed:** [ ]
- **Agent assigned to the `red` group:** [ ]
- **Notes:**

---

## 14. PLC Network Path Verification

- **PLC destination IP:**
- **Destination port:**
- **Source address shown:**
- **Source interface shown:**
- **`TcpTestSucceeded`:**
- **TCP/102 reachable:** [ ]
- **ICMP Echo Request allowed from Application Server:** [ ]
- **Notes:**

---

## 15. Engineering Context and Artifact Locations

Record the location and purpose of each artifact discovered on the Application Server.

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

### Additional Engineering Notes

- **PLC rack:**
- **PLC slot:**
- **DB1 purpose:**
- **DB10 purpose:**
- **Command area offset:**
- **Status area offset:**
- **Nonce location or format:**
- **Other relevant offsets or tags:**

---

## 16. PLC Baseline

- **Agent used:** Agent 2
- **S7 handshake completed:** [ ]
- **Rack:**
- **Slot:**
- **CPU state:**
- **DB10 status:**
- **DB1 snapshot file name:**
- **DB1 snapshot storage location:**
- **Snapshot timestamp:**

### Baseline Process Values

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

### Baseline Evidence

- **CALDERA operation ID:**
- **Relevant ability name:**
- **Relevant command output:**
- **Screenshot or evidence path:**
- **Notes:**

---

## 17. Process-Isolation Request

- **Agent used:** Agent 2
- **CALDERA operation ID:**
- **Ability name:**
- **DB10 command code:**
- **Command nonce:**
- **Command written successfully:** [ ]
- **Updated DB10 status:**
- **CPU state after request:**
- **DB1 impact snapshot file name:**
- **DB1 impact snapshot storage location:**
- **Snapshot timestamp:**

### Impact Process Values

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

### Impact Evidence

- **Relevant command output:**
- **Screenshot or evidence path:**
- **Observed alarms:**
- **Observed process symptoms:**
- **Notes:**

---

## 18. Recovery Verification

- **Process-isolation request cleared:** [ ]
- **Command code returned to zero:** [ ]
- **Nonce returned to zero:** [ ]
- **Recovered DB10 status:**
- **CPU state after recovery:**
- **Recovery DB1 snapshot file name:**
- **Recovery DB1 snapshot storage location:**
- **Snapshot timestamp:**

### Recovered Process Values

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

### Recovery Evidence

- **CALDERA operation ID:**
- **Relevant command output:**
- **Screenshot or evidence path:**
- **Notes:**

---

## 19. Optional PLC STOP and HOT START Branch

Complete this section only if directed by the workshop facilitator.

- **PLC STOP command issued:** [ ]
- **CPU state confirmed STOP:** [ ]
- **Evidence path:**
- **PLC HOT START command issued:** [ ]
- **CPU state confirmed RUN:** [ ]
- **Final S7 handshake successful:** [ ]
- **Simulator health verified:** [ ]
- **Evidence path:**
- **Notes:**

---

## 20. Malcolm Access and Investigation Setup

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
- **Relevant CALDERA operation IDs:**
- **Notes:**

---

## 21. Malcolm Timeline and Evidence

| Sequence | Activity | Source host | Destination host | Protocol or port | Time or marker | Malcolm evidence or saved view | Notes |
|---:|---|---|---|---|---|---|---|
| 1 | Public exposure discovery |  |  |  |  |  |  |
| 2 | Terminal Server access |  |  |  |  |  |  |
| 3 | Credential discovery |  |  |  |  |  |  |
| 4 | Pivot establishment |  |  |  |  |  |  |
| 5 | Application Server activity |  |  |  |  |  |  |
| 6 | S7 communication |  |  |  |  |  |  |
| 7 | Process-isolation activity |  |  |  |  |  |  |
| 8 | Process recovery |  |  |  |  |  |  |

### Malcolm Investigation Notes

- **Relevant dashboards or views:**
- **Filters used:**
- **Queries used:**
- **S7comm observations:**
- **Pivot traffic observations:**
- **Process-isolation evidence:**
- **Recovery evidence:**
- **Saved screenshots or exports:**
- **Additional notes:**

---

## 22. Attack Path Summary

```text
External Student System
        |
        v
Terminal Server Public IP: ______________________________
        |
        v
Terminal Server Private IP: _____________________________
        |
        | TCP/3389 pivot
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
- **Downstream agent:**
- **OT protocol:**
- **Process action:**
- **Observed impact:**
- **Recovery action:**
- **Blue Team evidence summary:**

---

## 23. Issues and Troubleshooting Log

| Step or phase | Issue | Error or symptom | Action taken | Result |
|---|---|---|---|---|
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

---

## 24. Final Completion Checklist

### Workshop Resources

- [ ] Buffered IP List downloaded
- [ ] SSH Recon Script downloaded
- [ ] Password Dictionary downloaded

### External Discovery and Initial Access

- [ ] Assigned Terminal Server identified
- [ ] Terminal Server credentials recovered
- [ ] Terminal Server accessed successfully

### Terminal Server

- [ ] CALDERA access information found
- [ ] Malcolm access information found
- [ ] Application Server credentials found
- [ ] Terminal Server preparation completed
- [ ] Agent 1 pivot established and validated

### Application Server

- [ ] Application Server accessed successfully
- [ ] Target PLC identified
- [ ] Pivot reachability validated
- [ ] Application Server preparation completed
- [ ] Agent 2 deployed and validated
- [ ] Agent 2 confirmed in the `red` group

### PLC Exercise

- [ ] PLC TCP/102 path validated
- [ ] Baseline captured
- [ ] Process-isolation request completed
- [ ] Impact captured
- [ ] Request cleared
- [ ] Recovery verified

### Malcolm Investigation

- [ ] Malcolm access validated
- [ ] Terminal Server activity identified
- [ ] Pivot activity identified
- [ ] Application Server activity identified
- [ ] S7 activity identified
- [ ] Process-isolation evidence identified
- [ ] Recovery evidence identified
- [ ] Investigation summary completed

---

## 25. Final Findings and Lessons Learned

### What Happened



### How the Activity Moved from IT to OT



### Process Impact



### Most Useful CALDERA Evidence



### Most Useful Malcolm Evidence



### Key Defensive Lesson



### Additional Notes


