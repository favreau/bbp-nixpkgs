{
    pkgs
}:


let 
      conflicts-modules = [ "mvapich2" "mvapich2-psm-x86_64" "openmpi" "gcc" "mpich2" ];
      generic-modules = rec {

      ## hpc components
      mvdtool = pkgs.envModuleGen rec {
            name = "mvd-tool";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;
            description = "MVD file format manipulation tool module generated by nix";
            packages = [
                            pkgs.mvdtool
                       ];
            conflicts = conflicts-modules;
      };  
      
      hpctools = pkgs.envModuleGen rec {
            name = "hpctools";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;
            description = "hpctools module generated by nix";
            packages = [
                            pkgs.hpctools
                       ];
            conflicts = conflicts-modules;
      };    
      
      functionalizer = pkgs.envModuleGen rec {
            name = "functionalizer";
            moduleFilePrefix = "nix/hpc";
            description = "functionalizer module generated by nix";
            packages = [
                            pkgs.functionalizer
                       ];
            conflicts =  conflicts-modules;
      };
      
      touchdetector = pkgs.envModuleGen rec {
            name = "touchdetector";
            moduleFilePrefix = "nix/hpc";
            description = "touchdetector module generated by nix";
            packages = [
                            pkgs.touchdetector
                       ];
            conflicts = conflicts-modules;
      };   
      
      bluebuilder = pkgs.envModuleGen rec {
            name = "bluebuilder";
            moduleFilePrefix = "nix/hpc";
            description = "bluebuilder module generated by nix";
            packages = [
                            pkgs.bluebuilder
                       ];
            conflicts = conflicts-modules;
      };
      
      neuron = pkgs.envModuleGen rec {
            name = "neuron";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;            
            description = "neuron module generated by nix";
            packages = [
                            pkgs.neuron             
                            pkgs.neurodamus           
                            pkgs.reportinglib
                            pkgs.readline
                            pkgs.ncurses  
                       ];
                       
            extraContent = "setenv BBP_HOME $targetEnv/";
            
            conflicts = conflicts-modules;
      };
      
      coreneuron = pkgs.envModuleGen rec {
            name = "coreneuron";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;            
            description = "neuron module generated by nix";
            packages = [
                            pkgs.coreneuron              
                       ];
            
            conflicts = conflicts-modules;
      };      
      
      steps = pkgs.envModuleGen rec {
            name = "steps";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;            
            description = "steps module generated by nix";
            packages = [
                            pkgs.steps-mpi
                       ];
            
            conflicts = conflicts-modules;
      };  
      
       
      nest = pkgs.envModuleGen rec {
            name = "nest";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;            
            description = "nest module generated by nix";
            packages = [
                            pkgs.nest
                       ];
            
            conflicts = conflicts-modules;
      };
      
      cyme = pkgs.envModuleGen rec {
            name = "cyme";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;            
            description = "cyme module generated by nix";
            packages = [
                            pkgs.cyme
                       ];
            
            conflicts = conflicts-modules;
      };
      
      mod2c = pkgs.envModuleGen rec {
            name = "mod2c";
            moduleFilePrefix = "nix/hpc";
            isLibrary = true;            
            description = "mod2c module generated by nix";
            packages = [
                            pkgs.mod2c
                       ];
            
            conflicts = conflicts-modules;
      };                  
      
      hpc = pkgs.envModuleGen {
            name = "HPCrelease";
            version = "201607";
            description = "load BBP HPC environment generated by nix";
            moduleFilePrefix = "BBP/hpc";
            packages = [ 
                            # circuit building
                            pkgs.functionalizer 
                            pkgs.touchdetector
                            pkgs.mvdtool
                            pkgs.highfive
                            pkgs.bluebuilder
                            pkgs.flatindexer

                            # cellular sim
                            pkgs.coreneuron
                            pkgs.mod2c
                            pkgs.neurodamus
                            pkgs.neuron
                            pkgs.reportinglib
                            pkgs.readline
                            pkgs.ncurses
        
                            # sub cellular sim
                            pkgs.steps-mpi

                            # point neuron
                            pkgs.nest

                            #utils
                            pkgs.bbp-mpi
                            
                            #python env for scientists
                            pkgs.python27Full                            
                            pkgs.python27Packages.numpy
                            pkgs.python27Packages.matplotlib
                            pkgs.python27Packages.six
                            pkgs.python27Packages.pandas
                                                        
                       ];
            extraContent = "setenv BBP_HOME $targetEnv/"; 
            
            conflicts = conflicts-modules;                      
      };

      ## viz components
      brion = pkgs.envModuleGen rec {
            name = "brion";
            moduleFilePrefix = "nix/viz";
            isLibrary = true;
            description = "Brion module generated by nix";
            packages = [
                            pkgs.brion
                       ];
            conflicts = conflicts-modules;
      };

      bbpsdk = pkgs.envModuleGen rec {
            name = "bbpsdk";
            moduleFilePrefix = "nix/viz";
            isLibrary = true;
            description = "BBPSDK module generated by nix";
            packages = [
                            pkgs.bbpsdk
                       ];
            conflicts = conflicts-modules;
      };

      
     ## std components 

      python27-light = with pkgs; envModuleGen rec {
            name = "python";
            version = "2.7-light";
            description = "minimalist python 2.7 module generated by nix";
            packages = let pythonPkgs = python27Packages;
                         in
                        [
                            # basic C/C++ bundle for pip 
                            gcc
                            stdenv
                            # python and module collection
                            pkgs.python 
                            pythonPkgs.pip
                            pythonPkgs.virtualenv
                       ];
            conflicts = [ python34-full python34-light ] ++ conflicts-modules;                           
      };
      
      python27-full = with pkgs; envModuleGen rec {
            name = "python";
            version = "2.7-full";
            isDefault = true;
            description = "complete python environment 2.7 generated by nix";
            packages = let pythonPkgs = python27Packages;
                         in
                        [
                            # basic C/C++ bundle for pip 
                            gcc
                            stdenv
                            # python and module collection
                            pkgs.python27Full 
                pythonPkgs.six
                            pythonPkgs.pip
                            pythonPkgs.virtualenv
                            pythonPkgs.numpy
                            pythonPkgs.pandas                            
                            pythonPkgs.matplotlib
                            pythonPkgs.six
                            pythonPkgs.pycurl
                            pythonPkgs.h5py
                       ];
            conflicts = [ python34-full python34-light ] ++ conflicts-modules;                           
      };      
      
      python34-light = pkgs.envModuleGen rec {
            name = "python";
            version = "3.4-light";
            description = "python 3.4 module generated by nix";
            packages = let pythonPkgs = pkgs.python34Packages;
                         in
                        [ 
                            pkgs.python34
                            pythonPkgs.pip
                            pythonPkgs.virtualenv
                       ];
            conflicts = [ python27-light python27-full ] ++ conflicts-modules;                          
      };
      
      
     python34-full = pkgs.envModuleGen rec {
            name = "python";
            version = "3.4-full";
            description = "python 3.4 module generated by nix";
            packages = let pythonPkgs = pkgs.python34Packages;
                         in
                        [ 
                            pkgs.python34
                            pythonPkgs.six
                            pythonPkgs.pip
                            pythonPkgs.virtualenv                             
                            pythonPkgs.numpy
                            pythonPkgs.pandas                            
                            pythonPkgs.pycurl
                            pythonPkgs.h5py
                       ];
            conflicts = [ python27-light python27-full ] ++ conflicts-modules;                          
      };
      
      cython = pkgs.envModuleGen rec {
            name = "cython";
            isLibrary = true;
            description = "cython module generated by nix";
            packages = [ 
                            pkgs.cython 
                       ];
            conflicts = conflicts-modules ++ [ "cython" ];
      }; 


      rust = pkgs.envModuleGen rec {
            name = "rust";
            version = "1.2";
            description = "rust platform module generated by nix";
            packages = [ 
                            pkgs.rustc
                            pkgs.cargo 
                       ];
      };    
 

      golang = pkgs.envModuleGen rec {
            name = "golang";
            version = "1.5";
            description = "golang and packages module generated by nix";
            packages = [ 
                            pkgs.goPackages.go
                            pkgs.goPackages.net
                            pkgs.goPackages.osext 
                       ];
      };  
      
      
      cmake = pkgs.envModuleGen rec {
            name = "cmake";
            version = "3.3";
            description = "cmake 3.3 module generated by nix";
            packages = [ 
                            pkgs.cmake 
                       ];
            conflicts = [ "cmake" ];
      };  
      
      boost = pkgs.envModuleGen rec {
            name = "boost";
            version = "1.57";
            isLibrary = true;
            description = "boost 1.57 module generated by nix";
            packages = [ 
                            pkgs.boost.dev pkgs.boost.lib
                       ];
            conflicts = conflicts-modules ++ [ "boost" ];
      };
      
      
      qt4 = pkgs.envModuleGen rec {
            name = "qt";
            isLibrary = true;
            description = "qt-4 module generated by nix";
            packages = [ 
                            pkgs.qt4
                       ];
            conflicts = conflicts-modules ++ [ "qt" ];
      };                
     
      openblas = pkgs.envModuleGen rec {
            name = "openblas";
            isLibrary = true;
            description = "openblas module generated by nix";
            packages = [
                            pkgs.openblas
                       ];
            conflicts = conflicts-modules;
      };

      folly = pkgs.envModuleGen rec {
            name = "folly";
            isLibrary = true;
	    	setRoot = "FOLLY";
            description = "folly module generated by nix";
            packages = [
                            pkgs.folly pkgs.openssl pkgs.glog pkgs.libevent 
                       ];
            conflicts = conflicts-modules;
      };

 
      mvapich2 = pkgs.envModuleGen rec {
            name = "mvapich2";
            isLibrary = true;
			isDefault = true;		
            description = "mvapich2 module generated by nix";
            packages = [ 
                            pkgs.mvapich2 
                            ## add slurm for libpmi dependencies
                            ## pkgs.slurm-llnl
                       ];
            conflicts = conflicts-modules;
      };

      mvapich2-rdma = pkgs.envModuleGen rec {
            name = "mvapich2-rdma";
            isLibrary = true;
			isDefault = true;		
            description = "mvapich2 module generated by nix";
            packages = [ 
                            pkgs.mvapich2-rdma
                            ## add slurm for libpmi dependencies
                            ## pkgs.slurm-llnl
                       ];
            conflicts = conflicts-modules;
      };
      
      hdf5 = pkgs.envModuleGen rec {
            name = "hdf5";
            isLibrary = true;
            setRoot = "HDF5";
            description = "hdf5 module generated by nix";
            packages = [ 
                            pkgs.hdf5 
                       ];
            conflicts = conflicts-modules ++ [ "hdf5" ];
      };
      
      readline = pkgs.envModuleGen rec {
            name = "readline";
            version = "6.3";
            isLibrary = true;
            setRoot = "READLINE";
            description = "readline module generated by nix";
            packages = [ 
                            pkgs.readline 
                       ];
            conflicts = conflicts-modules ++ [ "readline" ];
      };
      
      ncurses = pkgs.envModuleGen rec {
            name = "ncurses";
            isLibrary = true;
            version = "5.9";
            description = "ncureses module generated by nix";
            packages = [ 
                            pkgs.ncurses 
                       ];
            conflicts = conflicts-modules ++ [ "ncurses" ];
      }; 
     

      petsc = pkgs.envModuleGen rec {
            name = "petsc";
            version = "3.7";
            isLibrary = true;
            description = "PETSc module generated by nix";
            packages = [
                            pkgs.petsc
                       ];
            conflicts = conflicts-modules;
      };

 
      libxml2 = pkgs.envModuleGen rec {
            name = "libxml2";
            isLibrary = true;            
            description = "libxml2 module generated by nix";
            packages = [ 
                            pkgs.libxml2 
                       ];
            conflicts = conflicts-modules;
      };
      
               
      zlib = pkgs.envModuleGen rec {
            name = "zlib";
            version = "1.2.8";
            setRoot = "ZLIB";            
            isLibrary = true;            
            description = "zlib module generated by nix";
            packages = [ 
                            pkgs.zlib 
                       ];
            conflicts = conflicts-modules;
      };
      
      bison = pkgs.envModuleGen rec {
            name = "bison";
            version = "3.0.4";
            isLibrary = true;            
            description = "bison module generated by nix";
            packages = [ 
                            pkgs.bison 
                       ];
            conflicts = conflicts-modules;
      }; 
      
      flex = pkgs.envModuleGen rec {
            name = "flex";
            version = "2.5.39";
            isLibrary = true;            
            description = "flex module generated by nix";
            packages = [ 
                            pkgs.flex 
                       ];
            conflicts = conflicts-modules;
      };      
                  

      swig = pkgs.envModuleGen rec {
            name = "swig";
            version = "3.0.6";
            isLibrary = true;            
            description = "swig module generated by nix";
            packages = [ 
                            pkgs.swig
                       ];
            conflicts = conflicts-modules;
      };      
                  



      
      gcc52 = pkgs.envModuleGen rec {
            name = "gcc";
            version = "5.2.0";
            description = "gcc 5.2.0 module generated by nix";
            packages = [ 
                            pkgs.gcc5 
                       ];
            conflicts = [ gcc  clang];                             
      };   
      
      gcc = pkgs.envModuleGen rec {
            name = "gcc";
            version = "4.9.3";
            description = "gcc 4.9.3 module generated by nix";
            isDefault = true;
            packages = [ 
                            pkgs.gcc
                       ];
            conflicts = [ gcc52  clang];
      }; 
      
      clang = pkgs.envModuleGen rec {
            name = "clang";
            version= "3.6.2";
            description = "clang 3.6.2 module generated by nix";
            packages = [ 
                            pkgs.clang
                       ];
            conflicts = [ gcc  gcc52];                       
      };                
      
      
      R = pkgs.envModuleGen rec {
            name = "R";
            version = "3.2.2";
            description = "R module generated by nix";
            packages = [ 
                            pkgs.R
                       ];
      };
      


      
      all = pkgs.buildEnv {
        name = "all-modules";
        paths = [ boost mvapich2 hdf5 libxml2 zlib
                  openblas petsc folly
                  bison flex swig
                  R golang clang gcc gcc52 
                  cmake rust 
                  readline ncurses
                  python27-light python27-full python34-light python34-full cython
                  qt4
                  # viz team
                  brion bbpsdk
                  # hpc team
                  mvdtool hpctools functionalizer touchdetector bluebuilder neuron 
                  nest steps mod2c coreneuron
				  #rdma local specific
				  mvapich2-rdma
                ];
      };
     
     ## extra not portable softwares
     papi = pkgs.envModuleGen rec {
            name = "papi";
            isLibrary = true;            
            description = "papi module generated by nix";
            packages = [ 
                            pkgs.papi 
                       ];
            conflicts = conflicts-modules;
      }; 
      
     hpctoolkit = pkgs.envModuleGen rec {
            name = "hpctoolkit";
            isLibrary = true;            
            description = "hpctoolkit module generated by nix";
            packages = [ 
                            pkgs.hpctoolkit 
                       ];
            conflicts = conflicts-modules;
      }; 
      
    extra = pkgs.buildEnv {
        name = "extra-modules";
        paths = [ 
                papi 
                hpctoolkit
                ];
      };

};

bgq-modules =
(if  ((import ../../bluegene/portability.nix).isBlueGene == false)
then { }
else
with generic-modules; rec {

      bgq-gcc = pkgs.envModuleGen rec {
            name = "gcc";
            version = "4.1.4";
            moduleFilePrefix = "nix/bgq";
            description = "GCC compiler for BGQ backend  generated by nix";
            packages = [
                            pkgs.gcc-bgq
                       ];
      };


     bgq-boost = pkgs.envModuleGen rec {
            name = "boost";
            version = "1.57.0";
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "boost for BGQ backend  generated by nix";
            packages = [
                            pkgs.bgq-boost.dev pkgs.bgq-boost.lib
                       ];
      };

      bgq-mpich2 = pkgs.envModuleGen rec {
            name = "mpich2";
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "mpich for BGQ, Rob's forked version generated by nix";
            packages = [
                            pkgs.bg-mpich2.crossDrv
                       ];
      };


     bgq-hdf5 = pkgs.envModuleGen rec {
            name = "hdf5";
            moduleFilePrefix = "nix/bgq";
            setRoot = "HDF5";            
            isLibrary = true;
            description = "hdf5 for BGQ backend  generated by nix";
            packages = [
                            pkgs.bgq-hdf5
                       ];
      };


     bgq-libxml2 = pkgs.envModuleGen rec {
            name = "libxml2";
            version = "2.9.7";
            moduleFilePrefix = "nix/bgq";
            description = "libxml2 for BGQ backend  generated by nix";
            isLibrary = true;
            packages = [
                            pkgs.bgq-libxml2
                       ];
      };



      bgq-cmake = pkgs.envModuleGen rec {
            name = "cmake";
            version = "3.3.2";
            moduleFilePrefix = "nix/bgq";
            description = "cmake for BGQ backend  generated by nix";
            packages = [
                            pkgs.bgq-cmake
                       ];
      };

 


     bgq-zlib = pkgs.envModuleGen rec {
            name = "zlib";
            version = "1.2.8";
            setRoot = "ZLIB"; 
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "zlib for BGQ backend  generated by nix";
            packages = [
                            pkgs.bgq-zlib
                       ];
      };


     bgq-gcc47 = pkgs.envModuleGen rec {
            name = "gcc";
            version = "4.7.4";
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "GCC 4.7.4 in cross compiler mode for compiler for BGQ backend  generated by nix";
            packages = [
                            pkgs.bg-gcc47
                       ];
            conflicts = [ bgq-gcc ];
      };


     bgq-mpi-xlc = pkgs.envModuleGen rec {
            name = "xlc";
            version = "1.5";
            moduleFilePrefix = "nix/bgq/mpich2";
            isLibrary = true;
            description = "MPI with XLC compiler for BGQ backend  generated by nix";
            packages = [
                            pkgs.mpi-bgq
                       ];
            conflicts = [ bgq-gcc ];
      };


      bgq-python27-light = with pkgs; envModuleGen rec {
            name = "python";
            version = "2.7-light";
            moduleFilePrefix = "nix/bgq";
            description = "minimalist python 2.7 for BGQ backend generated by nix";
            packages = let pythonPkgs = python27Packages;
                         in
                        [
                            # basic C/C++ bundle for pip
                            pkgs.bg-gcc47
                            pkgs.bgq-stdenv-gcc47
                            # python and module collection
                            pkgs.bgq-python27-gcc47.crossDrv
                            #pythonPkgs.pip
                            #pythonPkgs.virtualenv
                       ];
            conflicts = [ bgq-python27-full  ] ++ conflicts-modules;
      };

      bgq-python27-full = with pkgs; envModuleGen rec {
            name = "python";
            version = "2.7-full";
	    isDefault = true;
            moduleFilePrefix = "nix/bgq";
            description = "minimalist python 2.7 for BGQ backend generated by nix";
            packages = let pythonPkgs = python27Packages;
                         in
                        [
                            # basic C/C++ bundle for pip
                            pkgs.bg-gcc47
                            pkgs.bgq-stdenv-gcc47
                            # python and module collection
                            pkgs.bgq-python27-gcc47.crossDrv
			    pkgs.bgq-pythonPackages-gcc47.bg-numpy.crossDrv
			    bgq-pythonPackages-gcc47.bg-mpi4py.crossDrv
			    bgq-pythonPackages-gcc47.bg-h5py.crossDrv
                       ];
            conflicts = [ bgq-python27-light ] ++ conflicts-modules;
      };


      bgq-openssl = pkgs.envModuleGen rec {
            name = "openssl";
	    version  = "1.0.1s";
            setRoot = "OPENSSL";
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "openssl for BGQ backend  generated by nix";
            packages = [
                            pkgs.all-pkgs-bgq-gcc47.openssl
                       ];
      };

      bgq-openblas = pkgs.envModuleGen rec {
            name = "openblas";
            setRoot = "OPENBLAS";
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "openblas for BGQ backend  generated by nix";
            packages = [
                            pkgs.bgq-openblas.crossDrv
                       ];
      };


      bgq-petsc = pkgs.envModuleGen rec {
            name = "petsc";
            setRoot = "PETSC";
            moduleFilePrefix = "nix/bgq";
            isLibrary = true;
            description = "petsc for BGQ backend  generated by nix";
            packages = [
                            pkgs.bgq-petsc-gcc47.crossDrv
                       ];
      };

      all = pkgs.buildEnv {
        name = "all-modules";
        paths = [ # bgq specific modules
                  bgq-gcc bgq-boost bgq-hdf5 bgq-libxml2 bgq-zlib
                  bgq-cmake bgq-gcc47 bgq-mpich2
                  gcc clang hdf5 boost cmake bison flex 

	       		  # bgq packages
                  bgq-python27-light bgq-python27-full 
				  bgq-openssl bgq-openblas bgq-petsc
 
                  # hpc team
                  mvdtool hpctools functionalizer touchdetector           
                 ];
      };

      hpc = pkgs.envModuleGen {
            name = "HPCrelease_BGQ";
            description = "load BBP HPC environment on BGQ module generated by nix";
            moduleFilePrefix = "BBP/hpc";            
            packages = [ 
                            pkgs.functionalizer 
                            pkgs.touchdetector
                            pkgs.bluebuilder                            
                            pkgs.highfive
                            pkgs.mvdtool                            

                            # cellular sim
                            pkgs.coreneuron
                            pkgs.mod2c
                            pkgs.neurodamus
                            pkgs.neuron
                            pkgs.reportinglib
                            pkgs.readline
                            pkgs.ncurses      
                       ];
            extraContent = "prepend-path BBP_HOME $targetEnv/";
     };



});

in 
  generic-modules // bgq-modules
