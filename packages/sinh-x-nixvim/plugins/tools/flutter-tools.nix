{
  lib,
  config,
  pkgs,
  ...
}:
{
  plugins.flutter-tools = {
    enable = true;

    settings = {
      widget_guides.enabled = true;
      closing_tags.enabled = true;
      lsp = {
        color = {
          enabled = true;
        };
      };
      debugger = {
        enabled = true;
      };
    };
  };

  extraPackages = lib.mkIf config.plugins.flutter-tools.enable [
    pkgs.flutter
  ];

  keymaps = lib.mkIf config.plugins.flutter-tools.enable [
    {
      mode = "n";
      key = "<leader>Fl";
      action = "<cmd>FlutterLogClear<CR>";
      options.desc = "Flutter log clear";
    }
    {
      mode = "n";
      key = "<leader>Fd";
      action = "<cmd>FlutterDevices<CR>";
      options.desc = "Flutter devices";
    }
    {
      mode = "n";
      key = "<leader>Fe";
      action = "<cmd>FlutterEmulators<CR>";
      options.desc = "Flutter emulators";
    }
    {
      mode = "n";
      key = "<leader>Fr";
      action = "<cmd>FlutterReload<CR>";
      options.desc = "Flutter hot reload";
    }
    {
      mode = "n";
      key = "<leader>FR";
      action = "<cmd>FlutterRestart<CR>";
      options.desc = "Flutter hot restart";
    }
    {
      mode = "n";
      key = "<leader>Fq";
      action = "<cmd>FlutterQuit<CR>";
      options.desc = "Flutter quit";
    }
    {
      mode = "n";
      key = "<leader>Fo";
      action = "<cmd>FlutterOutlineToggle<CR>";
      options.desc = "Flutter outline";
    }
    {
      mode = "n";
      key = "<leader>Ft";
      action = "<cmd>FlutterDevTools<CR>";
      options.desc = "Flutter DevTools";
    }
  ];

  plugins.which-key.settings.spec = lib.optionals config.plugins.flutter-tools.enable [
    {
      __unkeyed = "<leader>F";
      group = " Flutter";
    }
  ];
}
