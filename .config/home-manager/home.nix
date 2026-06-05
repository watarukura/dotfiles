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

    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      tig
      curl
      alejandra
      neovim
      lefthook
      aws-vault
      nodejs_24
      duckdb
      shellcheck
      shfmt
      yamlfmt
      typos
      actionlint
      zizmor
      pinact
      uv
      ttyd
      hyperfine
      bat
      rclone
      google-cloud-sdk
      ripgrep
      ssm-session-manager-plugin
      nkf
      gitleaks
    ];
  };

  programs.home-manager.enable = true;
}
