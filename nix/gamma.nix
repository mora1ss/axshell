{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "axshell-gamma";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mora1ss";
    repo = "axshell-gamma";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U8dkEc1H7Qancs1br59LurohKF2V0riw7P+V0u6HliY=";
  };

  cargoHash = "sha256-3UeKkkzuINTKjvASjxc2BvKnLcHosFryO/N81pNl+ic=";

  meta = {
    description = "Display temperature, brightness and gamma over D-Bus on Wayland";
    homepage = "https://github.com/mora1ss/axshell-gamma";
    license = lib.licenses.agpl3Plus;
    mainProgram = "axshell-gamma";
    platforms = lib.platforms.linux;
  };
})
