{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "R-nvim";
      version = "v0.99.0";
      src = pkgs.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "de8b89b4bab09ee317ccc13b38150ab67bf66793";
        sha256 = "sha256-ztanV7mSpZtcMQ0LgjUPO0y7e2GV6eYc8zAonVEAzOk=";
      };
    })
  ];
  extraConfigLua = ''
    local rnvim = require('r')
    rnvim.setup({
      R_args = {'--no-save', '--no-restore'},
      hook = {
        on_filetype = function ()
          -- This function will be called at the FileType event
          -- of files supported by R.nvim. This is an
          -- opportunity to create mappings local to buffers.
          vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
          vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
        end
      },
      nvimpager = 'split_h',
      min_editor_width = 1000,
    })
  '';
  keymaps = [ ];
}
