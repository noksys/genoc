{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Terminal Browsers
    w3m
    lynx
    elinks
    links2
    browsh # Modern web in terminal via headless firefox
    
    # Search Tools
    ddgr    # DuckDuckGo terminal client
    googler # Google terminal client

    # AI Tools
    tgpt # ChatGPT without API Key (web-like)
    # shell-gpt is usually a module import, handled separately if needed, 
    # but the package can be here too if the module just adds the package.
  ];
}
