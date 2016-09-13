# All BPP related pkgs
{
 std-pkgs,
 config
}:


let
    pkgFun = 
    pkgs:
      with pkgs;
      let 
		has_slurm = builtins.pathExists "/usr/bin/srun";
		bbp-mpi = if pkgs.isBlueGene == true then mpi-bgq
				else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2
				else mpich2;
		bbp-mpi-rdma = if pkgs.isBlueGene == true then mpi-bgq
				else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2-rdma 
				else mpich2;
		bbp-mpi-gcc = if pkgs.isBlueGene == true then bg-mpich2
                                else bbp-mpi;


		callPackage = newScope mergePkgs;
		enableBGQ-proto = caller: file: map:
		if mergePkgs.isBlueGene == true
			then (newScope (mergePkgs // map)) file
			else caller file;

		enableBGQ = caller: file: (enableBGQ-proto caller file mergePkgs.bgq-map);

		enableBGQ-gcc47 = caller: file: (enableBGQ-proto  caller file mergePkgs.bgq-map-gcc47);

		pkgsWithBGQGCC = if (pkgs.isBlueGene == true) then (pkgs // mergePkgs.bgq-map-gcc47) else pkgs;


		pkgsWithBGQXLC = if (pkgs.isBlueGene == true) then (pkgs // mergePkgs.bgq-map) else pkgs;

		nativeAllPkgs = pkgs;

		mergePkgs = pkgs // rec { 

		inherit bbp-mpi;

		## override component that need bbp-mpi
		petsc = pkgs.petsc.override {
			stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
			mpiRuntime = bbp-mpi-rdma;
		};

	

		##
		## git / cmake external for viz components
		##
		fetchgitExternal = callPackage ./config/fetchGitExternal{

		};   

		##
		## cmake externals for viz components
		## might cause not deterministic builds
		##
		cmake-external = callPackage ./config/cmake-external{

		};



		##
		## BBP common components
		##
		bbpsdk = callPackage ./common/bbpsdk {
 
		};

		vmmlib = callPackage ./common/vmmlib {   

		};         

		##
		## BBP viz components
		##
		servus = callPackage ./viz/servus {   

		};

		lunchbox = callPackage ./viz/lunchbox {   

		}; 

		brion = callPackage ./viz/brion {   

		}; 

		rtneuron = callPackage ./viz/rtneuron {   

		};  

		##
		## BBP HPC components
		##
		hpctools = enableBGQ callPackage ./hpc/hpctools { 

			mpiRuntime = bbp-mpi;
		}; 

		hpctools-gcc = enableBGQ-gcc47 callPackage ./hpc/hpctools { 

			mpiRuntime = bbp-mpi-gcc;
		}; 

		functionalizer = enableBGQ-gcc47 callPackage ./hpc/functionalizer { 
			 python = nativeAllPkgs.python;
			 pythonPackages = nativeAllPkgs.pythonPackages;
			 mpiRuntime = bbp-mpi-gcc;                
			 hpctools = hpctools-gcc;
		};  

		touchdetector = enableBGQ callPackage ./hpc/touchdetector {  
			 hpctools = hpctools;
			 mpiRuntime = bbp-mpi;  
		};

		bluebuilder = enableBGQ callPackage ./hpc/bluebuilder {
			mpiRuntime = bbp-mpi;
		};

		mvdtool = callPackage ./hpc/mvdTool { 

		};

		highfive = callPackage ./hpc/highfive {	
		
		};

		flatindexer = callPackage ./hpc/FLATIndexer {
			mpiRuntime = bbp-mpi; 
			numpy = pythonPackages.numpy;
		};
		  

		bbptestdata = callPackage ./tests/BBPTestData {

		};

		### simulation     

		cyme = callPackage ./hpc/cyme {

		};


		mod2c = callPackage ./hpc/mod2c {

		};

		coreneuron = enableBGQ callPackage ./hpc/coreneuron {
			mpiRuntime = bbp-mpi;      
		};

		bluron = enableBGQ callPackage ./hpc/bluron/cmake-build.nix {
			mpiRuntime = bbp-mpi;
		};


		neuron-modl = callPackage ./hpc/neuron {
			stdenv = (enableDebugInfo pkgsWithBGQXLC.stdenv);
			mpiRuntime = null;
			modlOnly = true;
		};

		neuron = enableBGQ callPackage ./hpc/neuron {
			stdenv = (enableDebugInfo pkgsWithBGQXLC.stdenv);
			mpiRuntime = bbp-mpi;
			nrnOnly = true;
			nrnModl = mergePkgs.neuron-modl;
		};


		reportinglib = enableBGQ callPackage ./hpc/reportinglib {
			mpiRuntime = bbp-mpi;      
		};

		neurodamus = enableBGQ callPackage ./hpc/neurodamus {
			mpiRuntime = bbp-mpi;  
			nrnEnv= mergePkgs.neuron;    
		};

		neuromapp = callPackage ./hpc/neuromapp {
			mpiRuntime = bbp-mpi;      
		};          

		mods-src = callPackage ./hpc/neurodamus/corebluron.nix{

		};



		nest = enableBGQ callPackage ./hpc/nest {
			mpiRuntime = bbp-mpi;
		};

		## 
		## sub-cellular simulation
		##

		rdmini = callPackage ./hpc/rdmini {
				ghc = haskellPackages.ghcWithPackages(haskellPackages:
				with haskellPackages; [
				#               hakyll_4_7_3_1
				#               regex-posix
				#               regex-pcre
				]);
		};

		steps = enableBGQ-gcc47 callPackage ./hpc/steps {
			stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
			mpiRuntime = bbp-mpi-rdma;
			numpy = if (mergePkgs.isBlueGene) then  mergePkgs.bgq-pythonPackages-gcc47.bg-numpy
				else pythonPackages.numpy;

            liblapack = if (mergePkgs.isBlueGene) then null
				  else liblapackWithoutAtlas;
		};

		steps-mpi = steps; # enable mpi by default 




		modules = (import ./modules) { pkgs = mergePkgs; };


		inherit enableBGQ;
        };
        in
        mergePkgs;
in
  (pkgFun std-pkgs)




