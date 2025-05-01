{lib, config, pkgs, ...}:

{
  options = {
    vr.enable = lib.mkEnableOption "Enable vr functionality";
    vr_patch.enable = lib.mkEnableOption "Enable capsys patch for amdgpu";
  };
  config = lib.mkIf config.vr.enable {
    environment.systemPackages = [pkgs.alvr];
    programs.alvr.enable = true;
    programs.alvr.openFirewall = true;
    
    boot.kernelPatches = lib.mkIf config.vr_patch.enable [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];
  };
}
