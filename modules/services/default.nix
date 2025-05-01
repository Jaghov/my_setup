{lib,...}:
{
  imports = [
    ./sound/default.nix
    ./bluetooth.nix
    ./window_manager.nix
  ];

  bluetooth.enable = lib.mkDefault true;
  blueman.enable = lib.mkDefault true;

  noisetorch.enable = lib.mkDefault false;
}
