{pkgs, ...}: {
  imports = [
    ./darwin.nix
    ./homebrew.nix
    ./spotlight.nix
  ];

  my.services.spotlight.enableIndex = false;
}
