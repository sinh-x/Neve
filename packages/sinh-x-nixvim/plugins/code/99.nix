{
  pkgs,
  ...
}:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "99";
      version = "2026-02-18";
      src = pkgs.fetchFromGitHub {
        owner = "ThePrimeagen";
        repo = "99";
        rev = "2415234dcd2a579eac4bd20c3c63e097d1f3da84";
        sha256 = "17yk6k3km937a0fjv3szyxpr8xv8jk2wn19s4k6hd23vs918arl0";
      };
    })
  ];

  extraConfigLua = ''
    local _99 = require("99")
    _99.setup({
      completion = {
        source = "cmp",
      },
    })
  '';

  keymaps = [
    {
      mode = "v";
      key = "<leader>9v";
      action.__raw = "function() require('99').visual() end";
      options = {
        desc = "99 Visual";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>9x";
      action.__raw = "function() require('99').stop_all_requests() end";
      options = {
        desc = "99 Stop All";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>9s";
      action.__raw = "function() require('99').search() end";
      options = {
        desc = "99 Search";
        silent = true;
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>9";
      group = "99 AI";
    }
  ];
}
