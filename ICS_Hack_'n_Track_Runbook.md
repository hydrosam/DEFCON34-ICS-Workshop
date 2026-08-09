# DEF CON OT Workshop Runbook

External Discovery • Terminal Compromise • CALDERA Red Team • Malcolm Blue Team

## 1. Workshop Narrative

The workshop begins outside the OT environment. Students identify the public IP address of their assigned Terminal Server, complete an authorized password challenge, discover CALDERA and Malcolm credentials, pivot through the Application Server using CALDERA, perform controlled PLC actions, and finally investigate the activity using Malcolm.

## 2. High-Level Architecture

```text
Internet
    |
    v
Terminal Server
    |
    +--> CALDERA Access
    +--> Malcolm Access
    +--> Application Server Credentials
    |
    v
Application Server
    |
    +--> Agent 2
    +--> Engineering Artifacts
    +--> PLC Access
    |
    v
PLC Simulator
    |
    v
Malcolm
```

## 3. Student-Facing Workshop Workflow

### Phase 1 - Public Discovery

```bash
./ssh-recon.sh
termsrv-XX
ips
```

### Phase 2 - Obtaining Terminal Server Credentials

Install Hydra and recover the Terminal Server password using the provided dictionary file.

```bash
hydra -l Administrator -P ./<dictionary>.txt ssh://<target_ip> -t 4 -f -o <output>.txt
```

### Phase 3 - Terminal Server Access

```bash
ssh <terminal_server_username>@<terminal_server_ip>
```

Use `cd`, `ls`, and `Get-Content` to locate the workshop documents.

## [SECTION BREAK – PLEASE OPEN TERMINAL SERVER CALDERA PIVOT SETUP RUNBOOK](Terminal_Server_Caldera_Pivot_Setup_Runbook.md)

### Phase 5 - Access CALDERA and Establish the Pivot

- Log into CALDERA.
- Confirm Agent 1.
- Confirm P2P capability.
- Confirm TCP/3389 listener.
- Connect to the Application Server.

### Phase 6 - Confirm splunkd.exe Is Running

```powershell
Get-CimInstance Win32_Process -Filter "Name='splunkd.exe'" |
    Select-Object ProcessId,ExecutablePath,CommandLine
```

### Phase 7 - Expected

Validate Agent 1, listener ownership, firewall restrictions, and TermService status.

### Phase 8 - Compact Verification Block

Use the verification commands from the Terminal Server runbook.

### Phase 9 - Deploy Agent 2

- Copy the downstream P2P command from CALDERA.
- Run it on the Application Server.
- Verify Agent 2.
- Use Agent 2 for all PLC-facing actions.

### Phase 10 - Confirm splunkd.exe Is Running

Verify Agent 2 is active and assigned to the red group.

### Phase 11 - Verify the Agent in CALDERA

Confirm the downstream Application Server agent appears correctly.

### Phase 12 - Verify the PLC Network Path

```powershell
Test-NetConnection `
    -ComputerName $LabPlcPrivateIp `
    -Port 102 `
    -InformationLevel Detailed
```

Expected result:

```text
TcpTestSucceeded : True
```

### Phase 13 - Compact Verification Block

Validate pivot reachability, Agent 2, and PLC reachability.

### Phase 14 - Expected State Check

Verify:

- Pivot TCP/3389 reachable
- Agent 2 running
- CALDERA red group assigned
- PLC reachable
- ICMP allowed for Snap7 SmartConnect

### Phase 15 - Discover Engineering Context

Review:

- HMI tag exports
- Commissioning notes
- Operator handoff notes
- Status maps
- Troubleshooting documents
- DB1 and DB10 references

### Phase 16 - Identify the PLC and Establish a Baseline

- Locate PLC
- Complete S7 handshake
- Verify CPU RUN
- Read DB10 status
- Download DB1 baseline snapshot

### Phase 17 - Stage the Process Isolation Request

- Write DB10 command code 1
- Verify nonce
- Read updated status
- Download updated DB1

### Phase 18 - Observe and Explain the Process Impact

Compare baseline and protected-hold process values.

### Phase 19 - Clear the Request and Verify Recovery

- Clear request
- Verify nonce reset
- Confirm DB10 recovery
- Download recovery snapshot

### Phase 20 - Optional PLC Disruption Branch

- PLC Stop
- Verify STOP
- PLC Hot Start
- Verify RUN

## [SECTION BREAK – PLEASE OPEN MALCOLM BLUE TEAM RUNBOOK](Malcolm.md)

**End of Workshop Runbook**
