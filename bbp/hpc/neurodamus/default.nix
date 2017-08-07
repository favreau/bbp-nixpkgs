{ stdenv
, config
, which
, fetchgitPrivate
, pkgconfig
, hdf5
, mpiRuntime
, zlib
, ncurses
, reportinglib
, nrnEnv
, coreNeuronMode ? false
, branchName ? "default"
}:

assert coreNeuronMode -> (branchName == "default");
assert ( branchName != "default" ) -> (coreNeuronMode == false);

let
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;

  src-neuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "aff82c903a16439c8bfdb1e9fa8b4d43bc59c512";
        sha256 = "1vdklpc7494jnnm7z4a1194rw02z43iji0mlc1pjfz3j8i3yv5pq";
    };

  src-neuron-savestate = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "459425c22a627b906cc67c0a7ac616f73267fd0c";
        sha256 = "1gkzp2131g779n1y2p4bp26gqgh1m4vq5hvb69pvq0jlrl3kvn2v";
  };

  src-neuron-hippocampus = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "864c435eba776f450492509dc491c7201fcd03ad";
        sha256 = "12qlkzdq1gj5661mdsgbq4vpsxmi9zqqwm0rjp6pfnch4hsx2433";
  };



  src-coreneuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "d82001eea54ba1602b6c13c00d871b35b0292fed";
        sha256 = "0xm750bl9whdam2d8bpvixdp1gagq8c3vaxlf7bs9xyw4jmc814n";
  };


in

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201707";

    buildInputs = [ stdenv which pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


    src = if (coreNeuronMode) then src-coreneuron
		  else if ( branchName == "savestate" ) then src-neuron-savestate
          else if ( branchName == "hippocampus" ) then src-neuron-hippocampus
		  else if ( branchName == "default" ) then src-neuron
          else throw ( "neurodamus : not a valid branchName name " + branchName ) ;



    CFLAGS="-O2 -g";
    CXXFLAGS="-O2 -g";

    buildPhase = ''
        mkdir -p $out

        # copy hocs and modl
        cp -r ./lib/* $out/;

        cd lib

        # add additional flags

        ${if (isBGQ == true) then ''export CXXFLAGS="-qsmp ''${CXXFLAGS}" '' else ''''}
        ${if (isBGQ == true) then ''export CFLAGS="-qsmp ''${CFLAGS}" '' else ''''}

        # build
        echo "build using nrnivmodl $(which nrnivmodl) ..."
        nrnivmodl -incflags '-I ${reportinglib}/include -I ${hdf5}/include' -loadflags '-L${reportinglib}/lib -lreportinglib -L${hdf5}/lib -lhdf5' modlib

    '';


    installPhase = ''
        #refactor

        mkdir -p $out/{bin,lib,share}
        mv */special $out/bin/
        mv */.libs/*.so* $out/lib/ || true
        mv */.libs/*.a $out/lib/ || true


    '' + (if (isBGQ == false) then ''
        ## rename accordingly special mech path
        grep -v "\-dll" $out/bin/special > ./special.tmp
        cp ./special.tmp $out/bin/special
        echo " \"\''${NRNIV}\" -dll \"$out/lib/libnrnmech.so\" \"\$@\" " >> $out/bin/special
    '' else '' '');





    passthru = {
        src = src;
    };

    MODLUNIT="${nrnEnv}/share/nrn/lib/nrnunits.lib";

    # we need to patch the last line of special on not-BGQ paltforms
    # current one is not able to work outside of build directory
    # and reference statically this one
    postInstall = if isBGQ == false then
    ''
    ## rename accordingly special mech path
    grep -v "\-dll" $out/bin/special > ./special.tmp
    cp ./special.tmp $out/bin/special
    echo " \"\''${NRNIV}\" -dll \"$out/lib/libnrnmech.so\" \"\$@\" " >> $out/bin/special
    ## nrn mech is not installed properly by cmake
    mkdir -p $out/lib
    cp lib/*/*/.libs/*.so* $out/lib/
    ''
    else
    '' '';

    propagatedBuildInputs = [ which hdf5 reportinglib ];

}


