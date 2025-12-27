{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sqlite                # A self-contained, serverless, zero-configuration, transactional SQL database engine
    sqlitebrowser         # DB Browser for SQLite
    usql                  # Universal command-line interface for SQL databases
  ];
}
