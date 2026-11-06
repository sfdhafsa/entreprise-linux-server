# Enterprise Server Baseline

## Server Identity

| Property | Value |
|---|---|
| Hostname | entreprise-server |
| Operating system | Ubuntu Server 24.04 LTS |
| Environment | VMware virtual machine |
| Administrator | sysadmin |
| Purpose | Linux administration and infrastructure learning |

## Installation Decisions

- Minimal Ubuntu Server installation.
- Default Ubuntu storage layout.
- OpenSSH installed manually after installation.
- English system localization.

## Administrative Access

Administration uses the dedicated `sysadmin` account.

Documented group membership:

- `sudo`
- `sysadmins`

The initial installation user is retained as a recovery account.

## SSH Security Baseline

The existing project baseline records:

- Public key authentication enabled.
- Password authentication disabled.
- Root SSH login disabled.
- ED25519 keys used for administration.
- Administrative privileges obtained through `sudo`.

These settings are retained from the earlier baseline; they were not re-audited during the networking and Nginx milestone.

## Network Interfaces

Addresses observed on 6 November 2026:

| Interface | Network | Address | Purpose |
|---|---|---|---|
| ens33 | NAT | 192.168.211.134/24 | Outbound connectivity |
| ens37 | Host-only | 192.168.18.129/24 | Lab administration and HTTP access |

The default gateway is `192.168.211.2` through `ens33`.

Both addresses are assigned through DHCP. Stable addressing remains a follow-up task.

The additional Host-only interface is configured through:

```text
/etc/netplan/60-host-only.yaml
```

See [setup.md](setup.md) for its configuration.

## SSH Access Path

```text
Ubuntu Desktop
192.168.18.128
      |
      | SSH — TCP 22
      v
Ubuntu Server
192.168.18.129
      |
      v
sysadmin shell
```

The Desktop SSH configuration uses:

```sshconfig
Host entreprise-server
    HostName 192.168.18.129
    User sysadmin
```

Any existing identity settings are preserved.

A fresh connection using `ssh entreprise-server` was verified with:

```bash
echo "$SSH_CONNECTION"
```

The output showed the Desktop and Server Host-only addresses.

## Web Service

Nginx is installed, running, and enabled at boot.

Verification commands:

```bash
sudo systemctl status nginx --no-pager
sudo ss -ltnp
```

The default welcome page was reached from Ubuntu Desktop at:

```text
http://192.168.18.129
```

Nginx currently acts as a static web server. Application reverse proxying is future work.

## Filesystem Layout and Permissions

The existing baseline uses a root-owned infrastructure layout:

| Path | Purpose | Owner | Group | Permissions |
|---|---|---|---|---|
| /srv/applications | Application deployments | root | sysadmins | 750 |
| /opt/tools | Administrative tools | root | sysadmins | 750 |
| /backup | Backup storage | root | sysadmins | 750 |

Administrative users access these directories through membership in `sysadmins`. Modifications require appropriate privileges.

These permissions are retained from the earlier documentation and were not re-audited during this milestone.

## Documentation Scope

This file records the Linux, network, and web-service baseline.

Firewall rules, the HTTP health-check script, and incident recovery were tested subsequently and will be documented separately.
