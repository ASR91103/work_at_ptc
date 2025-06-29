#!$PTC_TOOLS/perl5/bin/$PRO_MACHINE_TYPE/perl

use lib "$ENV{TOOLDIR}";  ### In Needham
use lib ($0 =~/(.+)\/.+$/); #add current directory to @INC
use File::Basename;
use File::Copy;
use testtp;
use dbgetc;

###########################################################################################
# Mechanica copy script. 
# 
###########################################################################################

$root_trail_path = shift;
$test_type       = shift;
$test_name       = shift;
$rel_trail_path  = shift;
$obj_path        = shift;

my $gunzip = $ENV{'GUNZIP'} || 'gunzip -f';
my $unzip = $ENV{'UNZIP'} || 'unzip -qu';
my $untar = $ENV{'UNTAR'} || 'tar xzf';
my ($test_dir, $scrp_dir);

($test_dir, $scrp_dir) = GetTestDir($root_trail_path, $obj_path, $rel_trail_path);
dprint("copy_mech.pl --> $test_name $test_type");
GetEnvVars($test_dir . $sep . 'SI/CASE.cfg');

### Exit Before copying if needed ###
exit(0) if (defined $ENV{'SIM_ONLY_DIFF'});
if ( not defined $ENV{'MECH_HOME'} and not defined $ENV{'MECH_LP'} ) {
    dprint("\tWARNING: Neither \"MECH_HOME\" nor \"MECH_LP\" has been set!");
    print STDERR "WARNING: Neither \"MECH_HOME\" nor \"MECH_LP\" has been set!\n";
}

GenFile('std_path', $test_dir ); # Generates a file containing the path to the Stds
CopyTest($test_dir,$cur_dir);

if ( $scrp_dir eq $ENV{TOOLDIR} . 'scripts' ) {
    MakeOldScr($scrp_dir, $cur_dir, $test_name);
} else {
    CopyScr($scrp_dir, $cur_dir, $test_name);
}

if ( $ENV{R_ALT_SIM_STDS_PATH} ) {
    # Copy alternate models, trails and qcrs.
    $AltTestDir = $ENV{R_ALT_SIM_STDS_PATH} . $sep . $rel_trail_path;
    CopyAltTest($AltTestDir, $cur_dir);
    # Copy alternate generic scripts.
    $AltScrDir = $ENV{R_ALT_SIM_STDS_PATH} . $sep . "auto" . $sep . "scripts";
    CopyScr($AltScrDir, $cur_dir, $test_name);
}

# Perform substitutions in scripts.
if ( $scrp_dir ne $ENV{TOOLDIR} . 'scripts' ) {
    MakeScr($cur_dir, $test_name);
} 

SetIntegrator($test_type) if ( $TestTP{$test_type} == 9 );

GenFile('config.mech','MISC_START_APPMGR FALSE') if ( $TestTP{$test_type} == 3 );

#########################

AddConfigOpts('show_debug_groups_in_ribbon', 'yes');
AddConfigOpts('sim_load_mech_mesh', 'yes');
AddConfigOpts('sim_invoke_diagnostics_on_run', 'yes');

if ( $TestTP{$test_type} == 3 or $TestTP{$test_type} == 7 or $TestTP{$test_type} == 14 ) {
    AddConfigOpts('use_strict_ui_trail', 'no');
}

#########################
dprint ("\n");
exit(0);

#*****************************************************************
# RECIEVE: objec, Run directory, Relative path to standards
# RETURN : 2 strings 
# PURPOSE: Get standards and script directories
#*****************************************************************
sub GetTestDir {
    my $RootTrail = shift;
    my $ObjPath   = shift;
    my $RelPath   = shift;
    my ($TestDir, $ScrDir, $Temp);

    die("SIM_STDS_PATH is not valid:\t$ENV{SIM_STDS_PATH}") if  ( $ENV{SIM_STDS_PATH} and ! -d $ENV{SIM_STDS_PATH} );
   
    $TestDir1 = $ENV{SIM_STDS_PATH} . $sep . $RelPath;
    $TestDir2 = $RootTrail . $sep .  $RelPath;
    $TestDir3 = $ObjPath . $sep . $RelPath;

    if ( -d $TestDir1 ) {
        $TestDir = $TestDir1;
    } elsif ( -d $TestDir2 ) {
        $TestDir = $TestDir2;
    } elsif ( -d $TestDir3 ) {
        open(FILE,">.obj_test");
        print FILE $FullObjPath;
        close(FILE);
        mkdir("SO",0777);  # Needed because PTC objects do not have an SO dir.
        $TestDir = $TestDir3;
    } else {
        eprint("ERROR => Can\'t find test standards in:");
        eprint("\t$TestDir1 OR\n\t$TestDir2 OR\n\t$TestDir3\n");
        exit(1);    
    }
    
    $ScrDir = $ENV{TOOLDIR} . 'scripts';
    $ScrDir = $ENV{SIM_STDS_PATH} . $sep . 'auto' . $sep . 'scripts' if (  -d $ENV{SIM_STDS_PATH} . $sep . 'auto' . $sep . 'scripts' );
    $ScrDir = $ENV{AUTOSIM_PATH}  . $sep . 'auto' . $sep . 'scripts' if (  -d $ENV{AUTOSIM_PATH}  . $sep . 'auto' . $sep . 'scripts' );
   

    if (! -d $ScrDir ) {
        eprint("ERROR: Simulation Script Directory Missing: $ScrDir\n");
        exit(1); 
    }

    return ($TestDir,$ScrDir);
}

#*****************************************************************
# Copy Test directory to current scratch
#*****************************************************************
sub CopyTest(){
  my $sdir = shift;
  my $tdir = shift;

  local *DIR;
  opendir(DIR,$sdir) || die "No $sdir: $!";
  dprint("\t-----> Copy directory $sdir to $tdir");
  while ($name=readdir(DIR)) {
     if ($name eq '.' or $name eq '..' ) { next;
     } elsif ( $name =~ /^so$/i ) { 
         mkdir("$tdir$sep$name",0777); # or eprint("ERROR: Failed to make directory $tdir$sep$name");
         if  ( $ENV{'SIM_COPY_SO'} == 1 ) {
             CopyTest("$sdir$sep$name","$tdir$sep$name");
         }
     } elsif (-d "$sdir$sep$name") {
         if ( $name =~ /^si$/i ) {
             CopyTest("$sdir$sep$name","$tdir");
         } else {
	     mkdir("$tdir$sep$name",0777);
	     CopyTest("$sdir$sep$name","$tdir$sep$name");
	 }
     } elsif ( $name =~ /^so.zip$/i ) {
         # SO.zip should include the top level "SO" directory itself.
         copy("$sdir$sep$name","$tdir$sep$name");
         system("unzip -qu $tdir$sep$name") == 0 and unlink "$tdir$sep$name";
         unlink std_path;
	 GenFile('std_path', $tdir);
         next;
     } elsif ( $name =~ /^si.zip$/i ) { 
         # SI.zip should not include the top level "SI" directory itself, only the files in it.
         copy("$sdir$sep$name","$tdir$sep$name");
         system("unzip -qu $tdir$sep$name") == 0 and unlink "$tdir$sep$name";
         next;
     } elsif ( $name =~ /^so.7z$/i ) {
         # SO.7z should include the top level "SO" directory itself.
         copy("$sdir$sep$name","$tdir$sep$name");
         system("7za x $tdir$sep$name -y > NULL") == 0 and unlink "$tdir$sep$name";
         unlink std_path;
	 GenFile('std_path', $tdir);
         next;
     } elsif ( $name =~ /^si.7z$/i ) { 
         # SI.7z should not include the top level "SI" directory itself, only the files in it.
         copy("$sdir$sep$name","$tdir$sep$name");
         system("7za e $tdir$sep$name -y > NULL") == 0 and unlink "$tdir$sep$name";
         next;
     } else {
         copy("$sdir$sep$name","$tdir$sep$name");
         chmod(0777,"$tdir$sep$name");
     }
     
     if (!-e "$tdir$sep$name") {
         eprint("Copy Failed:  \"$sdir$sep$name\" to \"$tdir$sep$name\" \n");
	 exit(1); 
     }
	 
  }
  closedir(DIR);
}



#*****************************************************************
# Copy alternate directory to current scratch
#*****************************************************************
sub CopyAltTest(){
  my $sdir = shift;
  my $tdir = shift;

  if (! -d $sdir) { return; }
  
  local *DIR;
  opendir(DIR,$sdir) || die "No $sdir: $!";
  dprint("\t-----> Copy directory $sdir to $tdir");
  while ($name=readdir(DIR)) {     
     if ($name eq '.' or $name eq '..' ) { next;
     } elsif ( $name =~ /^so$/i ) { 
         mkdir("$tdir$sep$name",0777); # or eprint("ERROR: Failed to make directory $tdir$sep$name");
         CopyAltTest("$sdir$sep$name","$tdir$sep$name");
     } elsif (-d "$sdir$sep$name") {
         if ( $name =~ /^si$/i ) {
             CopyAltTest("$sdir$sep$name","$tdir");
         } else {
	     mkdir("$tdir$sep$name",0777);
	     CopyAltTest("$sdir$sep$name","$tdir$sep$name");
	 }
        
     } else {
         copy("$sdir$sep$name","$tdir$sep$name");
         chmod(0777,"$tdir$sep$name");
     }
     
     if (!-e "$tdir$sep$name") {
         eprint("Copy Failed:  \"$sdir$sep$name\" to \"$tdir$sep$name\" \n");
	 exit(1); 
     }
	 
  }
  closedir(DIR);
}

#######################################################################################################
# RECIEVES:    Config file name and options
# RETURNS:     Nothing
# PURPOSE:     Generates a config file with the arguments to the function.
#######################################################################################################
sub GenFile {
    my $ConfigFileName = shift;   
    my @ConfigOptions = @_;
    open(FILE,">>$ConfigFileName");
    dprint("\t-----> Creating file $ConfigFileName  => @ConfigOptions");
    foreach (@ConfigOptions) {
         print FILE "$_\n";
    }
    close(FILE);
}

#######################################################################################################
# RECIEVES:    Config file name and options
# RETURNS:     Nothing
# PURPOSE:     Generates a config file with the arguments to the function.
#######################################################################################################
sub SetIntegrator {
    my $File;
    my $TestType = shift;
    
    opendir(DIR,'.');
    while ($File=readdir(DIR)) {
        next if ($File eq '.' or $File eq '..' or -d $File);	
        if ( $File =~ /([0-9a-z_\.\-]+\.fui)$/i ) {
            Replace($File, $File, '^\s*integrator\s+variable$', '    integrator dae') if ( $TestType eq 'QATmng_d' );
            Replace($File, $File, '^\s*integrator\s+dae$', '    integrator variable') if ( $TestType eq 'QATmng_v' );
        }
    }    
}

#######################################################################################################
# RECIEVES:    Nothing
# RETURNS:     a 0 or 1 to indicate if the search string was found
# PURPOSE:     Processes given file, removes leading spaces and multiple spaces in each line.
#######################################################################################################
sub ProcessFile {

    my $ConfigFileName = shift;
    my $Match          = shift;
    my $Switch         = 1;
    my $TempFile       = '..' . $sep . '.cfg.tmp';
    
    my $Line;

    if ( -f $ConfigFileName and !-f $TempFile ) { # Will only do this once
        open(INFILE, ">$TempFile");
        open(OUTFILE,"<$ConfigFileName");
        foreach $Line (<OUTFILE>) {
            chomp $Line;
            $Line =~ s/^\s+//;
            $Line =~ s/\s+/ /;
            $Switch = 0 if ( $Line =~ /^MECH_LP/);
            print INFILE "$Line\n";
        }
        close(INFILE);
        close(OUTFILE);

        unlink($ConfigFileName);
        copy($TempFile, $ConfigFileName);
    
    ### After the first time the SIM.cfg file has been processed, MECH_LP should exist
    } elsif ( -f $TempFile ) {
        $Switch = 0;
    }
    
    return $Switch;
}

#######################################################################################################
# RECIEVES:    Nothing
# RETURNS:     a 0 or 1 to indicate if the search string was found
# PURPOSE:     Processes given file, removes leading spaces and multiple spaces in each line.
#######################################################################################################
sub AddConfigOpts {
    my %ConfigOpts = @_;
    my $ConfigFile;
    my $ConfigExists = 0;

    $ConfigTmp = $cur_dir . $sep . 'config.tmp';
    $ConfigFile =  $cur_dir . $sep . 'config.pro';
    $ConfigExists = 1 if ( -f $cur_dir . $sep . 'config.pro' );

    if ( $ConfigExists ) {
        open(WRITEF, ">$ConfigTmp");
        open(READF, "<$ConfigFile");
        foreach my $Key ( keys(%ConfigOpts) ) {
            print WRITEF "$Key $ConfigOpts{$Key}\n";
        }
        foreach my $Line ( <READF> ) {
            print WRITEF "$Line";
        }
        close(WRITEF);
        close(READF);
        unlink($ConfigFile);
        rename($ConfigTmp, $ConfigFile);

    } else {
        open(WRITEF, ">$ConfigFile");
        foreach my $Key ( keys(%ConfigOpts) ){
            print WRITEF "$Key $ConfigOpts{$Key}\n";
        }
        close(WRITEF);
    }
}

#*****************************************************************
# Support QATagm_awp test standards organized as in the Inria suite.
#*****************************************************************
sub uncompress {
    my ($cmd, $file) = @_;
    # print "     $cmd $file\n";
    system("$cmd $file") == 0 and unlink $file;
}

sub uncompress_dir {
    my $TargetDir = shift;
    opendir(CWD, $TargetDir) or die "Failed to open current dir: $!\n";
    my $file;
    while (defined($file = readdir(CWD))) {
        next unless ($file =~ /(\.\w+(\.\w+)?)$/);
        $_ = $1;
        /^\.zip$/        && do { uncompress($unzip, $file); next; };
        /^\.t(ar\.)?gz$/ && do { uncompress($untar, $file); next; };
        /\.gz$/          && do { uncompress($gunzip, $file); next; };
    }
    closedir(CWD);
}

#*****************************************************************
# RECIEVE: Script directory, Run directory and Test name
# RETURN : Nothing
# PURPOSE: Copy all need scripts for the specific test type and then
#          Customize script file for specific test.
# NOTE:    For Pre 24.8 regressions.
#*****************************************************************
sub MakeOldScr {

    my $SourceDir = shift;
    my $TargetDir = shift;
    my $TestName  = shift;

    my $ModelName = $TestName;
    my $Prefix    = $test_type . '_';
    $ModelName =~ s/^$Prefix//;
    my $FileType = "db_-1";                 # db_-1 >> 'All Files(*)'

    foreach my $trail ( @{$ScrTP{$test_type}} ) {
        copy( $SourceDir . $sep . $trail , $TargetDir . $sep . $trail );
    }

    if ( $test_type eq "QATags" ) { 
        Replace( 'ags.scr', "$TestName.scr", '__NAME__', $ModelName);
            
    } elsif ( $test_type eq "QATagv" ) { 
        Replace( 'agv.scr', "$TestName.scr", '__NAME__', $ModelName);
            
    } elsif ( $test_type eq "QATigm_s" ) {
        Replace( 'igm_s.scr', "$TestName.scr", '__NAME__', $ModelName);
            
    } elsif ( $test_type eq "QATigm_v" ) {
        Replace( 'igm_v.scr', "$TestName.scr", '__NAME__', $ModelName);

    } elsif ( $test_type eq "QATpgm_s" ) {
        Replace( 'prt.txt', "$TestName.txt", '__FILENAME__', $ModelName . '.prt');
        Replace( 'pgm_s.scr', "$TestName.scr", '__NAME__', $ModelName);
            
    } elsif ( $test_type eq "QATpgm_v" ) { 
        Replace( 'prt.txt', "$TestName.txt", '__FILENAME__', $ModelName . '.prt');
        Replace( 'pgm_v.scr', "$TestName.scr", '__NAME__', $ModelName);
          
    } elsif ( $test_type eq "QATdxf" ) { 
        Replace( 'dxf.scr', "$TestName.scr", '__NAME__', $ModelName, '__P_Q__' , $test_type);

    } elsif ( $test_type eq "QATdvs" ) { 
        Replace( 'dvs.scr', "$TestName.scr", '__NAME__', $ModelName);

    } elsif ( $test_type eq "QATdvs_ug" ) {
        Replace('dvs_ug.scr', "$TestName.scr", '__NAME__', $ModelName, '__P_Q__', $test_type );

    } elsif ( $test_type eq "QATigs_lsm" ) {
        Replace('igs_lsm.scr', 'igs_lsm.scr', '__NAME__', $ModelName);
        Replace('iges_export_import.scr', 'iges_export_import.scr', '__NAME__', $ModelName, '__CP__', 'cp');
        
    } elsif ( $test_type eq "QATugs" ) {
        Replace('ugs_lsm.scr', 'ugs_lsm.scr', '__NAME__', $ModelName , '__P_Q__', $test_type );

    } elsif ( $test_type eq "QATvda" ) {
        Replace('vda.scr', "$TestName.scr", '__NAME__', $ModelName , '__P_Q__', $test_type );
        
    } elsif ( $TestTP{$test_type} == 3 ) {
        if ( $test_type eq 'QATasm' ) {
            my $TrailName = 'asm.txt';
            $TrailName = $ENV{ASM_ALT_SCRIPT} if ( exists($ENV{ASM_ALT_SCRIPT}) );
            Replace( $TrailName, $TestName . '.txt', '__FILENAME__', $ModelName . '.asm');
        } elsif ( $test_type eq 'QATprt' )  {
            my $TrailName = 'prt.txt';
            Replace( $TrailName, $TestName . '.txt', '__FILENAME__', $ModelName . '.prt');
        }
        Replace('GenLSM.scr', 'GenLSM.scr', '__P_Q__', $test_type, '__NAME__', $ModelName);
        Replace('DoTopoCheck.scr', 'DoTopoCheck.scr', '__P_Q__', $test_type, '__NAME__', $ModelName);
        Replace('ImportMNF.scr', 'ImportMNF.scr', '__NAME__', $ModelName);

    } elsif ( $TestTP{$test_type} == 14 ) {
        ReadSpecialInstr($TargetDir, \$ModelName, \$FileType);        
        if ( -e $TargetDir . $sep . $ModelName . '.asm' ) {
            Replace( 'AGEM_srf.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__AGEM_NUM__', '3', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATagm_srf');
            if ( $test_type eq 'QATagm_awp') {
                if (exists($ENV{AWP_ALT_SCRIPT})) {
                    Replace( $ENV{AWP_ALT_SCRIPT}, $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__FILETYPE__', $FileType)
                } else {
                    Replace( 'AGEM_awp.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__FILETYPE__', $FileType)
                }
            }
            Replace( 'inria.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATinria');
        } elsif ( -e $TargetDir . $sep . $ModelName . '.prt' )  {
            Replace( 'AGEM_srf.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__AGEM_NUM__', '2', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATagm_srf');
            if ( $test_type eq 'QATagm_awp') {
                if (exists($ENV{AWP_ALT_SCRIPT})) {
                    Replace( $ENV{AWP_ALT_SCRIPT}, $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__FILETYPE__', $FileType)
                } else {
                    Replace( 'AGEM_awp.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__FILETYPE__', $FileType)
                }
            }
            Replace( 'inria.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATinria');
        } elsif ( -e $TargetDir . $sep . $ModelName )  {
            Replace( 'AGEM_srf.txt', $TestName . '.txt', '__MODEL__', $ModelName, '__AGEM_NUM__', '2', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATagm_srf');
            if ( $test_type eq 'QATagm_awp') {
                if (exists($ENV{AWP_ALT_SCRIPT})) {
                Replace( $ENV{AWP_ALT_SCRIPT}, $TestName . '.txt', '__MODEL__', $ModelName, '__FILETYPE__', $FileType)
                } else {
                    Replace( 'AGEM_awp.txt', $TestName . '.txt', '__MODEL__', $ModelName, '__FILETYPE__', $FileType)
                }
            }
            Replace( 'inria.txt', $TestName . '.txt', '__MODEL__', $ModelName, '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATinria');
        } else {
            eprint("ERROR:  Model \"$ModelName\" was not found\n");
        }
    ### Adjust trail file name if Model Name is different from Test Name
    } elsif ( $ModelName ne $TestName ) {
        rename($ModelName . '.txt', $TestName . '.txt') if ( -f $ModelName . '.txt' );
        rename($ModelName . '.scr', $TestName . '.scr') if ( -f $ModelName . '.scr' );
    }
}

#*****************************************************************
# RECIEVE: Script directory, Run directory and Test name
# RETURN : Nothing
# PURPOSE: Copy all need scripts for the specific test type and then
#          Customize script file for specific test.
# NOTE:    For Post 24.8 regressions.
#*****************************************************************
sub MakeScr {
    my $TargetDir = shift;
    my $TestName  = shift;

    my @Tmp = split(/__/,$TestName);
    my $ModelName = $Tmp[$#Tmp];
    my $FileType = "db_-1";             # db_-1 >> 'All Files(*)'

    if ( $test_type eq "QATags" ) { 
        Replace( 'ags.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");
            
    } elsif ( $test_type eq "QATagv" ) { 
        Replace( 'agv.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");
            
    } elsif ( $test_type eq "QATigm_s" ) {
        Replace( 'igm_s.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");
            
    } elsif ( $test_type eq "QATigm_v" ) {
        Replace( 'igm_v.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");

    } elsif ( $test_type eq "QATpgm_s" ) {
        Replace( 'prt.txt', "$TestName.txt", '__FILENAME__', $ModelName . '.prt');
        Replace( 'pgm_s.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");
            
    } elsif ( $test_type eq "QATpgm_v" ) { 
        Replace( 'prt.txt', "$TestName.txt", '__FILENAME__', $ModelName . '.prt');
        Replace( 'pgm_v.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");
          
    } elsif ( $test_type eq "QATdxf" ) { 
        Replace( 'dxf.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"", '__P_Q__' , "\"$test_type\"");

    } elsif ( $test_type eq "QATdvs" ) { 
        Replace( 'dvs.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"");

    } elsif ( $test_type eq "QATdvs_ug" ) {
        Replace('dvs_ug.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"", '__P_Q__', "\"$test_type\"" );

    } elsif ( $test_type eq "QATigs_lsm" ) {
        Replace('igs_lsm.scr', 'igs_lsm.scr', '__NAME__', "\"$ModelName\"");
        Replace('iges_export_import.scr', 'iges_export_import.scr', '__NAME__', "\"$ModelName\"", '__CP__', 'cp');
        
    } elsif ( $test_type eq "QATugs" ) {
        Replace('ugs_lsm.scr', 'ugs_lsm.scr', '__NAME__', "\"$ModelName\"" , '__P_Q__', "\"$test_type\"" );

    } elsif ( $test_type eq "QATvda" ) {
        Replace('vda.scr', "$TestName.scr", '__NAME__', "\"$ModelName\"" , '__P_Q__', "\"$test_type\"" );

    } elsif ( $test_type eq "QATcta" ) {
        my $cta_model;
        if ( FileOK('-f', 'mdl_name.txt') ) {
            open(FILE, "<mdl_name.txt") or die "Could not open mdl_name.txt file:$!";
            $cta_model = <FILE>;
            close(FILE);
            chomp $cta_model; ### need this 
        } else {
            eprint("ERROR: file \"mdl_name.txt\" missing");
            exit(1);
        }

        Replace( 'cta.scr', 'cta.scr', '__NAME__', "\"$ModelName\"", '__CTA_MODEL__', "\"$cta_model\"");
        Replace('DoTopoCheck.scr', 'DoTopoCheck.scr', '__P_Q__', "\"$test_type\"", '__NAME__', "\"$ModelName\"");
        
    } elsif ( $TestTP{$test_type} == 3 ) {
        if ( $test_type eq 'QATasm' ) {
            my $TrailName = 'asm.txt';
            $TrailName = $ENV{ASM_ALT_SCRIPT} if ( exists($ENV{ASM_ALT_SCRIPT}) );
            Replace( $TrailName, $TestName . '.txt', '__FILENAME__', $ModelName . '.asm');
        } elsif ( $test_type eq 'QATprt' )  {
            my $TrailName = 'prt.txt';
            Replace( $TrailName, $TestName . '.txt', '__FILENAME__', $ModelName . '.prt');
        }
        Replace('GenLSM.scr', 'GenLSM.scr', '__P_Q__', "\"$test_type\"", '__NAME__', "\"$ModelName\"");
        Replace('DoTopoCheck.scr', 'DoTopoCheck.scr', '__P_Q__', "\"$test_type\"", '__NAME__', "\"$ModelName\"");
        Replace('ImportMNF.scr', 'ImportMNF.scr', '__NAME__', "\"$ModelName\"");

    } elsif ( $TestTP{$test_type} == 14 ) {
        uncompress_dir($TargetDir);
        ReadSpecialInstr($TargetDir, \$ModelName, \$FileType);
        if ( -e $TargetDir . $sep . $ModelName . '.asm' ) {
            Replace( 'AGEM_srf.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__AGEM_NUM__', '3', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATagm_srf');
            if ( $test_type eq 'QATagm_awp') {
                if (exists($ENV{AWP_ALT_SCRIPT})) {
                    Replace( $ENV{AWP_ALT_SCRIPT}, $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__FILETYPE__', $FileType)
                } else {
                    Replace( 'AGEM_awp.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__FILETYPE__', $FileType)
                }
            }
            Replace( 'inria.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.asm', '__APPLICATION__', 'Applications.rad_util_app_asm', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATinria');
        } elsif ( -e $TargetDir . $sep . $ModelName . '.prt' )  {
            Replace( 'AGEM_srf.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__AGEM_NUM__', '2', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATagm_srf');
            if ( $test_type eq 'QATagm_awp') {
                if (exists($ENV{AWP_ALT_SCRIPT})) {
                    Replace( $ENV{AWP_ALT_SCRIPT}, $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__FILETYPE__', $FileType)
                } else {
                    Replace( 'AGEM_awp.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__FILETYPE__', $FileType)
                }
            }
            Replace( 'inria.txt', $TestName . '.txt', '__MODEL__', $ModelName . '.prt', '__APPLICATION__', 'Applications.rad_util_app_prt', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATinria');
        } elsif ( -f $TargetDir . $sep . $ModelName )  {
            Replace( 'AGEM_srf.txt', $TestName . '.txt', '__MODEL__', $ModelName, '__AGEM_NUM__', '2', '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATagm_srf');
            if ( $test_type eq 'QATagm_awp') {
                if (exists($ENV{AWP_ALT_SCRIPT})) {
                    Replace( $ENV{AWP_ALT_SCRIPT}, $TestName . '.txt', '__MODEL__', $ModelName, '__FILETYPE__', $FileType)
                } else {
                    Replace( 'AGEM_awp.txt', $TestName . '.txt', '__MODEL__', $ModelName, '__FILETYPE__', $FileType)
                }
            }
            Replace( 'inria.txt', $TestName . '.txt', '__MODEL__', $ModelName, '__FILETYPE__', $FileType)
                if ( $test_type eq 'QATinria');
        } else {
            eprint("ERROR:  Model \"$ModelName\" was not found in $TargetDir\n");
        }

    } elsif ( $TestTP{$test_type} == 15 ) {

    ### Adjust trail file name if Model Name is different from Test Name
    } elsif ( $ModelName ne $TestName ) {
        rename($ModelName . '.txt', $TestName . '.txt') if ( -f $ModelName . '.txt' );
        rename($ModelName . '.scr', $TestName . '.scr') if ( -f $ModelName . '.scr' );
    }
}

#*****************************************************************
# RECIEVE: Script directory, Run directory and Test name
# RETURN : Nothing
# PURPOSE: Copy all need scripts for the specific test type
#*****************************************************************
sub CopyScr {
    my $SourceDir = shift;
    my $TargetDir = shift;
    my $TestName  = shift;

    my @Tmp = split(/__/,$TestName);
    my $ModelName = $Tmp[$#Tmp];

    foreach my $trail ( @{$ScrTP{$test_type}} ) {
        if ( -e "$SourceDir$sep$trail" ) {
            copy( $SourceDir . $sep . $trail , $TargetDir . $sep . $trail );
        }
    }
}

#*****************************************************************
# RECEIVE: Script directory, Model name
# RETURN : Nothing
# PURPOSE: Support THA Models (special characters in model name).
#*****************************************************************
sub ReadSpecialInstr {
    my ($TargetDir, $ModelName, $FileType) = @_;

    if (open (SPECIAL_INSTR, "$TargetDir/special_instr.txt")) {
        @alist = <SPECIAL_INSTR>;
        close (SPECIAL_INSTR);
        chomp (@alist);
        foreach $line (@alist) {
            my ($name, @value) = split(/:/, $line);
            $value[0] =~ s/^\s+//;
            $$ModelName = join(':',@value) if $name eq 'MODELNAME';
            $$FileType = 'db_872' if $name eq 'FILETYPE' && $value[0] eq 'UNIGRAPHICS';
        }
    }
}
