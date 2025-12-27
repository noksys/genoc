{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ollama                # Get up and running with large language models locally
    llama-cpp             # Port of Facebook's LLaMA model in C/C++
    # local-ai            # (Check availability/overlay)
  ];
}
