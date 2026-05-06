_: {

  plugins = {
    mini = {
      enable = true;

      modules = {
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
          options.custom_commentstring.__raw = ''
            function()
              local ok, internal = pcall(require, "ts_context_commentstring.internal")
              if not ok then
                return vim.bo.commentstring
              end

              local calculated_ok, commentstring = pcall(internal.calculate_commentstring)
              if calculated_ok and commentstring then
                return commentstring
              end

              return vim.bo.commentstring
            end
          '';
        };
      };
    };
  };
}
