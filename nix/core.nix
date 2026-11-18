{ lib
, rustPlatform
, sqlite
, fetchFromGitHub
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "axshell-core";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "mora1ss";
    repo = "axshell-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+Zr+RCt3KI+uf2ue5IufozX+WnV7FETaZLUsk6jlP0o=";
  };

  buildInputs = [ sqlite ];

  cargoHash = "sha256-Gyg0DtDoRllkyNuSWZviTy2KBaMibRx+MkQe6lNypC8=";

  meta = {
    description = "A core of services for AxShell shell in Rust";
    homepage = "https://github.com/mora1ss/axshell-core";
    license = lib.licenses.agpl3Plus;
    mainProgram = "axshell-core";
    platforms = lib.platforms.linux;
  };
})
