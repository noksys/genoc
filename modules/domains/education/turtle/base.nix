{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kturtle # KDE educational Turtle graphics
    ucblogo # Logo interpreter
  ];
}
