{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dbeaver-bin           # Universal Database Manager and SQL Client
    dbgate                # Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others
  ];
}
