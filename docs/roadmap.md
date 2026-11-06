# Roadmap

The project progresses through practical infrastructure milestones.

Checked tasks are supported by the existing server baseline or recorded lab tests. A checked task does not mean the entire phase is complete.

Earlier SSH security and filesystem configuration are documented in the baseline; they were not re-audited during the networking milestone.

## Phase 1 — Linux System Administration

Status: In progress.

Goal: Build a maintainable Linux server and operate an internal web service.

- [x] Install a minimal Ubuntu Server VM
- [x] Configure OpenSSH
- [x] Implement SSH key authentication
- [x] Create an administrative user and groups
- [x] Configure filesystem ownership and permissions
- [x] Connect Desktop and Server through Host-only networking
- [x] Verify SSH administration over Host-only
- [x] Update the Desktop SSH alias
- [x] Install Nginx
- [x] Verify HTTP access from Desktop
- [x] Inspect services with systemctl and ss
- [ ] Stabilize lab IP addresses
- [ ] Design a backup strategy
- [ ] Complete Linux administration documentation

## Phase 2 — Bash Automation

Status: In progress.

Goal: Automate useful administration tasks.

- [x] Add a system information script
- [ ] Integrate and document the tested HTTP health-check script
- [ ] Automated backup script
- [ ] Disk usage reports
- [ ] User audit script
- [ ] Evaluate log rotation requirements

## Current Documentation Follow-up

The following work has been exercised in the lab but is reserved for a separate repository update:

- [ ] Document UFW rules for Host-only SSH and HTTP access
- [ ] Record allowed and blocked connection tests
- [ ] Add the HTTP health-check script and its usage
- [ ] Record the Nginx stop, detection, restart, and recovery test

These unchecked items refer to repository integration and documentation, not a claim that the lab exercises remain undone.

## Phase 3 — Git and Documentation

Status: In progress.

Goal: Keep changes reviewable and the infrastructure understandable.

- [x] Initialize the repository
- [x] Document the server baseline
- [ ] Adopt a feature branch workflow consistently
- [ ] Maintain documentation alongside implementation
- [ ] Add a changelog
- [ ] Introduce issue tracking when useful

## Phase 4 — Python Administration Tools

Status: Planned.

Goal: Introduce Python when administration tasks benefit from it.

- [ ] Log analyzer
- [ ] Resource reporting utility
- [ ] Server reporting utility

## Phase 5 — Docker

Status: Planned.

Goal: Containerize services and understand their operation.

- [ ] Containerize an application
- [ ] Build a Docker Compose environment
- [ ] Configure persistent volumes
- [ ] Configure container networking
- [ ] Verify container health and logs

## Phase 6 — CI/CD

Status: Planned.

Goal: Automate quality checks and deployment.

- [ ] Introduce GitHub Actions
- [ ] Automate script linting
- [ ] Add meaningful validation checks
- [ ] Build container images
- [ ] Automate deployment and verification

## Phase 7 — Google Cloud Platform

Status: Planned.

Goal: Apply the local infrastructure skills in a cloud environment.

- [ ] Provision a Compute Engine VM
- [ ] Configure cloud networking and firewall rules
- [ ] Secure remote administration
- [ ] Deploy the service
- [ ] Configure Cloud Monitoring
- [ ] Evaluate Cloud Storage for backups
- [ ] Introduce infrastructure as code

## Learning Approach

For each milestone:

1. Understand the concepts needed for the task.
2. Implement the change.
3. Verify expected behavior.
4. Investigate a relevant failure.
5. Document the result.

Networking study stays focused on deployment, access control, and troubleshooting needs for DevOps and cloud engineering.
