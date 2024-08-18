_:
let
  get_bufnrs.__raw = # lua
    ''
      function()
        local buf_size_limit = 1024 * 1024 -- 1MB size limit
        local bufs = vim.api.nvim_list_bufs()
        local valid_bufs = {}
        for _, buf in ipairs(bufs) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf)) < buf_size_limit then
            table.insert(valid_bufs, buf)
          end
        end
        return valid_bufs
      end
    '';
in
{

  opts.completeopt = [
    "menu"
    "menuone"
    "noselect"
  ];

  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        mapping = {
          "<C-b>" = # lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = # lua
            "cmp.mapping.scroll_docs(4)";
          "<C-e>" = # lua
            "cmp.mapping.complete()";
          "<Esc>" = # lua
            "cmp.mapping(function(fallback) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true) cmp.mapping.close()(fallback) end)";
          "<Down>" = # lua
            "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<Up>" = # lua
            "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<CR>" = # lua
            "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
        };

        preselect = # lua
          "cmp.PreselectMode.None";

        snippet.expand = # lua
          "function(args) require('luasnip').lsp_expand(args.body) end";

        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_document_symbol";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "treesitter";
            priority = 850;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "path";
            priority = 300;
          }
          {
            name = "cmdline";
            priority = 300;
          }
          {
            name = "spell";
            priority = 300;
          }
          {
            name = "fish";
            priority = 250;
          }
          {
            name = "git";
            priority = 250;
          }
          {
            name = "npm";
            priority = 250;
          }
          {
            name = "calc";
            priority = 150;
          }
          {
            name = "codeium";
            priority = 150;
          }
          {
            name = "copilot";
            priority = 150;
          }
          {
            name = "emoji";
            priority = 100;
          }
        ];

        window = {
          completion.__raw = # lua
            ''cmp.config.window.bordered()'';
          documentation.__raw = # lua
            ''cmp.config.window.bordered()'';
        };
      };
    };

    friendly-snippets.enable = true;
    luasnip.enable = true;

    lspkind = {
      enable = true;

      cmp = {
        enable = true;

        menu = {
          buffer = "";
          calc = "";
          cmdline = "";
          codeium = "󱜙";
          emoji = "󰞅";
          git = "";
          luasnip = "󰩫";
          neorg = "";
          nvim_lsp = "";
          nvim_lua = "";
          path = "";
          spell = "";
          treesitter = "󰔱";
        };
      };
    };
  };

  extraConfigLua = ''

    local cmp = require'cmp'

    -- Setup cmp for markdow
    cmp.setup.filetype('markdown', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'treesitter' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'spell' },
      }, {
        { name = 'copilot' },
        { name = 'codeium' },
        { name = 'emoji' },
        { name = 'calc' },
      })
    })
    -- Setup cmp for rust
    cmp.setup.filetype('rust', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'treesitter' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'spell' },
      }, {
        { name = 'copilot' },
        { name = 'codeium' },
        { name = 'emoji' },
        { name = 'calc' },
      })
    })

    -- Setup cmp for nix
    cmp.setup.filetype('nix', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'treesitter' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'spell' },
      }, {
        { name = 'copilot' },
        { name = 'codeium' },
        { name = 'emoji' },
        { name = 'calc' },
      })
    })

    -- Setup cmp for R
    cmp.setup.filetype('r', {
      sources = cmp.config.sources({
        { name = 'cmp_r' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'treesitter' },
        {
          name = 'path',
          priority = 1000,
          option = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function()
              return vim.fn.getcwd()
            end,
          },
        },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'spell' },
      }, {
        { name = 'copilot' },
        { name = 'codeium' },
        { name = 'emoji' },
        { name = 'calc' },
      })
    })

    cmp.setup.filetype('yaml', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp_document_symbol' },
        {
          name = 'path',
          priority = 1000,
          option = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function()
              return vim.fn.getcwd()
            end,
          },
        },
        { name = 'buffer' },
        { name = 'luasnip' },
      }, {
        { name = 'copilot' },
        { name = 'codeium' },
        { name = 'emoji' },
        { name = 'calc' },
        })
    })

    cmp.setup.filetype('NeogitCommitMessage', {
      sources = cmp.config.sources({
        { name = 'git' },
        { name = 'buffer' },
        { name = 'spell' },
        { name = 'copilot' },
        { name = 'codeium' },
      })
    })
  '';
}
