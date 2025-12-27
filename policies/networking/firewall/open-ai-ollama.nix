{ ... }: {
  # Open Ollama API port (11434) to the network
  networking.firewall.allowedTCPPorts = [ 11434 ];
}
