{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    immudb                # Immutable database based on zero trust
    neo4j                 # Graph database management system
    clickhouse            # Column-oriented database management system
    # datomic             # (Proprietary/Unfree - requires nixpkgs config allowing unfree or custom overlay)
  ];
}
