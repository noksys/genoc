{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    emacs                 # The extensible, customizable, self-documenting display editor
  ];
}
