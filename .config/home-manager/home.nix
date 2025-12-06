{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  username = "kurashima-wataru";
in {
  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";

    packages = with pkgs; [
      git
      tig
      curl
      fish
      alejandra
      gh
      neovim
    ];
  };

  programs.home-manager.enable = true;
}
