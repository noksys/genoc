{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gdb    # GNU debugger
    file   # File type identification
    strace # Trace system calls
    ltrace # Trace library calls
    lsof   # List open files/sockets
  ];
}
