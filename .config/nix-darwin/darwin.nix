{pkgs, ...}: {
  # nix自体の設定
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
    gc = {
      automatic = true;
      interval = {
        Hour = 9;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };
  };
  # services.nix-daemon.enable = true;

  # システムの設定（nix-darwinが効いているかのテスト）
  system = {
    stateVersion = 6;
    primaryUser = "kurashima-wataru";

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        KeyRepeat = 1;
        InitialKeyRepeat = 12;
        ApplePressAndHoldEnabled = false;
      };
      finder = {
        # 隠しファイルを常に表示する
        AppleShowAllFiles = true;
        # 拡張子を常に表示する
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "bottom";
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
