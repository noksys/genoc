{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.kturtle # KDE educational Turtle graphics
    ucblogo # Logo interpreter
  ];
}
