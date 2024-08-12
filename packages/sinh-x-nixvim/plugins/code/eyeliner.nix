{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "eyeliner";
      version = "2024-08-09";
      src = pkgs.fetchFromGitHub {
        owner = "jinh0";
        repo = "eyeliner.nvim";
        rev = "7385c1a29091b98ddde186ed2d460a1103643148";
        sha256 = "sha256-PyCcoSC/LeJ/Iuzlm5gd/0lWx8sBS50Vhe7wudgZzqM=";
      };
    })
  ];
  extraConfigLua = ''
    require('eyeliner').setup {
      highlight_on_key = true, -- show highlights only after key press
      dim = true, -- dim all other characters
    }
  '';
  keymaps = [ ];
}
