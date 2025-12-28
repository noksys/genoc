{ config, pkgs, lib, ... }:

{
  # Fixing cedilla ć -> ç (X11 only; avoid forcing IM modules in Wayland)
  services.xserver.displayManager.sessionCommands = ''
    if [ "''${XDG_SESSION_TYPE}" = "x11" ]; then
      export QT_IM_MODULE=cedilla
      export GTK_IM_MODULE=cedilla
      export XMODIFIERS=@im=cedilla
      export XCOMPOSEFILE=/etc/XCompose
    fi
  '';

  # Keyboard layouts: US Intl + PT-BR with Shift+Shift toggle.
  services.xserver.xkb = {
    layout = "us,br";
    variant = "intl,abnt2";
    options = "grp:shifts_toggle";
  };

  # Avoid console.useXkbConfig: it injects a derivation into console.keyMap,
  # which breaks in 25.11+ where the option expects only string/path.
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
  
  i18n.extraLocaleSettings ={
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
}
