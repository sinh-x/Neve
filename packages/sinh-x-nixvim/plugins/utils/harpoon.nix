{ lib, config, ... }:
{
  plugins = {
    harpoon = {
      enable = true;
      enableTelescope = true;
      keymapsSilent = true;
      menu = {
        width = 120;
      };
      keymaps = {
        addFile = "<leader>ha";
        toggleQuickMenu = "<leader>he";
        navFile = {
          "1" = "<leader>h1";
          "2" = "<leader>h2";
          "3" = "<leader>h3";
          "4" = "<leader>h4";
          "5" = "<leader>h5";
        };
      };
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
}
