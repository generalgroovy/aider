# aider

Safe local-agent operations for Garuda Linux with Foot/fish, an existing Odysseus installation, host Ollama, Qwen2.5-Coder, and GitHub.

The toolkit gives agents broad control inside isolated Git worktrees while keeping host administration, publication, and cleanup explicit and auditable.

## Safety invariants

It never intentionally:

- mounts `/`, `$HOME`, `$HOME/.ssh`, browser profiles, or `/var/run/docker.sock`;
- stashes, resets, or edits a dirty human checkout;
- works directly on `main` or `master`;
- force-pushes, auto-merges, or deletes remote branches;
- grants `NOPASSWD: ALL`;
- installs packages automatically;
- exposes Odysseus or Ollama to the public internet.

Recommended Vivobook Go 15 policy:

- executor: `qwen2.5-coder:3b`;
- read-only reviewer: `qwen2.5-coder:7b`;
- utility: `qwen2.5-coder:1.5b`;
- use 8K context for 3B/7B and avoid loading 3B and 7B simultaneously.

## Install from fish

```fish
cd ~/Projects
git clone https://github.com/generalgroovy/aider.git
cd aider
bash scripts/install.sh
exec fish
agent-doctor
```

The installer does not install or update Odysseus, Ollama, Docker, or models.

## Project workflow

Existing GitHub repository:

```fish
agent-project github generalgroovy/flux2
```

Existing local checkout, even when dirty:

```fish
agent-project local ~/Projects/flux2
```

New private repository under `generalgroovy`:

```fish
agent-project new prototype-name private
```

Each command creates and pushes a locked worktree such as:

```text
~/AgentWorkspaces/flux2/20260801-031500-12345
agent/odysseus-20260801-031500-12345
```

Odysseus sees it at:

```text
/workspace/flux2/20260801-031500-12345
```

Start the existing Odysseus stack:

```fish
agent-run
```

Review and publish as a draft PR:

```fish
cd ~/AgentWorkspaces/flux2/20260801-031500-12345
agent-publish .
```

Remove only a clean, fully pushed local worktree:

```fish
agent-clean .
```

## Commands

| Command | Function |
|---|---|
| `agent-doctor` | Read-only diagnostics |
| `agent-project` | Create isolated workspaces from GitHub, local, or new repositories |
| `agent-run` | Start Odysseus with the restricted mount and persistent tmux logs |
| `agent-status` | Show services, memory, models, containers, workspaces, and audit state |
| `agent-stop` | Stop Odysseus and optionally unload Qwen models |
| `agent-publish` | Push and create a draft PR |
| `agent-clean` | Remove a clean, fully pushed local worktree only |

Configuration lives in:

```text
~/.config/aider-agent/agent.env
```

The Compose overlay mounts only:

```text
~/AgentWorkspaces -> /workspace
```

## Validate

```fish
make validate
```

See [Security](docs/SECURITY.md) and [Garuda/fish usage](docs/GARUDA-FISH.md).
