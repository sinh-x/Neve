{ helpers, lib, ... }:
{
  extraConfigLuaPre =
    # lua
    ''
      function bool2str(bool) return bool and "on" or "off" end

      function PrevOrLastQuickfix()
        local qf_idx = vim.fn.getqflist({idx = 0}).idx
        if qf_idx == 1 then
          vim.cmd('clast')
        else
          vim.cmd('cprev')
        end
      end
      function NextOrFirstQuickfix()
        local qf_list = vim.fn.getqflist()
        local qf_idx = vim.fn.getqflist({idx = 0}).idx
        if qf_idx == #qf_list then
          vim.cmd('cfirst')
        else
          vim.cmd('cnext')
        end
      end
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

            "<leader>ss" = {
              action = ":lua require('persistence').load()<cr>";
              options = {
                silent = true;
                desc = "Restore session";
              };
            };

            "<leader>sl" = {
              action = ":lua require('persistence').load({ last = true })<cr>";
              options = {
                silent = true;
                desc = "Restore last session";
              };
            };
            # Esc to clear search results
            "<esc>" = {
              action = ":noh<CR>";
            };

            # fix Y behaviour
            "Y" = {
              action = "y$";
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
            "dk" = {
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
            "<C-,>" = {
              action = ":b#<CR>";
              options = {
                desc = "Cycle last 2 active buffer";
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
            "<Tab>" = {
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
            "<S-Tab>" = {
              action = ":bprevious<CR>";
              options = {
                desc = "Previous buffer";
                silent = true;
              };
            };

            "<leader>tt" = {
              action = "<cmd>tabnew<cr>";
              obtions = {
                silent = true;
                desc = "New tab";
              };
            };
            "<leader>tx" = {
              action = "<cmd>tabclose<cr>";
              obtions = {
                silent = true;
                desc = "Close tab";
              };
            };
            "<leader>t[" = {
              action = "<cmd>tabprevious<cr>";
              obtions = {
                silent = true;
                desc = "Close tab";
              };
            };
            "<leader>t]" = {
              action = "<cmd>tabnext<cr>";
              obtions = {
                silent = true;
                desc = "Close tab";
              };
            };
            "<leader>t1" = {
              action = "<cmd>tabn 1<cr>";
              obtions = {
                silent = true;
                desc = "Tab 1";
              };
            };
            "<leader>t2" = {
              action = "<cmd>tabn 2<cr>";
              obtions = {
                silent = true;
                desc = "Tab 2";
              };
            };
            "<leader>t3" = {
              action = "<cmd>tabn 3<cr>";
              obtions = {
                silent = true;
                desc = "Tab 3";
              };
            };
            "<leader>t4" = {
              action = "<cmd>tabn 4<cr>";
              obtions = {
                silent = true;
                desc = "Tab 4";
              };
            };
            "<leader>t5" = {
              action = "<cmd>tabn 5<cr>";
              obtions = {
                silent = true;
                desc = "Tab 5";
              };
            };

            "<C-c>" = {
              action.__raw = # lua
                ''
                  function ()
                    local qf_exists = false
                    for _, win in pairs(vim.fn.getwininfo() or {}) do
                      if win['quickfix'] == 1 then
                        qf_exists = true
                      end
                    end
                    if qf_exists == true then
                      vim.cmd.cclose()
                      return
                    end
                    if not vim.tbl_isempty(vim.fn.getqflist()) then
                      vim.cmd.copen()
                    end
                  end
                '';
              options = {
                desc = "Toggle quickfix list";
              };
            };

            "[C" = {
              action = ":cfirst<CR>";
              options = {
                desc = "First quick fix item";
              };
            };
            "[c" = {
              action = ":lua PrevOrLastQuickfix()<CR>";
              options = {
                desc = "Prev quick fix item";
              };
            };
            "]c" = {
              action = ":lua NextOrFirstQuickfix()<CR>";
              options = {
                desc = "Next quick fix item";
              };
            };
            "]C" = {
              action = ":clast<CR>";
              options = {
                desc = "Last quick fix item";
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

            # "<leader>aa" = {
            #   action = "<cmd>CopilotChatToggle<cr>";
            #   options = {
            #     desc = "CopilotChat Toggle";
            #   };
            # };

            # "<leader>aV" = {
            #   action = "ggvG$<cmd>CopilotChat<cr>";
            #   options = {
            #     desc = "CopilotChat Whole File";
            #   };
            # };
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
    helpers.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual ++ insert)
    ++ [
      # Paste stuff without saving the deleted word into the buffer
      {
        mode = "x";
        key = "<leader>p";
        action = "\"_dP";
        options = {
          desc = "Deletes to void register and paste over";
        };
      }

      # Copy stuff to system clipboard with <leader> + y or just y to have it just in vim
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>y";
        action = "\"+y";
        options = {
          desc = "Copy to system clipboard";
        };
      }

      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>Y";
        action = "\"+Y";
        options = {
          desc = "Copy to system clipboard";
        };
      }

      # Delete to void register
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>D";
        action = "\"_d";
        options = {
          desc = "Delete to void register";
        };
      }
    ];
}
