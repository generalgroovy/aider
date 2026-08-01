# Security

Odysseus is an administrative application. Keep it authenticated and bound to localhost. The host Ollama endpoint may listen for Docker access but must not be exposed through the router or public firewall.

The overlay mounts only `~/AgentWorkspaces`. It does not mount the Docker socket, root filesystem, home directory, SSH keys, browser data, or secrets.

Agent work uses locked worktrees created from the remote default branch. Human checkouts may be dirty and are never stashed or reset.

`agent-publish` creates draft PRs only. `agent-clean` requires a clean worktree whose exact HEAD exists on the remote branch. It retains the branch and PR.

The optional gateway permits only fixed service status/restart and bounded journal operations. It grants no package installation, arbitrary command, Docker-group membership, Docker socket, or root shell.

Audit with:

```fish
sudo journalctl -t odysseus-admin --no-pager
sudo less /var/log/odysseus-agent-sudo.log
```
