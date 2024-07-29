{pkgs, ...}: {
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    mangohud
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
    mangohud
  ];
  services.xserver.videoDrivers = ["amdgpu"];
}
# {pkgs, ...}: {
#   hardware.graphics.extraPackages = with pkgs; [
#     amdvlk
#     mangohud
#     rocm-opencl-icd
#     rocm-opencl-runtime
#     vaapiVdpau
#     libvdpau-va-gl
#   ];
#   hardware.graphics.extraPackages32 = with pkgs; [
#     driversi686Linux.amdvlk
#     mangohud
#   ];
#   hardware.opengl = {
#     driSupport32Bit = true;
#   };
#   services.xserver.videoDrivers = ["amdgpu"];
# }

