let
  erlangReleases = builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.18-devel.tar.gz;

  pinnedNix =
    builtins.fetchGit {
      name = "nixpkgs-pinned";
      url = "https://github.com/NixOS/nixpkgs.git";
      rev = "e5f945b13b3f6a39ec9fbb66c9794b277dc32aa1";
    };

  purerlReleases =
    builtins.fetchGit {
      url = "https://github.com/purerl/nixpkgs-purerl.git";
      ref = "master";
      rev = "7eadeb83eb2590039c96386d572db3a2fce19370";
    };

  easy-ps = import
    (nixpkgs.pkgs.fetchFromGitHub {
      ## not merged yet for 0.15.3 https://github.com/justinwoo/easy-purescript-nix/pull/210
      owner = "toastal";
      repo = "easy-purescript-nix";
      rev = "ed00265f53ae3383a344ce642d40085601420455";
      sha256 = "sha256-X47A46YVcOFTsmi2lFr3yo7EaufBd4ufrTR+ZlPoYz0=";
    }) { pkgs = nixpkgs; };

  nixpkgs =
    import pinnedNix {
      overlays = [
        (import erlangReleases)
        (import purerlReleases)
      ];
    };


  erlangChannel = nixpkgs.nixerl.erlang-23-2-1.overrideScope' (self: super: {
    erlang = super.erlang.override {
      wxSupport = false;
    };
  });

in

with nixpkgs;

let
    inherit (stdenv.lib) optionals;
in

mkShell {
  buildInputs = with pkgs; [

    erlangChannel.erlang
    erlangChannel.rebar3
    erlangChannel.erlang-ls

    easy-ps.purs-0_15_3
    easy-ps.spago

    # Purerl backend for purescript
    purerl.purerl-0-0-17

  ];
}
