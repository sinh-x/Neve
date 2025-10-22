_: {

  plugins = {
    illuminate = {
      enable = true;

      settings = {
        filetypesDenylist = [
          "dirvish"
          "fugitive"
          "neo-tree"
          "TelescopePrompt"
        ];
        largeFileCutoff = 3000;
      };
    };
  };
}
