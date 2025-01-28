{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: {
        default = pkgs.${system}.stdenvNoCC.mkDerivation {
          pname = "cipher";
          version = "1.0.0";

          buildPhase = ''
            npm ci
            npm run bundle
          '';
          installPhase = ''
            unzip _s.zip -d $out
          '';
          buildInputs = with pkgs.${system}; [
            nodejs
            python311
            unzip
          ];

          src = ./.;
        };
      });
    };
}
