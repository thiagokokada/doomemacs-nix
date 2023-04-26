# doomemacs-nix

Proof-of-Concept of building [doomemacs][1] inside Nix without patching the
source code (e.g: [nix-doom-emacs][2] approach).

Don't use this yet, it is really not pratical for a few reasons:

- Uses `__impure` derivations, so it needs both `ca-derivations` and
  `impure-derivations` [experimental features][3] enabled in Nix.
- Because it uses impure derivations, it will always rebuild.

[1]: https://github.com/doomemacs/doomemacs
[2]: https://github.com/nix-community/nix-doom-emacs
[3]: https://nixos.org/manual/nix/stable/contributing/experimental-features.html
