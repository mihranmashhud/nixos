{
  stdenv,
fetchzip,
  fetchPnpmDeps,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
}: stdenv.mkDerivation (finalAttrs: rec {
  pname = "relagit";
  version = "v0.16.9";
  src = fetchzip {
    url = "https://github.com/relagit/relagit/archive/refs/tags/${version}.tar.gz";
    hash = "";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "";
  };

  postBuild = ''
    pnpm make:linux
  '';
})
