{
  pkgs,
  ...
}:
{
  extraPlugins = [
    pkgs.vimPlugins.opencode-nvim
  ];

  keymaps = [
    {
      mode = "n";
      key = "<C-a>";
      action.__raw = "function() require('opencode').ask() end";
      options = {
        desc = "OpenCode Ask";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<C-a>";
      action.__raw = "function() require('opencode').ask() end";
      options = {
        desc = "OpenCode Ask (visual)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ao";
      action.__raw = "function() require('opencode').select() end";
      options = {
        desc = "OpenCode Select";
        silent = true;
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>a";
      group = "AI";
    }
  ];
}
