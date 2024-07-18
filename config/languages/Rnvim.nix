{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "R-nvim";
      version = "2024-07-17";
      src = pkgs.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "d13c230503204f52094d95bb6f42992e71cf4e70";
        sha256 = "sha256-1+o3Iga7oXT98G1CWaPiOCCWlY5/yjJBgd4kUwbSd+w=";
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
  keymaps = [
  ];
}
