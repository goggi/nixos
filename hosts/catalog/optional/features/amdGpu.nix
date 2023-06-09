{pkgs, ...}: {
  hardware.opengl.extraPackages = with pkgs; [
    # amdvlk
    mangohud
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    # driversi686Linux.amdvlk
    mangohud
  ];
  services.xserver.videoDrivers = ["amdgpu"];
}
