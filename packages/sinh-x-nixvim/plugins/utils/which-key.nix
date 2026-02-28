_: {
  plugins.which-key = {
    enable = true;

    settings = {
      spec = [
        {
          __unkeyed = "<leader>b";
          group = "󰓩 Buffers";
        }
        {
          __unkeyed = "<leader>bs";
          group = "󰒺 Sort";
        }
        {
          __unkeyed = "<leader>g";
          group = "󰊢 Git";
        }
        {
          __unkeyed = "<leader>f";
          group = " Find";
        }
        {
          __unkeyed = "<leader>r";
          group = " Refactor";
        }
        {
          __unkeyed = "<leader>t";
          group = " Tab";
        }
        {
          __unkeyed = "<leader>u";
          group = " UI/UX";
        }
        {
          __unkeyed = "<leader>q";
          group = "Quit";
        }
        {
          __unkeyed = "<leader>s";
          group = " Search";
        }
        {
          __unkeyed = "<leader>w";
          group = " Windows";
        }
        {
          __unkeyed = "<leader><Tab>";
          group = " Tab";
        }
        {
          __unkeyed = "<leader>d";
          group = " Debug";
        }
        {
          __unkeyed = "<leader>c";
          group = " Code";
        }
        {
          __unkeyed = "<leader>T";
          group = " Test";
        }
      ];

      replace = {
        # key = [
        #   [
        #     "<Space>"
        #     "SPC"
        #   ]
        # ];

        desc = [
          [
            "<space>"
            "SPACE"
          ]
          [
            "<leader>"
            "SPACE"
          ]
          [
            "<[cC][rR]>"
            "RETURN"
          ]
          [
            "<[tT][aA][bB]>"
            "TAB"
          ]
          [
            "<[bB][sS]>"
            "BACKSPACE"
          ]
        ];
      };
      win = {
        border = "single";
      };

      # preset = "helix";
    };
  };
}
