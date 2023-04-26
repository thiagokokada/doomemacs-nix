{ stdenv
, cacert
, doomemacs
, doom
, git
, emacs
}:

stdenv.mkDerivation {
  name = "doom-sync";

  src = doomemacs;

  nativeBuildInputs = [ git ];
  buildInputs = [ emacs ];

  DOOMDIR = doom;
  EMACSDIR = placeholder "out";
  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  postPatch = ''
    patchShebangs bin
  '';

  buildPhase = ''
    mkdir $out
    cp -r . $out
    bin/doom sync
  '';

  # The hash always change, so we can't set the output hash for now
  __impure = true;
  # outputHash = "...";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
