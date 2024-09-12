# Good Enough NixOS Configuration (GENOC).

I made this repository to store my own NixOS configurations, but it might be very useful for you as a beginner to have a starting point.

For advanced users, it could be an opportunity to keep their configurations more organized.

If you have any improvement suggestions, don't hesitate: fork the repository and submit a Pull Request.

## Installation
First, perform a fresh installation of NixOS.

Then, run the following commands:

```bash
sudo su
cd /etc/nixos
git clone git@github.com:noksys/genoc.git
./bin/install-genoc.sh
```

Follow the on-screen instructions.

You can safely run this on an existing NixOS installation. All files inside `/etc/nixos` will be backed up to `/etc/nixos/backup/<timestamp>_nixconf_backup.zip`.
