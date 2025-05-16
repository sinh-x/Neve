{ lib, config, ... }:
{
  plugins = {
    harpoon = {
      enable = true;
      enableTelescope = true;
    };

    which-key.settings.spec = lib.optionals config.plugins.harpoon.enable [
      {
        __unkeyed = "<leader>h";
        group = "󱡀 Harpoon";
      }
      {
        __unkeyed = "<leader>ha";
        desc = "Add";
      }
      {
        __unkeyed = "<leader>he";
        desc = "QuickMenu";
      }
      {
        __unkeyed = "<leader>h1";
        desc = "1";
      }
      {
        __unkeyed = "<leader>h2";
        desc = "2";
      }
      {
        __unkeyed = "<leader>h3";
        desc = "3";
      }
      {
        __unkeyed = "<leader>h4";
        desc = "4";
      }
      {
        __unkeyed = "<leader>h5";
        desc = "5";
      }
    ];
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>a";
      action.__raw = "function() require'harpoon':list():add() end";
    }
    {
      mode = "n";
      key = "<C-e>";
      action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
    }
    {
      mode = "n";
      key = "<C-j>";
      action.__raw = "function() require'harpoon':list():select(1) end";
    }
    {
      mode = "n";
      key = "<C-k>";
      action.__raw = "function() require'harpoon':list():select(2) end";
    }
    {
      mode = "n";
      key = "<C-l>";
      action.__raw = "function() require'harpoon':list():select(3) end";
    }
    {
      mode = "n";
      key = "<C-m>";
      action.__raw = "function() require'harpoon':list():select(4) end";
    }
  ];
}
