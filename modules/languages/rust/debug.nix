{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lldb # LLVM debugger (Rust-friendly)
  ];
}
