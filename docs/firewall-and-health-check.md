# Firewall and Web Health Check

This document records the UFW policy, web health check, and Nginx recovery test completed in the local VMware lab.

The server's Host-only address at the time of testing was `192.168.18.129`. The Desktop's Host-only address was `192.168.18.128`.

These DHCP-assigned addresses may change in the future.

## Goal

The lab server should accept SSH administration and HTTP web requests from Ubuntu Desktop through the Host-only network.

Access through the Server's NAT address should not provide unnecessary access to the internal web service.

## UFW Firewall Policy

UFW is Ubuntu's command-line tool for managing firewall rules.

The policy was prepared before enabling the firewall:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

This means:

- Incoming connections are blocked unless a rule allows them.
- Outbound connections remain allowed, including package downloads and responses to accepted incoming connections.

The following rules allow only the Desktop Host-only address to access SSH and HTTP through the Server's Host-only interface:

```bash
sudo ufw allow in on ens37 from 192.168.18.128 to any port 22 proto tcp
sudo ufw allow in on ens37 from 192.168.18.128 to any port 80 proto tcp
```

The firewall was then enabled:

```bash
sudo ufw enable
sudo ufw status verbose
```

## Allowed Traffic

| Source | Server interface | Destination port | Service | Result |
|---|---|---:|---|---|
| Desktop `192.168.18.128` | `ens37` | TCP 22 | SSH | Allowed |
| Desktop `192.168.18.128` | `ens37` | TCP 80 | Nginx / HTTP | Allowed |

## Verification

A new SSH connection through the `entreprise-server` alias succeeded.

The Nginx welcome page also opened in the Desktop browser:

```text
http://192.168.18.129
```

HTTP access through the Server's NAT address was tested from Desktop:

```bash
curl --connect-timeout 5 http://192.168.211.134
```

The request timed out as expected.

The equivalent request through the Host-only address succeeded:

```bash
curl --connect-timeout 5 http://192.168.18.129
```

This confirmed that the intended Host-only path worked while the NAT HTTP path was blocked.

## Web Health Check

The repository contains:

```text
scripts/check-web.sh
```

Run it without arguments to check the Server's Host-only Nginx endpoint:

```bash
bash scripts/check-web.sh
```

Run it with a URL to test a different endpoint:

```bash
bash scripts/check-web.sh http://192.168.211.134
```

The script uses `curl` to request the URL, discards the page body, and reads only the HTTP status code.

| Result | Meaning | Exit code |
|---|---|---:|
| `OK: ... returned HTTP 200` | The web service responded successfully. | 0 |
| `FAIL: ... returned HTTP <code>` | The service responded, but not with HTTP 200. | 1 |
| `FAIL: could not reach ...` | The request could not establish a successful connection. | 1 |

Exit code `0` allows a person, scheduler, or CI job to treat the service as healthy. Exit code `1` signals a failed check.

## Nginx Recovery Exercise

A controlled service incident was performed without changing network or firewall settings.

1. Stop Nginx on Server:

   ```bash
   sudo systemctl stop nginx
   ```

2. Run the health check from Desktop:

   ```bash
   bash scripts/check-web.sh
   echo $?
   ```

   The script failed and returned exit code `1`.

3. Investigate on Server:

   ```bash
   sudo systemctl status nginx --no-pager
   sudo ss -ltnp
   ```

   Nginx was inactive and TCP port 80 was no longer listening.

4. Restore Nginx:

   ```bash
   sudo systemctl start nginx
   ```

5. Repeat the Desktop health check.

   The script returned HTTP `200` and exit code `0`.

## Current Limitations

- The firewall rules use DHCP-assigned addresses and will need review if the lab addresses change.
- Nginx currently serves its default static page.
- The health check tests HTTP availability only; it does not measure response time, validate application content, or monitor system resources.
