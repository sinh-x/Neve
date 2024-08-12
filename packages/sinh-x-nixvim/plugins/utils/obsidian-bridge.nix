{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "obsidian-bridge.nvim";
      version = "2024-06-13";
      src = pkgs.fetchFromGitHub {
        owner = "oflisback";
        repo = "obsidian-bridge.nvim";
        rev = "ad05b2ecdf0d22a3a9387ae4684acd208695d466";
        sha256 = "sha256-Phm4/Qjl7ebga7ViBz1K9In/favCBJPjsa/XU5U0J84=";
      };
    })
  ];
  extraConfigLua = ''
    local ob = require('obsidian-bridge')
    ob.setup({
       obsidian_server_address = "http://localhost:27123"
    })
  '';

  keymaps = [ ];
}
