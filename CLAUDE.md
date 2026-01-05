# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake-based Neovim configuration using nixvim and Snowfall Lib. The configuration is structured as a modular, declarative Neovim setup with 79+ plugins organized by category.

## Build and Development Commands

### Building the Neovim Package
```bash
# Build the default package
nix build

# Build and run Neovim
nix run

# Build the nvim alias
nix build .#nvim

# Enter development shell (includes pre-commit hooks)
nix develop
```

### Code Quality
```bash
# Format all Nix files
nix fmt

# Run pre-commit hooks manually
nix flake check

# The pre-commit hooks include:
# - deadnix: Remove unused Nix code (auto-fix with --edit)
# - nixfmt-rfc-style: Format Nix files
# - statix: Lint Nix code
# - luacheck: Check Lua syntax
# - pre-commit-hook-ensure-sops: Ensure no secrets
```

### Updating Dependencies
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixvim
```

## Architecture

### Directory Structure

```
sinh-x-Neve/
├── flake.nix                    # Main flake configuration
├── packages/sinh-x-nixvim/      # Main Neovim package
│   ├── default.nix              # Entry point (calls makeNixvimWithModule)
│   ├── options.nix              # Vim editor options (~70 settings)
│   ├── keymappings.nix          # Global keybindings
│   ├── autocommands.nix         # Event-triggered commands
│   ├── ft.nix                   # Filetype detection rules
│   └── plugins/                 # Plugin configurations (79 files)
│       ├── ui/                  # UI components (lualine, bufferline, noice, etc.)
│       ├── code/                # Code editing (treesitter, completion/, aerial, etc.)
│       ├── lsp/                 # Language servers and formatting
│       ├── git/                 # Git integration (gitsigns, neogit, diffview)
│       ├── utils/               # Navigation and utilities (telescope, harpoon)
│       ├── snippets/            # Snippet engines
│       ├── filetrees/           # File explorers
│       └── tools/               # Specialized tools
├── config/                      # Additional configuration
│   └── keymaps.nix              # Extra keymaps
├── lib/                         # Custom library utilities
│   ├── module/default.nix       # Helper functions (mkOpt, mkBoolOpt, enabled, etc.)
│   ├── file/default.nix         # File manipulation utilities
│   └── theme/default.nix        # Theme compilation (SCSS)
├── shells/default/              # Development shell
└── checks/pre-commit-hooks/     # Quality checks
```

### Module System

The configuration uses Snowfall Lib's automatic file discovery:
- All `.nix` files in `packages/sinh-x-nixvim/` are automatically imported
- Each file returns a NixOS module (attribute set)
- Modules are merged using NixOS module system (`mkIf`, `mkDefault`, etc.)
- Files named `default.nix` are entry points, not auto-imported as modules

### Entry Point (packages/sinh-x-nixvim/default.nix)

```nix
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;
    # ... global config (colorscheme, highlights)
  };
}
```

This recursively imports all non-default.nix files as modules.

## Adding or Modifying Configuration

### Adding a New Plugin

1. Create a new file in the appropriate category:
   ```bash
   # Example: adding a new UI plugin
   touch packages/sinh-x-nixvim/plugins/ui/my-plugin.nix
   ```

2. Write the module (automatically imported):
   ```nix
   { lib, config, ... }:
   {
     plugins.my-plugin = {
       enable = true;
       settings = {
         # plugin configuration
       };
     };

     # Optional: Add keymaps that activate only if plugin is enabled
     keymaps = lib.mkIf config.plugins.my-plugin.enable [
       {
         mode = "n";
         key = "<leader>mp";
         action = "<cmd>MyPluginCommand<CR>";
         options.desc = "My plugin action";
       }
     ];

     # Optional: Register with which-key
     plugins.which-key.settings.spec = lib.optionals config.plugins.my-plugin.enable [
       {
         __unkeyed = "<leader>m";
         group = "My Plugin";
       }
     ];
   }
   ```

### Adding/Modifying LSP Servers

Edit `packages/sinh-x-nixvim/plugins/lsp/lsp.nix`:

```nix
servers.new_language_server = {
  enable = true;
  filetypes = ["newlang"];
  settings = {
    # LSP-specific settings
  };
};
```

Currently configured LSP servers: ccls, clangd, cmake, lua-ls, bashls, pyright, nil_ls, marksman, html, cssls, tailwindcss, typescript, svelte, eslint, gdscript, dockerls, java, jsonls, yamlls, taplo, r-languageserver, and more.

### Adding Global Keymaps

Edit `packages/sinh-x-nixvim/keymappings.nix` or `config/keymaps.nix`:

```nix
# In the opts.keymaps list:
{
  mode = "n";  # normal, visual, insert, etc.
  key = "<leader>x";
  action = "<cmd>Command<CR>";
  options = {
    silent = true;
    desc = "Description for which-key";
  };
}
```

**Key organization:**
- Leader key: `<Space>`
- Local leader: `\`
- Prefixes: `<leader>b` (buffers), `<leader>f` (find), `<leader>l` (LSP), `<leader>g` (git), `<leader>u` (UI toggles), `<leader>h` (harpoon), etc.

### Modifying Vim Options

Edit `packages/sinh-x-nixvim/options.nix`:

```nix
opts = {
  # Add or modify editor options
  relativenumber = true;
  tabstop = 2;
  # ... etc
};
```

### Adding Autocommands

Edit `packages/sinh-x-nixvim/autocommands.nix`:

```nix
{
  event = "BufWritePre";  # Event to trigger on
  pattern = "*";           # File pattern
  callback = {
    __raw = ''
      function()
        -- Lua code here
      end
    '';
  };
}
```

### Adding Filetype Detection

Edit `packages/sinh-x-nixvim/ft.nix`:

```nix
extension = {
  "myext" = "mylang";
};
pattern = {
  ".*/path/pattern" = "filetype";
};
```

## Key Plugin Configurations

### Completion (plugins/code/completion/cmp.nix)

Source priority order:
1. LSP (1000) - Language server completions
2. Treesitter (850) - Syntax-aware completions
3. Luasnip (750) - Snippets
4. Buffer/Path (500) - Text and filesystem
5. Special sources (300-100) - spell, git, npm, calc, emoji

Filetype-specific configurations exist for Rust, Python, Markdown, YAML, and R.

### LSP Keymaps (plugins/lsp/lsp.nix)

All LSP keymaps use `<leader>l` prefix:
- `<leader>la` - Code action
- `<leader>ld` - Go to definition
- `<leader>lD` - Find references
- `<leader>lf` - Format buffer
- `<leader>lh` - Hover documentation
- `<leader>ln/p` - Next/previous diagnostic
- `<leader>lt` - Type definition

### Formatting System (plugins/lsp/conform.nix)

Conform is the primary formatter with LSP fallback. Format toggle available via keymaps.

### Git Integration

- **gitsigns**: Signs, blame, hunk operations
- **neogit**: Full git interface
- **diffview**: Side-by-side diffs
- **git-conflict**: Merge conflict resolution UI

## Library Utilities (lib/module/default.nix)

Helper functions available throughout the config:

```nix
mkOpt type default description    # Create option with description
mkBoolOpt description default     # Boolean option helper
enabled / disabled                # Quick {enable = true/false;} objects
capitalize string                 # Capitalize first letter
boolToNum bool                    # Convert bool to 1/0
default-attrs attrs               # Apply mkDefault to all attributes
```

## Common Patterns

### Conditional Plugin Configuration

```nix
# Disable plugin A if plugin B is enabled
plugins.plugin-a.enable = lib.mkIf (!config.plugins.plugin-b.enable) true;
```

### Adding Lua Configuration

```nix
{
  plugins.my-plugin.enable = true;

  extraConfigLua = ''
    -- Custom Lua code runs after plugin setup
  '';

  extraConfigLuaPre = ''
    -- Custom Lua code runs before plugin setup
  '';
}
```

### Conditional Keymaps with which-key

```nix
{
  plugins.my-plugin.enable = true;

  keymaps = lib.mkIf config.plugins.my-plugin.enable [
    # keymaps only active if plugin is enabled
  ];

  plugins.which-key.settings.spec = lib.optionals config.plugins.my-plugin.enable [
    # which-key specs only if plugin is enabled
  ];
}
```

## Testing Changes

After making configuration changes:

```bash
# Rebuild and test
nix build

# Run the new configuration
nix run

# Or install to your system (if using home-manager/NixOS)
# home-manager switch --flake .#your-config
```

## Important Notes

- All plugin files are automatically discovered - no manual imports needed
- Use `lib.mkIf` for conditional configuration to avoid evaluation errors
- Keymaps should use `options.desc` for which-key integration
- The colorscheme is TokyoNight (storm variant with transparency)
- Pre-commit hooks run automatically in the dev shell
- LSP servers are declaratively configured via nixvim, not manually installed
