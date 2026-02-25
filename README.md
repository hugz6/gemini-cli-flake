# gemini-cli Nix Flake

Nix flake packaging for [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli).

## Requirements

- [Nix](https://nixos.org/download) with flakes enabled

To enable flakes, add this to your `/etc/nix/nix.conf` or `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

## Usage

### Run without installing

```bash
nix run github:hugz6/gemini-cli-flake
```

### Install permanently

```bash
nix profile install github:hugz6/gemini-cli-flake
```

The `gemini-cli` command will then be available everywhere in your terminal.

### Uninstall

```bash
nix profile remove gemini-cli
```

## NixOS

Add this flake as an input in your system `flake.nix`:

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  gemini-cli.url = "github:hugz6/gemini-cli-flake";
};
```

Then add it to your packages in `configuration.nix`:

```nix
{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.gemini-cli.packages.${pkgs.system}.default
  ];
}
```

Apply the changes:

```bash
sudo nixos-rebuild switch
```

## Home Manager

Add this flake as an input and include it in your `home.nix`:

```nix
home.packages = [
  inputs.gemini-cli.packages.${pkgs.system}.default
];
```

## Development shell

If you want to work on the project locally with Node.js available:

```bash
nix develop
```

This drops you into a shell with Node.js and npm ready to use.

## Building locally

```bash
# Clone this repo
git clone https://github.com/hugz6/gemini-cli-flake
cd gemini-cli-flake

# Build
nix build

# Test the binary without installing
./result/bin/gemini-cli
```

## Updates

This flake is automatically updated when a new release of gemini-cli is published. A pull request is opened and the build is verified before merging.
