{
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
let
  inherit (inputs) nixvim;
in
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;

  module = {
    imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;

    luaLoader.enable = true;

    # Highlight and remove extra white spaces
    highlight.ExtraWhitespace.bg = "red";
    match.ExtraWhitespace = "\\s\\+$";

    colorschemes.tokyonight = {
      enable = true;
      settings = {
        day_brightness = 0.3;
        dim_inactive = false;
        hide_inactive_statusline = false;
        light_style = "day";
        lualine_bold = false;
        on_colors = "function(colors) end";
        on_highlights = "function(highlights, colors) end";
        sidebars = [
          "qf"
          "vista_kind"
          "terminal"
          "packer"
        ];
        style = "storm";
        styles = {
          comments = {
            italic = true;
          };
          floats = "dark";
          functions = { };
          keywords = {
            italic = true;
          };
          sidebars = "dark";
          variables = { };
        };
        terminal_colors = true;
        transparent = true;
      };
    };
  };
}
