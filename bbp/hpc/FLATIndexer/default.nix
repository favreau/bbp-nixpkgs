{ bbpsdk,
boost,
brion,
cmake,
config,
doxygen,
fetchgitPrivate,
hdf5,
lunchbox,
mpiRuntime,
numpy,
pandoc,
pkgconfig,
python,
servus,
sparsehash,
stdenv,
vmmlib,
zlib }:

stdenv.mkDerivation rec {
  name = "flatindexer-${version}";
  version = "1.8.11";
  meta = {
    description = "Spatial index";
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/building/FLATIndex";
    repository = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    license = {
      fullName = "Copyright 2018, Blue Brain Project";
    };
    maintainers = with config.maintainers; [
      tristan0x
    ];
  };

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/FLATIndex";
    rev = "${version}";
    sha256 = "0hbidg8ad5b3j32h809cln1fvwisrfykpmxx38bcx5lwsz5719xz";
  };

  buildInputs = [
    bbpsdk
    boost
    brion
    cmake
    doxygen
    hdf5
    lunchbox
    numpy
    pkgconfig
    python
    servus
    sparsehash
    stdenv
    vmmlib
    zlib
  ];
  cmakeFlags= [ "-DCOMMON_DISABLE_WERROR=TRUE" ];

  enableParallelBuilding = true;

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = [
       "mkdir -p $doc/share"
  ] ++ (stdenv.lib.optional) (pandoc != null) [ ''
    mkdir -p $out/share/doc/flatindexer/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.txt \
      -o $out/share/doc/flatindexer/html/index.html
  '' ];
  outputs = [ "out"  "doc" ];
}
