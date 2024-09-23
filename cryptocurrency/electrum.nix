{ config, lib, pkgs, ... }:

let
  # Define safetlib using the same Python version as Electrum
  safetlib = pkgs.python311Packages.buildPythonPackage rec {
    pname = "safetlib";
    version = "1.0.0";

    src = ./safet-0.1.4.tar.gz;

    propagatedBuildInputs = with pkgs.python311Packages; [
      click
      ecdsa
      hidapi
      libusb1
      mnemonic
      requests
      rlp
      setuptools
      wheel
    ];

    doCheck = false;
  };

  # Override Electrum to include safetlib
  electrumWithSafetlib = pkgs.electrum.overrideAttrs (oldAttrs: rec {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ safetlib ];
  });
in
{
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      electrumWithSafetlib
      libusb
      python3Full
      safetlib
      udev
    ])
  ];
}
