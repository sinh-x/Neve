_: {
  autoCmd = [
    {
      desc = "Highlight on yank";
      event = [ "TextYankPost" ];
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      };
    }
    {
      desc = "Auto create dir when save file, in case some intermediate directory is missing";
      event = [ "BufWritePre" ];
      callback = {
        __raw = ''
          function(event)
            if event.match:match("^%w%w+://") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
      };
    }
    {
      event = [ "CursorHold" ];
      desc = "lsp show diagnostics on CursorHold";
      callback = {
        __raw = ''
          function()
            local hover_opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              source = "always",
            }
            vim.diagnostic.open_float(nil, hover_opts)
          end
        '';
      };
    }
    {
      desc = "Save session";
      event = [ "BufWinLeave" ];
      pattern = [ "*.*" ];
      command = "mkview";
    }
    {
      desc = "Load session";
      event = [ "BufWinEnter" ];
      pattern = [ "*.*" ];
      command = "silent! loadview";
    }
    {
      desc = "Stop Insert mode on FocusLost";
      event = "FocusLost";
      callback = {
        __raw = ''
          function()
            if vim.api.nvim_get_mode().mode == 'i' then
              vim.cmd [[stopinsert]]
            end
          end
        '';
      };
    }
    {
      desc = "Auto save all when FocusLost";
      event = "FocusLost";
      command = "silent! wa";
    }
    {
      desc = "Macro Enter";
      event = "RecordingEnter";
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.g.macro_recording = "Recording @" .. vim.fn.reg_recording()
            vim.api.nvim_echo({{' ' .. vim.g.macro_recording, 'WarningMsg'}}, false, {})
          end
        '';
      };
    }
  ];
}
