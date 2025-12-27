{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ardour        # DAW
    reaper        # DAW (Proprietary but linux native)
    audacity      # Wave editor
    hydrogen      # Drum machine
    
    # Plugins & Synths
    vital         # Wavetable synth
    helm          # Synth
    calf          # LV2 plugins
    lsp-plugins
  ];
}
