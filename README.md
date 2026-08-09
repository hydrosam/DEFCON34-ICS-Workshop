# DEF CON OT Workshop User Guide

## Welcome

This workshop simulates a complete IT-to-OT intrusion lifecycle. Students begin with only limited information, discover and compromise an exposed system, pivot through the environment using CALDERA, interact with a PLC simulator, and finally switch to a Blue Team perspective using Malcolm to investigate the attack path and process impact. 【1-456b84】

The workshop consists of four primary runbooks:

1. Main Workshop Runbook
2. Terminal Server CALDERA Pivot Setup Runbook
3. Application Server CALDERA Agent Setup Runbook
4. Malcolm Blue Team Runbook

These documents should be completed in the order outlined below. 【1-456b84】

---

# Required Downloads

Download the following files before beginning:

| Resource | Purpose | Download |
|-----------|----------|----------|
| Buffered IP List | List of known Terminal Server IPs used during discovery | **[INSERT DOWNLOAD LINK]** |
| SSH Recon Script (`ssh-recon.sh`) | Searches the IP list to identify the assigned Terminal Server | **[INSERT DOWNLOAD LINK]** |
| Password Dictionary (`dictionary.txt`) | Used during the Hydra credential recovery exercise | **[INSERT DOWNLOAD LINK]** |

[Data sheet](Data_sheet.txt)

[Malcolm rundown](Malcolm.md)
---

# Workshop Flow

```text
Main Runbook
    |
    +--> Phase 1: Public Discovery
    |
    +--> Phase 2: Credential Recovery
    |
    +--> Phase 3: Terminal Server Access
    |
    +--> Terminal Server Runbook
    |
    +--> Application Server Runbook
    |
    +--> Main Runbook (PLC Activities)
    |
    +--> Malcolm Blue Team Runbook
```

---

# Step 1 – Public Discovery

Follow the Main Workshop Runbook.

Students are provided a unique Terminal Server name and must use the supplied reconnaissance script and buffered IP list to identify the correct public IP address. 【1-456b84】

### Required Files

- Buffered IP List
- `ssh-recon.sh`

### Expected Outcome

You should identify:

- Terminal Server public IP address
- Confirmation that the host is reachable

---

# Step 2 – Recover Terminal Server Credentials

Continue following the Main Workshop Runbook.

Students perform an authorized password recovery exercise using Hydra and the supplied dictionary file. The objective is to identify valid credentials for the exposed Terminal Server. 【1-456b84】

### Required Files

- `dictionary.txt`

### Expected Outcome

You should obtain:

- Terminal Server username
- Terminal Server password

---

# Step 3 – Access the Terminal Server

Continue following the Main Workshop Runbook.

Use SSH to log into the Terminal Server using the credentials recovered during the previous phase. Once connected, begin exploring the system. 【1-456b84】

### Expected Outcome

You should locate:

- CALDERA URL
- CALDERA username
- CALDERA password
- Malcolm URL
- Malcolm username
- Malcolm password
- Application Server credentials document

These artifacts are intentionally placed on the Terminal Server as part of the workshop scenario. 【1-456b84】

---

# Step 4 – Open the Terminal Server Runbook

At the end of Phase 3, the Main Workshop Runbook directs students to the:

## Terminal Server CALDERA Pivot Setup Runbook

This runbook focuses on preparing the Terminal Server for CALDERA pivot operations.

Students will:

- Discover Application Server information
- Verify ownership of TCP/3389
- Disable Remote Desktop Services
- Configure the CALDERA pivot listener
- Configure Windows Firewall restrictions
- Validate the pivot configuration

The Terminal Server becomes the bridge between the public environment and the OT network. 【2-fc7ce0】

### Expected Outcome

Students should complete the following:

- CALDERA Agent 1 deployed
- TCP/3389 configured for pivot communication
- Firewall restricted to the Application Server
- Pivot connectivity verified

【2-fc7ce0】

---

# Step 5 – Open the Application Server Runbook

Once the Terminal Server pivot is operational, move to the:

## Application Server CALDERA Agent Setup Runbook

This runbook focuses on:

- PLC discovery
- Pivot verification
- Downstream CALDERA agent deployment
- OT connectivity validation

Students use the Terminal Server pivot to deploy Agent 2 onto the Application Server. 【3-2b4725】

### Expected Outcome

Students should complete the following:

- PLC identified
- Downstream CALDERA agent deployed
- Agent assigned to the `red` group
- OT path to PLC verified

【3-2b4725】

---

# Step 6 – Return to the Main Workshop Runbook

After completing the Terminal Server and Application Server runbooks, return to the Main Workshop Runbook.

The remaining phases focus on OT reconnaissance and process interactions. 【1-456b84】

## Engineering Context Discovery

Students locate engineering artifacts that explain the PLC environment.

Examples include:

- HMI exports
- Commissioning notes
- Operator handoff documents
- Status mappings
- Troubleshooting references
- DB1 and DB10 memory references

【1-456b84】

---

## PLC Discovery and Baseline Collection

Students use Agent 2 to:

- Locate the PLC
- Complete the S7 handshake
- Verify CPU state
- Read baseline status values
- Download process data

【1-456b84】

---

## Process Isolation Scenario

Students stage a controlled process-isolation request and observe the resulting operational impact.

Activities include:

- Writing the command to DB10
- Validating process-state changes
- Monitoring status values
- Comparing process snapshots

The controller remains operational while process output is reduced. 【1-456b84】

---

## Process Recovery

Students remove the isolation request and verify normal operations return.

Activities include:

- Clearing the request
- Confirming status recovery
- Verifying baseline values
- Reviewing updated process snapshots

【1-456b84】

---

# Step 7 – Open the Malcolm Blue Team Runbook

After completing the OT attack sequence, students transition to the Blue Team perspective.

## Malcolm Blue Team Runbook

Using Malcolm, students reconstruct the complete attack path.

Expected analysis areas include:

1. Public exposure discovery
2. Terminal Server compromise
3. Credential discovery
4. CALDERA pivot establishment
5. Application Server compromise
6. S7 communications
7. Process isolation actions
8. Process recovery activities

This phase demonstrates how defenders correlate process impacts to the original IT compromise path. 【1-456b84】

---

# Quick Reference

| Activity | Runbook |
|-----------|----------|
| Public Discovery | Main Workshop Runbook |
| Password Recovery | Main Workshop Runbook |
| Terminal Server Access | Main Workshop Runbook |
| Pivot Configuration | Terminal Server Runbook |
| Downstream Agent Deployment | Application Server Runbook |
| PLC Discovery | Main Workshop Runbook |
| Process Isolation | Main Workshop Runbook |
| Recovery Validation | Main Workshop Runbook |
| Threat Hunting and Investigation | Malcolm Runbook |

【1-456b84】【2-fc7ce0】【3-2b4725】

---

# Student Completion Checklist

- [ ] Download Buffered IP List
- [ ] Download SSH Recon Script
- [ ] Download Dictionary File
- [ ] Discover Terminal Server IP Address
- [ ] Recover Terminal Server Credentials
- [ ] Access Terminal Server
- [ ] Locate CALDERA Credentials
- [ ] Locate Malcolm Credentials
- [ ] Locate Application Server Credentials
- [ ] Complete Terminal Server Runbook
- [ ] Complete Application Server Runbook
- [ ] Deploy Agent 2
- [ ] Identify the PLC
- [ ] Capture Baseline Process State
- [ ] Execute Process Isolation Exercise
- [ ] Validate Recovery
- [ ] Complete Malcolm Investigation

---

## Runbook Order Summary

1. User Guide
2. Main Workshop Runbook (Phases 1–3)
3. Terminal Server Runbook
4. Application Server Runbook
5. Main Workshop Runbook (Phases 5–20)
6. Malcolm Blue Team Runbook

Following the documents in this order ensures students experience the attack path exactly as designed and can trace it end-to-end during the Blue Team investigation phase. 【1-456b84】【2-fc7ce0】【3-2b4725】
