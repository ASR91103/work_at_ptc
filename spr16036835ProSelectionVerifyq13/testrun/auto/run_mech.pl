#!$PTC_TOOLS/perl5/bin/$PRO_MACHINE_TYPE/perl
###########################################################################################
#
# Mechanica Running results script. 
# Usage: run_mech.pl <test_type> <test_name> <pro-e-run-cmd> <RUN_MODE> <GRAPHICS_MODE> <unknown_mode>
#
# 22-Jan-07  L-01-24  SJB  $$1  Handle new contact_nr_its argument to msengine.
# 13-Jul-09  L-05-01  PSG  $$2  Removed -modeltype engine command line option.
# 30-Sep-09  L-05-06  SJB  $$3  Fix for QATitgeng_pp test type.
# 25-Jul-23  Q-10-50  MKM       enable SAAS in simulate
# 18-Aug-23  Q-10-50  MKM       fixed arguments for Creo Plus
# 24-Aug-23  Q-11-31  MKM  $$4  fixed performance issue in Creo Plus
#
###########################################################################################

$Bin=($0 =~/(.+)\/.+$/);
use lib "$ENV{TOOLDIR}";  ### In Needham
use lib ($0 =~/(.+)\/.+$/); #add current directory to @INC
use File::Basename;
use File::Copy;
use testtp;
use dbgetc;

BEGIN {
    if ( $ENV{OS_TYPE} eq 'NT' ) {
        require timeout_nt; import timeout_nt;
    } else {
        require timeout_unix; import timeout_unix;
    }
}

my $test_type = $ARGV[0];

exit undef if (exists $ENV{'SIM_ONLY_DIFF'});
dprint("run_mech.pl --> $ARGV[1] $test_type");
SetEnvVars($test_type);  # Before doing anything, set Env Vars local/global
MakeSysLog();            # Create a log of all the Env Vars set
SavePropertyLibraries();
RunCommand();
RestorePropertyLibraries();

exit undef; # Or auto will fail all cases


#########################################################################################
# RECEIVES: Nothing
# RETURNS:  Nothing
# PURPOSE:  Rename property libraries in the home directory so they don't affect the test.
#########################################################################################
sub SavePropertyLibraries {
    my $HD = $ENV{'HOME'};
    if ( $ENV{OS_TYPE} eq 'NT' ) {
	$HD = $ENV{'HOMEDRIVE'} . $ENV{'HOMEPATH'};
    }
    my @libnames;
    push(@libnames, 'mspstf.lib');
    push(@libnames, 'mbmsct.lib');
    push(@libnames, 'mshlprp.lib');
    push(@libnames, 'mmatl.lib');

    for $i ( 0 .. 3 ) {
	my $fn = $HD . $sep . $libnames[$i];
	my $fn_saved = $fn . '_saved';
	if ( -e "$fn" ) { rename("$fn","$fn_saved"); }
    }
}

#########################################################################################
# RECEIVES: Nothing
# RETURNS:  Nothing
# PURPOSE:  Rename property libraries in the home directory so they don't affect the test.
#########################################################################################
sub RestorePropertyLibraries {
    my $HD = $ENV{'HOME'};
    if ( $ENV{OS_TYPE} eq 'NT' ) {
	$HD = $ENV{'HOMEDRIVE'} . $ENV{'HOMEPATH'};
    }
    my @libnames;
    push(@libnames, 'mspstf.lib');
    push(@libnames, 'mbmsct.lib');
    push(@libnames, 'mshlprp.lib');
    push(@libnames, 'mmatl.lib');

    for $i ( 0 .. 3 ) {
	my $fn = $HD . $sep . $libnames[$i];
	my $fn_saved = $fn . '_saved';
	if ( -e "$fn_saved" ) { rename("$fn_saved","$fn"); }
    }
}

#########################################################################################
# RECEIVES: 6 Strings
# RETURNS:  String
# PURPOSE:  Generate a launch command to run the case
#########################################################################################
sub RunCommand {

    my $MECHHOME       = $ENV{'MECH_HOME'};
    my $MECHBIN        = $MECHHOME . $sep . '..' . $sep . 'bin' . $sep;
	
    my $test_type;
    my $TestName;
    my $proe_cmd;
    my $run_mode;
    my $graphics_mode;
    my $unk_mode;
	
	if ($ENV{R_USE_CREO_PLUS} eq 'true')
    {
        $test_type      = $ARGV[0];
        $TestName       = $ARGV[1];
        $proe_cmd       = "$ARGV[2] $ARGV[3]";
        $run_mode       = $ARGV[4];
        $graphics_mode  = $ENV{R_GRAPHICS};
        $unk_mode       = $ARGV[6];
    }
    else
    {
        $test_type      = $ARGV[0];
        $TestName       = $ARGV[1];
        $proe_cmd       = $ARGV[2];
        $run_mode       = $ARGV[3];
        $graphics_mode  = $ENV{R_GRAPHICS};
        $unk_mode       = $ARGV[5];
	}
	
    my $MSeng_opts = $ENV{'MSENGINE_CL_OPPS'};
    my @Tmp       = split(/__/,$TestName);
    my $ModelName = $Tmp[$#Tmp];

    if ($TestTP{$test_type}==1) {
        if ( $test_type eq "ProETM" ) {
           if ( $ENV{OS_TYPE} eq 'NT' ) {
               SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt  -R$TestName.tm ");
           } else {
               eprint("ERROR: ProETM cases are only run on NT");
               exit(1);
           }
        } else {
            SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt ");
        }
    }

    elsif ($TestTP{$test_type}==2) {
        SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt ");
    }
    
    elsif ($TestTP{$test_type}==3){

         SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt ");

        # Need to set this here because Proe will not
        # run after these ENV settings are changed, but need to change them for standalone
	if ( $ENV{"OS_TYPE"} eq "NT" and not $ENV{SIM_NO_MECHLIB} ) {
            $ENV{'LIB'}             = $ENV{'MECH_HOME'} . $sep . 'lib';  
	} elsif ( not $ENV{SIM_NO_MECHLIB} ) {
	    if ( $test_type eq 'QATdvs_ug' or $test_type eq 'QATugs' or $test_type eq 'QATeng_ug' )
            {
                $ENV{'LD_LIBRARY_PATH'} = "$ENV{'MECH_HOME'} . $sep .'lib';$ENV{LD_LIBRARY_PATH}";
            }
            else
            {
                $ENV{'LD_LIBRARY_PATH'} = "$ENV{'MECH_HOME'} . $sep .'lib'";
            }
            $ENV{'LD_LIBRARYN32_PATH'} = $ENV{'MECH_HOME'} . $sep . 'lib';
            $ENV{'LD_LIBRARY64_PATH'}  = $ENV{'MECH_HOME'} . $sep . 'lib';
            $ENV{'SHLIB_PATH'}      = $ENV{'MECH_HOME'} . $sep . 'lib';
        }

        # Run standalone
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r GenLSM.scr ") if ( FileOK('-e',"$ModelName.mdb") ); # Install bug for Hamilton

        my ($Volumes, $Surfaces, $DynParts) = GetLSMValues('display1.lsm', 'volume', 'surface', 'dynamics_part') if ( FileOK('-e',"display1.lsm") ); # Install bug for Hamilton
        Replace('DoTopoCheck.scr', 'DoTopoCh.scr', '__VOLUMES__', $Volumes, '__SURFACES__', $Surfaces);
        Replace('topo_check.scr', 'topo_check.scr', '__DYN_PARTS__', $DynParts); 
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r DoTopoCh.scr ") if ( FileOK('-e',"DoTopoCh.scr") ); # Install bug for Hamilton
    }
    

    elsif ($TestTP{$test_type}==4) {
        SysTOCmd($MECHBIN."mmotion $ENV{'MECH_GRAPHICS'} -r $TestName.scr ");
    }

 
    elsif ($TestTP{$test_type}==5 || $TestTP{$test_type}==11 || $TestTP{$test_type}==12 ) {

        my $SKIP_TOPO_CHK = 0;
        if ( $test_type eq 'QATugs' ) {
            ### Generate lsm ###
            SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r ugs_lsm.scr ");

            ###Get Values From display1.lsm ###
            my ($Volumes, $Surfaces, $DynParts);
            if ( -e 'display1.lsm' )
            {
                ($Volumes, $Surfaces, $DynParts) = GetLSMValues('display1.lsm', 'volume', 'surface', 'dynamics_part');
                rename('display1.lsm','display1.lsm_setup');
            } else 
            {
                eprint("FILE MISSING: ugs_lsm.scr did not generate display1.lsm");
                exit(-1);
            }
        
            ###Edit and Run Main script ###
            if ( "$Volumes" or "$Surfaces") {
                Replace('ugs2.scr', "$TestName.scr" , '__P_Q__', $test_type, '__NAME__', $ModelName, '__VOLUMES__', $Volumes, '__SURFACES__', $Surfaces , '__DYNAMIC_PARTS__', $DynParts);
            } else {
                dprint("\tNo Volumes or Surfaces - Skipping Topo Check");
                $SKIP_TOPO_CHK = 1;
            }
        } 
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r $TestName.scr ") unless ( $test_type eq 'QATugs' and  $SKIP_TOPO_CHK ) ;
    }


    elsif ($TestTP{$test_type}==6) {
        SysTOCmd($MECHBIN."mtherm $ENV{'MECH_GRAPHICS'} -r $TestName.scr ");
    }

    elsif ($TestTP{$test_type}==7) {
        SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt ");

        # Need to set this here because Proe will not
        # run after these ENV settings are changed, but need to change them for standalone
	if ( $ENV{"OS_TYPE"} eq "NT" and not $ENV{SIM_NO_MECHLIB} ) 
        {
            $ENV{'LIB'}             = $ENV{'MECH_HOME'} . $sep . 'lib';  
	} elsif ( not $ENV{SIM_NO_MECHLIB} ) {
	        if ( $test_type eq 'QATdvs_ug' or $test_type eq 'QATugs' or $test_type eq 'QATeng_ug')
                {
	            $ENV{'LD_LIBRARY_PATH'}    = "$ENV{'MECH_HOME'} . $sep . 'lib';$ENV{LD_LIBRARY_PATH}";
                }
	        else
                {
	            $ENV{'LD_LIBRARY_PATH'}    = "$ENV{'MECH_HOME'} . $sep . 'lib'";
                }
            $ENV{'LD_LIBRARYN32_PATH'} = $ENV{'MECH_HOME'} . $sep . 'lib';
            $ENV{'LD_LIBRARY64_PATH'}  = $ENV{'MECH_HOME'} . $sep . 'lib';
            $ENV{'SHLIB_PATH'}         = $ENV{'MECH_HOME'} . $sep . 'lib';
        }

        # Run standalone
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r $TestName.scr ");
    }


    elsif ($TestTP{$test_type}==8 or $TestTP{$test_type}==17) {
        SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt ");        
        
        #Find correct mechbatch file
        my $mecbatch_file;
        if ( $ENV{"OS_TYPE"} eq "NT" ) {
            $mecbatch_file = 'mecbatch.bat';
        } else {
            $mecbatch_file = 'mecbatch';
        }
        
        if ( not defined $ENV{"R_USE_CREO_PLUS"} )
        {
            if (! FileOK('-f',$mecbatch_file) ) {
	        eprint("ERROR: mecbatch file was not created.\n");
                exit -1;
            } else {
                ReUseMesh($mecbatch_file) if ( $ENV{'REUSEMESH'} );
                if ( $ENV{'OS_TYPE'} eq 'UNIX' ) {
                    SysCmd("chmod 755 mecbatch");
                    SysTOCmd(".\/mecbatch >> Error.out 2>&1 ");
                } else {
                    SysTOCmd("$cur_dir\\mecbatch.bat >> Error.out 2>&1");
                }
            }
        }

        # Additional post-processing step for type QATitgeng_pp
        if ($TestTP{$test_type}==17) {
            SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode mech_pp.txt ");        
        }
    }


    elsif ($TestTP{$test_type}==9){
        # execute fakeui for each fui file
        local *DIR;
        my $Measures;
        my $TERM_ON_ERR = '-E';
        if (!-f "./mng.info") {&eprint("==> Error: mng.info file was not found.\n");
        } else {
            open(MNG_INFO,"mng.info");
            while (<MNG_INFO>) {
                
                ### Get a list of measures for motion engine to generate
                if(/MEASURES/) {    
                    my $Start_pos = index($_,'"') + 1;
                    my $End_pos   = rindex($_,'"');
                    $Measures     = substr($_, $Start_pos, $End_pos - $Start_pos);
                 } elsif ( /^\s*TERM_ON_ERR=\"(.*)\"/ ) {
                     $TERM_ON_ERR = $1;
                 }
                 
            }
            close(MNG_INFO);
            opendir(DIR,'.');
            while ($sdir=readdir(DIR)) {
                next if ($sdir eq '.' or $sdir eq '..');	
                next if (-d "$dir$sep$sdir"); # ignore directories
    	        if ( $sdir=~ /([0-9a-z_\.\-]+\.fui)$/i ) {
                    $nm = $1;
                    if ( $ENV{OS_TYPE} eq 'UNIX' ) {
    	                SysCmd($MECHHOME . $sep . 'bin' . $sep . "fakeui -O -N -PVA -FbH -C -G -J -Z8 $Measures $TERM_ON_ERR $nm > ProMech_$nm.out 2>&1");
                    } elsif ( $ENV{OS_TYPE} eq 'NT' ) {
                        SysCmd($MECHHOME . $sep . 'bin' . $sep . "fakeui -O -N -PVA -FbH -C -G -J -Z8 $Measures $TERM_ON_ERR $nm > ProMech_$nm.out 2>&1");
                    }
    	        }    
            }
            closedir(DIR);
        }
    }
    

    elsif ($TestTP{$test_type}==10) {
        my $DPIModelName = GetDPIModelName();

        SysTOCmd($MECHBIN."msengine $ModelName -dpi_cad_model_name $DPIModelName ") if ( $test_type eq "QATeng_link_asm"  or $test_type eq "QATeng_link_prt" or $test_type eq "QATeng_ug" );
        
        SysTOCmd($MECHBIN."msengine $ModelName $ENV{'MSENGINE_CL_OPPS'}") if ( $test_type eq 'QATeng' or $test_type eq 'QATengsi' );
    }

    
    elsif ($TestTP{$test_type}==13) {
        
        unlink("$ModelName.dat", "$ModelName.idx", "$ModelName.mdb", "display1.dvs");

        ### Generate First and Second LSM from IGS import
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r igs_lsm.scr ");

        ###Get Values From display1.lsm 
        my ($Volumes, $Surfaces, $DynParts) = GetLSMValues('display1.lsm', 'volume', 'surface', 'dynamics_part');
        my ($AvgNodeX, $AvgNodeY, $AvgNodeZ) = GetLSMValues('display1.lsm', 'average_node_X', 'average_node_Y', 'average_node_Z');
        
        ###Running Topo Check
        if ( "$Volumes" or "$Surfaces") {
            Replace('DoTopoCheck.scr', 'DoTopoCheck.scr', '__P_Q__', $test_type, '__NAME__', $ModelName, '__VOLUMES__', $Volumes, '__SURFACES__', $Surfaces);
            Replace('topo_check.scr', 'topo_check.scr', '__DYN_PARTS__', $DynParts); 
            SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r DoTopoCheck.scr ");
        } else {
            MeshGeomSKIP();
        }

        ###Do DV Check
        Replace('DoDVCheck.scr', 'DoDVCheck.scr', '__P_Q__', $test_type, '__NAME__', $ModelName, '__VOLUMES__', $Volumes, '__SURFACES__', $Surfaces);
        Replace('dv_check.scr', 'dv_check.scr', '__DYN_PARTS__', $DynParts, '__AVG_NODE_X__', $AvgNodeX, '__AVG_NODE_Y__', $AvgNodeY, '__AVG_NODE_Z__', $AvgNodeZ); 
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r DoDVCheck.scr ");

        ### IGES Export and then import
        unlink('export_1.igs', 'export_1.igl', 'import_1.igs');
        SysTOCmd($MECHBIN."mstruct $ENV{'MECH_GRAPHICS'} -r iges_export_import.scr ");
    } 
    
    elsif ($TestTP{$test_type}==14) {
        SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $TestName.txt");
    }

    elsif ($TestTP{$test_type}==15) {
        SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode QATmdx_perf.txt");
    }

    elsif ($TestTP{$test_type}==16) {
        SysTOCmd("/bin/ksh $MECHBIN" . "mstruct $ENV{'MECH_GRAPHICS'} -r cta.scr");
        my ($Volumes, $Surfaces, $DynParts) = GetLSMValues('display1.lsm', 'volume', 'surface', 'dynamics_part') if ( FileOK('-e',"display1.lsm") ); # Install bug for Hamilton
        Replace('DoTopoCheck.scr', 'DoTopoCh.scr', '__VOLUMES__', $Volumes, '__SURFACES__', $Surfaces);
        Replace('topo_check.scr', 'topo_check.scr', '__DYN_PARTS__', $DynParts);
        if ( $Volumes == 0 and $Surfaces == 0 ) {
            eprint("\tERROR: VOLUMES = $Volumes and SURFACES = $Surfaces");
            exit(1);
        }
        SysTOCmd($MECHBIN . "mstruct $ENV{'MECH_GRAPHICS'} -r DoTopoCh.scr ") if ( FileOK('-e',"DoTopoCh.scr") ); # Install bug for Hamilton
    }

    
    ## special QATdev type used only for developement purposes
    elsif ( $TestTP{$test_type} == 99 ) {
        my ( $PreScriptFail, $PostScriptFail);
        
        $PreScriptFail = SysCmd("$ENV{PTC_TOOLS}/perl5/bin/$ENV{PRO_MACHINE_TYPE}/perl $ENV{SIM_PRE_RUN} $TestName $cur_dir");
        
        if ( -f "$ENV{SIM_QATdev_FILE}" ) {
            my $stat = SysTOCmd("$proe_cmd $run_mode $graphics_mode $unk_mode $ENV{SIM_QATdev_FILE} ", 'DONT_EXIT');
            $stat = $stat ? "FAIL_STATUS" : "";
            $PostScriptFail = SysCmd("$ENV{PTC_TOOLS}/perl5/bin/$ENV{PRO_MACHINE_TYPE}/perl  $ENV{SIM_POST_RUN} $TestName $cur_dir $stat");
        } else {
            eprint("MISSING FILE: $ENV{SIM_QATdev_FILE}");
        }
    } 
    else {
      eprint("Type $test_type have not been implemented yet.");
    }
    dprint("\n");
}

######################################################################################################
# RECEIVES:   Nothing
# RETURNS:    Nothing
# PURPOSE:    Sets Enviroment Variables needed to run Case
######################################################################################################
sub SetEnvVars {

    #Get Global and Local Env Variables
    GetEnvVars('./EnvVars');  # *Old* Local to Case Env Vars
    GetEnvVars('./CASE.cfg'); #Local to Case Env Vars
    
    $ENV{SIM_TIMEOUT}      = 3500 if ( $ENV{SIM_TIMEOUT} !~ /^\d+$/ or $ENV{SIM_TIMEOUT} < 30 );
    $ENV{'DISPLAY'}        = $ENV{'SIM_DISPLAY'} if ( exists $ENV{'SIM_DISPLAY'} );
    
    $ENV{'MECH_DEBUG_MENU'}  = 'ON';
    $ENV{'MECH_NO_APPMGR'}   = '1';
    $ENV{'MM_TMPDIR'}        = $ENV{'TMPDIR'};
    $ENV{'MEDI_KEEP_FILES'}  = 'ON';
    $ENV{'PTEST_MECH_EXIT'}  = 'ON';
    $ENV{'PRINT_TERFILE'}    = 'ON';

    my $test_type            = shift;
    my $MECH_LIB             = $ENV{'MECH_HOME'} . $sep . 'lib' if ( not $ENV{SIM_NO_MECHLIB} );

    if ( $ENV{OS_TYPE} eq "UNIX" ){
        $ENV{'QAT_PRO_GFX'}                 ='OFF';
        $ENV{'MECH_DISABLE_REGEN_STOP_BTN'} ='1';
        $ENV{'NLS_LANG'}                    ='AMERICAN_AMERICA.US7ASCII';
        $ENV{'LD_LIBRARY_PATH'}             = $MECH_LIB . ':' . $ENV{'LD_LIBRARY_PATH'};
        $ENV{'SHLIB_PATH'}                  = $MECH_LIB . ':' . $ENV{'SHLIB_PATH'};
        if ( $ENV{PRO_MACHINE_TYPE} eq 'sgi_elf4' ) {
            $ENV{'LD_LIBRARYN32_PATH'}      = $MECH_LIB . ':' . $ENV{'LD_LIBRARYN32_PATH'} if ( exists $ENV{'LD_LIBRARYN32_PATH'} );
            $ENV{'LD_LIBRARY64_PATH'}       = $MECH_LIB . ':' . $ENV{'LD_LIBRARY64_PATH'}  if ( exists $ENV{'LD_LIBRARY64_PATH'}  );
        }
    } else {
        $ENV{'LIB'}                             = $MECH_LIB . ';' . $ENV{'LIB'};   
    }
   
    if ($TestTP{$test_type} == 3 or $TestTP{$test_type} == 11 or $TestTP{$test_type} == 13) {
        $ENV{'AV_QA_FILE'}       = 'autogem.qat';
	$ENV{'AV_QA_CHECK_GEOM'} = 'TRUE'                 if ( $TestTP{$test_type} != 11);
        $ENV{'QAT_MCAD_OPTS'}    = 'qa_topo qa_import'    if ( $TestTP{$test_type} == 3);       
        $ENV{'QAT_MCAD_OPTS'}    = ''                     if ( $TestTP{$test_type} == 11);

        
        if ($test_type eq 'QATigs_lsm'){
            $ENV{'QAT_MCAD_OPTS'}    = 'qa_topo qa_dv qa_cadrt igesrt';
        }
        
        if ( $test_type eq 'QATags' ) {
            $ENV{'QAT_REENTRANT_CORNERS'} = 'OFF';
            $ENV{'QAT_SURFACE_ONLY'}      = 'TRUE';
        }


        if ( $test_type eq 'QATigm_s' ) {
            $ENV{'QAT_REENTRANT_CORNERS'} = 'OFF';
            $ENV{'QAT_SURFACE_ONLY'}      = 'TRUE';
        }


        if ( $test_type eq 'QATigm_v' ) {
            $ENV{'QAT_REENTRANT_CORNERS'} ='ON';
        }
    }


    # For standalone, HOOPS conflicts with CADDS5 version, so un-set LD_LIBRARY_PATH
    if ( $TestTP{$test_type} == 5 || $TestTP{$test_type} == 6 ||
	$TestTP{$test_type} == 11 || $TestTP{$test_type} == 12 || $TestTP{$test_type} == 13) {
	if ( $ENV{"OS_TYPE"} ne "NT" and not $ENV{SIM_NO_MECHLIB}  ) {
	        if ( $test_type eq 'QATdvs_ug' or $test_type eq 'QATugs' or $test_type eq 'QATeng_ug') 
                {
	            $ENV{'LD_LIBRARY_PATH'} = "$MECH_LIB;$ENV{LD_LIBRARY_PATH}";
                }
	        else
                {
	            $ENV{'LD_LIBRARY_PATH'} = "$MECH_LIB";	            
                }
            $ENV{'SHLIB_PATH'} = "$MECH_LIB";
        }
    }


    if ( $TestTP{$test_type} == 7 ) {
        $ENV{'AV_QA_FILE'}            = 'autogem.qat';
        $ENV{'QAT_MCAD_OPTS'}         = 'qa_topo qa_import';
        $ENV{'QAT_REENTRANT_CORNERS'} = 'OFF';
        $ENV{'QAT_SURFACE_ONLY'}      = 'TRUE' if ( $test_type eq 'QATpgm_s');
    }

    if ( $TestTP{$test_type} == 14 ) {
       $ENV{'AV_QA_FILE'} = 'autogem.qat';
    }

    if ( $test_type eq 'QATugs') {
        $ENV{'AV_QA_FILE'}    = 'autogem.qat';
        $ENV{'QAT_MCAD_OPTS'} = 'qa_topo';
    }


    if ($test_type eq 'QATdxf'){
        $ENV{'QAT_MCAD_OPTS'} = 'qa_import';
        $ENV{'AV_QA_FILE'}    = 'autogem.qat';
    }

    if ( $test_type eq 'ProETM') {
        $ENV{PATH}              = $::ENV{TM_HOME} . $sep . 'obj;' . $::ENV{PATH};
        $ENV{MECH_HOME}         = $::ENV{TM_HOME} . $sep . '..' . $sep . 'TM_MECH' . $sep . $::ENV{PRO_MACHINE_TYPE};
        $ENV{PRO_RES_DIRECTORY} = $::ENV{TM_HOME} . $sep . 'resource';  ## This is a temp setting
        $ENV{USE_PRO_FILE_DLG}  = 'TRUE';
    }
    
    # Needed when running structure engine for these cases
    if ( not defined $ENV{'PRO_MECH_COMMAND'} ) 
    {
        $ENV{'PRO_MECH_COMMAND'} = $ENV{'PRO_DIRECTORY'} . $sep . 'bin' . $sep . 'pro.bat' if ( $ENV{'OS_TYPE'} eq 'NT') ;
        $ENV{'PRO_MECH_COMMAND'} = $ENV{'PRO_DIRECTORY'} . $sep . 'bin' . $sep . 'pro' if ( $ENV{'OS_TYPE'} eq 'UNIX') ;

#       $ENV{'PRO_MECH_COMMAND'} = $ARGV[2];
#       $ENV{'PRO_MECH_COMMAND'} .= '.exe' if ( $ENV{OS_TYPE} eq 'NT' and $ENV{'PRO_MECH_COMMAND'} !~ /\.exe$/ ); 
#   } elsif ( not -e $ENV{'PRO_MECH_COMMAND'} and -e  $ENV{'PRO_MECH_COMMAND'} . '.exe' ) {
#       eprint("ERROR: PRO_MECH_COMMAND not set correctly => $ENV{'PRO_MECH_COMMAND'}");

    }

    # Run in Iconified mode if Graphics mode is '0'
    if ( $ENV{R_GRAPHICS} == 0 ){
        $ENV{'MECH_GRAPHICS'} = '-i';
    } else {
        $ENV{'MECH_GRAPHICS'} = '';
    } 
}


######################################################################################################
# RECEIVES:   Name of mecbatch file
# RETURNS:    Nothing
# PURPOSE:    copies the mdb file in the Study directory of the standards to the study directory
#             of the regression run.  This forces the engine use the existing mesh and not remesh the 
#             model.
######################################################################################################
sub ReUseMesh {
    
    my $BatchFile = shift;
    my (@DesignStudyName, $Element, $ExistingMesh, $TargetFile, $MeshExt);
    my @lines = ReadFile($BatchFile);

    open(STDPATH, "std_path");
    # my $StdPath = readline STDPATH; #does not work on Itanium
    my @StdPathPrefix = <STDPATH>;
    chomp $StdPathPrefix[0];
    close(STDPATH);

    my $StdPath = $StdPathPrefix[0] . $sep . 'SO';

    foreach $Element ( @lines ) {
        if ( $Element =~ /msengine/ ) {
            # determine whether to copy an mdb file or an mda file.
            @DesignStudyName = split('"', $Element);
            $MeshExt = '.mda';
            $ExistingMesh = "$StdPath$sep$DesignStudyName[3]$sep$DesignStudyName[3]$MeshExt"; 
            if ( -e "$ExistingMesh") {
                # do nothing.
            } else {
                $MeshExt = '.mdb';
                $ExistingMesh = "$StdPath$sep$DesignStudyName[3]$sep$DesignStudyName[3]$MeshExt";
            }
            $TargetFile   = $DesignStudyName[3] . $sep . 'meshed_sdymdl.mdb';
            dprint("\t-----> Reusing Existing Mesh, copying  $ExistingMesh to $TargetFile");
            copy("$ExistingMesh","$TargetFile") or eprint("Could not copy $ExistingMesh to $TargetFile");

        }
    }
}


######################################################################################################
# RECEIVES:   Nothing
# RETURNS:    Nothing
# PURPOSE:    Generate a system log file.
######################################################################################################
sub MakeSysLog {
    my @arraykeys  = keys(%ENV);
    my ($EnvVar, $EnvValue);
    
    open(ENVFILE,">system.log") or die("$!");
    @arraykeys = sort(@arraykeys);
    foreach my $i ( @arraykeys){
        print ENVFILE "setenv $i \'$ENV{$i}\'\n";
    }
    close(ENVFILE);
}


#######################################################################################################
# RECEIVES:    Nothing 
# RETURNS:     String 
# PURPOSE:     Get the DPI Model Name for the current regression from the file DPIModel.txt
#######################################################################################################
sub GetDPIModelName {
   
    my (@ModelNames, $DPIName, $FilePath);
    $FilePath = 'DPIModel';

    if (-f "$FilePath" ) {
        open(FILE,"<$FilePath");
        while(<FILE>) {
            push(@ModelNames,$_);
        }
        close(FILE);
        $DPIName = $ModelNames[$#ModelNames];
    } else { 
        $DPIName = 'No_DPI_File_Found';
    }
    return $DPIName;
}


#######################################################################################################
# RECEIVES:    Config file name and options
# RETURNS:     Nothing
# PURPOSE:     Generates a config file with the arguments to the function.
#######################################################################################################
sub GenConfigFile {
    my $ConfigFileName = shift;   
    my @ConfigOptions = @_;
    open(FILE,">$ConfigFileName");
    foreach (@ConfigOptions) {
         print FILE "$_\n";
    }
    close(FILE);
}


#######################################################
#
# RECEIVES - File Path
# RETURNS  - Array of lines from file
# PURPOSE  - Read a file into an array 
#
########################################################
sub ReadFile{

    my $Path      = shift;
    my @FileLines = ();
    
    if ( -e "$Path" ){
        open(FILE, "$Path") or die "Cant open File $Path";
        @FileLines = <FILE>;
        close(FILE);
    }
    else {
         eprint( "Can't find file $Path\n");
         exit;
    }
    return @FileLines;
}
