# Garuda Sway, Foot, and fish

The tools are Bash programs launched normally from fish.

```fish
bash scripts/install.sh
exec fish
agent-doctor
```

Do not paste a block containing `exit` directly into interactive fish: `begin ... end` is not a subshell, so `exit` closes fish and therefore Foot.

Detach tmux without stopping logs:

```text
Ctrl+B, then D
```

Reconnect:

```fish
tmux attach -t odysseus
```

A `pcilib` label permission message is usually unrelated hardware-enumeration noise; inspect the actual command status and following error separately.
