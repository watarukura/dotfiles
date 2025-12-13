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
      alejandra
      gh
      neovim
      lefthook
      aws-vault
      nodejs_24
      go
      duckdb
      direnv
      shellcheck
      shfmt
      yamlfmt
      typos
      actionlint
      zizmor
      pinact
    ];
  };

  programs.home-manager.enable = true;
}
