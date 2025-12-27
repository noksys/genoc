{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc                   # GNU Compiler Collection
    gdb                   # The GNU Project Debugger
    gnumake               # A tool to control the generation of non-source files from sources
    qemu                  # A generic and open source machine emulator and virtualizer
    nasm                  # The Netwide Assembler
    binutils              # Tools for manipulating binaries (linker, assembler, etc.)
    man-pages             # Linux man-pages
    man-pages-posix       # POSIX man-pages
  ];
}
