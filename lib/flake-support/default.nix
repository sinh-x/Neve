{
  inputs,
  src,
}:
let
  inherit (inputs.nixpkgs) lib;

  namespace = "sinh-x";

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  forAllSystems = lib.genAttrs systems;

  discoverDefaultNix =
    root:
    let
      walk =
        dir: prefix:
        lib.flatten (
          lib.mapAttrsToList (
            name: type:
            let
              path = dir + "/${name}";
              rel = if prefix == "" then name else "${prefix}/${name}";
            in
            if type == "directory" then
              (lib.optional (builtins.pathExists (path + "/default.nix")) {
                inherit rel;
                file = path + "/default.nix";
              })
              ++ walk path rel
            else
              [ ]
          ) (builtins.readDir dir)
        );
    in
    builtins.listToAttrs (
      map (entry: {
        name = entry.rel;
        value = entry.file;
      }) (walk root "")
    );

  discoverNonDefaultNixFiles =
    root:
    let
      walk =
        dir:
        lib.flatten (
          lib.mapAttrsToList (
            name: type:
            let
              path = dir + "/${name}";
            in
            if type == "directory" then
              walk path
            else if lib.hasSuffix ".nix" name && name != "default.nix" then
              [ path ]
            else
              [ ]
          ) (builtins.readDir dir)
        );
    in
    walk root;

  repoLib =
    (import ../default.nix { inherit lib; })
    // (import ../file/default.nix { lib = flakeLib; })
    // (import ../module/default.nix { lib = flakeLib; })
    // (import ../theme/default.nix { lib = flakeLib; })
    // {
      inherit discoverNonDefaultNixFiles;
    };

  flakeLib = lib.extend (
    _final: _prev:
    repoLib
    // {
      ${namespace} = repoLib;
    }
  );

  packageFiles = discoverDefaultNix (src + "/packages");
  checkFiles = discoverDefaultNix (src + "/checks");
  shellFiles = discoverDefaultNix (src + "/shells");

  packageOverlays = lib.mapAttrs' (name: file: {
    name = "package/${name}";
    value =
      final: prev:
      let
        package = final.callPackage file {
          inherit inputs namespace;
          inherit (final) system;
          pkgs = final;
        };
      in
      {
        ${name} = package;
        ${namespace} = (prev.${namespace} or { }) // {
          ${name} = package;
        };
      };
  }) packageFiles;

  nonDefaultOverlays = packageOverlays;

  overlays = nonDefaultOverlays // {
    default =
      final: prev:
      lib.foldl' (attrs: overlay: attrs // overlay final prev) { } (
        builtins.attrValues nonDefaultOverlays
      );
  };

  pkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = (builtins.attrValues nonDefaultOverlays) ++ [
        (_final: _prev: { lib = flakeLib; })
      ];
    };

  packages = forAllSystems (
    system:
    let
      autoPackages = lib.mapAttrs (
        _name: file:
        (pkgsFor system).callPackage file {
          inherit inputs namespace system;
          pkgs = pkgsFor system;
        }
      ) packageFiles;
    in
    autoPackages
    // {
      default = autoPackages.sinh-x-nixvim;
      nvim = autoPackages.sinh-x-nixvim;
    }
  );

  checks = forAllSystems (
    system:
    lib.mapAttrs (
      _name: file:
      import file {
        inherit inputs namespace;
        lib = flakeLib;
        pkgs = pkgsFor system;
      }
    ) checkFiles
  );

  devShells = forAllSystems (
    system:
    lib.mapAttrs (
      _name: file:
      (pkgsFor system).callPackage file {
        inherit inputs namespace system;
        pkgs = pkgsFor system;
      }
    ) shellFiles
  );

  formatter = forAllSystems (system: (pkgsFor system).nixfmt);
in
{
  inherit
    checks
    devShells
    formatter
    overlays
    packages
    ;

  inherit src;

  lib = repoLib;

  templates = { };
}
