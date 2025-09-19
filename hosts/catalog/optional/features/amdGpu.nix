# {pkgs, ...}: {
#   hardware.opengl.extraPackages = with pkgs; [
#     amdvlk
#     mangohud
#     rocm-opencl-icd
#     rocm-opencl-runtime
#   ];
#   hardware.opengl.extraPackages32 = with pkgs; [
#     driversi686Linux.amdvlk
#     mangohud
#   ];
#   services.xserver.videoDrivers = ["amdgpu"];
# }
{pkgs, ...}: {
  hardware.graphics.extraPackages = with pkgs; [
    vkd3d-proton
    vkd3d
    amdvlk
    mangohud
rocmPackages.clr
    vaapiVdpau
    libvdpau-va-gl
  ];
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
    mangohud
  ];
  services.xserver.videoDrivers = ["amdgpu"];
}
