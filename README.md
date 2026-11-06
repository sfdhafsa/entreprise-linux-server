# entreprise-linux-server

A practical Linux infrastructure project built progressively through system administration, networking, automation, monitoring, containerization, CI/CD, and cloud deployment.

## Project Status

Active development.

The local VMware lab currently includes:

- Ubuntu Desktop as the administration workstation.
- Ubuntu Server 24.04 LTS as the service host.
- SSH administration through a Host-only network.
- Nginx serving a web page accessible from Ubuntu Desktop.
- NAT connectivity on both VMs for outbound access.
- A Bash system information script.

This documentation milestone covers the Linux, networking, and Nginx baseline. Firewall configuration, HTTP health-check automation, and incident recovery have also been tested in the lab and will be documented in a separate update.

## Lab Overview

| Machine | Role | NAT address | Host-only address |
|---|---|---|---|
| Ubuntu Desktop | Administration workstation and web client | 192.168.211.132/24 | 192.168.18.128/24 |
| Ubuntu Server | SSH and Nginx server | 192.168.211.134/24 | 192.168.18.129/24 |

These are the addresses observed in this lab. They are assigned through DHCP and may change.

## Verified Results

- SSH login succeeds through the server's Host-only address.
- The `entreprise-server` SSH alias uses that Host-only address.
- Nginx is running and enabled at boot.
- Ubuntu Desktop displays the Nginx welcome page at:
  `http://192.168.18.129`

## Documentation

- [Architecture](docs/architecture.md)
- [Server baseline](docs/server-baseline.md)
- [Network and web-service setup](docs/setup.md)
- [Roadmap](docs/roadmap.md)

## Existing Automation

- [`scripts/system-info.sh`](scripts/system-info.sh): displays hostname, current user, kernel, uptime, disk usage, and memory usage.

## Next Improvements

- Stabilize the lab's IP addresses.
- Document the firewall policy and its verification.
- Integrate the HTTP health-check script and incident report.
- Deploy an application behind Nginx.
- Progress toward monitoring, Docker, CI/CD, and Google Cloud Platform.

The project represents a learning environment, not a production deployment.
