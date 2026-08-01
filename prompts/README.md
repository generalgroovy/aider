# Agent prompts

## Inspect

Read the assigned workspace without modifying it. Show branch and status, inspect documentation/history/source/tests, separate facts from assumptions, and propose one bounded slice with expected files and validation.

## Implement

Implement only the approved slice. Print significant commands, update `.agent` logs, preserve unrelated work, validate, show the diff, create one focused commit, push the current agent branch, report evidence, and stop.

## Bounded autonomous

Complete at most three small slices. Stop on repeated failure, ambiguity, credentials, package/system changes, destructive migrations, access outside the workspace, or any need for merge/rebase/reset/force-push/branch deletion.

## Review

Use `qwen2.5-coder:7b` read-only. Review the branch diff against its base for correctness, security, tests, scope, and operational risk. Do not edit or push.
