{
  plugins.headlines = {
    enable = true;
  };
}
# This plugin have some issues with obsidian which render checkboxes incorrectly
# {pkgs, ...}: {
#   extraPlugins = with pkgs.vimUtils; [
#     (buildVimPlugin {
#       pname = "markdown.nvim";
#       version = "v4.1.0";
#       src = pkgs.fetchFromGitHub {
#         owner = "MeanderingProgrammer";
#         repo = "markdown.nvim";
#         rev = "3578523f497a8ad3b4a356d1e54e609838ce0922";
#         sha256 = "sha256-DohaHVIEPCO+xO4VfsHBpocWzDCM9C5NN2sU/lUajK0=";
#       };
#     })
#   ];
#   extraConfigLua = ''
#     local md = require('render-markdown')
#     md.setup({})
#   '';
#
#   keymaps = [
#   ];
# }

