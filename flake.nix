{
  description = "Gemini CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gemini-cli-src = {
      url = "github:google-gemini/gemini-cli?ref=refs/tags/v0.30.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, gemini-cli-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.buildNpmPackage {
          pname = "gemini-cli";
          version = "0.30.0";
	  src = gemini-cli-src;

          npmDepsFetcherVersion = 2;
          npmDepsHash = "sha256-5Ce1aI0PjJsVhbuQyLxCHOrQStjEyoaJVbgPsvAwW9o=";
          nativeBuildInputs = with pkgs; [
            pkg-config
            python3
          ];

          buildInputs = with pkgs; [
            libsecret
          ];
          buildPhase = ''
            npm run bundle
          '';
          
          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/lib/gemini-cli
          
            cp -rL bundle/ $out/lib/gemini-cli/bundle
          
            cat > $out/bin/gemini-cli <<EOF
            #!/bin/sh
            exec ${pkgs.nodejs}/bin/node $out/lib/gemini-cli/bundle/gemini.js "\$@"
            EOF
          
            chmod +x $out/bin/gemini-cli
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.nodejs ];
        };
      }
    );
}
