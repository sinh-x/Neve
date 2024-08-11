{
  plugins.lualine = {
    enable = true;
    alwaysDivideMiddle = true;
    globalstatus = true;
    ignoreFocus = ["neo-tree"];
    extensions = ["fzf"];
    theme = "auto";
    componentSeparators = {
      left = "|";
      right = "|";
    };
    sectionSeparators = {
      left = "█"; # 
      right = "█"; # 
    };
    sections = {
      lualine_a = ["mode"];
      lualine_b = [
        {
          name = "branch";
          icon = "";
        }
        "diff"
        "diagnostics"
      ];
      lualine_c = ["filename"];
      lualine_x = ["filetype"];
      lualine_y = ["progress"];
      lualine_z = [''" " .. os.date("%R")''];
      extraConfigLua = ''
      '';
    };
    extraConfigLua = ''
      ---Indicators for special modes,
      ---@return string status
      function extra_mode_status()
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

    '';
  };
}
