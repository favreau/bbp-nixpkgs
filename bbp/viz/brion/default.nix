{
 stdenv
, fetchgit
, boost
, cmake
, servus
, lunchbox
, keyv
, vmmlib
, pkgconfig
, hdf5-cpp
, highfive
, zlib
, mvdtool
, pythonPackages
, doxygen
, legacyVersion ? false
}:


let
    legacy-info = {
        version = "2.0-legacy";
        rev = "bea8f838bc6d4c9b40bf90d1cdacaa625bbabe7b";
        sha256 = "1qhs9dzq8j8bdssqhmnxm5hm7bl2h8zipavzqx2va1jwg5f2mnr6";
    };

    last-info = {
        version = "3.0-dev201809";
        rev = "1c4515ed1e20d321d098c03b081d39e637f31528";
        sha256 = "0p0903addvi719bxp30kaz64rxzhajavsq5hz6l3i5357wqycv42";
    };

    brion-info = if (legacyVersion) then legacy-info else last-info;

in
stdenv.mkDerivation rec {
    name = "brion-${version}";
    version = brion-info.version;

    buildInputs = [ stdenv pkgconfig mvdtool boost pythonPackages.python
                    pythonPackages.numpy pythonPackages.lxml
                    pythonPackages.sphinx_1_3 cmake vmmlib servus
                    lunchbox keyv hdf5-cpp highfive zlib doxygen ];

    src = fetchgit {
        url = "https://github.com/BlueBrain/Brion.git";
        rev = brion-info.rev;
        sha256 = brion-info.sha256;
    };

    patches = (stdenv.lib.optionals) (legacyVersion) [ ./brion-legacy-higfive.patch ];

    enableParallelBuilding = false; # memory consumption too high for python bindings generation

    cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

    makeFlags = [ "VERBOSE=1" ];

    propagatedBuildInputs = [ servus vmmlib boost
                              pythonPackages.python pythonPackages.numpy];

    passthru = {
        pythonModule = pythonPackages.python;
    };
}
