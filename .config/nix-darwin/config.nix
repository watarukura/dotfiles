{ pkgs, ... }:
{
  imports = [
    ./darwin.nix
    ./homebrew.nix
  ];
}
