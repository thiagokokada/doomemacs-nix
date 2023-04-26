{
  description = "doomemacs packaged for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
  };

  outputs = { doomemacs, nixpkgs, flake-utils, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
    in
    eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        emacs = pkgs.emacs;
        doom = ./doom.d;
      in
      {
        packages = rec {
          # To use this properly, use it with Home-Manager, e.g.:
          # { inputs, ... }:
          # {
          #   xdg.configFile."emacs" = {
          #     source = inputs.doomemacs-nix.packages.${system}.doom-sync;
          #     # Important so doomemacs can create its write directories
          #     # (e.g.: $EMACSDIR/.local/cache) during runtime
          #     recursive = true;
          #   }
          # }
          # TODO: create Home-Manager module
          doom-sync = pkgs.callPackage ./doomemacs {
            inherit doomemacs emacs doom;
          };
          # This is mostly for PoC purposes, since we can't write to e.g.:
          # EMACSDIR/.local/cache, this cause some issues during runtime
          emacs-with-doom = (pkgs.writeShellScriptBin "emacs" ''
            export DOOMDIR=${doom}
            export EMACSDIR=${doom-sync}
            ${emacs}/bin/emacs $@
          '').overrideAttrs (old: { __impure = true; });
        };
      }
    );
}
