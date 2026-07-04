# Neovim Config 101 — Getting Started

A beginner-friendly guide to this Neovim setup, written for someone new to Vim/Neovim.

This config is built on **[LazyVim](https://www.lazyvim.org/)** — a curated Neovim
"distribution" that bundles a plugin manager, ~30 plugins, keybindings, and sane
defaults so you don't have to wire everything by hand.

---

## 1. Where does the config live?

Neovim reads its config from `~/.config/nvim/` (this folder). When you run `nvim`,
it automatically executes `init.lua` — the **entry point**, the first file that runs.
Everything else is loaded because `init.lua` (directly or indirectly) asks for it.

Config is written in **Lua** (a small programming language). Files end in `.lua`.

---

## 2. Directory structure

```
~/.config/nvim/
├── init.lua                  ← ENTRY POINT (runs first, loads everything)
├── lua/                      ← all your Lua code lives here
│   ├── config/
│   │   ├── lazy.lua          ← installs plugin manager + LazyVim
│   │   ├── options.lua       ← editor settings (tabs, numbers, etc.)
│   │   ├── keymaps.lua       ← your custom keyboard shortcuts
│   │   └── autocmds.lua      ← "auto commands" (run code on events)
│   └── plugins/
│       ├── mini-pairs.lua    ← a configured plugin (auto-close brackets)
│       └── example.lua       ← template/reference (disabled, safe to delete)
├── lazy-lock.json            ← EXACT plugin versions (like package-lock.json)
├── lazyvim.json              ← which LazyVim "Extras" are enabled
├── stylua.toml               ← formatting rules for the Lua config files
├── .neoconf.json             ← LSP/project settings
├── doc/
│   └── getting_started.md    ← this file
└── README.md / LICENSE / .gitignore
```

### The two important folders

**`lua/config/`** — settings *about the editor itself*. These four files are special:
LazyVim automatically loads them at the right time. You just add your lines.

- `options.lua`  → toggles/values (tab width, line numbers, wrap...).
- `keymaps.lua`  → your shortcuts, e.g. map `jk` to Escape.
- `autocmds.lua` → "when X happens, do Y" (e.g. use 2-space tabs for Python).
- `lazy.lua`     → bootstraps everything. **You almost never touch this.**

**`lua/plugins/`** — one file per plugin (or group) you want to add or customize.
LazyVim **auto-loads every `.lua` file in here**. Each file must `return` a table
describing the plugin.

---

## 3. How loading actually flows

```
nvim
 └─ init.lua
     └─ require("config.lazy")        (= lua/config/lazy.lua)
         ├─ downloads lazy.nvim if missing
         ├─ loads LazyVim (the whole distro: 30+ plugins, sane defaults)
         │    └─ auto-loads config/options.lua, keymaps.lua, autocmds.lua
         └─ auto-loads everything in lua/plugins/  (your customizations)
```

Key insight: **`require("config.lazy")` means "run the file `lua/config/lazy.lua`".**
`require("a.b")` = the file `lua/a/b.lua`. The dots are folder separators.

---

## 4. The mental model: 3 things you'll ever change

As a beginner, 99% of your edits fall into one of these:

| I want to...              | Edit this                 | Example                    |
| ------------------------- | ------------------------- | -------------------------- |
| Change an editor setting  | `lua/config/options.lua`  | `vim.opt.number = true`    |
| Add a keyboard shortcut   | `lua/config/keymaps.lua`  | map `jk` → Escape          |
| Add / tweak a plugin      | new file in `lua/plugins/`| add a colorscheme          |

### Example A — an option (settings are just `vim.opt.X = value`)

```lua
vim.opt.wrap = true             -- soft-wrap long lines
vim.opt.relativenumber = false  -- turn off relative line numbers
```

### Example B — a keymap

The pattern is `vim.keymap.set(mode, keys, action, opts)`:

```lua
-- "i" = insert mode. Press jk quickly to escape instead of reaching for Esc:
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
```

### Example C — a plugin (a file in `lua/plugins/` returning a table)

```lua
return {
  { "catppuccin/nvim", name = "catppuccin" },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
```

The plugin's GitHub `"user/repo"` is all lazy.nvim needs to install it.
`opts` = that plugin's settings.

---

## 5. What LazyVim gives you (why you have plugins you didn't install)

**LazyVim is a distribution** — a curated bundle: a plugin manager (`lazy.nvim`),
~30 plugins, keybindings, and defaults, all pre-wired. Your config stays small
because LazyVim does the heavy lifting. Your job is just to *override* bits you
don't like.

Notable plugins you get for free:

| Plugin              | What it does for you                              |
| ------------------- | ------------------------------------------------- |
| `snacks.nvim`       | File picker, dashboard, terminal, notifications   |
| `blink.cmp`         | Autocomplete                                      |
| `flash.nvim`        | Jump anywhere on screen fast (press `s`)          |
| `which-key.nvim`    | Shows keybindings as you type (your best friend)  |
| `gitsigns`          | Git changes in the sign column                    |
| `treesitter`        | Syntax highlighting + smart text selection        |
| `mason` + `lspconfig`| Language servers (autocomplete, go-to-def, errors)|
| `conform`/`nvim-lint`| Auto-formatting + linting                        |
| `bufferline`, `lualine`| Tabs at top, status line at bottom             |

**Extras:** LazyVim has optional add-on packs (language support, extra tools).
Enable them with `:LazyExtras` — it writes to `lazyvim.json`. Much easier than
configuring a language server by hand.

---

## 6. Vim basics (the absolute essentials)

Vim is **modal** — keys do different things depending on the mode:

- **Normal** (default): navigate and run commands. Press `Esc` to get here anytime.
- **Insert**: type text. Enter with `i` (before cursor) or `a` (after cursor).
- **Visual**: select text. Enter with `v`.
- **Command**: type `:` then a command (e.g. `:w` to save).

Core moves (Normal mode):

| Keys       | Action                          |
| ---------- | ------------------------------- |
| `h j k l`  | left / down / up / right        |
| `w` / `b`  | next / previous word            |
| `gg` / `G` | top / bottom of file            |
| `0` / `$`  | start / end of line             |
| `/text`    | search for "text" (`n` = next)  |

Core edits (Normal mode):

| Keys       | Action                          |
| ---------- | ------------------------------- |
| `i` / `a`  | insert before / after cursor    |
| `dd`       | delete (cut) line               |
| `yy`       | yank (copy) line                |
| `p`        | paste                           |
| `u`        | undo                            |
| `Ctrl-r`   | redo                            |
| `:w`       | save                            |
| `:q`       | quit (`:wq` save+quit, `:q!` force quit) |

**The Vim "grammar":** verb + motion. `d` (delete) + `w` (word) = `dw`.
`c` (change) + `i"` (inside quotes) = `ci"`. This composability is where the
speed comes from. Run `:Tutor` inside nvim for a hands-on 30-minute lesson.

---

## 7. Key shortcuts in this config

The **leader key is `Space`**. Press `Space` and **wait** — `which-key` pops up a
menu of everything you can do. This is how you discover features without memorizing.

| Keys              | Action                            |
| ----------------- | --------------------------------- |
| `Space` `Space`   | Find file (fuzzy) — most-used     |
| `Space` `/`       | Search text across the project    |
| `Space` `e`       | Toggle file explorer              |
| `Space` `b` `b`   | Switch between open buffers        |
| `` Space` ``      | Jump to last file                 |
| `s`               | Flash — type 2 chars to teleport  |
| `gd`              | Go to definition                  |
| `K`               | Show docs / hover info            |
| `Space` `c` `a`   | Code actions (fixes, refactors)   |
| `Space` `c` `r`   | Rename symbol everywhere          |
| `Space` `g` `g`   | Open Lazygit (git UI)             |
| `Ctrl-/`          | Toggle terminal                   |
| `Space` `l`       | Open Lazy plugin manager          |
| `Space` `q` `q`   | Quit                              |

---

## 8. Useful commands (type in Normal mode)

| Command             | Does                                         |
| ------------------- | -------------------------------------------- |
| `:Lazy`             | Plugin dashboard — install/update/check      |
| `:LazyExtras`       | Browse & enable language/tool packs          |
| `:Mason`            | Manage language servers, formatters, linters |
| `:checkhealth`      | Diagnose problems with your setup            |
| `:source $MYVIMRC`  | Reload config without restarting             |
| `:Tutor`            | Built-in interactive Vim tutorial            |
| `:h <topic>`        | Built-in help (e.g. `:h vim.opt`)            |

---

## 9. Golden rules for a beginner

1. **Never edit `lua/config/lazy.lua`** unless you really know why.
2. **To add settings** → append to `options.lua`. **To add plugins** → new file in `plugins/`.
3. **`lazy-lock.json` pins versions.** Don't hand-edit it. If an update breaks
   things, `:Lazy restore` rolls back to it.
4. **Back up your config with git** — it's just text files. One bad edit can be
   reverted instantly.
5. When something breaks, run `:checkhealth` and read the error's `file:line` —
   it usually points right at the problem.

---

## 10. Common "gotchas"

- **Config changes not applying?** Restart Neovim, or run `:source $MYVIMRC`.
  Some changes (especially plugin specs) need a full restart.
- **`attempt to index a boolean value`** in `init.lua`: usually means a `require(...)`
  returned nothing and you tried to call a method on it. Keep `init.lua` minimal —
  it should just be `require("config.lazy")`.
- **Formatter overrides your tab width:** language extras/formatters (Prettier, gofmt,
  etc.) may reformat with their own conventions. That's expected — configure the
  formatter or use an `autocmd` per filetype if you want different behavior.
- **A plugin file must `return` a table.** If you forget `return`, the plugin
  silently won't load.

---

## 11. tmux + Neovim (supercharge your workflow)

**tmux** is a *terminal multiplexer*: it splits your terminal into panes/windows,
and — crucially — **sessions persist**. Close your terminal or drop an SSH
connection, reconnect, and everything is exactly where you left it (nvim still
open, dev server still running).

- **nvim** handles editing.
- **tmux** handles everything *around* it: running the app, tests, logs, git,
  and multiple projects in adjacent panes — all keyboard-driven, no mouse.

### tmux mental model

Everything starts with a **prefix key** (default `Ctrl-b`), then a command key:

| Keys              | Action                                        |
| ----------------- | --------------------------------------------- |
| `Ctrl-b` `%`      | Split pane vertically                         |
| `Ctrl-b` `"`      | Split pane horizontally                       |
| `Ctrl-b` `arrow`  | Move between panes                             |
| `Ctrl-b` `c`      | New window (like a tab)                        |
| `Ctrl-b` `n` / `p`| Next / previous window                         |
| `Ctrl-b` `d`      | Detach (session keeps running in background)   |
| `Ctrl-b` `z`      | Zoom current pane fullscreen (toggle)          |
| `Ctrl-b` `[`      | Copy mode (scroll; use Vim keys, `q` to quit)  |

Session commands from the shell:

```bash
tmux                    # start a session
tmux new -s work        # start a named session
tmux ls                 # list sessions
tmux attach -t work     # reattach to a session
```

### The killer feature: seamless navigation

The biggest productivity win is moving between nvim splits and tmux panes with the
**same keys** — `Ctrl-h/j/k/l` — so panes and windows feel like one grid. This
needs two plugins that work together:

1. `christoomey/vim-tmux-navigator` on the **nvim** side (a file in `lua/plugins/`).
2. `vim-tmux-navigator` on the **tmux** side (in `~/.tmux.conf`).

Without it you keep switching mental modes (`Ctrl-b arrow` for tmux vs `Ctrl-w`
for nvim). With it, navigation is one fluid motion.

### Recommended `~/.tmux.conf` starting points

- Mouse support (scroll, click to select/resize panes).
- vi-style copy mode (scroll + select + yank with Vim keys).
- True-color / 256-color so your nvim theme renders correctly.
- Faster escape-time so `Esc` in nvim isn't laggy.
- Optional: `tpm` (tmux plugin manager) to auto-save/restore sessions.

### Why pair them

Editing lives in nvim; the in-nvim terminal (`Ctrl-/`) is great for quick,
one-off commands. tmux is for the durable stuff around editing: long-running
servers, watching logs, juggling several projects, and keeping it all alive
across disconnects.

---

## 12. Learning path

1. **Today:** Run `:Tutor`. Learn modes, `hjkl`, `i`/`Esc`, `:w`, `:q`.
2. **This week:** Use `Space`+`Space` (find file) and `Space`+`/` (search) instead
   of a mouse. Press `Space` whenever unsure — let `which-key` teach you.
3. **Next:** Practice `verb + motion` (`dw`, `ci"`, `dap`) — the heart of Vim speed.
4. **Later:** Enable your languages via `:LazyExtras`, and add personal keymaps to
   `lua/config/keymaps.lua`.

Happy hacking.
