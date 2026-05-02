{
  description = "Sinh-x-nixvim configuration";

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # nixvim nix configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";

    # Snowfall Lib (still referenced by legacy auto-discovery in
    # packages/sinh-x-nixvim/default.nix and shells/default/default.nix;
    # scheduled for removal in NXN-002 Phase 4.6 once Phase 4.4 swaps the
    # remaining call sites to the repo-owned helpers in lib/flake-support).
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake (same as snowfall-lib above; removed in NXN-002 Phase 4.6).
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    import ./lib/flake-support {
      inherit inputs;
      src = ./.;
    };
}
