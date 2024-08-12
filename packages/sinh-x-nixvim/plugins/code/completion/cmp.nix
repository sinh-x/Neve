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
  plugins = {
    cmp-nvim-lsp = {
      enable = true;
    }; # lsp
    cmp-buffer = {
      enable = true;
    };
    copilot-cmp = {
      enable = true;
    }; # copilot suggestions
    cmp-fish = {
      enable = true;
    };
    cmp-git = {
      enable = true;
    }; # git
    cmp-path = {
      enable = true;
    }; # file system paths
    cmp_luasnip = {
      enable = true;
    }; # snippets
    cmp-cmdline = {
      enable = false;
    }; # autocomplete for cmdline
    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {
        experimental = {
          ghost_text = true;
        };
      };
      settings = {
        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
            ['<C-j>'] = cmp.mapping.select_next_item(),
            ['<C-k>'] = cmp.mapping.select_prev_item(),
            ['<C-e>'] = cmp.mapping.abort(),

            ['<C-b>'] = cmp.mapping.scroll_docs(-4),

             ['<C-f>'] = cmp.mapping.scroll_docs(4),

             ['<C-Space>'] = cmp.mapping.complete(),

             ['<CR>'] = cmp.mapping.confirm({ select = true }),

             ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            })
          '';
        };
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
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
            name = "codeium";
            priority = 300;
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
            name = "neorg";
            priority = 250;
          }
          {
            name = "npm";
            priority = 250;
          }
          {
            name = "tmux";
            priority = 250;
          }
          {
            name = "zsh";
            priority = 250;
          }
          {
            name = "calc";
            priority = 150;
          }
          {
            name = "emoji";
            priority = 100;
          }
        ];

        performance = {
          debounce = 60;
          fetching_timeout = 200;
          max_view_entries = 30;
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = {
            border = "rounded";
          };
        };
        formatting = {
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
          expandable_indicator = true;
        };
      };
    };
  };
  extraConfigLua = ''
        luasnip = require("luasnip")
        kind_icons = {
          Text = "󰊄",
          Method = "",
          Function = "󰡱",
          Constructor = "",
          Field = "",
          Variable = "󱀍",
          Class = "",
          Interface = "",
          Module = "󰕳",
          Property = "",
          Unit = "",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
      }

      local cmp = require'cmp'

        cmp.setup({
          sources = cmp.config.sources({
            { name = 'path' },
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
          }, {
            { name = 'copilot' },
          }),
        })

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({'/', "?" }, {
          sources = {
            { name = 'buffer' }
          }
        })

      -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
            { name = 'buffer' },
            })
          })

      -- Setup cmp for R
      cmp.setup.filetype('r', {
        sources = cmp.config.sources({
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
          { name = 'cmp_r' },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
        }, {
          { name = 'copilot' },
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
        })
      })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
          }, {
          { name = 'cmdline' }
          }),
        })
  '';
}
