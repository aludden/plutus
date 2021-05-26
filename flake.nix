{
  description = "Flake for Plutus";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=7d71001b796340b219d1bfa8552c81995017544a";
    haskell-nix.url = "github:input-output-hk/haskell.nix?rev=87084d65a476cc826a0e8c5d281d494254f5bc7a";
    flake-utils.url = "github:numtide/flake-utils?rev=b543720b25df6ffdfcf9227afafc5b8c1fabfae8";
  };

  outputs = { self, nixpkgs, haskell-nix, flake-utils, ... }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        topLevel = import ./. {
          inherit system;
          isInFlake = true;
          haskellNix = haskell-nix;
        };

        inherit (topLevel) pkgs plutus;
      in
      rec {
        packages = rec {
          marlowe-playground-client = topLevel.marlowe-playground.client;
          marlowe-playground-server = topLevel.marlowe-playground.server;
          plutus-playground-client = topLevel.plutus-playground.client;
          plutus-playground-server = topLevel.plutus-playground.server;
          marlowe-website = topLevel.marlowe-web;
          web-ghc-server = plutus.haskell.project.hsPkgs.web-ghc.components.exes.web-ghc-server;
        };
      }));
}
