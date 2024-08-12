{ config, lib, ... }:
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
  filesystem = {
    filteredItems = {
      hideDotfiles = false;
      hideHidden = false;

      neverShowByPattern = [
        ".direnv"
        ".git"
      ];

      visible = true;
    };

    followCurrentFile = {
      enabled = true;
      leaveDirsOpen = true;
    };

    useLibuvFileWatcher.__raw =
      # lua
      ''vim.fn.has "win32" ~= 1'';
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
        {
          event = "file_open_requested",
          handler = function()
            -- auto close
            -- vimc.cmd("Neotree close")
            -- OR
            require("neo-tree.command").execute({ action = "close" })
          end
        },
        {
          event = 'file_opened',
          handler = function(file_path)
            require("neo-tree").close_all()
          end,
        },
      },
      window = {
        position = 'float',
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

  keymaps = lib.mkIf config.plugins.neo-tree.enable [
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
