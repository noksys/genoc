# lenovo.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  # ---- Audio firmware patch (unchanged) -----------------------------------
  hardware.firmware = [
    (pkgs.runCommandNoCC "legion-audio-patch" {} ''
      mkdir -p $out/lib/firmware
      cp ${./legion-alc287.patch} $out/lib/firmware/legion-alc287.patch
    '')
  ];
  boot.extraModprobeConfig = ''
    # options snd-hda-intel model=alc287-yoga9-bass-spk-pin
    options snd-hda-intel patch=legion-alc287.patch
  '';
  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # ---- Graphics base (PERFORMANCE by default) ------------------------------
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable   = true;      # PRIME infra
    open                 = false;     # 4090 laptop -> driver proprietário
    nvidiaSettings       = false;
    nvidiaPersistenced   = false;

    # BASE = performance: dGPU primária (sem RTD3)
    # >>> NÃO usar mkForce aqui; a specialisation 'powersave' vai sobrescrever <<<
    prime.offload.enable   = false;   # dGPU dirige a sessão
    prime.sync.enable      = true;    # suavidade se painel é iGPU-wired
    powerManagement.enable = false;   # não tentar suspender a dGPU no base
    # (finegrained não se aplica sem offload)
  };

  # ---- dGPU runtime power policy via udev (ajuda o RTD3 no powersave) ------
  # Mantém dGPU "on" no AC e permite autosuspend na bateria.
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", \
      RUN+="/bin/sh -c 'echo on > /sys/bus/pci/devices/0000:01:00.0/power/control'"

    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", \
      RUN+="/bin/sh -c 'echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control'"
  '';

  # ---- NVIDIA/userland tools (como você tinha) -----------------------------
  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
    nv-codec-headers
    nvidia-container-toolkit
    nvidia-optical-flow-sdk
    nvidia-system-monitor-qt
    nvidia-texture-tools
    nvidia-vaapi-driver
    nvtopPackages.nvidia
  ];

  # ---- Specialisation extra: POWERSAVE (iGPU primária + RTD3) --------------
  specialisation = {
    powersave.configuration = {
      hardware.nvidia = {
        # Aqui sim usamos mkForce para garantir a sobreposição sobre o base
        prime.offload.enable        = lib.mkForce true;   # iGPU dirige; use `prime-run` p/ dGPU
        prime.sync.enable           = lib.mkForce false;  # não usar modo sync com offload
        powerManagement.enable      = lib.mkForce true;   # RTD3 ligado (dGPU dorme em idle)
        powerManagement.finegrained = lib.mkForce true;   # permitido somente com offload
      };
      # Não sobrescreva environment.sessionVariables aqui (preserva NIX_PATH etc).
    };
  };
}
