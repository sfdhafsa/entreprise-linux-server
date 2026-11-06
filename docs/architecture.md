# Enterprise Linux Server Architecture

## Purpose

Build and operate a Linux infrastructure locally, then progressively introduce automation, monitoring, containers, CI/CD, and cloud deployment.

## Current Architecture

Network and web-service baseline recorded on 6 November 2026.

```text
Windows host running VMware
|
+-- NAT network: 192.168.211.0/24
|   Gateway: 192.168.211.2
|   |
|   +-- Ubuntu Desktop
|   |   ens33: 192.168.211.132/24
|   |
|   +-- Ubuntu Server
|       ens33: 192.168.211.134/24
|
+-- Host-only network: 192.168.18.0/24
    |
    +-- Ubuntu Desktop
    |   ens37: 192.168.18.128/24
    |   Administration workstation and HTTP client
    |
    +-- Ubuntu Server
        ens37: 192.168.18.129/24
        Hostname: entreprise-server
        SSH: TCP 22
        Nginx: TCP 80
```

The Windows host also participates in the Host-only network. Other VMs attached to the same network may communicate with these machines, subject to access controls.

## Machine Roles

### Ubuntu Desktop

- Provides the administration terminal.
- Connects to Server through SSH.
- Tests the web service using a browser and command-line tools.
- Uses NAT for Internet access.

### Ubuntu Server

- Hosts OpenSSH and Nginx.
- Accepts administration connections through its Host-only address.
- Serves the Nginx welcome page.
- Retains NAT for outbound access, including package downloads.

## Networking Decisions

Both VMs have two interfaces:

- `ens33`: NAT network.
- `ens37`: Host-only network.

The default route uses `192.168.211.2` through `ens33`.

Traffic to `192.168.18.0/24` uses the directly connected Host-only interface.

The Host-only network provides a separate communication path for the lab. It does not replace firewall rules.

Removing the server's NAT adapter was considered but has not been implemented.

## Services

| Service | Port | Current purpose |
|---|---|---|
| OpenSSH | TCP 22 | Remote administration |
| Nginx | TCP 80 | Static HTTP web server |

Nginx currently serves its default welcome page. It is not yet configured as a reverse proxy for an application.

SSH and Nginx were observed listening on all IPv4 and IPv6 interfaces. Actual access also depends on network paths and firewall rules.

## Verified Communication

| Source | Destination | Verification |
|---|---|---|
| Desktop 192.168.18.128 | Server 192.168.18.129:22 | Successful SSH session |
| Desktop browser | http://192.168.18.129 | Nginx welcome page displayed |

Firewall rules, health-check automation, and incident recovery are covered by a separate documentation milestone.

## Current Limitations

- IP addresses are assigned through DHCP and may change.
- The web service uses HTTP; HTTPS is not configured.
- No application backend has been deployed.
- No cloud infrastructure is part of this local baseline.

## Future Direction

- Stable addressing.
- Application deployment and Nginx reverse proxying.
- Monitoring, logging, and backups.
- Containerization with Docker.
- Automated validation and deployment through CI/CD.
- Deployment to Google Cloud Platform.

## Repository Structure

```text
entreprise-linux-server/
├── README.md
├── LICENSE
├── assets/
├── backups/
├── configs/
├── docs/
├── monitoring/
└── scripts/
```

## Design Principles

- Build incrementally.
- Verify each milestone.
- Document decisions and operational procedures.
- Separate implemented capabilities from future plans.
- Learn networking concepts as needed for deployment and troubleshooting.
