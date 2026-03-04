{pkgs, ...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    caskArgs = {
      appdir = "~/Applications";
    };
    brews = [
      "coreutils"
      "findutils"
      "diffutils"
      "gnu-sed"
      "gnu-tar"
      "gawk"
      "gzip"
      "grep"
      "jq"
      "yq"
      "fzf"
      "ghq"
      "awscli"
      "aqua"
      "starship"
      "chezmoi"
      "zsh-completions"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "k1LoW/tap/git-wt"
      "k1LoW/tap/mo"
      "deck"
      "datadog/pack/pup"
      "teamspirit-cli"

      # for PHP
      "libsodium"
      "libxml2"
      "sqlite"
      "autoconf"
      "automake"
      "bison"
      "bzip2"
      "freetype"
      "gd"
      "gettext"
      "icu4c@78"
      "krb5"
      "libedit"
      "libiconv"
      "libjpeg"
      "libpng"
      "libzip"
      "pkg-config"
      "re2c"
      "zlib"
      "oniguruma"
      "openssl@1.1"
      "binutils"
      "enchant"
      "libxpm"
      "sqlite"
      "curl"
    ];
    taps = [
      "k1LoW/tap"
      "datadog/pack"
      {
        name = "dmm-com/internal-oss-homebrew-tap";
        clone_target = "https://github.com/dmm-com/internal-oss-homebrew-tap.git";
        force_auto_update = true;
      }
      {
        name = "dmm-com/internal-oss-teamspirit-cli";
        clone_target = "https://github.com/dmm-com/internal-oss-teamspirit-cli.git";
        force_auto_update = true;
      }
    ];
    casks = [
      ### GUI Applications
      "1password"
      "1password-cli"
      "cursor"
      "obsidian"
      "raycast"
      "ghostty"
      "jetbrains-toolbox"
      "clipy"
      "docker-desktop"
      "google-japanese-ime"
      "karabiner-elements"
      "slack"
      "rectangle"
      "coteditor"

      ### Fonts
      "font-google-sans-code"
      "font-jetbrains-mono-nerd-font"
    ];
  };
}
