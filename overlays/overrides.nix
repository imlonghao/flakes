channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    bgpq4 borgmatic cachix rage nixpkgs-fmt nomad deploy-rs teleport tuic
    owncast garage autorestic just netdata netdataCloud hysteria realm sing-box uv;

  haskellPackages = prev.haskellPackages.override (old: {
    overrides = prev.lib.composeExtensions (old.overrides or (_: _: { }))
      (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
  });
}
