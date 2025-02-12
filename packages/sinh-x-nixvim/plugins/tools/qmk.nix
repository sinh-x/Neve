{
  plugins.qmk = {
    enable = true;
    settings = {
      name = "LAYOUT_sinh_x_58";
      variant = "qmk";
      layout = [
        "_ x x x x x x _ _ _ x x x x x x"
        "_ x x x x x x _ _ _ x x x x x x"
        "_ x x x x x x _ _ _ x x x x x x"
        "_ x x x x x x x _ x x x x x x x"
        "_ _ _ x x x x x _ x x x x x _ _"
      ];
    };
  };
}
# _: {
# extraPlugins = with pkgs.vimUtils; [
#   (buildVimPlugin {
#     pname = "qmk.nvim";
#     version = "2024-09-14";
#     src = pkgs.fetchFromGitHub {
#       owner = "codethread";
#       repo = "qmk.nvim";
#       rev = "ad51cb15e607da0983fcf9882d38a2aafac32149";
#       sha256 = "sha256-uNLfrk53JStVZdT42brqR1I4swU/rG6gZQbsDk+vaJE=";
#     };
#   })
# ];
# extraConfigLua = ''
#   local qmk = require("qmk")
#   qmk.setup({
#     name = "LAYOUT_sinh_x_58",
#     variant = "qmk",
#     layout = {
#       "_ x x x x x x _ _ _ x x x x x x",
#       "_ x x x x x x _ _ _ x x x x x x",
#       "_ x x x x x x _ _ _ x x x x x x",
#       "_ x x x x x x x _ x x x x x x x",
#       "_ _ _ x x x x x _ x x x x x _ _",
#     },
#   })
# '';
#
# keymaps = [ ];
# }
