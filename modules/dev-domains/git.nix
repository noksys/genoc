{ pkgs, ... }:

let
  git-sh = pkgs.stdenv.mkDerivation rec {
    pname = "git-sh";
    version = "1.4";

    src = pkgs.fetchFromGitHub {
      owner = "vlad2";
      repo = "git-sh";
      rev = "1.4";
      sha256 = "1w1r6b91dcr6n24i06y1rp2vw5rqnbrabzx2jqlf57gsjczanbjg";
    };

    buildInputs = [ pkgs.bash pkgs.ronn ];
    propagatedBuildInputs = [ pkgs.git ];

    buildPhase = ''
      make all
    '';

    installPhase = ''
      make install PREFIX=$out
    '';

    meta = with pkgs.lib; {
      description = "git-sh: A simple git shell environment";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    git             # Git CLI
    git-lfs         # Large file support
    git-crypt       # Repo encryption helper
    git-filter-repo # History rewrite tool
    tig             # TUI for Git
    gh              # GitHub CLI
    git-annex       # Content-addressed file manager
    git-sh          # Git shell environment
  ];
}
