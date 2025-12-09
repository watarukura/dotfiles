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

      ### Fonts
      "font-google-sans-code"
      "font-jetbrains-mono-nerd-font"
    ];
  };
}
