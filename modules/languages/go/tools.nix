{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gopls          # Official Go Language Server
    delve          # Debugger for the Go programming language
    go-tools       # Additional tools (godoc, goimports, etc)
    golangci-lint  # Fast Go linters runner
    govulncheck    # Vulnerability scanner for Go
    gotestsum      # 'go test' runner with output optimized for humans
    air            # Live reload for Go apps
  ];
}
