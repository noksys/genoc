{ pkgs, ... }:
{
  # Realtime Audio Config (Pipewire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    qjackctl          # JACK Audio Connection Kit - Qt GUI Interface
    easyeffects       # Audio effects for PipeWire applications
    lsp-plugins       # Linux Studio Plugins Project
  ];
}
