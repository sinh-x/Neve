{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "outline.nvim";
      version = "2024-07-05";
      src = pkgs.fetchFromGitHub {
        owner = "hedyhli";
        repo = "outline.nvim";
        rev = "2175b6da5b7b5be9de14fd3f54383a17f5e4609c";
        sha256 = "sha256-U8FmA7dJIV9T6Uose7Q9xATfB73H6PPQAGLw3FEsk9Y=";
      };
    })
  ];
  extraConfigLua = ''
    local outline = require('outline')
    outline.setup({})
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>co";
      action = "<cmd>Outline<cr>";
      options = {
        silent = true;
        desc = "Outline";
      };
    }
  ];
}
