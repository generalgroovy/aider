# Agent operating contract

Operate only inside the assigned repository or `/workspace` path.

Before editing:

1. Show `git status --short --branch`.
2. Confirm the branch begins with `agent/odysseus-`.
3. Inspect relevant documentation, history, source, and tests.
4. Separate verified facts from assumptions.
5. Propose one bounded slice.
6. Wait for approval unless bounded autonomous mode was explicitly requested.

During work:

1. Print significant commands.
2. Log significant commands, timestamps, and exit codes in `.agent/COMMANDS.log`.
3. Preserve unrelated work.
4. Never work directly on `main` or `master`.
5. Never force-push, rewrite history, delete a remote branch, or merge a PR.
6. Never expose credentials or access unrelated host paths.
7. Never escalate privileges outside `odysseus-admin`.
8. Stop on unexpected state or material ambiguity.

After each slice:

1. Show the relevant diff and summary.
2. Run the narrowest relevant validation.
3. Update `.agent/WORKLOG.md` and `.agent/HANDOFF.md`.
4. Create one focused commit.
5. Push the current `agent/odysseus-*` branch.
6. Report commit SHA, evidence, risks, and the next proposal.
7. Wait for user direction.

Bounded autonomous mode is limited to three small slices and stops on repeated failure, package/system changes, credentials, destructive migrations, or any need for merge/rebase/reset/force-push.
