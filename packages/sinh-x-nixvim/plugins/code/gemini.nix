{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "gemini.nvim";
      version = "2025-03-18";
      src = pkgs.fetchFromGitHub {
        owner = "kiddos";
        repo = "gemini.nvim";
        rev = "ad354181f340e2f560c04ec7945bfcdd9e26ad47";
        sha256 = "sha256-9tph7b1PbnBaE6P0mOmfTMNC1gAuxmpL6h/jayxk3M4=";
      };
    })
  ];

  keymaps = [ ];
}
