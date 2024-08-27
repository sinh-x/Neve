{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "aw-watcher.nvim";
      version = "2022-09-18";
      src = pkgs.fetchFromGitHub {
        owner = "ActivityWatch";
        repo = "aw-watcher-vim";
        rev = "4ba86d05a940574000c33f280fd7f6eccc284331";
        sha256 = "sha256-I7YYvQupeQxWr2HEpvba5n91+jYvJrcWZhQg+5rI908=";
      };
    })
  ];

  keymaps = [ ];
}
