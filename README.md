# ICS Hack 'N Track: DEF CON OT Workshop

## User Guide

This repository contains the student-facing documents and supporting files for the DEF CON OT workshop. The workshop follows an IT-to-OT path from external discovery through Terminal Server access, CALDERA pivoting, Application Server access, controlled PLC interaction, and Malcolm investigation.

Use this README as the navigation page. Follow the runbooks in the order shown below and return to the main runbook whenever a section break directs you to do so.

## Workshop Documents

| Document | Purpose |
|---|---|
| [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md) | Primary workshop narrative and student workflow |
| [Terminal Server Runbook](Terminal_Server_Caldera_Pivot_Setup_Runbook.md) | Terminal Server discovery, CALDERA pivot preparation, Agent 1 deployment, and TCP/3389 validation |
| [Application Server Runbook](Application_Server_Setup_for_Caldera_Downstream_Agent_Runbook.md) | PLC discovery, pivot validation, Agent 2 deployment, and PLC network-path validation |
| [Malcolm Blue Team Runbook](Malcolm.md) | Blue Team investigation and reconstruction of the workshop activity |
| [Purple Team Notes](Purple_Team_Notes.md) | Worksheet for credentials, addresses, agent details, PLC 

## Required Downloads

Download these files before beginning the workshop:

| Resource | Purpose | Download |
|---|---|---|
| Buffered IP List | List of known Terminal Server IP addresses used during public discovery | [Download Buffered IP List](ips.txt) |
| SSH Recon Script (`ssh-recon.sh`) | Searches the buffered IP list for the assigned Terminal Server | [Download SSH Recon Script](ssh-recon.sh) |
| Password Dictionary (`dictionary.txt`) | Used during the authorized Hydra credential exercise | [Download Password Dictionary](dictionary.txt) |
| Data Sheet (`Data_template.txt`) | Used for gathering information during the workshop for the Malcolm analysis | [Data Template](Data_template.txt) |

## Workshop Flow

```text
README.md
    |
    v
Main Workshop Runbook
    |
    +--> Phase 1: Discovery
    |
    +--> Phase 2: Obtain Terminal Server Credentials
    |
    +--> Phase 3: Access the Terminal Server
    |
    v
Terminal Server Runbook
    |
    +--> Find workshop and Application Server information
    +--> Prepare TCP/3389
    +--> Configure the restricted firewall rule
    +--> Deploy and verify CALDERA Agent 1
    |
    v
Return to Main Workshop Runbook
    |
    v
Application Server Runbook
    |
    +--> Find the target PLC
    +--> Verify the Terminal Server pivot
    +--> Deploy and verify CALDERA Agent 2
    +--> Verify the PLC network path
    |
    v
Return to Main Workshop Runbook
    |
    +--> Discover engineering context
    +--> Establish the PLC baseline
    +--> Stage the process-isolation request
    +--> Observe process impact
    +--> Clear the request and verify recovery
    |
    v
Malcolm Blue Team Runbook
```

## Before You Begin

1. Download the Buffered IP List, SSH Recon Script, Data sheet and Password Dictionary.
2. Make the recon script executable: `chmod +x ssh-recon.sh`
3. Open [Purple Team Notes](Purple_Team_Notes.md) and record information as you progress.
4. Open the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).
5. Do not skip a section break. Each section break tells you which runbook to open next.
6. When a runbook tells you to return to the ICS_Hack_'n_Track_Runbook, return to the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

## Step 1: Public Discovery

Start in the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

Use the supplied SSH reconnaissance script and buffered IP list to identify the public IP address associated with your assigned Terminal Server name.

Record the following in [Purple Team Notes](Purple_Team_Notes.md):

- Assigned Terminal Server name
- Terminal Server public IP address
- SSH banner or identifying output
- Reconnaissance command and result

### Expected Outcome

- The assigned Terminal Server public IP address is known.
- The host responds as expected to the workshop reconnaissance script.

## Step 2: Obtain Terminal Server Credentials

Continue in the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

Complete the authorized Hydra dictionary exercise using the supplied password dictionary.

Record the following in [Purple Team Notes](Purple_Team_Notes.md):

- Dictionary file path
- Hydra command
- Terminal Server username
- Recovered Terminal Server password
- Hydra output file

### Expected Outcome

- The Terminal Server username and password are known.

## Step 3: Access the Terminal Server

Continue in the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

Connect to the Terminal Server over SSH and inspect the available files. Locate the workshop access information and the stored Application Server credentials.

Record the following in [Purple Team Notes](Purple_Team_Notes.md):

- CALDERA URL, username, and password
- Malcolm URL, username, and password
- Application Server hostname or private IP
- Application Server SSH username and password
- Paths of the documents containing the information

### Expected Outcome

- Terminal Server access is established.
- CALDERA and Malcolm access details are known.
- Application Server credentials are known.

## Step 4: Complete the Terminal Server Runbook

At the section break in the main runbook, open the [Terminal Server Runbook](Terminal_Server_Caldera_Pivot_Setup_Runbook.md).

Follow that runbook from beginning to end. It contains the complete Terminal Server workflow:

1. Confirm the scope and success criteria.
2. Obtain the workshop information.
3. Define the Terminal Server lab variables.
4. Inspect Microsoft Defender and add the exact-file exception.
5. Identify the current owner of TCP/3389.
6. Stop and disable Remote Desktop Services after confirming alternate access.
7. Create the restricted inbound firewall rule.
8. Copy and run the current Terminal Server pivot command from CALDERA.
9. Confirm the pivot process is running and owns TCP/3389.
10. Run the compact verification block.

> **Critical access warning:** Stopping Remote Desktop Services can terminate an active RDP session. Confirm the alternate administration path required by the Terminal Server runbook before stopping `TermService`.

### Terminal Server Completion Check

Before returning to the main runbook, verify:

- `TermService` is stopped and disabled.
- The exact Sandcat executable path is allowlisted in Microsoft Defender.
- The firewall rule allows only the assigned Application Server.
- CALDERA Agent 1 is in the `pivot` group.
- The P2P listener is bound to TCP/3389.
- The pivot process owns TCP/3389.

When the Terminal Server runbook reaches its final section break, return to the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

## Step 5: Complete the Application Server Runbook

When the workflow reaches the Application Server portion, open the [Application Server Runbook](Application_Server_Setup_For_Caldera_Downstream_Agent_Runbook.md).

Follow that runbook from beginning to end. It contains the complete Application Server workflow:

1. Confirm the scope and success criteria.
2. Find the target PLC using Nmap and ARP.
3. Define the Application Server lab variables.
4. Verify the Terminal Server pivot listener is reachable on TCP/3389.
5. Inspect Microsoft Defender and add the exact-file exception.
6. Copy the current downstream/P2P command from CALDERA.
7. Confirm the downstream process is running.
8. Verify the Application Server agent in CALDERA.
9. Verify the PLC network path on TCP/102.
10. Run the compact verification block.
11. Review the final expected state.

### Application Server Completion Check

Before returning to the main runbook, verify:

- The target PLC IP address is known.
- The Terminal Server pivot is reachable on TCP/3389.
- The exact Sandcat executable path is allowlisted in Microsoft Defender.
- CALDERA Agent 2 appears as the Application Server agent.
- Agent 2 is assigned to the `red` group.
- The agent command line uses the Terminal Server pivot callback.
- The PLC is reachable from the Application Server on TCP/102.
- The Application Server retains the intended OT-facing source path.

When the Application Server runbook reaches its final section break, return to the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

## Step 6: Continue the Main Workshop Runbook

Continue with the PLC-facing phases in the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md).

### Discover Engineering Context

Inspect the Application Server for artifacts that explain the PLC memory model, including:

- HMI tag exports
- Commissioning notes
- Operator handoff notes
- Status maps
- Troubleshooting documents
- DB1 memory-layout references
- DB10 memory-layout references

Record every relevant file path and finding in [Purple Team Notes](Purple_Team_Notes.md).

### Identify the PLC and Establish a Baseline

Use Agent 2 for PLC-facing actions:

- Run the OT port-scan ability.
- Identify the PLC on TCP/102.
- Complete the S7 handshake with rack 0 and slot 1.
- Confirm the CPU is in RUN.
- Read the baseline DB10 status.
- Download the baseline DB1 process snapshot.

### Stage the Process-Isolation Request

Follow the main runbook to:

- Write command code 1 to the documented DB10 command area.
- Capture or verify the command nonce.
- Read the updated process status.
- Download DB1 again.
- Confirm the CPU remains in RUN.

### Observe the Process Impact

Compare the baseline and impact values documented in the main runbook. Record the DB10 status, CPU state, mode, fuel flow, turbine RPM, fuel-valve position, steam flow, steam pressure, and system status in [Purple Team Notes](Purple_Team_Notes.md).

### Clear the Request and Verify Recovery

- Clear the DB10 process-isolation request.
- Verify that the command code and nonce return to zero.
- Read the recovered DB10 status.
- Download DB1 again.
- Confirm that the process returns to its baseline values.

The optional PLC STOP/HOT START branch remains separate from the primary process-isolation workflow and should be completed only when directed.

## Step 7: Complete the Malcolm Blue Team Runbook

At the final section break in the main runbook, open the [Malcolm Blue Team Runbook](Malcolm.md).

Use Malcolm to reconstruct the activity from the Blue Team perspective. Follow the Malcolm runbook in its existing order and record the relevant filters, views, timestamps or markers, source and destination systems, protocol observations, S7 activity, and supporting evidence in [Purple Team Notes](Purple_Team_Notes.md).

The investigation should trace the workshop path through:

1. Public discovery
2. Terminal Server access
3. Credential discovery
4. Terminal Server pivot establishment
5. Application Server activity
6. S7 communication
7. Process-isolation activity
8. Process recovery

## Quick Reference

| Activity | Document |
|---|---|
| Repository navigation | [README](README.md) |
| Public discovery | [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md) |
| Credential exercise | [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md) |
| Terminal Server SSH access | [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md) |
| Terminal Server preparation and Agent 1 | [Terminal Server Runbook](Terminal_Server_Caldera_Pivot_Setup_Runbook.md) |
| Application Server preparation and Agent 2 | [Application Server Runbook](Application_Server_Setup_For_Caldera_Downstream_Agent_Runbook.md) |
| PLC baseline and process-isolation workflow | [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md) |
| Blue Team investigation | [Malcolm Blue Team Runbook](Malcolm.md) |
| Student evidence and notes | [Purple Team Notes](Purple_Team_Notes.md) |
| Workshop data reference | [Data Sheet](Data_template.txt) |

## Student Completion Checklist

### Preparation

- [ ] Download the Buffered IP List.
- [ ] Download the SSH Recon Script.
- [ ] Download the Password Dictionary.
- [ ] Open Purple Team Notes.

### Public Discovery and Initial Access

- [ ] Identify the assigned Terminal Server public IP.
- [ ] Recover the Terminal Server credentials.
- [ ] Access the Terminal Server over SSH.
- [ ] Locate the CALDERA access details.
- [ ] Locate the Malcolm access details.
- [ ] Locate the Application Server credentials.

### Terminal Server

- [ ] Complete the Terminal Server runbook.
- [ ] Confirm alternate administration access before stopping RDP.
- [ ] Confirm Agent 1 is in the `pivot` group.
- [ ] Confirm the P2P listener uses TCP/3389.
- [ ] Confirm the firewall source is restricted to the Application Server.

### Application Server

- [ ] Access the Application Server.
- [ ] Identify the target PLC.
- [ ] Complete the Application Server runbook.
- [ ] Confirm Agent 2 is in the `red` group.
- [ ] Confirm the PLC path uses the Application Server OT-facing interface.
- [ ] Confirm PLC TCP/102 reachability.

### PLC Exercise

- [ ] Discover the engineering context.
- [ ] Capture the baseline process state.
- [ ] Stage the process-isolation request.
- [ ] Capture the impact state.
- [ ] Clear the request.
- [ ] Verify recovery to baseline values.

### Malcolm Investigation

- [ ] Complete the Malcolm Blue Team runbook.
- [ ] Identify the Terminal Server activity.
- [ ] Identify the pivot activity.
- [ ] Identify the Application Server activity.
- [ ] Identify the S7 activity.
- [ ] Identify the process-isolation activity.
- [ ] Identify the recovery activity.
- [ ] Complete the investigation notes.

## Runbook Order Summary

1. [README](README.md)
2. [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md), Phases 1 through 3
3. [Terminal Server Runbook](Terminal_Server_Caldera_Pivot_Setup_Runbook.md)
4. Return to the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md)
5. [Application Server Runbook](Application_Server_Setup_For_Caldera_Downstream_Agent_Runbook.md)
6. Return to the [Main Workshop Runbook](ICS_Hack_'n_Track_Runbook.md) for the PLC workflow
7. [Malcolm Blue Team Runbook](Malcolm.md)
8. Use [Purple Team Notes](Purple_Team_Notes.md) throughout the entire workshop
