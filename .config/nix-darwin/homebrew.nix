{pkgs, ...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
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

      # for PHP
      "libsodium"
      "libxml2"
      "sqlite"
      "autoconf"
      "automake"
      "bison"
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
    ];
    taps = [
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
