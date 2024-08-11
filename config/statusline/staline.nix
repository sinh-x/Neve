{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "staline.nvim";
      version = "2024-02-05";
      src = pkgs.fetchFromGitHub {
        owner = "tamton-aquib";
        repo = "staline.nvim";
        rev = "a53f869278b8b186a5afd6f21680cd103c381599";
        hash = "sha256-GDMKzxFDtQk5LL+rMsxTGTyLv69w5NUd+u19noeO5ws=";
      };
    })
  ];
  extraConfigLua = ''
      ---Indicators for special modes,
      ---@return string status
      local function extra_mode_status()
        -- recording macros
        local reg_recording = vim.fn.reg_recording()
        if reg_recording ~= "" then
          return " @" .. reg_recording
        end
        -- executing macros
        local reg_executing = vim.fn.reg_executing()
        if reg_executing ~= "" then
          return ' @' .. reg_executing
        end
        -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
        local mode = vim.api.nvim_get_mode().mode
        if mode == 'ix' then
          return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
        end
        return ""
      end


      require'staline'.setup {

      sections = {
        left = {
          ' ', 'right_sep_double', '-mode', 'left_sep_double', ' ',
          'right_sep', '-file_name', 'left_sep', ' ',
          'right_sep_double', '-branch', 'left_sep_double', ' ',
        },
        mid  = {'lsp'},
        right= {
          'right_sep', '-cool_symbol', 'left_sep', ' ',
          'right_sep', '- ', '-lsp_name', '- ', 'left_sep',
          'right_sep_double', '-line_column', 'left_sep_double', ' ',
        }
      },

      defaults={
        fg = "#986fec",
        cool_symbol = "  ",
        left_separator = "",
        right_separator = "",
        -- line_column = "%l:%c [%L]",
        true_colors = true,
        line_column = "[%l:%c] 並%p%% "
        -- font_active = "bold"
      },
      mode_colors = {
        n  = "#181a23",
        i  = "#181a23",
        ic = "#181a23",
        c  = "#181a23",
        v  = "#181a23"       -- etc
      }
      mode_icons = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["nov"] = "NORMAL",
        ["noV"] = "NORMAL",
        ["niI"] = "NORMAL",
        ["niR"] = "NORMAL",
        ["niV"] = "NORMAL",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["ix"] = "INSERT",
        ["s"] = "INSERT",
        ["S"] = "INSERT",
        ["v"] = "VISUAL",
        ["V"] = "VISUAL",
        [""] = "VISUAL",
        ["r"] = "REPLACE",
        ["r?"] = "REPLACE",
        ["R"] = "REPLACE",
        ["c"] = "COMMAND",
        ["t"] = "TERMINAL",
      },
    })
  '';
}
