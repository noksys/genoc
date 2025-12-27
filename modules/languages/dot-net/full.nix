{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # C# / .NET
    dotnet-sdk_8
    omnisharp-roslyn
    
    # F#
    # (Included in dotnet-sdk usually)
    
    # PowerShell
    powershell
  ];
}
