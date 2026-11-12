{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.axshell;
in
{
  options.programs.axshell = {
    enable = mkEnableOption "system-level support for the AxShell desktop shell";
  };

  config = mkIf cfg.enable {
    programs.ski.enable = mkDefault true;
    networking.networkmanager.enable = mkDefault true;
    hardware.bluetooth.enable = mkDefault true;
    hardware.i2c.enable = mkDefault true;
    services.power-profiles-daemon.enable = mkDefault true;
    security.rtkit.enable = mkDefault true;
    security.pam.services.axshell = { };

    services.pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
    };

    fonts.packages = [ pkgs.nerd-fonts.iosevka ];
  };
}
