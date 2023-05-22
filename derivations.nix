{ callPackage, fetchzip, lib, stdenv
# Optional override for the HLS binaries to support specific GHC versions.
, ghcVersions ? [
  "8.6.5"
  "8.8.3"
  "8.8.4"
  "8.10.5"
  "8.10.6"
  "8.10.7"
  "9.0.1"
  "9.0.2"
  "9.2.1"
] }:
let
  inherit (stdenv) isDarwin isLinux;
  hlsBins = [ "wrapper" ] ++ ghcVersions;

  #############################################################################
  # Derivation attributes & metadata shared across platforms.
  #############################################################################

  pname = "haskell-language-server";
  version = "1.7.0.0";
  meta = {
    description = ''
      A language server that provides information about Haskell programs to
      IDEs, editors, and other tools.
    '';
    homepage = "https://github.com/haskell/haskell-language-server";
    license = lib.licenses.asl20; # Apache-2.0 license.
    maintainers = [ ];

    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

in rec {
  #############################################################################
  # Platform-Specific Derivations
  #############################################################################

  nixosSrc = fetchzip {
    url =
      "https://github.com/haskell/haskell-language-server/releases/download/${version}/haskell-language-server-${version}-src.tar.gz";
    sha256 = "sha256-k7hLNQmua4KbJ6Fb2gGF+Wc67U++cvt5+imsVFt9z2s=";
    stripRoot = false;
  };

  nixosDrv = callPackage ./nixos {
    inherit hlsBins pname version meta;
    src = nixosSrc;
  };

  macosSrc = fetchzip {
    url =
      "https://github.com/haskell/haskell-language-server/releases/download/${version}/haskell-language-server-macOS-${version}.tar.gz";
    sha256 = "08zmy222z4gw7fansxnpv9v0yfv8lm9f9bklnz8dcm41hmy26hp6";
    stripRoot = false;
  };

  macosDrv = callPackage ./macos {
    inherit hlsBins pname version meta;
    src = macosSrc;
  };
}
