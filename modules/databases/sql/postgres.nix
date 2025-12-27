{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    postgresql_16         # Modern PostgreSQL engine
    pgcli                 # Postgres CLI with autocompletion and syntax highlighting
    pgadmin4              # Administration and development platform for PostgreSQL
  ];
}
