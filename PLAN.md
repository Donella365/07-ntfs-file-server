# Lab 07 — NTFS File Server — Build Plan

This lab follows the original lab doc almost exactly. It was already written in
an automated style (Terraform + Key Vault + one orchestration script), so this
plan only calls out the handful of things that had to change to run correctly
on this machine and this Azure account. Everything else — every `.tf` file,
every script inside `scripts/`, the folder layout, and the verification
steps — comes straight from the original doc, unchanged.

## What gets built

Three Windows VMs on one Azure network, deployed and configured entirely
through code:

| VM | Job |
| --- | --- |
| **DC01** | Runs Active Directory — tracks every user, group, and computer |
| **FS01** | File server — hosts shared folders (Finance, HR, Sales, IT) with locked-down permissions |
| **CLIENT01** | A regular Windows 11 machine — used to log in as different test users and prove permissions actually work |

## The business idea behind it

Departments should only see their own files. Finance shouldn't see HR's data.
Sales shouldn't see Finance's data. IT needs to see everything to do their
job. Instead of setting permissions file-by-file, users are put into
**security groups** (e.g. `GRP_Finance`), and permissions are set once on
each folder. Anyone added to the group instantly gets the right access —
anyone removed instantly loses it.

## How it gets built (automated, not click-ops)

1. **Terraform** creates the resource group, network, all three VMs, and an
   Azure Key Vault that stores the VM admin password — never typed into a
   file or the terminal.
2. **One orchestration script** (`configure-lab.ps1`) pushes a series of
   smaller PowerShell scripts into each VM automatically, using
   `az vm run-command` — no manual RDP needed for setup. In order, it:
   - Promotes DC01 to a domain controller
   - Creates the OUs, security groups, and five test users
   - Joins FS01 to the domain, creates the shares, sets NTFS permissions
   - Joins CLIENT01 to the domain, enables RDP for domain users
   - Sets up a Group Policy Object so RDP stays enabled
   - Runs two automated verification scripts and prints PASS/FAIL for every
     check
3. **Manual RDP happens only once, at the end** — logging in as different
   test users to confirm Sarah can get into Finance but Tom can't.

This mirrors real practice: infrastructure and configuration as code,
hands-on-keyboard reserved for verification.

## Deviations from the original doc, and why

| Change | Reason |
| --- | --- |
| Region: `Central US` → `mexicocentral` | `Central US` is blocked by this Azure for Students subscription's region policy. Allowed regions were checked first via `az policy assignment list` rather than assumed. |
| `configure-lab.ps1` is run with `pwsh` | This machine runs Fedora 44, not Windows. PowerShell Core (`pwsh`) is installed so the exact same script — same syntax, same logic — runs unchanged. Nothing in the script itself changes. |
| `rdp_source` set to the real home IP, not left as `"*"` | The doc's default leaves RDP reachable from the entire internet. Given a past lab in this portfolio picked up real brute-force login attempts within days of a rule being left open, this gets locked to one IP from the start instead of tightened later. |

## Everything else stays as written in the original doc

- Same file layout: Terraform files in the project root, VM-side scripts in
  `scripts/`
- Same resource group name (`RG-FileServerLab`) — required later by the RBAC
  lab, which reads this lab's resources
- Same Key Vault pattern (`enable_rbac_authorization = true`, secret written
  only after the role assignment propagates)
- Same five test users, same four security groups, same four file shares
- Same verification steps and same troubleshooting table
