{ ... }:

{
  imports = [
    ../../modules/databases/tools/gui-clients.nix
    ../../modules/databases/sql/postgres.nix
    ../../modules/databases/sql/mysql.nix
    ../../modules/databases/sql/sqlite.nix
  ];
}
