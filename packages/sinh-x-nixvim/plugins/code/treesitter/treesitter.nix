_: {

  plugins = {
    treesitter = {
      enable = true;

      folding.enable = true;
      nixvimInjections = true;

      settings = {
        ensure_installed = "all";

        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
          disable = # lua
            ''
              function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 10000
              end
            '';
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = "grc";
            node_decremental = "<bs>";
          };
        };

        indent = {
          enable = true;
        };

      };

      # NOTE: Default is to install all grammars, here's a more concise list of ones i care about
      # grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      #   angular
      #   bash
      #   bicep
      #   c
      #   c-sharp
      #   cmake
      #   cpp
      #   css
      #   csv
      #   diff
      #   dockerfile
      #   dot
      #   fish
      #   git_config
      #   git_rebase
      #   gitattributes
      #   gitcommit
      #   gitignore
      #   go
      #   html
      #   hyprlang
      #   java
      #   javascript
      #   json
      #   json5
      #   jsonc
      #   kdl
      #   latex
      #   lua
      #   make
      #   markdown
      #   markdown_inline
      #   mermaid
      #   meson
      #   ninja
      #   nix
      #   norg
      #   objc
      #   python
      #   rasi
      #   readline
      #   regex
      #   rust
      #   scss
      #   sql
      #   ssh-config
      #   svelte
      #   swift
      #   terraform
      #   toml
      #   tsx
      #   typescript
      #   vim
      #   vimdoc
      #   xml
      #   yaml
      #   zig
      # ];
    };

    # treesitter-refactor = {
    #   enable = false;
    #   # DEPRECATED: nvim-treesitter-refactor is archived and incompatible with nvim-treesitter main branch
    #   # Repository: https://github.com/nvim-treesitter/nvim-treesitter-refactor (archived Nov 28, 2025)
    #   #
    #   # RECOMMENDED ALTERNATIVE: nvim-treesitter-locals
    #   # See: https://github.com/nvim-treesitter/nvim-treesitter-locals
    #   # Provides LSP-like functionality based on treesitter locals
    #   #
    #   # For refactoring functionality, consider:
    #   # - Built-in LSP: vim.lsp.buf.definition(), vim.lsp.buf.rename(), etc.
    #   # - Plugin: refactoring.nvim (already enabled in ../refactoring.nix)
    #   settings = {
    #     highlight_definitions = {
    #       enable = true;
    #       clear_on_cursor_move = true;
    #     };
    #     smart_rename = {
    #       enable = true;
    #     };
    #     navigation = {
    #       enable = true;
    #     };
    #   };
    # };
  };
}
