# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Nix flake-based Neovim configuration using **nixvim** and **Snowfall Lib**. ~77 plugins organized as auto-discovered NixOS modules. Colorscheme: TokyoNight (storm, transparent).

## Build and Development Commands

```bash
nix build              # Build the default package (also: nix build .#nvim)
nix run                # Build and run Neovim
nix fmt                # Format all Nix files (uses nixfmt)
nix flake check        # Run pre-commit hooks
nix develop            # Dev shell (pre-commit hooks, nix-inspect, fish shell)
nix flake update       # Update all flake inputs
nix flake lock --update-input nixvim  # Update specific input
```

**Pre-commit hooks:** deadnix (auto-fix), nixfmt, statix, luacheck, pre-commit-hook-ensure-sops

**Environment:** `.envrc` provides direnv integration (`use flake`). Dev shell auto-switches to zsh.

## Architecture

### Module System (Key Concept)

The entry point `packages/sinh-x-nixvim/default.nix` calls `makeNixvimWithModule` and uses `lib.snowfall.fs.get-non-default-nix-files-recursive` to auto-import every `.nix` file (except `default.nix` files) as a NixOS module. **No manual imports needed** — just create a `.nix` file in the right directory.

Modules are merged via the NixOS module system. Use `lib.mkIf` for conditional config and `lib.optionals` for conditional list items.

### Key Files

| File | Purpose |
|------|---------|
| `packages/sinh-x-nixvim/default.nix` | Entry point, colorscheme config |
| `packages/sinh-x-nixvim/options.nix` | Vim options (~70 settings, Neovide config, clipboard providers) |
| `packages/sinh-x-nixvim/keymappings.nix` | Primary keybindings + toggle functions (line numbers, wrap, inlay hints) |
| `packages/sinh-x-nixvim/autocommands.nix` | Auto-save on focus lost, highlight on yank, save/load views, macro indicators |
| `packages/sinh-x-nixvim/ft.nix` | Custom filetype detection (avsc->json, rasi->scss, hypr->hyprlang) |
| `config/keymaps.nix` | Additional keymaps with toggle functions (diagnostics, autoformat, spell, completions) |
| `packages/sinh-x-nixvim/plugins/lsp/lsp.nix` | LSP server configs |
| `packages/sinh-x-nixvim/plugins/lsp/conform.nix` | Formatter configs (20+ languages) |
| `packages/sinh-x-nixvim/plugins/code/completion/cmp.nix` | Completion sources with priorities |

### Two Keymap Files

There are two separate keymap files that both contribute keybindings:
- **`keymappings.nix`** — Core keybindings (buffer nav, window splits, search, movement) + Lua toggle functions
- **`config/keymaps.nix`** — Extended toggles (diagnostics, autoformat, spell, fold column, completions) using a `lib.mapAttrsToList` pattern with a `bool2str` helper

Both are auto-imported and merged. They have some overlapping bindings (e.g., `<C-s>` for save).

### Plugin Categories

Plugins live in `packages/sinh-x-nixvim/plugins/` organized by:
- **code/** (35 files) — treesitter, completion, aerial, avante, copilot, refactoring, motions (hop, leap, eyeliner)
- **ui/** (13) — bufferline, noice, notify, indent guides, alpha dashboard, mini-starter
- **utils/** (13) — telescope, harpoon, which-key, spectre, persistence, project-nvim
- **git/** (6) — gitsigns, neogit, diffview, git-conflict, mini-diff, git-worktree
- **lsp/** (5) — lsp servers, conform, fidget, rustaceanvim, R.nvim
- **filetrees/** (2) — neo-tree, yazi
- **tools/** (2) — wakatime, qmk
- **snippets/** (1) — luasnip

### Disabled-by-Default Plugins

Several plugins exist as config files but are `enable = false`: lualine, fidget, rustaceanvim, codeium, efm, colorizer, copilot, copilot-chat, treesitter-textobjects. Enable them by changing `enable = true` in their respective files.

### Leader Key Organization

Leader: `<Space>`, Local leader: `\`

| Prefix | Group |
|--------|-------|
| `<leader>b` | Buffers |
| `<leader>f` | Find (telescope) |
| `<leader>l` | LSP |
| `<leader>g` | Git |
| `<leader>gh` | Git hunks |
| `<leader>h` | Harpoon |
| `<leader>r` | Refactor |
| `<leader>t` | Terminal |
| `<leader>u` | UI/UX toggles |
| `<leader>q` | Quit |

## Adding a New Plugin

Create a file in the appropriate category (auto-imported):

```nix
{ lib, config, ... }:
{
  plugins.my-plugin = {
    enable = true;
    settings = { };
  };

  keymaps = lib.mkIf config.plugins.my-plugin.enable [
    {
      mode = "n";
      key = "<leader>mp";
      action = "<cmd>MyPluginCommand<CR>";
      options.desc = "My plugin action";
    }
  ];

  plugins.which-key.settings.spec = lib.optionals config.plugins.my-plugin.enable [
    { __unkeyed = "<leader>m"; group = "My Plugin"; }
  ];
}
```

## Library Utilities

**`lib/module/default.nix`** — `mkOpt`, `mkOpt'`, `mkBoolOpt`, `mkBoolOpt'`, `enabled`/`disabled` shorthand, `capitalize`, `boolToNum`, `default-attrs`, `nested-default-attrs`

**`lib/file/default.nix`** — `fileWithText` (append text after file), `fileWithText'` (prepend text before file)

**`lib/theme/default.nix`** — `compileSCSS` (compiles SCSS to CSS using sassc)

**`lib/default.nix`** — `override-meta` (override package meta attributes)

## CI/CD

GitHub Actions (`.github/workflows/update.yml`) runs on PRs: statix fix, nix fmt, flake checker, then auto-commits. Note: CI installs alejandra alongside statix but `nix fmt` uses nixfmt from the flake — the alejandra install is unused.

## Flake Details

- **Namespace:** `sinh-x`
- **Aliases:** `default` and `nvim` both point to `sinh-x-nixvim`
- **Inputs:** nixpkgs (unstable), nixvim, snowfall-lib, snowfall-flake, pre-commit-hooks-nix
- **allowUnfree:** true
