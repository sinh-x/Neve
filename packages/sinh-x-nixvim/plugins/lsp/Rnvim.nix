_: {
  # extraPlugins = with pkgs.vimUtils; [
  #   (buildVimPlugin {
  #     pname = "R-nvim";
  #     version = "2025-01-10";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "R-nvim";
  #       repo = "R.nvim";
  #       rev = "d989047c8577409094e956d9847a96fb7a16595f";
  #       sha256 = "sha256-YiKcFsyf+N/pwJLKfq9L2jX1RTaOMrD3VxtwaE3U35g=";
  #     };
  #   })
  # ];
  # extraConfigLua = ''
  #   local rnvim = require('r')
  #   rnvim.setup({
  #     R_args = {'--no-save', '--no-restore'},
  #     hook = {
  #       on_filetype = function ()
  #         -- This function will be called at the FileType event
  #         -- of files supported by R.nvim. This is an
  #         -- opportunity to create mappings local to buffers.
  #         vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
  #         vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
  #       end
  #     },
  #     nvimpager = 'split_h',
  #     min_editor_width = 1000,
  #   })
  # '';
  # keymaps = [ ];
}
