{
  # Fixing cedilla ć -> ç (X11 only; avoid forcing IM modules in Wayland —
  # KDE Plasma 6 sessions handle compose natively).
  services.xserver.displayManager.sessionCommands = ''
    if [ "''${XDG_SESSION_TYPE}" = "x11" ]; then
      export QT_IM_MODULE=cedilla
      export GTK_IM_MODULE=cedilla
      export XMODIFIERS=@im=cedilla
      export XCOMPOSEFILE=/etc/XCompose
    fi
  '';

  # Avoid console.useXkbConfig: it injects a derivation into console.keyMap,
  # which breaks in 25.11+ where the option expects only string/path
  # (https://github.com/NixOS/nixpkgs/issues/411374).
  console.useXkbConfig = false;

  environment.etc."XCompose".text = ''
    # Cedilla
    <dead_acute> <c> : "ç"
    <dead_acute> <C> : "Ç"

    # Grave accent
    <dead_grave> <a> : "à"

    # Acute accent for vowels
    <dead_acute> <a> : "á"
    <dead_acute> <A> : "Á"
    <dead_acute> <e> : "é"
    <dead_acute> <E> : "É"
    <dead_acute> <i> : "í"
    <dead_acute> <I> : "Í"
    <dead_acute> <o> : "ó"
    <dead_acute> <O> : "Ó"
    <dead_acute> <u> : "ú"
    <dead_acute> <U> : "Ú"

    # Tilde (~) for vowels
    <dead_tilde> <a> : "ã"
    <dead_tilde> <A> : "Ã"
    <dead_tilde> <o> : "õ"
    <dead_tilde> <O> : "Õ"
    <dead_tilde> <n> : "ñ"
    <dead_tilde> <N> : "Ñ"

    # Circumflex (^) for vowels
    <dead_circumflex> <a> : "â"
    <dead_circumflex> <A> : "Â"
    <dead_circumflex> <e> : "ê"
    <dead_circumflex> <E> : "Ê"
    <dead_circumflex> <i> : "î"
    <dead_circumflex> <I> : "Î"
    <dead_circumflex> <o> : "ô"
    <dead_circumflex> <O> : "Ô"
    <dead_circumflex> <u> : "û"
    <dead_circumflex> <U> : "Û"

    # Display isolated accents when followed by space
    <dead_acute> <space> : "'"
    <dead_grave> <space> : "`"
    <dead_circumflex> <space> : "^"
    <dead_tilde> <space> : "~"
    <dead_diaeresis> <space> : "\""
  '';
}
