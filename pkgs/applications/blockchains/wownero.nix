{ stdenv, fetchFromGitHub, cmake, boost, miniupnpc_2, openssl, unbound
, readline, libsodium, rapidjson, fetchurl
}:

with stdenv.lib;

let
  randomwowVersion = "1.1.6";
  randomwow = fetchurl {
    url = "https://github.com/wownero/RandomWOW/archive/${randomwowVersion}.tar.gz";
    sha256 = "1c55y2dwrayh6k1avpchs89gq1mvy5c305h92jm2k48kzhw6a792";
  };
in

stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.8.0.0";

  src = fetchFromGitHub {
    owner = "wownero";
    repo = "wownero";
    rev    = "v${version}";
    sha256 = "14nggivilgzaqhjd4ng3g2p884yp2hc322hpcpwjdnz2zfc3qq6c";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost miniupnpc_2 openssl unbound rapidjson readline libsodium
  ];

  postUnpack = ''
    rm -r $sourceRoot/external/RandomWOW
    unpackFile ${randomwow}
    mv RandomWOW-${randomwowVersion} $sourceRoot/external/RandomWOW
  '';

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ];

  meta = {
    description = ''
      A privacy-centric memecoin that was fairly launched on April 1, 2018 with
      no pre-mine, stealth-mine or ICO
    '';
    longDescription = ''
      Wownero has a maximum supply of around 184 million WOW with a slow and
      steady emission over 50 years. It is a fork of Monero, but with its own
      genesis block, so there is no degradation of privacy due to ring
      signatures using different participants for the same tx outputs on
      opposing forks.
    '';
    homepage    = "https://wownero.org/";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ fuwa ];
  };
}
