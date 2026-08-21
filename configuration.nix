{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."rdahlke" = {
    isNormalUser = true;
    description = "rdahlke";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = [
    pkgs.git
    pkgs.gnupg
    pkgs.python3
    pkgs.vim
  ];

  # `system.stateVersion` come from configuration.init.nix
}
