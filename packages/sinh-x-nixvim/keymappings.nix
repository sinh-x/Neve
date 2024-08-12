{ helpers, lib, ... }:
{
  extraConfigLuaPre =
    # lua
    ''
      function bool2str(bool) return bool and "on" or "off" end
    '';

  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };

  keymaps =
    let
      normal =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "n";
              inherit action key;
              options = attrs.options or { };
            }
          )
          {
            "<Space>" = {
              action = "<NOP>";
            };

            # Esc to clear search results
            "<esc>" = {
              action = ":noh<CR>";
            };

            # fix Y behaviour
            "Y" = {
              action = "y$";
            };

            # back and fourth between the two most recent files
            "<C-c>" = {
              action = ":b#<CR>";
            };

            "<C-s>" = {
              action = "<cmd>w<cr>";
              options = {
                silent = true;
                desc = "Save file";
              };
            };

            # navigate to left/right window
            "<C-Left>" = {
              action = "<C-w>h";
              options = {
                desc = "Left window";
              };
            };
            "<C-Right>" = {
              action = "<C-w>l";
              options = {
                desc = "Right window";
              };
            };
            "<C-Up>" = {
              action = "<C-w>k";
              options = {
                desc = "Right window";
              };
            };
            "<C-Down>" = {
              action = "<C-w><C-j>";
              options = {
                desc = "Right window";
              };
            };

            # navigate quickfix list
            "<C-k>" = {
              action = ":cnext<CR>";
            };
            "<C-j>" = {
              action = ":cprev<CR>";
            };

            # resize with arrows
            "<M-Up>" = {
              action = ":resize -2<CR>";
            };
            "<M-Down>" = {
              action = ":resize +2<CR>";
            };
            "<M-Left>" = {
              action = ":vertical resize +2<CR>";
            };
            "<M-Right>" = {
              action = ":vertical resize -2<CR>";
            };

            # move current line up/down
            # M = Alt key
            "<M-k>" = {
              action = ":move-2<CR>";
            };
            "<M-j>" = {
              action = ":move+<CR>";
            };

            "dj" = {
              action = "v:count == 0 ? 'gj' : 'j'";
              options = {
                desc = "Move cursor down";
                expr = true;
              };
            };
            "k" = {
              action = "v:count == 0 ? 'gk' : 'k'";
              options = {
                desc = "Move cursor up";
                expr = true;
              };
            };
            "<Leader>qq" = {
              action = "<Cmd>confirm qa<CR>";
              options = {
                desc = "Quit";
              };
            };
            "<Leader>n" = {
              action = "<Cmd>enew<CR>";
              options = {
                desc = "New file";
              };
            };
            "<leader>W" = {
              action = "<Cmd>w!<CR>";
              options = {
                desc = "Force write";
              };
            };
            "<leader>qQ" = {
              action = "<Cmd>q!<CR>";
              options = {
                desc = "Force quit";
              };
            };
            "<leader>|" = {
              action = "<Cmd>vsplit<CR>";
              options = {
                desc = "Vertical split";
              };
            };
            "<leader>-" = {
              action = "<Cmd>split<CR>";
              options = {
                desc = "Horizontal split";
              };
            };

            "<leader>bC" = {
              action = ":%bd!<CR>";
              options = {
                desc = "Close all buffers";
                silent = true;
              };
            };
            "<leader>b]" = {
              action = ":bnext<CR>";
              options = {
                desc = "Next buffer";
                silent = true;
              };
            };
            "<TAB>" = {
              action = ":bnext<CR>";
              options = {
                desc = "Next buffer (default)";
                silent = true;
              };
            };
            "<leader>b[" = {
              action = ":bprevious<CR>";
              options = {
                desc = "Previous buffer";
                silent = true;
              };
            };
            "<S-TAB>" = {
              action = ":bprevious<CR>";
              options = {
                desc = "Previous buffer";
                silent = true;
              };
            };

            "<leader>ud" = {
              action.__raw =
                # lua
                ''
                  function ()
                    vim.b.disable_diagnostics = not vim.b.disable_diagnostics
                    if vim.b.disable_diagnostics then
                      vim.diagnostic.disable(0)
                    else
                      vim.diagnostic.enable(0)
                    end
                    vim.notify(string.format("Buffer Diagnostics %s", bool2str(not vim.b.disable_diagnostics), "info"))
                  end'';
              options = {
                desc = "Buffer Diagnostics toggle";
              };
            };

            "<leader>uD" = {
              action.__raw =
                # lua
                ''
                  function ()
                    vim.g.disable_diagnostics = not vim.g.disable_diagnostics
                    if vim.g.disable_diagnostics then
                      vim.diagnostic.disable()
                    else
                      vim.diagnostic.enable()
                    end
                    vim.notify(string.format("Global Diagnostics %s", bool2str(not vim.g.disable_diagnostics), "info"))
                  end'';
              options = {
                desc = "Global Diagnostics toggle";
              };
            };

            "<leader>uf" = {
              action.__raw =
                # lua
                ''
                  function ()
                    -- vim.g.disable_autoformat = not vim.g.disable_autoformat
                    vim.cmd('FormatToggle!')
                    vim.notify(string.format("Buffer Autoformatting %s", bool2str(not vim.b[0].disable_autoformat), "info"))
                  end'';
              options = {
                desc = "Buffer Autoformatting toggle";
              };
            };

            "<leader>uF" = {
              action.__raw =
                # lua
                ''
                  function ()
                    -- vim.g.disable_autoformat = not vim.g.disable_autoformat
                    vim.cmd('FormatToggle')
                    vim.notify(string.format("Global Autoformatting %s", bool2str(not vim.g.disable_autoformat), "info"))
                  end'';
              options = {
                desc = "Global Autoformatting toggle";
              };
            };

            "<leader>uS" = {
              action.__raw =
                # lua
                ''
                  function ()
                    if vim.g.spell_enabled then vim.cmd('setlocal nospell') end
                    if not vim.g.spell_enabled then vim.cmd('setlocal spell') end
                    vim.g.spell_enabled = not vim.g.spell_enabled
                    vim.notify(string.format("Spell %s", bool2str(vim.g.spell_enabled), "info"))
                  end'';
              options = {
                desc = "Spell toggle";
              };
            };

            "<leader>uw" = {
              action.__raw =
                # lua
                ''
                  function ()
                    vim.wo.wrap = not vim.wo.wrap
                    vim.notify(string.format("Wrap %s", bool2str(vim.wo.wrap), "info"))
                  end'';
              options = {
                desc = "Word Wrap toggle";
              };
            };

            "<leader>uh" = {
              action.__raw =
                # lua
                ''
                  function ()
                    local curr_foldcolumn = vim.wo.foldcolumn
                    if curr_foldcolumn ~= "0" then vim.g.last_active_foldcolumn = curr_foldcolumn end
                    vim.wo.foldcolumn = curr_foldcolumn == "0" and (vim.g.last_active_foldcolumn or "1") or "0"
                    vim.notify(string.format("Fold Column %s", bool2str(vim.wo.foldcolumn), "info"))
                  end'';
              options = {
                desc = "Fold Column toggle";
              };
            };

            "<leader>uc" = {
              action.__raw =
                # lua
                ''
                  function ()
                    vim.g.cmp_enabled = not vim.g.cmp_enabled
                    vim.notify(string.format("Completions %s", bool2str(vim.g.cmp_enabled), "info"))
                  end'';
              options = {
                desc = "Completions toggle";
              };
            };

            "<leader>aa" = {
              action = "<cmd>CopilotChatToggle<cr>";
              options = {
                desc = "CopilotChat Toggle";
              };
            };

            "<leader>aV" = {
              action = "ggvG$<cmd>CopilotChat<cr>";
              options = {
                desc = "CopilotChat Whole File";
              };
            };
          };
      visual =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "v";
              inherit action key;
              options = attrs.options or { };
            }
          )
          {
            "<leader>aa" = {
              action = "<cmd>CopilotChatToggle<cr>";
              options = {
                desc = "CopilotChat Toggle";
              };
            };
            # Better indenting
            "<S-Tab>" = {
              action = "<gv";
              options = {
                desc = "Unindent line";
              };
            };
            "<" = {
              action = "<gv";
              options = {
                desc = "Unindent line";
              };
            };
            "<Tab>" = {
              action = ">gv";
              options = {
                desc = "Indent line";
              };
            };
            ">" = {
              action = ">gv";
              options = {
                desc = "Indent line";
              };
            };

            # Move selected line/block in visual mode
            "K" = {
              action = ":m '<-2<CR>gv=gv";
            };
            "J" = {
              action = ":m '>+1<CR>gv=gv";
            };

            # Backspace delete in visual
            "<BS>" = {
              action = "x";
            };
          };
      insert =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "i";
              inherit action key;
              options = attrs.options or { };
            }
          )
          {
            "<C-s>" = {
              action = "<cmd>w<cr><esc>";
              options = {
                silent = true;
                desc = "Save file";
              };
            };
            # Move selected line/block in insert mode
            "<C-k>" = {
              action = "<C-o>gk";
            };
            "<C-h>" = {
              action = "<Left>";
            };
            "<C-l>" = {
              action = "<Right>";
            };
            "<C-j>" = {
              action = "<C-o>gj";
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual ++ insert);
}
