#!$PTC_TOOLS/perl5/bin/$PRO_MACHINE_TYPE/perl 

($Bin)=($0 =~/(.+)\/.+$/);
use lib "$ENV{TOOLDIR}";  ### In Needham
use lib ($0 =~/(.+)\/.+$/); #add current directory to @INC
use testtp;
use dbgetc;
use File::Basename;
use File::Copy;
use File::Compare;
use Cwd;

if ($sep eq '\\') {$SEP='\\\\';}
else              {$SEP=$sep};

###########################################################################################
# Mechanica diffing results script. 
#
# 02/22/05   Jean   $$1   Remove Pro/E files for spg
# 04/01/05   Jean   $$2   Fixed bug from previous change.
# 06/15/06   SJB    $$3   Fixed trail check.
# 12/20/06   SJB    $$4   Fixed trail check again.
# 03/05/07   adixit       RSM Changes.
# 04/19/07   adixit       RSM Changes for non-USASCII languages.
# 04/03/08   SJB    $$5   Check for version mismatch between Pro/E and Mechanica unless
#			  SIM_ALLOW_VERSION_MISMATCH is set.
# 01/12/10   SJB    $$6   Don't diff localized strings in .grt files for QATitgeng_pp tests.
# 02/17/10   SJB    $$7   Don't check for existence of SO directory.
# 03/05/10   SJB    $$8   Fix syntax error.
# 03/17/10   SJB    $$9   Add diffing of mapped mesh log (*.mlg) with i2sdiff.pl
# 07/13/10   SJB    $$10  Don't check for existence of SO directory for QATagm_awp and QATagm_srf tests.
# 02/28/11   SJB    $$11  Creo rebranding.
# 02/17/11   SJB    $$12  lsm file diffing for DGE-on-demand.
# 04/27/11   lli    $$13  Rebranding (Pro/ENGINEER -> Creo)
# 06-01-11   SJB    $$14  Fix timing issue with file access.
# 04-19-12   SJB    $$15  Move i2sdiff.pl from bin to auto so that $AUTOSIM_PATH works.
# 01-15-13   KDB    $$16  Check thread safety of sara evaluators.
# 01/23/13   MRC    $$17  rebranding to PTC Inc.
# 01/30/13   SJB    $$18  Introduce new test type QATitgms_pp
# 03/29/13   SJB    $$19  Support performance tests (#perf_test).
# 04/11/13   SJB    $$20  Fix last.
# 07/29/13   SJB    $$21  Undo #14 - fix at fdiff level.
# 04/01/15   KDB    $$22  In GetFilesToDiff(), added case insensitive check for SkipExt.
# 02/08/22   MKM    $$23  Fixed for inria test due to (MISSING: Local Standards Dir).
#
###########################################################################################

my (%DiffStatus, %DiffFiles, %DiffTol);

my $test_type = $ARGV[0];
my $test_name = $ARGV[1];
my @Tmp       = split(/__/, $test_name);
my $ModelName = $Tmp[$#Tmp];
my $ExitStatus  = 0;

dprint("diff_mech.pl -->  $test_name $test_type");

GetEnvVars('CASE.cfg');  # Set Local Env Vars
$ENV{MECH_HOME} = $ENV{MECH_LP} . $sep . $ENV{PRO_MACHINE_TYPE} if ( defined $ENV{MECH_LP} and -d $ENV{MECH_LP} ); 

my ( $RunSODir, $RunDir )  = GetDirs($cur_dir, $test_name, $test_type);
if ($ENV{R_PERF} eq 'true') {	# performance test
    # Generate .perf file from .stt file. This replaces the call to perf_results from auto.pl for xtop tests.
    GeneratePerfData($RunDir, $test_name);
    exit($ExitStatus);
}

my $dbgFile                = $RunDir . $sep . 'dbgfile.dat';
my $simFailFile            = $RunDir . $sep . 'sim_fail.dat';
my $SODir                  = GetSODir($RunDir);
my $PrevRunStdsDir         = GetPrevRunStdsDir($test_name, $test_type) if ( exists $ENV{'SIM_DIFF_AGAINST_RUN'});

dprint("\t$SODir --> SO Standards Directory");  # The 'SO' Sub-Directory that standards are kept 
dprint("\t$RunSODir --> Run SO Directory");     # The 'SO' directory under the Run Directory.
dprint("\t$RunDir --> Run Directory");          # The directory the test is/was run in.
dprint("\t$PrevRunStdsDir --> Diff against a previous run\n") if ( exists $ENV{'SIM_DIFF_AGAINST_RUN'} ); 


if ( TimedOut($simFailFile) ) {
    warn("WARNING: TEST TIMED-OUT ==> SKIPPING DIFFER");
    $ExitStatus = 6;

### If the Test Directory Does not exist; Should only be true when rediffing and user deleted/moved or did not save results
} elsif ( ! -d $RunDir  ) {
    eprint("MISSING: Local Run Dir => $RunDir");
} elsif ( ! -d $RunSODir and $test_type ne 'QATitgms' and $test_type ne 'QATitgms_pp' and $test_type ne 'QATagm_awp' and $test_type ne 'QATagm_srf' and $test_type ne 'QATinria') {
    eprint("MISSING: Local Standards Dir => $RunSODir");
    eprint("TEST TYPE => $test_type");
} elsif ( $test_type ne 'ProEQCR' ) {

    TrailFileError($RunDir, $test_name);
    TestThreadSafetyOfEvaluators($RunDir, $test_name);

    ### Process Skip and Must Exist Arrays to Global Hash ###
    SetDiffArrays($test_type); # Done in dbgetc.pm
    foreach (@SkipExt)        {$DiffStatus{$_} = 0;} 
    foreach (@MustExistExt)   {$DiffStatus{$_} = 1;}

    GetDiffOpts($RunDir . $sep . '..' . $sep . 'SIM.diffopts'); # Global Diff Opts file
    GetDiffOpts($RunDir . $sep . 'DiffOpts'); # *Old* Local Diff Opts File
    GetDiffOpts($RunDir . $sep . 'CASE.diffopts'); # Local Diff Opts file

    CopyLSMFiles($RunSODir, $RunDir, $test_type) if ( ! $ENV{'SIM_ONLY_DIFF'} );
    CheckRunFiles($RunDir, $test_type, $test_name, $ModelName);

    # Diff Files against SO Dir in Run Dir (This is needed because some Regrs copy lsm files to SOs. See CopyLSMFiles fxn.
    %DiffFiles = GetFilesToDiff($RunSODir, $RunDir, $PrevRunStdsDir, $test_type, %DiffStatus);
    %DiffFiles = ProcessDiffHash($RunSODir, $PrevRunStdsDir, %DiffFiles) if ( exists $ENV{'SIM_DIFF_AGAINST_RUN'} );
    DiffRunFiles($test_name, $test_type, $RunSODir, $RunDir, %DiffFiles);

    # Diff File against SO in Standards Dir
    unless ( -f '.obj_test' ) {
        if ( $ENV{R_ALT_SIM_STDS_PATH} ) {
            %DiffFiles = GetFilesToDiff($SODir, $RunDir, $RunSODir, $test_type, %DiffStatus);
        }
        else {
            %DiffFiles = GetFilesToDiff($SODir, $RunDir, $PrevRunStdsDir, $test_type, %DiffStatus);
        }        
        %DiffFiles = ProcessDiffHash($SODir, $PrevRunStdsDir, %DiffFiles) if ( exists $ENV{'SIM_DIFF_AGAINST_RUN'} );
        DiffRunFiles($test_name, $test_type, $SODir, $RunDir, %DiffFiles);
    }
} else {
    dprint("\tSO is not diffed for ProEQCR Cases");
}

ProcessReDiffedDirs($RunSODir, $RunDir, $cur_dir, $test_name, $test_type, $dbgFile, $simFailFile ) if ( $ENV{'SIM_ONLY_DIFF'} );
$ExitStatus = 6 if ( -s $simFailFile );
$ExitStatus = 6 if ( -s $dbgFile  and ( $ENV{LANG} eq 'C' or $ENV{'SIM_LANG_DIFF_QCR'} ) );

# delete all core files and delete all Pro/E files for spg
if ($ENV{'OS_TYPE'} eq 'UNIX') {
   $csh_cmd="csh -fc";
   $spgid=`$csh_cmd "genid"`;
   chop($spgid);
} else {
   if (defined $ENV{USERNAME}) {
      $spgid= $ENV{USERNAME};
   } else {
      $spgid= "spg";
   }
}

opendir(DIR,$RunDir) || die "No $RunDir?: $!";
while ($name=readdir(DIR)) {
    if ($name eq '.' or $name eq '..' ) {
        next;
    } elsif ( $name =~ /core(.?)\d*/ ) {
        unlink( $RunDir . $sep . $name );
    } elsif ( $name =~ /config\.pro|\.asm|\.cdm|\.dgm|\.drm|\.lay|\.mfg|\.prt|\.rep|\.sec|\.vda/) {
	if ($spgid eq "spg" || $spgid eq "spgreg") {
	   unlink( $RunDir . $sep . $name );
	}
    }
}
closedir(DIR);

SaveRun($RunDir, $test_name, $test_type, $ExitStatus) if ( not $ENV{'SIM_ONLY_DIFF'} );

exit($ExitStatus);


#*****************************************************************
# RECIEVES:  2 Strings
# RETURNS:   NOTHING
# PURPOSE:   Processes LSM Files Generated by the Run
#*****************************************************************
sub CopyLSMFiles {
    my $StdsDir  = shift;
    my $RunDir   = shift;
    my $TestType = shift;

    
    if (!-d "$StdsDir") {
        if ($TestType ne 'QATitgms' and $TestType ne 'QATitgms_pp' and $TestType ne 'QATagm_awp' and $TestType ne 'QATagm_srf' and $TestType ne 'QATinria') {
            eprint("MISSING Standards Dir $StdsDir\n");
            eprint("TEST TYPE => $TestType");
        }
        return; 
    }

    if ($TestTP{$TestType}==3) {
       eprint("MISSING FILE(S):  display1.lsm not Generated") if ( not -f 'display1.lsm');
       return;
    } elsif ($TestTP{$TestType}==5) {
        if ($TestType eq 'QATugs') {
            # These cases diff display1.lsm generated by the run with display2.lsm generated by the run.
            if (-f 'display1.lsm') {
                copy('display1.lsm',"$StdsDir$sep"."display2.lsm") or eprint("Could not copy display1.lsm to $StdsDir$sep display2.lsm" );
                dprint("\t-----> Copying display1.lsm to $StdsDir$sep" . 'display2.lsm'); 
            } else { 
                eprint("MISSING FILE:  display1.lsm Not Generated.");
                return;
            }

        }
    } elsif ($TestTP{$TestType} == 12 or $TestTP{$TestType} == 13) {
        # These cases diff display1.lsm generated by the run with display2.lsm and display3.lsm generated by the run.
        if (-f 'display1.lsm') {
            copy('display1.lsm',"$StdsDir$sep"."display2.lsm") or die "Can Not copy display1.lsm to $StdsDir$sep".'display2.lsm';
            dprint("\t-----> Copying display1.lsm to $StdsDir$sep".'display2.lsm');   
            copy('display1.lsm',"$StdsDir$sep"."display3.lsm") or die "Can Not copy display1.lsm to $StdsDir$sep" . 'display3.lsm';
            dprint("\t-----> Copying display1.lsm to $StdsDir$sep" . 'display3.lsm');
        } else {
            eprint("MISSING FILE:  display1.lsm Was Not Generated.");
            return;
        }
        if ( $TestTP{$TestType} == 13 ) {
            for $i ( 1 .. 3 ) { 
                my ($Points, $Curves) = GetLSMValues("display$i.lsm", 'point', 'curve');
                my $Total = $Points + $Curves;
                eprint("ERROR:  display$i.lsm Points + Curves = $Total") if ( $Total == 0 );
            }
        }
    } elsif ($TestTP{$TestType} == 16 ) {
        # These cases diff display1.lsm generated by the run with display2.lsm generated by the run.
        if (-f 'display1.lsm') {
            copy('display1.lsm',"$StdsDir$sep"."display2.lsm") or eprint("Could not copy display1.lsm to $StdsDir$sep display2.lsm" );
            dprint("\t-----> Copying display1.lsm to $StdsDir$sep" . 'display2.lsm'); 
        } else { 
             eprint("MISSING FILE:  display1.lsm Not Generated.");
             return;
        }
    }
}


#*****************************************************************
# RECIEVES:  2 Strings
# RETURNS:   NOTHING
# PURPOSE:   Processes Files Generated by the Run and check for errors
#*****************************************************************
sub CheckRunFiles {
    my $RunDir    = shift;
    my $TestType  = shift;
    my $TestName  = shift;
    my $ModelName = shift;

    if ($TestTP{$TestType}==3) {
        MeshGeomOK($RunDir);
        eprint("ERROR:  Hisfile.txt was Generated")  if ( -f 'Hisfile.txt');

    } elsif ($TestTP{$TestType}==5) {
        if ($TestType eq 'QATugs') {
            MeshGeomOK($RunDir);
            MNLCheck($ModelName, $RunDir);
            eprint("ERROR:  Hisfile.txt was Generated")  if ( -f 'Hisfile.txt');
       }
    } elsif ($TestTP{$TestType} == 7) {
        MeshOK($RunDir);
        eprint("ERROR:  Hisfile.txt was Generated")  if ( -f 'Hisfile.txt');
    } elsif ($TestTP{$TestType}==11) {
        MeshOK($RunDir);
    } elsif ($TestTP{$TestType}==13){
        MeshGeomOK($RunDir);
        DVCheckOK($RunDir . $sep . 'display1.dvs');
    } elsif ($TestTP{$TestType}==14) {
      
        if ( $test_type eq 'QATagm_srf' or $test_type eq 'QATagm_awp') {  
	    ### Only run for english regressions ###
	    if ( $ENV{LANG} eq 'C' or undef $ENV{LANG}  ) {
		open(FILE,  $TestName . '.new') or eprint "Could not open $TestName'.new': $!";
		my $elemsCopied = 0;
		foreach my $line ( <FILE> ) {
		    if ( $line =~ /Successfully copied elements from an existing mesh file/i ) {
			$elemsCopied = 1;
			dprint("\tElements Copied Successfully($TestName.new)");
			last;
		    }
		}
		eprint("ERROR: Elements failed to copy from existing mesh file($TestName.new)") if ( not $elemsCopied );
		close(FILE);
	    }

	    MeshOK($RunDir);
        } elsif ( $test_type eq 'QATinria') {
	    ### Only run for english regressions ###
            if ( $ENV{LANG} eq 'C' or undef $ENV{LANG}  ) {
                open(FILE,  $TestName . '.new') or eprint "Could not open $TestName'.new': $!";
                my $meshedinFEM = 0;
                foreach my $line ( <FILE> ) {
                    if ( $line =~ /A total of \d+ elements and \d+ nodes were created/ ) {
                        $meshedinFEM = 1;
                        dprint("\tCreated FEM Mesh Successfully($TestName.new)");
                        last;
                    }
                }
                eprint("ERROR: Failed to mesh the model($TestName.new)") if ( not $meshedinFEM );
                close(FILE);
            }

        }
    } elsif ($TestTP{$TestType} == 16) {
        MeshGeomOK($RunDir);
        MNLCheck($ModelName, $RunDir);
        eprint("ERROR:  Hisfile.txt was Generated")  if ( -f 'Hisfile.txt');
    }

    ### For DPI Mapping test ###
    my $DPI_File = $RunDir . $sep . 'AV_DEBUG_MAPPING.out';
    if ( -e $DPI_File  ) {
        my @FileLines = ReadFile($DPI_File);
        if ( @FileLines == 2 ) {
            dprint("\t$DPI_File Okay");
        } else {
            eprint("ERROR:  DPI Mapping Failed => $DPI_File @FileLines Lines");
        }
    }
}


#*****************************************************************
# RECIEVES:  4 Strings and a hash of files to diff.
# RETURNS:   NOTHING
# PURPOSE:   Creates and executes Diff command. Then, it checks
#            the output of the differ in the $RESULTS_FILE_NAME.
#*****************************************************************
sub DiffRunFiles {

    my ($cmd, $FileExt);
    
    my $TestName          = shift;
    my $CaseType          = shift;
    my $StdsDir           = shift;
    my $RunDir            = shift;
    my %DiffFiles         = @_;             #  Key -> File Standard Path      Value -> Run File Pat

    my $RESULTS_FILE_NAME = 'ResultsTempFile';
    my $STDERROR_FILE     = 'Error.out';
    dprint(); # Format of command.log file
    
    if ( keys(%DiffFiles) >= 0 ) {
        exit(6) unless ( DiffersOK() );
    }

    my $reportQcr = 0;
    foreach ( keys(%DiffFiles)){

        my ($FMF, $Differ, $DiffTolVar);
        my $SysCmdOpt = '';
        my $PathToPerl = '';
        my ($StudyDir, $AnalysisDir) = (m/$TestName[\\\/][Ss][Oo][\\\/](\w+)[\\\/](\w+)/); 
     
        if (! -f $DiffFiles{$_} ){
            eprint("ERROR:  MISSING $DiffFiles{$_}");
        } else {
            my $i2sdiffer_for_Non_USASCII_Lang = 0;
            $Std     = $_;
            $RunFile = $DiffFiles{$_};
            $FileExt = GetFtype($_);
            $Differ  = GetDiffer($CaseType,$FileExt);

            # Skips all file types except .res files when SIM_DIFF_ONLY_RES is set.
            next if ( $ENV{SIM_DIFF_RES_ONLY} == 1 and $FileExt ne 'res' and ( $TestTP{$CaseType} == 8 or $TestTP{$CaseType} == 10 or $TestTP{$CaseType} == 17 ) );
           
            ### Get correct diff tolerance key for given file type
            my $DiffTolKey;
            foreach my $Key ( keys(%DiffTol) )
            {
                if ( $FileExt =~ /$Key$/ )
                {
                    $DiffTolKey = $Key;
                    last;
                }
            }
          
           ($Std,$RunFile) = RemoveStrings($Std,$RunFile) if ( $ENV{LANG} ne 'C' and $FileExt eq 'grt' and $CaseType =~ /^QATitgms_pp|QATitgms|QATitgeng_pp$/i );
           ($Std,$RunFile) = DMIG_File($Std,$RunFile) if ( $FileExt eq 'dmig' );
           
            ### For resdiff and measdiff there are no outfile file arguments!!!
            if ($Differ =~ /resdiff$/) {
                $DiffTolVar = "-i $DiffTol{$DiffTolKey}" if ( ($DiffTol{$DiffTolKey}) );
                $DiffTolVar .= " -r " if  ( $CaseType =~ /^QATitgmm|QATscrmm$/ );
            } elsif ( $Differ =~ /measdiff$/ ) {
                delete($ENV{MEASDIFF_PRINT_ALL});
		@RC = split(/\\/, $RunFile) if ( $ENV{'OS_TYPE'} eq 'NT' );
		@RC = split(/\//, $RunFile) if ( $ENV{'OS_TYPE'} eq 'UNIX' );
                $AnalysisName = $RC[$#RC-1];
                $MEASDIFF_MCFG = $RunDir . $sep . $AnalysisName . '.mcfg';
                $SysCmdOpt = $MEASDIFF_MCFG if ( -f $MEASDIFF_MCFG ); # This should point to optional config file for use with measdiff
                $ENV{MEASDIFF_RECONFIG} = $AnalysisDir . '.rcfg';
            } elsif ( $Differ =~ /fdiff$/ ) {
                $FMF         = GetFMF($StudyDir, $AnalysisDir, $CaseType, $StdsDir, $FileExt );
                $SysCmdOpt   = $RESULTS_FILE_NAME; # This sets the output file name for fdiff
                if ( $DiffTol{$DiffTolKey} =~ /-z|-t/ ) {
                    $DiffTolVar  = " $DiffTol{$DiffTolKey} ";
                } elsif ( exists $DiffTol{$DiffTolKey} ) { 
                    $DiffTolVar  = " -z $DiffTol{$DiffTolKey} " if ( exists($DiffTol{$DiffTolKey}) );
                }
                $DiffTolVar .= " -i " if ( ($CaseType eq 'QATitg_eng' or $CaseType eq 'QATitgeng_pp') and not $ENV{SIM_DIFF_DBID} and $ENV{P_VERSION} > 230 );
            } elsif ( $Differ =~ /i2sdiff/ ) {
                        $PathToPerl = "$ENV{PTC_TOOLS}/perl5/bin/$ENV{PRO_MACHINE_TYPE}/perl ";
                        $SysCmdOpt = '';
                        $DiffTolVar = '';
                        $FMF = '';
              }
            else {
                eprint("ERROR:  Unknown differ -> $Differ");
            }

            ### Motion engine regression diffing always uses resdiff
            if ( $TestTP{$CaseType} == 9 ){   
                my $PercentTol;
                
                $DiffTolVar = "-i 5e-3" if ( not defined $DiffTolVar ); #Set default tolerance
                if ($FileExt =~ /^m$|^fb$|^a$|^fhn$/ ) { 
                    $PercentTol = "-p 1";
                } else {
                    $PercentTol = "-p .1";
                }
                $cmd = "$Differ $PercentTol $DiffTolVar -m 10 -P $Std $RunFile 2> $STDERROR_FILE";

            ### All Normal Cases
            } else {
                if ( $Differ =~ /i2sdiff/ ) {
                    $Differ = $PathToPerl . $Differ;
                    if ( $ENV{LANG} ne 'C' ) {
                        $i2sdiffer_for_Non_USASCII_Lang = 1;
                    }
                }
                $cmd = "$Differ $DiffTolVar $FMF $Std $RunFile $SysCmdOpt 2> $STDERROR_FILE";
              }
           ### No RSM comparison for non-usascii languages
           if ( not $i2sdiffer_for_Non_USASCII_Lang )
           {
              $cmd =~ s/\s{2,}/ /g; # removes extra spaces (produced by empty option strings) in the diff command
              $DiffResults = `$cmd`;
              dprint ("\t$cmd");
           }

            ### Print Diff results to file only when resdiff or measdiff are used as the DIFFER 
            ### fdiff write results to file by default.
            if ($DiffResults){
                open(FILE, ">$RESULTS_FILE_NAME") or die "Can not open file to write: $!";
                print FILE "$DiffResults\n";
                close(FILE);
            }

            ### Okay if extra entities in the test file
            if (-s $RESULTS_FILE_NAME) {
                
                my $diff_errs=0;
                my $i = 0;
                my @FileLn;
                open(TFILE, "<$RESULTS_FILE_NAME") or die "Can not open file to read: $!";
                @FileLn = <TFILE>;
                close TFILE;

                LINE_LOOP: until ( $i > $#FileLn ){
                    chomp $FileLn[$i];
                    if ( $FileLn[$i] =~ /^\s*$/ ) {  #Skip blank lines
                        $i++;
                        next LINE_LOOP;
                    }
                    if ( $FileLn[$i] =~ /^Extra entities/ ) {  #Skip extra entities
                        until ( $i > $#FileLn ){
                            if ( $FileLn[$i] =~ /^\s*$|^\s*<\w\w\w>/ ) {
                                next LINE_LOOP;
                            }
                            $i++;   
                        }
                        next LINE_LOOP;
                    }
                    $diff_errs=1;
 		    last LINE_LOOP;
 	        }
                
 	        if ($diff_errs==1) {
                    $reportQcr = 1;
                    eprint("FAILURE:  $Std $RunFile");
		    ecat($RESULTS_FILE_NAME);
 	        } else {
                    if ( not $i2sdiffer_for_Non_USASCII_Lang ) {
                        dprint("\t-----> PASSED DIFF");
                    }
                }

            } else { 
                if ( not $i2sdiffer_for_Non_USASCII_Lang ) {
                    dprint("\t-----> PASSED DIFF");
                }
            }
        }
        
        if ( -s $STDERROR_FILE ) {
            ecat($STDERROR_FILE);
            unlink($STDERROR_FILE);
        }
        unlink($RESULTS_FILE_NAME) if ( -f $RESULTS_FILE_NAME );
    }

    ### Write message for regDB to report this as a QCR failure.
    if ($reportQcr == 1) {
        eprint("qcr file comparison has errors");
    } 
} 


################################################################################
#
# RECIEVES: 4 strings( Standards Directory, Run Directory, Test name, Test Type
#                     Diff Run Directory )
#           Hash ( key = file patterns to match, value = to skip 
#           or check exitance)
# RETURNS:  Hash of file pairs to diff
# PURPOSE:  Search Recursively down through the Stds directory 
#           Tree for files to diff. Checks 'exist' files and 
#           skips 'skip' files. 
#
################################################################################
sub GetFilesToDiff {
    
    my $StdDir     = shift;
    my $RunDir     = shift;
    my $DiffRun    = shift;
    my $TestType   = shift;
    my %DiffStatus = @_;

    my ($i, $j, @DirList, %DiffList );

    if (opendir(SDIR, "$StdDir")) {
        @DirList = readdir(SDIR);
        closedir(SDIR);
    } else {
        if ($TestType eq 'QATitgms' or $TestType eq 'QATitgms_pp' or $TestType eq 'QATagm_awp' or $TestType eq 'QATagm_srf' or $TestType eq 'QATinria') {
            return %DiffList;
        } else {
            eprint("Can not open $StdDir: $!"); 
            eprint("TEST TYPE => $TestType"); 
        }
    }

    for $i ( 0 .. $#DirList ) {
        my $CurrentStdDirEntry  = $StdDir . $sep . $DirList[$i];
        my $CurrentRunDirEntry  = $RunDir . $sep . $DirList[$i];
        my $CurrentDiffRunEntry = $DiffRun . $sep . $DirList[$i];
        
        if ( exists $ENV{SIM_DIFF_AGAINST_RUN} and not -e $CurrentDiffRunEntry ) {
            dprint("\t-----> Skipping $DirList[$i] because $CurrentDiffRunEntry does not exist");
            next;
        }
        
        if ( -d $CurrentStdDirEntry and $DirList[$i] =~ m/[^.]/ ) {
            
            ### recursive call if $CurrentDirEntry is directory ###
            dprint "\n\tProcessing Dir ---> $CurrentStdDirEntry";
            my %DiffListR = GetFilesToDiff($CurrentStdDirEntry, $CurrentRunDirEntry, $CurrentDiffRunEntry, $TestType, %DiffStatus);  	    
            foreach ( keys(%DiffListR)) {
                $DiffList{"$_"} = $DiffListR{"$_"};
            }
        

        # Go through %DiffStatus Keys to check for match and then do Skip or Exist check or add to DiffList           
        } elsif ( -f $CurrentStdDirEntry and $DirList[$i] =~ m/[^.]/ ) {

            my @keys = keys(%DiffStatus); 
            for $j ( 0 .. $#keys ) {
                if ( $DirList[$i] =~ m"$keys[$j]"i ) {
                    if ( $DiffStatus{$keys[$j]} == 0 ) {
                        dprint("\t-----> Skipping $CurrentStdDirEntry - matched $keys[$j]");    
                    }

                    if ( $DiffStatus{$keys[$j]} == 1 ) { 
                        if ( -f $CurrentRunDirEntry ) {
                            dprint("\t-----> Exists   $CurrentRunDirEntry - matched $keys[$j]");    
                        } else {
                            eprint("ERROR:  MISSING $CurrentRunDirEntry");
                        }
                    }
                    last;
                
                } elsif ( $j == $#keys) {
		            if ( -f $CurrentDiffRunEntry and exists $ENV{R_ALT_SIM_STDS_PATH}) {		        
			            next;
		            }
                    $DiffList{$CurrentStdDirEntry} = $CurrentRunDirEntry;
                }
            }
        }
    }
    return %DiffList;
}

#*******************************************************************
# RECIEVES:  4 Strings 
# RETURNS:   NOTHING
# PURPOSE:   Determines if and where the results file will be copied
#*******************************************************************
sub SaveRun {

    my $RunDir     = shift;
    my $test_name  = shift;
    my $test_type  = shift;
    my $exitStatus = shift;

    my ( $Pass_TDir, $Review_TDir, $Fail_TDir);

    my $ERROUT  = $RunDir . $sep . 'std.err';
    my $STDOUT  = $RunDir . $sep . 'std.out';
    my $MSGFILE = $RunDir . $sep . $test_name . '.msg'; 

    rename($STDOUT, $MSGFILE) if ( -f $STDOUT ); 
    `cat $ERROUT >> $MSGFILE` if ( -f $ERROUT );
    unlink($ERROUT);
    
    if ( defined $ENV{SIM_LCH_DIR} ) {
        ### Needed for saving results when running dauto
        $Pass_TDir     =  $ENV{SIM_LCH_DIR} . $sep . $test_name;
        $Review_TDir   =  $ENV{SIM_LCH_DIR} . $sep . $test_name;
        $Fail_TDir     =  $ENV{SIM_LCH_DIR} . $sep . $test_name;
        ################################################
    } else {
        $Pass_TDir     =  '..' . $sep . 'P_' . $test_name;
        $Review_TDir   =  '..' . $sep . $test_name;
        $Fail_TDir     =  '..' . $sep . $test_name;
    }
    
    if ( ! $ENV{'SIM_ONLY_DIFF'} ) {

        dprint();  # formatting of command.log
        RemoveDirTree($Pass_TDir) if ( -d $Pass_TDir );
        RemoveDirTree($Fail_TDir) if ( -d $Fail_TDir );
        RemoveDirTree($Review_TDir) if ( -d $Review_TDir );

        if ( $exitStatus ) {
            CopyResults($RunDir, $Review_TDir);
        } elsif ( $ENV{'SIM_SAVE_PASSES'} ){
            CopyResults($RunDir, $Pass_TDir);
        }
    }
} 


############################################################################################################
# RECEIVES:  Directory to delete and Recursive call counter
# RETURNS :  Nothings
# PURPOSE :  Recursively delete a directory tree
############################################################################################################

sub RemoveDirTree {

    my $tdir     = shift;
    my $Counter  = shift;
    my $name;    
    

    ### Infinit Loop Protection
    if ( ! defined $Counter ) {
        dprint("\tRemoving Directory Tree => $tdir");
        $Counter = 0;
    } elsif ( $Counter == 50 ) {
        eprint("Function - diff_mech.pl::RemoveDirTree() in Infinite Loop - exiting function");
        exit(6);
    }
    $Counter++;

    local *DIR;
    opendir(DIR,$tdir) || warn "Can Not Open $tdir: $!";
    while ($name=readdir(DIR)) {
        if ($name eq '.' or $name eq '..' ) {
            next;
        } elsif (-d "$tdir$sep$name") {
            RemoveDirTree("$tdir$sep$name", $Counter);
        } else {
            unlink( $tdir . $sep . $name ) if ( -f "$tdir$sep$name" );
        }
    }
    closedir(DIR);

    rmdir($tdir);
} 


#*****************************************************************
# RECIEVES:  2 Strings - Source Directory Path and Target Directory Path
#            1 Number  - Recursive Call Counter
# RETURNS:   NOTHING
# PURPOSE:   Copies a directory or file
#*****************************************************************
sub CopyResults {

    my $sdir     = shift;
    my $tdir     = shift;
    my $Counter  = shift;
    my $name;    


    ### Infinit Loop Protection
    if ( ! defined $Counter ) {
        dprint("\tSaving Results          => $tdir");
        $Counter = 0;
    } elsif ( $Counter == 50 ) {
        eprint("Function - diff_mech.pl::CopyResults() in Infinite Loop - exiting function");
        exit(6);
    }
    $Counter++;
    
    # Save Regression Run
    mkdir($tdir,0777) if ( !-d $tdir);
    warn "*** Failed To Save Results Directory $tdir" if ( !-d $tdir);    
    local *DIR;
    opendir(DIR,$sdir) || die "No $sdir?: $!";
    while ($name=readdir(DIR)) {
        if ($name eq '.' or $name eq '..' ) {
            next;
        } elsif (-d "$sdir$sep$name") {
            CopyResults("$sdir$sep$name","$tdir$sep$name", $Counter);
	### Hack to exclude named pipe file created during Linux optimization studies
        } elsif ( $name ne 'core' && $name ne 'MECH_IN' ) {
            unlink( $tdir . $sep . $name ) if ( -f "$tdir$sep$name" );
            copy("$sdir$sep$name","$tdir$sep$name");
            chmod(0755, "$tdir$sep$name");
            warn "   *** Failed To Save Results File $tdir$sep$name" if (!-f "$tdir$sep$name");
        }
    }
    closedir(DIR);
} 

#*******************************************************************
# RECEIVES: Nothing
# RETURNS:  int ( 0 or 1)
# PURPOSE:  Check to see that the differs are present and are either 
#           executables or perl scripts 
#*******************************************************************
sub DiffersOK 
{
    my @Differs = qw(fdiff measdiff resdiff i2sdiff);
    my $Status  = 1;
    my $DifferExeDir;
    my $DifferPerlDir;

    $DifferExeDir = $ENV{MECH_HOME} . $sep . 'bin' . $sep;
    if (defined $ENV{AUTOSIM_PATH}) {
        $DifferPerlDir = $ENV{AUTOSIM_PATH} . $sep . 'auto' . $sep;
    } else {
        $DifferPerlDir = $ENV{SIM_STDS_PATH} . $sep . 'auto' . $sep;
    }

    foreach my $DifferName ( @Differs ) {
        ### i2sdiff is a perl script
        if ( $DifferName eq 'i2sdiff' ) {
            my $Differ = $DifferPerlDir .  $DifferName . '.pl';
            if ( !-f $Differ ) {
                eprint("ERROR: NO INSTALL ==> $Differ");
                $Status = 0;
            }
        }
        ### Rest other differs are executables
        ### Covers both NT and UNIX cases
        else {
                my $Differ = $DifferExeDir .  $DifferName;
                if ( (!-f $Differ or !-x $Differ) and ( !-f $Differ . '.exe' or !-x $Differ . '.exe' ) ) {
                    eprint("ERROR: NO INSTALL ==> $Differ");
                    $Status = 0;
                }
        }
    }

    return $Status;
}

#*****************************************************************
# RECEIVES:  2 Strings
# RETURNS:   String (Which differ to use).
# PURPOSE:   Select the correct Differ to use for each file type 
#            being diffed.
#*****************************************************************
sub GetDiffer 
{
    my $TestType = shift;
    my $FileExt  = shift;
    
    my ($Differ, $DiffDir, $DiffDir1);

    $DiffDir = $ENV{MECH_HOME} . $sep . '..' . $sep . 'bin' . $sep; ### Very Slow     
    $DiffDir = $ENV{MECH_HOME} . $sep . 'bin' . $sep;
    if (defined $ENV{AUTOSIM_PATH}) {
        $DiffDir1 = $ENV{AUTOSIM_PATH} . $sep . 'auto' . $sep;
    } else {
        $DiffDir1 = $ENV{SIM_STDS_PATH} . $sep . 'auto' . $sep;
    }

    my $MEASDIFF = $DiffDir . 'measdiff';
    my $FDIFF    = $DiffDir . 'fdiff';
    if (defined $ENV{MECH_FDIFF}) {
	$FDIFF    = $ENV{MECH_FDIFF};
    }
    my $RESDIFF  = $DiffDir . 'resdiff';
    my $I2SDIFF  = $DiffDir1 . 'i2sdiff.pl';

    if ( $TestTP{$TestType} == 9 or $FileExt =~ /grt$|dvs$|rep$|dmig$/ ) {
        $Differ = $RESDIFF;
    } elsif ( ($TestTP{$TestType} == 8 or $TestTP{$TestType} == 10 or $TestTP{$TestType} == 17) and $FileExt =~ /res$/ ) {
        if ( $ENV{USE_MEASDIFF} == 1 ) {
            $Differ = $MEASDIFF;
        } else { 
            $Differ = $FDIFF;
          }
      } elsif( $FileExt =~ /rsm$/ or $FileExt =~ /mlg$/) { 
          $Differ = $I2SDIFF; 
        }
    else { $Differ = $FDIFF; }

    return $Differ;
} 

#*****************************************************************
# RECIEVES:  5 Strings
# RETURNS:   1 String - fmf file and ext of file to diff.
# PURPOSE:   Select the correct .fmf file for diffing and 
#            gets the extension of the file being diffed.
#*****************************************************************
sub GetFMF 
{

    my $StudyDir    = shift;
    my $AnalysisDir = shift;
    my $TestType    = shift;
    my $StdsDir     = shift;
    my $FileExt     = shift;
    my ( $FMFcmd, $FMFPath );
    
    my $RESFile = $StdsDir .$sep . $StudyDir . $sep . $AnalysisDir . $sep . $StudyDir . '.res';
    $FMFPath = $ENV{TOOLDIR} . 'fmf';
    $FMFPath = $ENV{SIM_STDS_PATH} . $sep . 'auto' . $sep . 'fmf' if ( -d $ENV{SIM_STDS_PATH} . $sep . 'auto' . $sep . 'fmf' );
   
    ### Set FMF file  ###
    if ( -f $RESFile ) {
        open(RES, "<$RESFile") or eprint("ERROR diff_mech.pl: Could not read $RESFile") ;
        while (<RES>){
            if (/max_temperature/){
                if ( $FileExt =~ /d\d{2,}$|e\d{2,}$|f\d{2,}$|g\d{2,}$|l\d{2,}$|r\d{2,}$|s\d{2,}$|t\d{2,}$|cnv$|hst$|neu$|opt$|pnu$|res$/ ){
                    $FileExt =~ tr/1234567890/x/;                                  
                    $FMFcmd =  $FMFPath . $sep . 'thermal.fmf ' . $FileExt;
                } else {
                    $FMFcmd = '';
                }
                last; 
            } elsif (/modal_frequency/){
                if (  $FileExt =~ /a\d{2,}$|b\d{2,}$|d\d{2,}$|e\d{2,}$|f\d{2,}$|g\d{2,}$|l\d{2,}$|p\d{2,}$|r\d{2,}$|s\d{2,}$|t\d{2,}$|cnv$|coe$|hst$|neu$|oph$|opt$|pnu$|res$/ ){
                    $FileExt =~ tr/1234567890/x/;               
                    $FMFcmd =  $FMFPath . $sep . 'modal.fmf ' . $FileExt;
                } else {
                    $FMFcmd = '';
                }
                last;
            }
        }
        close RES;
    }

    $FMFcmd = $FMFPath . $sep . 'import_lsm.fmf ' . $FileExt if ( $TestType =~ /^QATigs_lsm$/ );

    if ( ! $FMFcmd ){
        # DGE_ON_DEMAND is the default in P-20. Exclude geom counts in diffing lsm files.
        if ( $FileExt =~ /lsm$/ and $TestType =~ /^QATitgms|QATitgms_pp$/ ) {
            $FMFcmd =  $FMFPath . $sep . 'common_dge.fmf ' . $FileExt;            
        } elsif ( $FileExt =~ /a\d{2,}$|b\d{2,}$|c\d{2,}$|d\d{2,}$|e\d{2,}$|f\d{2,}$|g\d{2,}$|h\d{2,}$|i\d{2,}$|j\d{2,}$|k\d{2,}$|m\d{2,}$|q\d{2,}$|l\d{2,}$|p\d{2,}$|r\d{2,}$|s\d{2,}$|ss\d{2,}$|sp\d{2,}$|t\d{2,}$|v\d{2,}$|w\d{2,}$|x\d{2,}$|y\d{2,}$|\d{3,}$|fatigue\d{2,0}$|cnv$|coe$|hst$|lsm$|neu$|opt$|pnu$|res$|lrs$/ ) {
            $FileExt =~ tr/1234567890/x/;
            $FMFcmd =  $FMFPath . $sep . 'common.fmf ' . $FileExt;            
        } else {
            $FMFcmd = '';
        }
    }

    return $FMFcmd;
} 

#######################################################
# RECEIVES - File Path
# RETURNS  - Array of lines from file
# PURPOSE  - Read a file from disk
########################################################
sub ReadFile{

    my $Path      = $_[0];
    my @FileLines = ();
    my @FilteredFileLines = ();
    
    if ( -e "$Path" ){
        open(FILE, "$Path") or eprint("Could Not Read File $Path: $!");
        while (<FILE>){
            chomp;
            push(@FileLines,"$_\n");
        }
        close(FILE);

    } else {
         eprint "Can't find file $Path\n";        
         exit(6);
    }

    return @FileLines;
}

##########################################################################
# RECEIVES: Sting with the Path to the diff opts file
# RETURNS:  Nothing
# PURPOSE:  Check for local and Global DiffOpts files and if it exists 
#           added file extensions to the DiffStatus hash or to DiffTol 
#           hash in Mainto be used during diffing.
##########################################################################
sub GetDiffOpts {
    my $DiffOptsPath = shift;
    my ($i, $j, $line);
   

    if ( -f "$DiffOptsPath" ) {
        dprint("\tProcessing  $DiffOptsPath File");
        my ($key, $value, @DiffOptsFile);
        my @DiffOptsFile = ReadFile($DiffOptsPath);
        for $i ( 0 .. $#DiffOptsFile ){
            next if ( $DiffOptsFile[$i] =~ /^#|^\s*$/ );

            ### this code allows for lines like:  "lsm -z .00001 -t 4"
            ( $line = $DiffOptsFile[$i] ) =~ s/#.*//;
            $line  =~ s/\s+/ /g;
            $line  =~ s/^\s*//;
            $line  =~ s/\s*$//;
            ($value = $line ) =~ s/^(\S+)\s+//;
            $key   = $1;
            
#           ($key, $value) = split(' ',$DiffOptsFile[$i]);
            

            ### Processing XX extensions
            if ( $key =~ /xx$/ ){
                $key =~ s/xx$/\\d{2,}\$/;  # changes the 'xx' to '\d{2,}' to match 2 or more digits
            }
            
            ### Catagorizing DiffOpts
            if ( $value eq 'SKIP' ){
                $DiffStatus{$key} = 0;
                dprint("\t-----> Will Skip $key Types");  
            } elsif ( $value eq 'EXIST') {
                $DiffStatus{$key} = 1;
                dprint("\t-----> Will Check For Existance of $key Types");               
            } else {
                $DiffTol{$key} = $value;
                dprint("\t-----> $key -> tol = $DiffTol{$key}"); # remove
            }
        }
        dprint(); # Formatting of command.log
    }
}


##########################################################################
# RECEIVES: String with run directory
# RETURNS:  Nothing
# PURPOSE:  Check Pro/E and Mechanica trail files to make sure product 
#           finished correctly
##########################################################################
sub TrailFileError {

    use strict;

    my (@FileLines, @TrailCmds, $Line, @DirList, $DirEntry, $i, $LastLine, @versions);
    my $RunDir          = shift;
    my $TestName        = shift;
    my $TrailName       = $TestName . '.new';
    my $Switch          = 0;
    my $MultiTrailFiles = 0;
    my $TrailInfo;

    opendir(DIR, $RunDir) or  eprint("Could not read $RunDir to check how trail files exited: $!");
    my @DirList = readdir DIR;
    FILELOOP: foreach $DirEntry ( @DirList ) {

        my $FPath = $RunDir . $sep . $DirEntry;
        $MultiTrailFiles = 1 if ( $FPath =~ /trail\.txt\.\d+$/ );   #### Temp hack for xtop crash on exit when running DPI cases
        if ( -f $FPath and $FPath =~ /$TrailName$|trail\.txt\.\d+$|mech_trl.txt.\d+/ ){
            
            @FileLines = ReadFile($FPath);

            if ( not $ENV{'SIM_ALLOW_VERSION_MISMATCH'} ) {
                ### Check for Pro/E / Mechanica version mismatch based in trail file strings.
                ### The second line of I-mode trails contains the Pro/E version, and further
                ### down is the Mechanica header containing the version it was built against.
                for ( $i = 0; $i < $#FileLines; $i++ ) {
                    chomp $FileLines[$i];

                    if ( $FileLines[$i] =~ /(^\!Creo  TM  Version )(\w\-\d\d\-\d\d)(  \(c\) (\d+) by PTC Inc.  All Rights Reserved.)/ ) {
                        push(@versions, $2);
                    }
                    if ( $FileLines[$i] =~ /(\!Mech\s+#\s+Product\:\s+Creo Simulate\s*)(\w\-\d\d\-\d\d)(\:\w+)/ ) {
                        push(@versions, $2);
                        if ($versions[0] ne $versions[1]) {
                            eprint("ERROR: Pro/E ($versions[0]) and Creo Simulate ($versions[1]) versions do not match");
                            next FILELOOP;
                        }
                    }
                }
            }

            ### Pro/E Exiting sequence
            my $lastLine = $FileLines[$#FileLines];
            chomp $lastLine;
            if ( $lastLine =~ /^\!End of Trail File$/ ) {
                dprint("\t$DirEntry EXIT OK");
                next FILELOOP;
            }

            ### Check for an OOS
            for ( $i = $#FileLines; $i >= 0; $i-- ) {
                chomp $FileLines[$i];
                if ( $FileLines[$i] =~ /trail\s*file\s+out\s+of\s+sequence\s+/i ){
                    eprint("ERROR:  TRAIL OOS $DirEntry --> $FileLines[$i]");
                    $Switch = 1;
                    next FILELOOP;
                }
                if (  $FileLines[$i] =~ /^\s*.{0,1}junkfile.{0,1}\s*$/ ) { # proe trail when running standalone
                    dprint("\t$DirEntry EXIT OK");
                    next FILELOOP;
                }
                if ( $FileLines[$i] =~ /^\s*~|INP_(menu_select|button)/ and 
                     $FileLines[$i] !~ /^~\s*(Move|Resize)/ and 
                     $FileLines[$i] !~ /^~\s*Focus(In|Out)/ ) {
                    push(@TrailCmds, $FileLines[$i]);
                }
            }

            ### Standalone Save and Exit sequence
            if ( $TrailCmds[0] =~ /^~ Activate \`UI Message Dialog\` \`(yes|ok)\`/ ) {
                for my $j ( 1 .. 2 ) {
                    if (  $TrailCmds[$j] =~   /^INP_menu_select\( \".File.Quit\" \)\;\s*/ ) {
                        dprint("\t$DirEntry EXIT OK");
                        next FILELOOP;
                    }
                }
            }

            ### Standalone Exiting sequence
            # Exit without saving changes
            if ( $TrailCmds[0] =~ /^INP_button\( \"\", \"(Yes|No)\" \)\;\s*/ ) {
                for my $j ( 1 .. 3 ) {
                    if (  $TrailCmds[$j] =~   /^INP_menu_select\( \".File.Quit\" \)\;\s*/ ) {
                        dprint("\t$DirEntry EXIT OK");
                        next FILELOOP;
                    }
                }
            }

            dprint("\tPREMATURE EXIT ($DirEntry)");
            foreach my $li ( @TrailCmds ) {
                dprint("\t\t$li");
            }
            $TrailInfo = $TrailInfo . "ERROR:  PREMATURE EXIT ($DirEntry)";
            $Switch = 1;
        }
    }

    #### Temp hack for xtop crash on exit when running DPI cases
    if ( $MultiTrailFiles == 1 ) {
        $Switch = 0;
    } elsif ( $Switch == 1 ) {
        eprint("$TrailInfo");
    }
    #############################################################   
    
    dprint(""); #command.log formatting
    closedir(DIR);
    return $Switch;
}

##########################################################################
# RECEIVES: 2 Strings - the current Directory and The Test Name
# RETURNS:  2 Strings - the Run Directory and the SO Directory in the Run
#                       Directory
# PURPOSE:  Finds the Run Directory and the SO directory under Run  Directory.
#           The Paths are changed from the default when the ENV 'SIM_ONLY_DIFF'
#           is set. 
##########################################################################
sub GetDirs {
    my $CurDir   = shift;
    my $CaseName = shift;
    my $TestType = shift;
    my ($StdsDir, $RunDir);
    
    my $FailDir   = $CurDir . $sep . '..' . $sep . "$CaseName";
    my $ReviewDir = $CurDir . $sep . '..' . $sep . "$CaseName";   
    my $PassDir   = $CurDir . $sep . '..' . $sep . "$CaseName";


    dprint("\t****  REDIFF ONLY ****") if ( $ENV{'SIM_ONLY_DIFF'} );


    ### Sets Path when rediffing a failed test case.
    if ( $ENV{'SIM_ONLY_DIFF'} and -d $PassDir )
    {
        $StdsDir  = $PassDir . $sep . 'SO';
        $RunDir   = $PassDir;


    ### Sets Path when rediffing a pass test case.
    } elsif ( $ENV{'SIM_ONLY_DIFF'} and -d $ReviewDir ) {
    
        $StdsDir  = $ReviewDir . $sep . 'SO';
        $RunDir   = $ReviewDir;


    ### Sets Path when rediffing a pass test case.
    } elsif ( $ENV{'SIM_ONLY_DIFF'} and -d $FailDir ) {
    
        $StdsDir  = $FailDir . $sep . 'SO';
        $RunDir   = $FailDir;


     ### Sets Path when rediffing a pass test case.
    } elsif ( $ENV{'SIM_ONLY_DIFF'} ) {
    
        $StdsDir  = 'Re-Diffing But Can Not Find Standards Directory';
        $RunDir   = 'Re-Diffing But Can Not Find Original Run Directory';


   ### Default Stds Directory and Run Directory    
    } else {

        $StdsDir  = $CurDir . $sep . 'SO';
        $RunDir   = $CurDir;

    }
    return $StdsDir, $RunDir;
}


##########################################################################
# RECEIVES: 3 Strings - The Test Type, the Test Name and The Run Directory
# RETURNS:  1 String  - The SO Path
# PURPOSE:  Gets the Standards' path for this case based on the path in the 
#           file 'std_path' in the Run Directory
##########################################################################
sub GetSODir {
    my $RunDir   = shift;

    # The 'std_path' file contains the path to the SO Standards directory.
    my $Std_Path = $RunDir . $sep . 'std_path';

    open(SOPATH, "$Std_Path") or die "ERROR: Can Not Open File: $Std_Path";
    #   my $SOPath = readline SOPATH; # does not work on Itanium
    my @SOPathPrefix = <SOPATH>;
    chomp $SOPathPrefix[0];
    close(SOPATH);
    my $SOPath = $SOPathPrefix[0] . $sep . 'SO';

    return $SOPath;
}


##########################################################################
# RECEIVES: Receives 2 strings, the Model Name and the Run Directory
# RETURNS:  1 or 0
# PURPOSE:  Checks to see if the mnl file has any errors. 
##########################################################################
sub MNLCheck {
    my $ModelName = shift;
    my $RunDir   = shift;
    my (@FileLines, $i);
    my $MNLPath  = $RunDir . $sep . $ModelName . '.mnl';

    #verify $TestName.mnl file was generated by Mech
    if ( open (MNL_FILE, "<$MNLPath") ) {
        my @FileLines = <MNL_FILE>;
        close(MNL_FILE);

        # If not matched before last line, Print Failed
        for $i  ( 0 .. $#FileLines ) {
            last if ( $FileLines[$i] =~ /\s+Total\serrors\:\s0$/ );
            if ( $i == $#FileLines ) {
                eprint("ERROR:  Errors in mnl file");
                return 0;
            }
        }    
    
    } else {
        eprint("MISSING FILE:  $MNLPath Not Generated");
        return 0;
    }
    
    dprint("\tMNL File $MNLPath --> OK");
}


##########################################################################
# RECEIVES: Receives 5 strings - Standards Directory used for diffing, Run
#           directory for current case, Current Directory, Test Name and 
#           Test Type.
# RETURNS:  Nothing
# PURPOSE:  To Update the saved case directory name after a re-diff 
#           ( eg. change pass name to fail name, P_CaseName --> R_CaseName )
##########################################################################
sub ProcessReDiffedDirs {

    use strict;
    
    my $StdsDir     = shift;
    my $RunDir      = shift;
    my $CurDir      = shift;
    my $TestName    = shift;
    my $TestType    = shift;
    my $dbgFile     = shift;
    my $simFailFile = shift;

    my ($InitRunStatus, $QCRsExist, $File, @DirList);

    if ( $RunDir ne $CurDir ) {
        copy($dbgFile, $CurDir . $sep . 'dbgfile.dat') if ( -e $dbgFile ); # When rediffing QCR failures will be re-applied 
        copy($CurDir . $sep . 'command.log', $RunDir . $sep . 'command.log'); # Update the command.log in RunDir
        copy($CurDir . $sep . 'sim_fail.dat', $simFailFile) if ( -e $CurDir . $sep . $simFailFile ); # If diffs copy to RunDir
    } else {
        eprint("ERROR on re-diff");  # Error This should never happen
        exit(6);
    }
}


##########################################################################
# RECEIVES: Receives string with Run Dir Path
# RETURNS:  String with a 1 value or undef value
# PURPOSE:  Checks sim_fail.dat file to see if there is a Time Out message
#           in it. If there is then the Exit Flag is set to '1' otherwise
#           the Exit Flag is undefinited.
##########################################################################
sub TimedOut {
    my $FilePath   = shift;
    my $ExitFlag;


    ### If Run timed set Flag
    if ( -f $FilePath ) {
        open(FILE, "$FilePath") or die("Could Not Open $FilePath: $!");
        while (<FILE>){
            $ExitFlag = 1 if ( /TIMED-OUT/ );
        }
        close(FILE);
    }
    return $ExitFlag;
}


##########################################################################
# RECEIVES: 2 Strings and a hash with the files 
#           to diff.
# RETURNS:  a hash with files to diff
# PURPOSE:  Processes the hash and replaces the Standards Directory Path
#           with the value in the Env Var 'SIM_DIFF_AGAINST_RUN'
##########################################################################
sub ProcessDiffHash {
    # $SODirPath was the Directory that the function 'GetFilesToDiff' used to find all the
    # standards that need to be diffed against, this substring needs to be removed from the
    # key and the path $PrevRunDir needs to be added to the front of
    # the path for the key. The value for the key should remain unchanged.
    my $SODirPath     = shift;
    my $PrevRunDir    = shift;
    my %DiffFiles     = @_;
    my %ModDiffFiles;

    my $SODirLength = length($SODirPath);
    my $NewPath     = $ENV{'SIM_DIFF_AGAINST_RUN'};
    my @DiffKeys    = keys(%DiffFiles);

    ### Replace the $SODirPath with $ENV{'SIM_DIFF_AGAINST_RUN'} in the 
    foreach $Key ( @DiffKeys ) {
        my $Value                = $DiffFiles{$Key};
        my $NewKey               = $PrevRunDir . substr($Key, $SODirLength); 
        $ModDiffFiles{"$NewKey"} = $Value;
    }
    return %ModDiffFiles;
}

##########################################################################
# RECEIVES: 2 Strings 
# RETURNS:  1 String path to Previous Run 
# PURPOSE:  Function finds the path to the previous run in the subdir
#           indicated by $ENV{SIM_DIFF_AGAINST_RUN}
##########################################################################
sub GetPrevRunStdsDir {
    
    my $TestName = shift;
    my $TestType = shift;

    my $NewPath = $ENV{'SIM_DIFF_AGAINST_RUN'};

    ### Modify $NewPath if the Env Var 'SIM_DIFF_AGAINST_RUN' was set with a '/' or '\' at the end and add test type 
    if ( $NewPath =~ /\\$|\/$/ ){
        my $Length = length($NewPath);
        $NewPath   = substr($NewPath, -1, $Length - 1);
    }
    $NewPath = $NewPath . $sep . $TestType;


    ### Adjusts the Stds Path for diffing against Previous Passes or Failures.
    if ( -d $NewPath . $sep . 'R_' . $TestName ) {   
        $NewPath = $NewPath . $sep . 'R_' . $TestName;
    } elsif ( -d $NewPath . $sep . 'P_' . $TestName ) {
        $NewPath = $NewPath . $sep . 'P_' . $TestName;
    } elsif ( -d $NewPath . $sep . 'F_' . $TestName ) {
        $NewPath = $NewPath . $sep . 'F_' . $TestName;       
    } else {
        my $FNewPath = $NewPath . $sep . 'F_' . $TestName;       
        my $PNewPath = $NewPath . $sep . 'P_' . $TestName;
        my $RNewPath = $NewPath . $sep . 'R_' . $TestName;
        
        eprint("ERROR:  Can\'t Find Previous Run Dir --> $PNewPath, $FNewPath, $RNewPath");
        exit(6);
    }
    return $NewPath 
}

##########################################################################
# RECEIVES: 2 file names
# RETURNS:  2 file names 
# PURPOSE:  Processes *.grt files and removes line with a string in it. 
##########################################################################
sub RemoveStrings {
    my ($i,$NewS,$NewR,@StdF,@RunF);
    my $Std  = shift;
    my $RunF = shift;
    
    ($NewS = $Std)  =~ s/^.*?([\w\d\-\.\_]+)$/$1/;
    ($NewR = $RunF) =~ s/^.*?([\w\d\-\.\_]+)$/$1/;
    
    $NewS = 'SO' . $sep . $NewS . '.tmp';
    $NewR = $NewR . '.tmp';

    dprint("\tRemoving strings from $Std => $NewS");
    dprint("\tRemoving strings from $RunF => $NewR");

    open(STD, "<$Std");
    open(RUN, "<$RunF");
    open(NEWS,">$NewS");
    open(NEWR,">$NewR");

    foreach (<STD>) { print NEWS $_ if ( m/^[\d\s\.\-\+eE]+$/ ) }
    foreach (<RUN>) { print NEWR $_ if ( m/^[\d\s\.\-\+eE]+$/ ) }
    
    close(STD);
    close(RUN);
    close(NEWS);
    close(NEWR);

    return $NewS,$NewR; 
}

##########################################################################
# RECEIVES: 2 file names
# RETURNS:  2 file names 
# PURPOSE:  Processes *.dmig files and changes the Fortran Double percision
#           notation to standard exponent notation that resdiff understands
##########################################################################
sub DMIG_File {
    my ($i,$NewS,$NewR,@StdF,@RunF);
    my $Std  = shift;
    my $RunF = shift;
    
    ($NewS = $Std)  =~ s/^.*?([\w\d\-\.\_]+)$/$1/;
    ($NewR = $RunF) =~ s/^.*?([\w\d\-\.\_]+)$/$1/;
    
    $NewS = 'SO' . $sep . $NewS . '.tmp';
    $NewR = $NewR . '.tmp';

    dprint("\tChanging Fortran Double Notation to Standards Exponent Notation $Std => $NewS");
    dprint("\tChanging Fortran Double Notation to Standards Exponent Notation $RunF => $NewR");

    open(STD, "<$Std");
    open(RUN, "<$RunF");
    open(NEWS,">$NewS");
    open(NEWR,">$NewR");

    foreach (<STD>) {
        s/(\d+)D([\+\-]\d+)/$1e$2/g;
        print NEWS $_;
    }
    foreach (<RUN>) {
        s/(\d+)D([\+\-]\d+)/$1e$2/g;
        print NEWR $_;
    }
    
    close(STD);
    close(RUN);
    close(NEWS);
    close(NEWR);

    return $NewS,$NewR; 
}

##########################################################################
# RECEIVES: String with run directory
# RETURNS:  Nothing
# PURPOSE:  Check for thread safety of sara evaluators(1d,2d,3d) by comparing dump files
#           created in multithreaded environment.
##########################################################################
use File::Compare 'cmp';
sub Cmp($) {
    my $line = $_[0];
    for ($line) {
        s/^\s+//;   # Trim leading whitespace.
        s/\s+$//;   # Trim trailing whitespace.
    }
    return uc($line);
}

sub TestThreadSafetyOfEvaluators {

    use strict;
    my $Switch          = 0;
    my $RunDir          = shift;
    my (@FileLines, @TrailCmds, $Line, @DirList, $DirEntry, @EvalDirList, $EvalDirEntry, $i, $BaseFile, $File);

    opendir(DIR, $RunDir) or  eprint("Could not read $RunDir to check thread safety of evaluators: $!");
    @DirList = readdir DIR;

    foreach $DirEntry ( @DirList ) {

        my $FPath = $RunDir . $sep . $DirEntry;
        if ( -d $FPath and $FPath =~ /eval_3d|eval_2d|eval_1d/ ){

            opendir(EVAL_DIR, $FPath) or  eprint("Could not read $RunDir to check thread safety of evaluators: $!");
            @EvalDirList = readdir EVAL_DIR;
            foreach (@EvalDirList)
            {
                $File = $FPath.$sep.$_;
                if ($File =~ /.dmp/ )
                {
                    if($BaseFile eq ""){
                        $BaseFile = $File;
                        next;
                    }

                    my $return = compare($BaseFile, $File, sub {Cmp $_[0] ne Cmp $_[1]} );
                    if(-1 == $return){
                        eprint("ERROR: THREAD SAFETY EVALUATOR. Failed to open files $BaseFile --> $File\n");
                        $Switch = 1;
                    }
                    elsif(0 != $return){
                        eprint("ERROR: THREAD SAFETY EVALUATOR. Files are different from baseline $BaseFile --> $File\n");
                        $Switch = 1;
                    }
                }
            }

            $BaseFile = "";
            closedir(EVAL_DIR);
         }
    }

    dprint(""); #command.log formatting
    closedir(DIR);
    return $Switch;
}

##########################################################################
# RECEIVES: Run directory and test name.
# RETURNS:  nothing
# PURPOSE:  Parses .stt file written by the engine and generates .perf file
#           used by the performance tracking tool.
##########################################################################
sub GeneratePerfData($RunDir)
{
    my $RunDir = shift;
    my $test_name = shift;
    my $analysis, $task, $pass, $memory, $hh, $mm, $ss, $total_elapsed;
    opendir(DIR,$RunDir) || die "No $RunDir?: $!";
    while ($name=readdir(DIR)) {
        if ($name eq '.' or $name eq '..') {
            next;
        }
        my $studyDirName = $RunDir . $sep . $name;
        if (!-d "$studyDirName") {
            next;
	}
        opendir(STUDY,$studyDirName) || die "No study dir ?: $!";
        while ($sttName=readdir(STUDY)) {
            if ($sttName !~ /.stt/) {
                next;
            }

            my $perfFileName = $RunDir . $sep . '..' . $sep . $test_name . '.perf';
            my $perfExists = 0;
            if (-f "$perfFileName") { $perfExists = 1; }
            open(PERF, ">>$perfFileName") or die "Can not open file to append: $!";
            my $sttFileName = $RunDir . $sep . $name . $sep . $sttName;
            open(STT,$sttFileName) or die "No input file!: $!";
            my $ver = "";
            my $testHeader = 0;
            my $skip = 0;
            $analysis = "";
            while (<STT>)
            {
                if (m/(Creo Simulate Structure)(\s+)(Version)(\s+)(\S+)(:spg)/) {
                    $ver = $5;
                }
                if ($perfExists eq 0 && $testHeader == 0 && $ver ne "") {
                    my $now = localtime;
                    my $mach_name=`hostname`;
                    print PERF "\n\nPERFORMANCE TESTING\n";
                    print PERF "Date:         $now\n";
                    print PERF "Host:         $mach_name";
                    print PERF "Machtype:     $ENV{PRO_MACHINE_TYPE}\n";
                    print PERF "Graphics:     0\n";
                    print PERF "Trail Ver:    irrelevant\n";
                    print PERF "Trail Build:  $ver\n\n";
                }
                if ($testHeader == 0 && $ver ne "") {
                    print PERF "-------------------------------------------------------------------\n";
                    print PERF "$test_name  Version $ver\n";
                    print PERF "-------------------------------------------------------------------\n";
                    $testHeader = 1;
                }
                if (m/^(Begin P-Loop Pass )(\d)/) {
                    $pass = $2;
                }
                if (m/^(Begin)(\s+)(.+)/) {
                    $task = $3;
                    if ($task !~ /(.+)(Pass )(\d)/ && $pass > 0 ) {
                        $task = $task . " Pass " . $pass;
                    }
                    $skip = 0;
                }
                if (m/^(Completed)/) {
                    $skip = 1;
                }
                if (m/(Memory Usage)(\s+)(\S+)(\s+)(\S+)/) {
                    $memory = $5;
                }
                if (m/(\s+)(Step Elapsed Time)(\s+)(\S+)(\s+)(\d+)(\.)(\d+)/) {
                    $seconds = $6;
                    $minutes = int ($seconds / 60);
                    $seconds = $seconds - ($minutes * 60);
                    $hours = int ($minutes / 60);
                    $minutes = $minutes - ($hours * 60);
                    if ($hours < 10) { $hh = "0" . $hours; } else { $hh = $hours; }
                    if ($minutes < 10) { $mm = "0" . $minutes; } else { $mm = $minutes; }
                    if ($seconds < 10) { $ss = "0" . $seconds; } else { $ss = $seconds; }
                }
                if (m/(Step CPU Time)/ && $skip == 0) {
                    printf(PERF "$analysis$task  %s:%s:%s\n", $hh, $mm, $ss);
                }
                if (m/^(Begin Analysis\: \")(\S+)(\")/) {
                    $analysis = $2 . ": ";
                    $pass = 0;
                }
                if (m/^(   Elapsed Time)(\s+)(\S+)(\s+)(\d+)(\.)(\d+)/) {
                    $seconds = $5;
                    $minutes = int ($seconds / 60);
                    $seconds = $seconds - ($minutes * 60);
                    $hours = int ($minutes / 60);
                    $minutes = $minutes - ($hours * 60);
                    if ($hours < 10) { $hh = "0" . $hours; } else { $hh = $hours; }
                    if ($minutes < 10) { $mm = "0" . $minutes; } else { $mm = $minutes; }
                    if ($seconds < 10) { $ss = "0" . $seconds; } else { $ss = $seconds; }
                }
                if (m/(   Elapsed Time       \(sec\):)(\s+)(\S+)$/) {
                    $total_elapsed = $3;
                }
            }
            print PERF "-------------------------------------------------------------------\n";
            printf(PERF "TOTAL              %s:%s:%s\n", $hh, $mm, $ss);
            print PERF "MEMORY             $memory\n";

            close(STT);
            close(PERF);            
        }
        closedir(STUDY);
   }
   closedir(DIR);
}

