# nixpkgs overlay

nixpkgs including my own derivations.

## Usage

Using as `nixpkgs`:

```nix
{
  inputs.nixpkgs = "github:icetan/nixpkgs-overlay";
  ...
}
```

Overlaying another `nixpkgs` version:

```nix
{
  inputs.icetan-overlay = "github:icetan/nixpkgs-overlay";

  inputs.nixpkgs = "github:nixos/nixpkgs";

  outputs = { self, icetan-overlay, nixpkgs, ... }:
    ... 
    pkgs = import nixpkgs {
      inherit system;
      inherit (icetan-overlay) overlays;
    };
    ...
}
```
