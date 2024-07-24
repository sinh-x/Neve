{
  plugins.neo-tree = {
    enable = true;
    enableDiagnostics = true;
    enableGitStatus = true;
    enableModifiedMarkers = true;
    enableRefreshOnWrite = true;
    closeIfLastWindow = true;
    popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
    buffers = {
      bindToCwd = true;
      followCurrentFile = {
        enabled = true;
      };
    };
  };

  extraConfigLua = ''
    require("neo-tree").setup({
      event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.opt_local.relativenumber = true
        end,
      },
      },
      window = {
        position = 'left',
        mappings = {
          ['A'] = {
            'add_directory',
            config = {
              show_path = 'relative', -- "none", "relative", "absolute"
            },
          },
          ['a'] = {
            'add',
            config = {
              show_path = 'relative', -- "none", "relative", "absolute"
            },
          },
          ['m'] = {
            'move',
            config = {
              show_path = 'relative', -- "none", "relative", "absolute"
            },
          },
        },
      },
      })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree toggle reveal_force_cwd<cr>";
      options = {
        silent = true;
        desc = "Explorer NeoTree (root dir)";
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Neotree toggle<CR>";
      options = {
        silent = true;
        desc = "Explorer NeoTree (cwd)";
      };
    }
    {
      mode = "n";
      key = "<leader>be";
      action = ":Neotree buffers<CR>";
      options = {
        silent = true;
        desc = "Buffer explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>ge";
      action = ":Neotree git_status<CR>";
      options = {
        silent = true;
        desc = "Git explorer";
      };
    }
  ];
}
