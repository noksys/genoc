{ pkgs, ... }:

{
  imports = [
    ../../modules/languages/rust/full.nix
    ../../modules/languages/c-cpp/base.nix # Often needed for linking
  ];

  environment.systemPackages = with pkgs; [
    lldb
    gdb
    valgrind
  ];
}
