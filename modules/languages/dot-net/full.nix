{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # C# / .NET
    dotnet-sdk_8     # .NET SDK
    omnisharp-roslyn # C# language server
    
    # F#
    # (Included in dotnet-sdk usually)
    
    # PowerShell
    powershell       # PowerShell shell
  ];
}
