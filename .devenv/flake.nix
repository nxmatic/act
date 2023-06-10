{
  description = "A Nix-flake-based Go 1.17 development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs.inputs.nixpkgs.follows = "stable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      goVersion = 20;
      overlays = [ (self: super: { go = super."go_1_${toString goVersion}"; }) ];
      pkgs = import nixpkgs { inherit overlays system; };
	  hardeningDisable = [ "all" ];
    in
    {
      devShells.default = pkgs.mkShellNoCC {

        hardeningDisable = [ "all" ];

        packages = with pkgs; [
          # go 1.19 (specified by overlay)
          go

          # goimports, godoc, etc.
          gotools

          # https://github.com/golangci/golangci-lint
          golangci-lint

          delve
          gopls
          go-outline
          gocode
          gopkgs
          gocode-gomod
          godef
          golint
        ];

        shellHook = ''
          ${pkgs.go}/bin/go version
        '';
      };
    });
}
