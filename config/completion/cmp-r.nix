{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "cmp-r";
      version = "2024-07-16";
      src = pkgs.fetchFromGitHub {
        owner = "R-nvim";
        repo = "cmp-r";
        rev = "18b88eeb7e47996623b9aa0a763677ac00a16221";
        sha256 = "sha256-3h+7q/x5xST50b9MdjR+9JULTwgn6kAyyrL5qhCtta0=";
      };
    })
  ];
  extraConfigLua = ''
    require'cmp'.setup {
      sources = {
        { name = 'cmp_r' },
      }
    }
  '';
  keymaps = [
  ];
}
