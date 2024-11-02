_: {

  # Shows the breadcrumb lsp node path in lualine
  plugins.navic = {
    enable = true;

    settings = {
      lsp = {
        autoAttach = true;
        preference = [
          "clangd"
          "tsserver"
        ];
      };
    };
  };
}
