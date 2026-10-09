# AGENTS.md

## Sandbox (jai)

You run inside a jai sandbox as an unprivileged user, with a private bare
`$HOME`. Things that look broken (missing dotfiles, read-only paths, invisible
host processes) are the sandbox, not bugs.

- Write only in the workdir (cwd). Any other writable dir exists so its tool can
  function — don't hand-edit them. Before writing anywhere else (installing
  tools, editing user configs), ask the user first.
- `~/.local/bin` is read-only; the binaries there are fine to _run_.
- The real home's dotfiles don't exist here: no `~/.ssh`, `~/.gitconfig`,
  `~/.bashrc` — hence missing git user.\* and ssh to remotes failing.
- `/tmp` is private and doesn't persist; host processes are invisible and can't
  be killed.

## Codemode

The `codemode` tool is enabled globally. Use it to batch independent tool calls
(e.g. `Promise.all`) and filter large outputs in one round trip — only the
script's output reaches the model.

Only if writing non-trivial scripts or unsure about the API, read the full docs:
`/usr/lib/node_modules/pi/packages/coding-agent/docs/codemode.md`

Minimal gotchas:

- Input is raw JavaScript run in a QuickJS sandbox: top-level `await`/`return`
  work, but there are no Node APIs, file system, network, or timers.
- `tools.bash()` resolves to an object
  `{ output, truncated, full_output_path?, exit_code, wall_time_seconds }` — use
  `.output` for the text.
- A failed script does not undo tool calls already made.
