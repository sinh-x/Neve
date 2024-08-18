{ pkgs, ... }:
{

  extraPlugins = with pkgs.vimPlugins; [ smartcolumn-nvim ];

  extraConfigLuaPre = # lua
    ''
      require("smartcolumn").setup({
        colorcolumn = "120",

        disabled_filetypes = {
          "ministarter",
          "help",
          "text",
          "markdown",
          "neo-tree",
          "checkhealth",
          "lspinfo",
          "noice",
        },

        custom_colorcolumn = {
          go = { "100" },
          nix = { "120" },
          rust = { "100" },
        },

        scope = "file",
      })
    '';
}
