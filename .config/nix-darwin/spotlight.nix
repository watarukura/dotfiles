{
  config,
  lib,
  ...
}: let
  cfg = config.my.services.spotlight;
in {
  options = {
    # https://github.com/natsukium/dotfiles/blob/main/modules/darwin/spotlight.nix
    my.services.spotlight = {
      enableIndex = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf (!cfg.enableIndex) {
    system.activationScripts.extraActivation.text = ''
      echo "disabling spotlight indexing..."
      mdutil -i off -d / &> /dev/null
      mdutil -E / &> /dev/null
    '';
  };
}
