{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    racket # A programmable programming language
    guile  # GNU Ubiquitous Intelligent Language for Extensions
    chicken # A practical and portable Scheme system
  ];
}
