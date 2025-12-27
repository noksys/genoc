{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    redis                 # An open source, advanced key-value store
    mongodb-compass       # The GUI for MongoDB
    # mongosh             # MongoDB Shell (uncomment if needed)
    cassandra             # Database management system designed to handle large amounts of data
  ];
}
