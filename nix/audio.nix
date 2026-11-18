{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, pipewire
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "axshell-audio";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "mora1ss";
    repo = "axshell-audio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6GKbaSBHH3CfzKHIXPcNEkG8z5BBrDBvRQqzRj3iTQ4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pipewire ];

  doCheck = true;
  checkTarget = "test";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "PipeWire audio processor for the AxShell shell";
    homepage = "https://github.com/mora1ss/axshell-audio";
    license = lib.licenses.agpl3Only;
    mainProgram = "axshell-audio";
    platforms = lib.platforms.linux;
  };
})
