# Local Network and Web-Service Setup

This guide records the networking and Nginx milestone completed on 6 November 2026.

It supplements the existing [server baseline](server-baseline.md). It does not describe a complete Ubuntu installation.

The IP addresses and interface names below belong to this lab; other environments may differ.

## 1. Configure VMware Adapters

Both VMs retain their existing NAT adapter.

With each VM shut down:

1. Open its settings in VMware.
2. Add a Network Adapter.
3. Select Host-only.
4. Enable Connect at power on.
5. Start the VM.

Resulting interfaces:

| Machine | NAT interface | Host-only interface |
|---|---|---|
| Desktop | ens33 | ens37 |
| Server | ens33 | ens37 |

Inspect each VM:

```bash
hostname
ip -br addr
ip route
```

Desktop configured its Host-only interface automatically.

Server initially detected `ens37` but showed it as DOWN, with no IP address.

## 2. Configure Host-only Networking on Server

The existing Netplan configuration included only:

```yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: true
```

Preserve that configuration.

Create a separate file:

```bash
sudo nano /etc/netplan/60-host-only.yaml
```

Contents:

```yaml
network:
  version: 2
  ethernets:
    ens37:
      dhcp4: true
      dhcp4-overrides:
        use-routes: false
      optional: true
```

The configuration requests an address through DHCP and instructs the renderer not to use DHCP-provided routes on this interface.

Apply and validate:

```bash
sudo chmod 600 /etc/netplan/60-host-only.yaml
sudo netplan generate
sudo netplan try
```

If generation reports an error, correct it before proceeding.

Confirm the temporary configuration when prompted if connectivity remains available. Keep VMware console access available during network changes.

Inspect the result:

```bash
ip -br addr
ip route
```

Observed addresses:

| Machine | NAT address | Host-only address |
|---|---|---|
| Desktop | 192.168.211.132/24 | 192.168.18.128/24 |
| Server | 192.168.211.134/24 | 192.168.18.129/24 |

The server's default route remained through `192.168.211.2` on `ens33`.

A DHCP-specific route to `192.168.18.1` also appeared in the observed server output. Its origin was not investigated during this milestone.

## 3. Verify Host-only SSH Access

Keep the existing SSH session open.

From a second terminal on Desktop:

```bash
ssh sysadmin@192.168.18.129
```

Inside the new Server session:

```bash
echo "$SSH_CONNECTION"
```

Expected address pattern:

```text
192.168.18.128 <client-port> 192.168.18.129 22
```

The client port is temporary and changes between connections.

This confirms SSH uses the Host-only network.

## 4. Update the SSH Alias

On Desktop:

```bash
nano ~/.ssh/config
```

Update the existing entry while preserving other settings, including any `IdentityFile`:

```sshconfig
Host entreprise-server
    HostName 192.168.18.129
    User sysadmin
```

Test a fresh connection:

```bash
ssh entreprise-server
echo "$SSH_CONNECTION"
```

The Host-only connection was verified successfully.

## 5. Install Nginx

On Server:

```bash
sudo apt update
sudo apt install nginx
```

The server retains its NAT adapter for package downloads.

Inspect the service:

```bash
sudo systemctl status nginx --no-pager
```

Observed result:

- Service active and running.
- Service enabled at boot.

`--no-pager` prints the status directly in the terminal instead of opening a scrollable viewer.

## 6. Verify HTTP from Desktop

In the Desktop browser, open:

```text
http://192.168.18.129
```

Observed result:

```text
Welcome to nginx!
```

This verifies that a client on another VM can reach the web service.

## 7. Inspect Listening Ports

On Server:

```bash
sudo ss -ltnp
```

Observed listeners included:

| Address | Service |
|---|---|
| 0.0.0.0:80 and [::]:80 | Nginx |
| 0.0.0.0:22 and [::]:22 | SSH |
| 127.0.0.53:53 and 127.0.0.54:53 | Local DNS resolver |

`0.0.0.0` represents all IPv4 interfaces. `[::]` represents the IPv6 wildcard address.

A listening socket does not prove that every network can reach it. Routing and firewall rules also affect access.

## Follow-up Work

- Stabilize the DHCP-assigned addresses.
- Document the tested UFW policy.
- Integrate the HTTP health-check script.
- Record the Nginx failure and recovery exercise.
- Deploy an application and configure reverse proxying.

Firewall and automation details are intentionally reserved for a separate documentation update.
