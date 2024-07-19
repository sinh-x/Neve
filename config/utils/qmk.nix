{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "qmk.nvim";
      version = "2024-04-18";
      src = pkgs.fetchFromGitHub {
        owner = "codethread";
        repo = "qmk.nvim";
        rev = "cfa6cecae362d23778cd97317d33ab12671e157c";
        sha256 = "sha256-cNHB3h9+ip3FGFG9oJppr6ahFQh3DaeD39lnH4uIhFw=";
      };
    })
  ];
  extraConfigLua = ''
    local qmk = require("qmk")
    qmk.setup({
      name = "LAYOUT_sinh_x_58",
      variant = "qmk",
      layout = {
        "_ x x x x x x _ _ _ x x x x x x",
        "_ x x x x x x _ _ _ x x x x x x",
        "_ x x x x x x _ _ _ x x x x x x",
        "_ x x x x x x x _ x x x x x x x",
        "_ _ _ x x x x x _ x x x x x _ _",
      },
    })
  '';

  keymaps = [
  ];
}
