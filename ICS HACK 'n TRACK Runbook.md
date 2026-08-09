# DEF CON OT Workshop Runbook

External Discovery • Terminal Compromise • CALDERA Red Team • Malcolm Blue Team

| Workshop phase | Student objective | Primary evidence |
|---|---|---|
| Discovery | Find the assigned Terminal Server public IP | ssh bash script |
| Initial access | Recover the Terminal Server password and log in | Authorized credential challenge |
| Orientation | Find CALDERA and Malcolm access details | Document stored on Terminal Server |
| Red team | Build the path from Terminal Server to PLC-facing Application Server | CALDERA agents, artifacts, and S7 actions |
| Blue team | Trace the intrusion and process impact | Malcolm telemetry and investigation worksheet |

## 1. Workshop Narrative

The workshop begins outside the OT environment. Students receive a printed handout that explains how to identify the public IP address of their assigned Terminal Server using Shodan or a similar internet-exposure search service. After locating the host, they complete an authorized password challenge against the Terminal Server and gain access to the first foothold.

Once inside, students find a deliberately planted document containing the CALDERA and Malcolm URLs and credentials. A second intentionally weak operational document exists on the Terminal Server because an administrator kept forgetting the Application Server login. That document reveals the private Application Server address, username, and password.

The Terminal Server is not itself the OT bridge. Students must use the stored Application Server credentials to move to the private Windows Server 2022 Application Server, deploy the downstream CALDERA agent through the Terminal Server pivot, discover engineering context, and perform controlled S7comm actions against the PLC simulator.

After the red-team sequence is complete, students switch roles and use Malcolm to reconstruct the path from public exposure through terminal compromise, credential discovery, agent deployment, S7 communication, process isolation, and recovery.

> **Teaching point:** Operations sees alarms and reduced output, but the controller remains alive. Security must connect those process symptoms to the preceding IT-to-OT intrusion path.

## 2. High-Level Architecture

```text
Internet / Shodan-style discovery
        |
        v
Public Windows Terminal Server
  - Initial password challenge
  - Agent 1 / P2P pivot
  - CALDERA and Malcolm access document
  - Forgotten Application Server credentials document
        |
        | private access
        v
Windows Server 2022 Application Server
  - Agent 2 through Terminal Server pivot
  - Engineering and HMI artifacts
  - Direct PLC-facing network path
        |
        | ICMP SmartConnect + TCP/102
        v
Ubuntu PLC Simulator
  - Dockerized S7 simulator
  - DB1 process snapshot
  - DB10 command/status area
        |
        v
Malcolm
  - Network visibility
  - S7comm analysis
  - Blue-team traceback
```

## 3. Student-Facing Workshop Workflow

### Phase 1 - Public Discovery

Students will have printed instructions which explain the name of the terminal server they will be targeting, unique for each student, as well as the link to the user GitHub repo. Then, they will utilize a bash script to search through a list of known terminal server IPs to determine which IP to target for their workshop.

> **Hint:** The bash script can be found on the GitHub repo, along with the list of known terminal server IPs.

After installing the bash script and buffered IP list, navigate to its directory and run:

```bash
# Run the bash script
./ssh-recon.sh

# Enter unique terminal server name
termsrv-XX

# Enter path to buffered IP list
ips
```

After completing the above instructions, the script will parse through the list of known IPs and stop once the correct connection is identified.

### Phase 2 - Obtaining Terminal Server Credentials

Students will complete a dictionary attack on the terminal server to obtain its login credentials. To do this, they must install and use a tool called Hydra, an online-password cracking tool.

#### Hydra Installation Instructions (Windows - WSL)

```powershell
wsl --install
```

Reboot and set the WSL username and password, then start WSL:

```powershell
wsl
```

#### Hydra Installation Instructions (Linux)

```bash
sudo apt install hydra
```

#### Hydra Installation Instructions (macOS)

Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://githubusercontent.com)"
```

Update Homebrew:

```bash
brew update
```

Install Hydra:

```bash
brew install hydra
```

After installing Hydra using WSL, Linux, or macOS Homebrew, locate the `dictionary.txt` file obtainable through Git. Run the following command, filling in the variables as needed:

```bash
hydra -l Administrator -P ./<name_of_dictionary_file>.txt ssh://<target_ip> -t 4 -f -o <name_of_output_file>.txt
```

This command takes a dictionary file containing potential passwords for the target device. Hydra uses the dictionary file to attempt to crack the targeted device and user in four parallel streams. After successfully identifying a password, the process stops and outputs the resulting password, target IP, and username to the specified text file.

### Phase 3 - Terminal Server Access

Students must now attempt to connect to the terminal server using the credentials obtained in the previous steps.

To obtain access to the Terminal Server:

```bash
ssh <terminal_server_username>@<terminal_server_ip>
```

You should receive a banner with a welcome message and be asked whether you are sure you want to connect. Enter `yes`. Next, enter the password for the Terminal Server. At this point, you have obtained access to the Terminal Server.

> **Hint:** To navigate the Terminal Server, use `cd` followed by a target destination. Use `..` to move to the previous directory and `ls` to view the contents of the current directory. After finding a document, use `Get-Content` followed by the target document to read its contents.

## SECTION BREAK - PLEASE OPEN TERMINAL SERVER CALDERA PIVOT SETUP RUNBOOK

### Phase 5 - Access CALDERA and Establish the Pivot

Students will use the discovered access details and stored Application Server credentials to enter the CALDERA phase.

- Log into CALDERA using the credentials found on the Terminal Server.
- Confirm Agent 1 is the assigned Terminal Server agent.
- Confirm Agent 1 has P2P relay capability.
- Confirm the Terminal Server pivot listener uses TCP/3389.
- Use the stored credentials to connect from the Terminal Server to the private Application Server.

Open the CALDERA web interface and copy the Windows Sandcat deployment command for the Terminal Server pivot agent directly from CALDERA. Use the command generated for the pivot group with P2P listening enabled on TCP/3389.

Before pasting the command, confirm that the generated command uses the following intended settings:

- CALDERA server: the assigned workshop CALDERA HTTPS URL
- Agent group: pivot
- P2P listener: enabled
- P2P listen host: `0.0.0.0`
- P2P listen port: `3389`
- Agent output path: `C:\Users\Public\splunkd.exe`
- TLS verification: use the workshop value shown by CALDERA for the self-signed lab certificate

Paste and run the command exactly as generated by CALDERA in the same elevated PowerShell session. The command is self-contained. Do not edit it to reuse the Lab-prefixed variables defined earlier in this runbook.

Expected lab behavior: CALDERA may warn that TLS certificate verification is disabled when using the workshop self-signed certificate. Confirm that this matches the approved lab configuration.

> **Expected warning:** The self-signed lab certificate causes a warning that TLS certificate verification is disabled. This is expected for the documented workshop configuration.

### Phase 6 - Confirm splunkd.exe Is Running

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

### Phase 7 - Expected

| Check | Expected result | Meaning |
|---|---|---|
| TermService | Stopped / Disabled | TCP/3389 is reserved for the lab pivot |
| splunkd.exe | Running | Agent 1 is active |
| Listener | `0.0.0.0` or `::` on TCP/3389 | P2P relay is accepting downstream traffic |
| Port owner | splunkd | RDP is no longer occupying the listener port |
| Firewall source | `<APPLICATION_SERVER_PRIVATE_IP>` | Only the Application Server is allowed inbound |

> **Stop point:** Once `splunkd.exe` is running and is confirmed as the owner of TCP/3389, the Terminal Server pivot preparation is complete.

### Phase 8 - Compact Verification Block

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

### Phase 9 - Deploy Agent 2

Students deploy the downstream agent through Agent 1.

- Copy the Windows downstream/P2P command directly from CALDERA.
- Run the command on the Application Server.
- Confirm the new agent appears in CALDERA.
- Verify the host identity and red group.
- Task all PLC-facing abilities to Agent 2, not Agent 1.

In the CALDERA interface, select the Windows downstream/P2P deployment command intended for the Application Server. The generated command should use the Terminal Server pivot as its callback and place the agent in the red group.

Before pasting it, confirm the generated command reflects:

- Callback host: the Terminal Server pivot private IP
- Callback port: TCP/3389
- Group: red
- Platform: Windows
- Agent output path: `C:\Users\Public\splunkd.exe`
- P2P/downstream bootstrap mode enabled
- The approved workshop TLS behavior shown by CALDERA

> **Execution instruction:** Paste and run the command exactly as generated by CALDERA in the elevated PowerShell session. Do not rewrite it to use the Lab-prefixed variables in this runbook.

### Phase 10 - Confirm splunkd.exe Is Running

Confirm the downstream process and inspect its command line:

```powershell
Get-CimInstance Win32_Process -Filter "Name='splunkd.exe'" |
    Select-Object ProcessId,ExecutablePath,CommandLine
```

Expected characteristics:

- `ExecutablePath` is `C:\Users\Public\splunkd.exe`.
- The command line uses the Terminal Server pivot callback.
- The command line includes group `red`.
- A process ID is present and remains stable after the command finishes.

### Phase 11 - Verify the Agent in CALDERA

Return to the CALDERA interface and verify that the Application Server agent appears as the downstream/red agent. Confirm the hostname and IP information match the Application Server before tasking any abilities.

> **Stop point:** Once `splunkd.exe` is running and the matching red-group agent appears in CALDERA, the Application Server agent setup is complete.

### Phase 12 - Verify the PLC Network Path

After the downstream agent is established, verify the Application Server can reach the PLC simulator on TCP/102 using its OT-facing interface.

```powershell
Test-NetConnection `
    -ComputerName $LabPlcPrivateIp `
    -Port 102 `
    -InformationLevel Detailed
```

Required result:

```text
TcpTestSucceeded : True
```

The detailed output should show the Application Server's OT-facing source address and interface. This confirms S7 traffic will originate directly from the Application Server rather than through the Terminal Server pivot.

> **Snap7 ICMP note:** The native Snap7 client performs an ICMP reachability check before it attempts TCP/102. The PLC security group must therefore allow narrowly scoped ICMP Echo Request traffic from the Application Server in addition to TCP/102. This is a Snap7 behavior, not an S7comm protocol requirement.

### Phase 13 - Compact Verification Block

Use this read-only block to verify the final state:

```powershell
Write-Host '=== Pivot Reachability ==='
Test-NetConnection `
    -ComputerName $LabPivotPrivateIp `
    -Port $LabP2pPort |
    Select-Object ComputerName,RemotePort,SourceAddress,TcpTestSucceeded

Write-Host '=== Downstream Sandcat Process ==='
Get-CimInstance Win32_Process -Filter "Name='splunkd.exe'" |
    Select-Object ProcessId,ExecutablePath,CommandLine

Write-Host '=== PLC TCP/102 Reachability ==='
Test-NetConnection `
    -ComputerName $LabPlcPrivateIp `
    -Port 102 |
    Select-Object ComputerName,RemotePort,SourceAddress,TcpTestSucceeded
```

### Phase 14 - Expected State Check

| Check | Expected result | Meaning |
|---|---|---|
| Pivot TCP/3389 | Reachable | Application Server can download and contact through Agent 1 |
| Defender exclusion | Exact file only | Authorized payload can execute without broad security changes |
| splunkd.exe | Running | Agent 2 is active |
| CALDERA group | red | Correct downstream agent classification |
| PLC TCP/102 | Reachable | Application Server has the intended OT path |
| PLC ICMP | Echo allowed narrowly | Native Snap7 can pass SmartConnect |

### Phase 15 - Discover Engineering Context

Students inspect the Application Server for engineering artifacts that explain the PLC memory model.

- HMI tag exports
- Commissioning notes
- Operator handoff notes
- Status maps
- Troubleshooting documents
- DB1 and DB10 memory-layout references

> **Placeholder:** [INSERT APPLICATION SERVER FILE STRUCTURE AND ARTIFACT LOCATIONS]

### Phase 16 - Identify the PLC and Establish a Baseline

Students use Agent 2 to discover and safely interrogate the PLC.

- Run the OT port-scan ability from Agent 2.
- Identify the PLC on TCP/102.
- Complete the S7 handshake using rack 0 and slot 1.
- Read the CPU state and confirm RUN.
- Read the baseline DB10 status.
- Download the baseline DB1 process snapshot.

> **Network note:** Native Snap7 performs an ICMP reachability check before attempting TCP/102. The lab must narrowly allow ICMP Echo Request from the Application Server to the PLC simulator.

### Phase 17 - Stage the Process Isolation Request

Students use the discovered engineering context to stage a trusted process-isolation request in DB10.

- Write command code 1 to the defined DB10 command area.
- Capture or verify the command nonce.
- Read the updated process status.
- Download DB1 again to observe the process impact.
- Confirm the CPU remains in RUN.

### Phase 18 - Observe and Explain the Process Impact

Baseline:

```text
DB10 status: BASE LOAD
CPU state: RUN
Mode: AUTO AGC
Fuel flow: 34.8 TPH
Turbine RPM: 3600 RPM
Fuel valve: 45% OPEN
Steam flow: 210 TPH
Steam pressure: 126 BAR
System status: BASELOAD
```

Impact:

```text
DB10 command: cmd_code=1
DB10 status: PROT HOLD
CPU state: RUN
Mode: OP REVIEW
Fuel flow: 14.2 TPH
Turbine RPM: 3120 RPM
Fuel valve: 18% OPEN
Steam flow: 132 TPH
Steam pressure: 102 BAR
System status: PROT HOLD
```

### Phase 19 - Clear the Request and Verify Recovery

Students remove the staged request and prove the process recovered.

- Clear the DB10 process-isolation request.
- Verify command code and nonce return to zero.
- Read the recovered DB10 status.
- Download DB1 again.
- Confirm the process returns to the baseline values.

### Phase 20 - Optional PLC Disruption Branch

Keep the PLC STOP/HOT START sequence separate from the main protective-hold storyline.

- PLC Stop
- Verify CPU state is STOP
- PLC Hot Start
- Verify CPU state returns to RUN
- Verify final S7 handshake and simulator health

## SECTION BREAK - PLEASE OPEN MALCOLM BLUE TEAM RUNBOOK

**End of Workshop Runbook**
