# DEF CON OT Workshop Runbook

External Discovery • Terminal Compromise • CALDERA Red Team • Malcolm Blue Team

## 1. Workshop Narrative

The workshop begins outside the OT environment. Students receive a printed handout that explains the name pf the terminal server they are targeting. Then, after locating the host, they complete an authorized password challenge against the Terminal Server and gain access to the first foothold.
Once inside, students find a document containing the CALDERA and Malcolm URLs and credentials. A second document exists on the Terminal Server because an administrator kept forgetting the Application Server login. That document reveals the private Application Server address, username, and password.
The Terminal Server is not itself the OT bridge. Students must use the stored Application Server credentials to move to the private Windows Server 2022 Application Server, deploy the downstream CALDERA agent through the Terminal Server pivot, discover engineering context, and perform controlled S7comm actions against the PLC simulator.
After the red-team sequence is complete, students switch roles and use Malcolm to reconstruct the path from public exposure through terminal compromise, credential discovery, agent deployment, S7 communication, process isolation, and recovery.


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

Students will have printed instructions which explain the name of the terminal server they will be targeting (unique for each student), as well as the link to the user GitHub repo. Then, they will utilize a bash script to search through a list of known terminal server IPs to determine which IP to target for their workshop.

> **Hint** The bash script can be found on the github repo, along with the list of known terminal server IPs. 

```bash
./ssh-recon.sh
termsrv-XX
ips
```

After compeleting the above instructions, the script will parse through the list of known IPs and stop once the correct connection is identified.

### Phase 2 - Obtaining Terminal Server Credentials

Students will complete a dictionary attack on the terminal server to obtain its login credentials. To do this, they must install and use a tool called Hydra, an online-password cracking tool.

**Hydra Installation Instructions (Windows-WSL)**
```bash
wsl -install
# Reboot and set WSL username and password
wsl
```

**Hydra Installation Instructions (Linux)**
```bash
sudo apt install Hydra
```

**Hydra Installation Instructions (MacOS)**
```bash
# install homebrew
/bin/bash -c "$(curl -fsSL https://githubusercontent.com)"
# update
brew update
# install hydra
brew install hydra
```

**After installing Hydra**
```bash
# Locate your dictionary.txt (obtainable via git) file and enter the following command, filling in the <variables> as needed.
hydra -l Administrator -P ./<dictionary>.txt ssh://<target_ip> -t 4 -f -o <output>.txt
# This command takes a dictionary file stored with potential passwords for the target device. Hydra takes this dictionary file and attempts to crack the targeted device and user in 4 parallel streams. Upon successfully identifying a password, the process stops and outputs the resulting password to a determined text file, along with the target IP and username.
```

### Phase 3 - Terminal Server Access

Students must now attempt to connect to the terminal server using the credentials obtained in previous steps.

**To obtain access to the Terminal Server**
```bash
ssh <terminal_server_username>@<terminal_server_ip>
```

> **Hint**: Hint: To navigate the terminal server, use cd (change directory) followed by a target destination (.. for previous directory) and ls (list) to view the contents of the currently active directory. Once you find a document, you can use the command Get-Content  followed by the target document to read its contents.

## [SECTION BREAK – PLEASE OPEN TERMINAL SERVER CALDERA PIVOT SETUP RUNBOOK](Terminal_Server_Caldera_Pivot_Setup_Runbook.md)

### Phase 5 - Access CALDERA and Establish the Pivot

Students will use the discovered access details and stored Application Server credentials to enter the CALDERA phase.

- Log into CALDERA.
- Confirm Agent 1.
- Confirm P2P capability.
- Confirm TCP/3389 listener.
- Connect to the Application Server.

## [SECTION BREAK – PLEASE OPEN APPLICATION SERVER SETUP FOR CALDERA DOWNSTREAM AGENT RUNBOOK](Application_Server_Setup_for_Caldera_Downstream_Agent_Runbook.md)

### Phase 6 - Deploy Agent 2

Students deploy the downstream agent through Agent 1.

- Copy the downstream P2P command from CALDERA.
- Run it on the Application Server.
- Confirm the new agent appears in Caldera
- Verify Agent 2.
- Task all PLC-facing abilities to Agent 2, not Agent 1.

### Phase 7 - Discover Engineering Context

Students inspect the Application Server for engineering artifacts that explain the PLC memory model.

- HMI tag exports
- Commissioning notes
- Operator handoff notes
- Status maps
- Troubleshooting documents
- DB1 and DB10 references

### Phase 8 - Identify the PLC and Establish a Baseline

Students use Agent 2 to discover and safely interrogate the PLC.

- Students use Agent 2 to discover and safely interrogate the PLC.
- Identify the PLC on TCP/102.
- Complete the S7 handshake using rack 0 and slot 1.
- Read DB10 status
- Download DB1 baseline snapshot

>**Network note:** Native Snap7 performs an ICMP reachability check before attempting TCP/102. The lab must narrowly allow ICMP Echo Request from the Application Server to the PLC simulator.

### Phase 9 - Stage the Process Isolation Request

Students use the discovered engineering context to stage a trusted process-isolation request in DB10.

- Write command code 1 to the defined DB10 command area.
- Capture or verify the command nonce.
- Read the updated process status.
- Download DB1 again to observe the process impact.
- Confirm the CPU remains in RUN

### Phase 10 - Observe and Explain the Process Impact

Baseline:
-  DB10 status: BASE LOAD
-  CPU state: RUN
-  Mode: AUTO AGC
-  Fuel flow: 34.8 TPH
-  Turbine RPM: 3600 RPM
-  Fuel valve: 45% OPEN
-  Steam flow: 210 TPH
-  Steam pressure: 126 BAR
-  System status: BASELOAD

Impact:
-  DB10 command: cmd_code=1
-  DB10 status: PROT HOLD
-  CPU state: RUN
-  Mode: OP REVIEW
-  Fuel flow: 14.2 TPH
-  Turbine RPM: 3120 RPM
-  Fuel valve: 18% OPEN
-  Steam flow: 132 TPH
-  Steam pressure: 102 BAR
-  System status: PROT HOLD


### Phase 11 - Clear the Request and Verify Recovery

Students remove the staged request and prove the process recovered.

- Clear the DB10 process-isolation request.
- Verify command code and nonce return to zero.
- Read the recovered DB10 status.
- Download DB1 again.
- Confirm the process returns to the baseline values.


### Phase 12 - Optional PLC Disruption Branch

Keep the PLC STOP/HOT START sequence separate from the main protective-hold storyline.

- PLC Stop
- Verify CPU state is STOP
- PLC Hot Start
- Verify CPU state returns to RUN
- Verify final S7 handshake and simulator health


## [SECTION BREAK – PLEASE OPEN MALCOLM BLUE TEAM RUNBOOK](Malcolm.md)

**End of Workshop Runbook**
