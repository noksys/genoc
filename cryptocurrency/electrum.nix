{ config, lib, pkgs, ... }:

let
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

  electrumWithSafetlib = pkgs.electrum.overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      pkgs.python311Packages.installer
      pkgs.python311Packages.pytest
      pkgs.protobuf
      pkgs.python311Packages.protobuf
    ];
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
      safetlib
      pkgs.python311Packages.attrs
      pkgs.python311Packages.aiohttp
      pkgs.python311Packages.aiohttp-socks
      pkgs.python311Packages.aiorpcx
      pkgs.python311Packages.dns
      pkgs.python311Packages.pycryptodomex
      pkgs.python311Packages.cryptography
      pkgs.python311Packages.jsonpatch
    ];
    NIX_CFLAGS_COMPILE = "-Wno-conversion";
  });
in
{
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      electrumWithSafetlib
      libusb1
      python3Full
      safetlib
      udev
    ])
  ];
}

