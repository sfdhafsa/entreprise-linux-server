# Enterprise Server Baseline

## Server Identity

| Property | Value |
|---|---|
| Hostname | enterprise-server |
| Operating System | Ubuntu Server 24.04 LTS |
| Environment | VMware Virtual Machine |
| Purpose | Linux infrastructure learning and administration baseline |

## Installation Decisions

- Minimal Ubuntu Server installation was selected.
- Default Ubuntu storage layout was used.
- OpenSSH server was installed manually after installation.
- The system uses English localization.


## Administrative Access

The server uses a dedicated administrative account.

### Administrator

- User: sysadmin
- Groups:
  - sudo
  - sysadmins

The initial installation user is kept as a recovery account.

---

## SSH Configuration

SSH access is configured using public key authentication.

### Authentication method

- Public key authentication: enabled
- Password authentication: disabled
- Root SSH login: disabled

### Key algorithm

ED25519 keys are used for administrator authentication.

### Access flow

The administrator connects from a dedicated workstation:

Ubuntu Desktop
    |
    | SSH using ED25519 private key
    |
    ↓
enterprise-server
    |
    | validates authorized_keys
    |
    ↓
sysadmin shell

### Security decisions

- Direct root SSH access is disabled.
- Password-based SSH authentication is disabled.
- Administrative access is performed through sudo.

## Filesystem Layout and Permissions

The server follows a root-owned infrastructure model.

| Path | Purpose | Owner | Group | Permissions |
|------|---------|-------|-------|-------------|
| /srv/applications | Application deployments | root | sysadmins | 750 |
| /opt/tools | Administrative tools | root | sysadmins | 750 |
| /backup | Backup storage | root | sysadmins | 750 |

Administrative users access these directories through membership in the sysadmins group.

Direct modifications require sudo privileges.