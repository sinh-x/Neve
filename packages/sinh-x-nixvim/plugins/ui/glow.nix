{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  extraPlugins = with pkgs.vimPlugins; [ glow-nvim ];

  extraConfigLuaPre = # lua
    ''
      require('glow').setup({
        border = "single";
        glow_path = "${getExe pkgs.glow}";
        style = "tokyo-night";
      });
    '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>pg";
      action = ":Glow<CR>";
      options = {
        desc = "Glow (Markdown)";
        silent = true;
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>p";
      mode = "n";
      group = " Preview";
    }
  ];
}
