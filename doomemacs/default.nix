{ stdenv
, cacert
, doomemacs
, doom
, git
, emacs
, sha256 ? null
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
    runHook preBuild

    mkdir $out
    cp -r . $out
    bin/doom sync

    runHook postBuild
  '';

  # Removing sources of impurity
  preFixup = ''
    find $out/.local/straight/repos -name '.git' -type d -exec rm -rf '{}' +
    rm -rf $out/.local/straight/build-*-cache.el
  '';

  __impure = if (sha256 == null) then true else false;
  outputHash = sha256;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
