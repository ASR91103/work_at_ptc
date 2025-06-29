##############################################################################
# PROGRAM: auto.pl (perl5)
#
##############################################################################
#
#   PUT REVISION HISTORY AT END
#
#   Need "skipped::  #skipped because" for print_fail
#
##############################################################################
# DOCUMENTATION
#
# Usage: auto exe_path [trail_path] [obj_path]
#
#
# Functions:
#
# define_unified_cmd()     Define OS depend command.
#
# init_sys_env()
#
# init_proe_env()
#
# init_auto_env()          Initialize R_* environment variables.
#
# init_directives()
#
# reset_directives()
#
# set_directive()
#
# init_others()
#
# set_profly_env()         Set environment variables for running profly
#                          tests
#
# set_altlang()
#
# get_version()
#
# print_env_info()         Print out environment information,
#                          It is the head of succ.log and fail.log
#
# waiting_for_startup()    wait until the check_cutoff time and ptcmisc ok.
#
# get_num_tests()          get the total number of the tests in auto.txt.
#
# cleanup()                This function will be called when hit control-C.
#
# read_a_test()            read a test from auto_list to test_list.
#
# parse_and_copy_a_test()  parse the test_list, set directives and
#           copy the test.
# copy_objects($)
#
# copy_trail($$)
#
# copy_pd_demo_trail($$)   copy trail files for #pd tests
#
# copy_qcr($)
#
# copy_d($)
#
# copy_config($)
#
# copy_misc()              copy miscellaneous file to $rundir/auto_misc,
#                          the files in $rundir/auto_misc will be copied
#                          to $tmpdir when copy a test.
#
# exclude_file($)          find out whether the file should be copied to
#                          $rundir/auto_misc.
#
# succ_skip($)             skip the test and mark as SUCCESS.
#
# fail_skip($)             skip the test and mark as FAILURE.
#
# run_a_test($$$)          run a whole test.
#
# run_commands()           run the commands for currect tests
#
# prev_run_process()       some special processes should be done before the
#                          test actually run. Include: fix trail, R_*
#                          process and run PRE_RUN_SCRIPT.
#
# wait_for_executable()    wait if xtop missing.
#
# run_trail($$)
#
# run_trail_low($$)
#
# post_run_process($)      some special processes should be done after the
#                          test is run. Include: run POST_RUN_SCRIPT,
#                          R_* process, get performent result, etc.
#
# pre_directive_process()  set predirectives.
#
# test_display()
#
# print_succfail($)        | tee -a $succ $fail
#
# print_succ($)            | tee -a $succ
#
# print_fail($)            | tee -a $fail
#
# rm_dbgfile_for_non_langtest()
#
# find_printf($)           check the printf when R_RUNMODE = 0
#
# run_gprof($)
#
# reset_envs()
#
# create_new_file($)       create trailname.new file.
#
# check_dbgfile($)
#
# check_bitmaps($)
#
# gettraceback($)
#
# save_all_core($)
#
# exit_on_core()
#
# get_perf_results($)      get performance testing result.
#
# get_runtime($$)
#
# write_succ_result($$$$$)
#
# write_fail_result($$$$$$)
#
# get_fail_line_num($)     get the line number which the test fails on
#
# pre_run_weblink_test($$) some special process should be done before
#                          run a weblink test.
#
# date_mdy()               get current month-day-year
#
# date_hms()               get current hours-minute-second
#
# cnv_sec_hms($)           convert seconds to hours-minute-second
#
# cnv_hms_sec($)           convert hours-minute-second to seconds
#
# get_unique_tmp_dir()
#
# process_pcv_file()       convert a .pcv file to a .out file
#                          containing source file, function, #
#                          of hits (> 0) .....
#                          Can get a more detailed .out file by
#                          setting R_PUREVERBOSE to "true".
#
# get_pct()                converts purecov data to a percentage value
#
# process_funclist_file()  Post process .funclist file to generate .sat file
#
# kill_old_processs()	   Kill all old process's related to Creo that may by 
#						   running because of some random exits while running the test
#						   This will be called only if R_USE_LOCAL_SERVER is set.
#						   Also, this should NOT be used while running test in multiple thread.		
#
################################################################################
#
#
# Following are the Global Variables used in auto.pl:
#
# $numargs --- @ARGV
#
# $local_xtop
#
# $trail_path --- the path to trail files.
#
# $obj_path --- the path to object files.
#
# $autotxt --- the auto.txt file
#
# $num_tests --- the number of tests in the auto.txt
#
# $test_num --- the number of tests has run since auto started
#
# $result --- the result of the last test
#
# @auto_list --- the whole auto.txt list
#
# $curr_line --- the current processed line in @auto_list
#
# $csh_cmd --- the command for running C-shell script (it depends on the OS)
#
# $rm_cmd --- the command for removing files (it depends on the OS)
#
# $cp_cmd --- the command for copying files (it depends on the OS)
#
# $protab_exec --- the protab executable will be used in auto
#
# $proguide_exec --- the proguide executable will be used in auto
#
# %directives --- include all the status of the directives for auto
#
# $cur_dir --- the current directory
#
# $auto_ver --- the auto_ver.log file
#
# $tmpdir --- the directory for running a test
#
# $rundir --- the directory for saving all test result
#
# $timefile --- the reg_time.log file
#
# $skip_tests --- skip the rest of test in current @test_list when it is true
#
# $spgid --- user ID
#
# $mach_type --- $PRO_MACHINE_TYPE
#
# $mach_name --- machine name
#
# $date --- month-day-year
#
# $startauto --- the hour-minute-second when start auto
#
# $fail --- the fail.log file
#
# $succ --- the succ.log file
#
# $run_fly_tests --- it is set true when run a profly test
#
# $old_tmpdir --- the $TMPDIR before start auto
#
# $uif_graphics --- the graphics mode for running uif test
#
# $report_memory --- report the memory if it is true.
#
# $demo_dir --- the directory which is needed to be copied for a #pd test
#
# %cmd_list --- the command list related with the current test
#
# $mach_list --- the list of machine type related with the current test
#
# $uif_exec --- the executable which will be used by the current uif test
#
# $genuifargs --- the arguments which will be used by the current uif test
#
# $altlang --- the language which is using when run auto
#
# $version --- the proe version
#
# $startsec --- the time in seconds when auto start
#               (used for calculating total time)
#
# $endauto --- the time when auto finish
#
# $total_time --- the total time spent from auto start to finish
#
# @test_list --- list one test
#
# $trailfile --- the trail file which is running
#
#############################################################################
use English;
use Env;
use Cwd;
use File::Basename;
use FileHandle;
use FindBin;
use lib "$ENV{TOOLDIR}";
use lib "$FindBin::Bin"; # looking for modules in start directory
use File::Copy;
use File::Path;
use GetTrlUtil;
use Fastreg;
use Text::Wrap;
use Uwgmreg;
use LWP::Simple;
use Fcntl qw(:flock);
use POSIX;
use LWP::UserAgent;
use Wispauto;

$| = 1;

define_unified_cmd;

$ENV{'AUTO_PL_PID'} = $$;
$r_using_local_install = 0;
$delete_creo_saas_automation_repo = 0;
$delete_creo_saas_automation_repo_gdx = 0;

$numargs = @ARGV;
if ($numargs == 0 ) {
   print "\nUsage: auto exe_path [trail_path] [obj_path]\n\n";
   print "Check: http://rdweb.ptc.com/cgi-bin/auto_info\n";
   print "for more details\n\n";
   exit (1);
}

$local_xtop = @ARGV[0];

$cur_dir = cwd();

if ($ENV{DO_UPDATE_CREOSAAS_ENV} eq "true") {  
  update_creosaas_env();
}

$did_cef_mismatch = 0;
$collab_other_pid = "";
$build_tag = get_build_tag();
$build_version = get_creo_build_version();

$ENV{'CREO_BUILD_TAG'} = $build_tag if ($build_tag ne '');
$ENV{'CREO_SAAS_BUILD_TAG'} = $build_tag if (($build_tag ne '') && ($ENV{'R_USE_CREO_PLUS'} eq 'true'));
$ENV{'CREO_BUILD_VERSION'} = $build_version if ($build_version ne '');
$ENV{'CREO_SAAS_BUILD_VERSION'} = $build_version if (($build_version ne '') && ($ENV{'R_USE_CREO_PLUS'} eq 'true'));
$ENV{'CREO_SAAS_PTC_VERSION'} = $ENV{PTC_VERSION} if (($ENV{PTC_VERSION} ne '') && ($ENV{'R_USE_CREO_PLUS'} eq 'true'));

if ("$cur_dir" eq "$ENV{HOME}") {
    print "\nCurrent dir is set to \$HOME. Aborting.. \n";
    exit (1);
}

if ($ENV{R_RSDPROJECT} eq 'true' && $ENV{DWN} ne '') {
  $ENV{RSDSYS} = $ENV{DWN};
}

if (defined $ENV{'CDIMAGE_PERF_RUN'}) {
   $ENV{'R_PERF'} = 'true';
}

if (defined $ENV{'R_BITMAP_RUN'}) {
   $ENV{'R_BITMAP'} = 'true';
}

if ($ENV{TOOLDIR} ne "" ) {
   $TOOLDIR =  $ENV{TOOLDIR};
}

if ($ENV{PTC_TOOLS} ne "" ) {
   $PTC_TOOLS =  $ENV{PTC_TOOLS};
}

if ($ENV{PRO_MACHINE_TYPE} ne "" ) {
   $PRO_MACHINE_TYPE =  $ENV{PRO_MACHINE_TYPE};
}

if ($ENV{PRO_DIRECTORY} ne "" ) {
   $PRO_DIRECTORY =  $ENV{PRO_DIRECTORY};
}

if ($ENV{PRO_SRC} ne "" ) {
   $PRO_SRC =  $ENV{PRO_SRC};
}

if ($ENV{PTCSRC} ne "" ) {
   $PTCSRC =  $ENV{PTCSRC};
}

if ($ENV{PTCSYS} ne "" ) {
   $PTCSYS =  $ENV{PTCSYS};
}

if ($ENV{PROE_START} ne "" ) {
   $PROE_START =  $ENV{PROE_START};
}

if (not defined $ENV{R_AVOID_REG_UPLOAD}) {
   $ENV{R_AVOID_REG_UPLOAD} = true;
}

if ($ENV{R_AVOID_REG_UPLOAD} ne 'true') {
   undef $ENV{R_AVOID_REG_UPLOAD};
}

#if ($ENV{CREO_MEM_USAGE_STATS} ne 'false') {
#    $ENV{CREO_MEM_USAGE_STATS} = 'true' if ($ENV{P_VERSION} >= 400);
#}

if ($ENV{PTC_MEMMGR_STYLE} ne 'slim' && not defined $ENV{R_AVOID_XTOP_APPVERIFIER}) {
   remove_appverifier_setting();
}

if ($ENV{PTC_MEMMGR_STYLE} eq 'slim' && not defined $ENV{R_AVOID_XTOP_APPVERIFIER}) {
   configure_appverifier_setting();
}

$r_nt_job_pl = "${TOOLDIR}run_nt_job.pl";
if (defined $ENV{R_ALT_NT_JOB_PL} && -e  $ENV{R_ALT_NT_JOB_PL}) {
  $r_nt_job_pl = $ENV{R_ALT_NT_JOB_PL};
}
print "Using $r_nt_job_pl\n";

if (defined $ENV{R_INSTALL_CREO} && $ENV{R_INSTALL_CREO} eq "true") {
  print "Auto will install Creo and use for Regression Testing ...\n\n";
  $r_using_local_install = 1;
}

if ( ($ENV{R_USE_CREO_PLUS} eq "true") || ($ENV{R_SAAS_REGRESSION} eq "true") ) {
    $CREO_SAAS_TEST_ALT_USERNAME_default = "$ENV{CREO_SAAS_TEST_ALT_USERNAME}";
    $CREO_SAAS_USERNAME_default = "$ENV{CREO_SAAS_USERNAME}";
    
    $CREO_SAAS_TEST_ALT_PASSWORD_default = "$ENV{CREO_SAAS_TEST_ALT_PASSWORD}" if ($ENV{CREO_SAAS_TEST_ALT_PASSWORD} ne '');
    $CREO_SAAS_PASSWORD_default = "$ENV{CREO_SAAS_PASSWORD}" if ($ENV{CREO_SAAS_PASSWORD} ne '');
    if ($ENV{P_VERSION} >= 400) {
      $ENV{'SAAS_CONFIGS_ON'} = 'false' if (not defined $ENV{'SAAS_CONFIGS_ON'});
    }
    $saas_config_on_default = $ENV{'SAAS_CONFIGS_ON'} if ($ENV{'SAAS_CONFIGS_ON'} ne '') ;
}

if (defined $ENV{R_USE_CREO_PLUS} && $ENV{R_USE_CREO_PLUS} eq "true") {
    $ENV{LOCAL_INSTALL_PATH_NT} = $ENV{LOCAL_INSTALL_PATH};
    $ENV{LOCAL_INSTALL_PATH_NT} =~ s#/#\\#g;
  print "Auto will use Creo Plus for Regression Testing ...\n\n";
  $r_using_local_install = 1;
}
if (defined $ENV{R_INSTALL_CREO_SCHEMATICS} && $ENV{R_INSTALL_CREO_SCHEMATICS} eq "true") {
  print "Auto will install Creo Schmematics and use for Regression Testing ...\n\n";
  $r_using_local_install = 1;
}

if (-d "$ENV{PRO_DIRECTORY}/$ENV{PRO_MACHINE_TYPE}/nms" && defined $ENV{R_DEFAULT_LICENSE}) {
  print "Auto will use pre-installed Creo from $ENV{PRO_DIRECTORY} for Regression Testing ...\n\n";
  $r_using_local_install = 1;
}

if (defined $ENV{R_INSTALL_CREO} && $ENV{R_INSTALL_CREO} eq "true") {
	print "Installing Creo for Regression Testing ...\n\n";
	`cp $INSTALL_SCRIPTS_FOLDER/cdimage_install_uninstall.pl .`;
	my $logs = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ./cdimage_install_uninstall.pl install`;
	print "$logs\n";
	if ($?) {
		print "Installation of Creo Failed!. Please view the logs for details.\n";
		exit(1);
	}
}

if (defined $ENV{R_USE_CREO_CDIMAGE} && $ENV{R_USE_CREO_CDIMAGE} eq "true") {
   if ($ENV{CREO_AGENT_EXE_PATH} eq '' ) {
      $ENV{CREO_AGENT_EXE_PATH} = "$ENV{COMMONPROGRAMFILES}/PTC/Creo/Agent/creoagent.exe";
      $ENV{CREO_AGENT_EXE_PATH} =~ s#(\s\(x86\))##;
      $ENV{CREO_AGENT_EXE_PATH} =~ s|\\|/|g;
      print "CREO_AGENT_EXE_PATH = $ENV{CREO_AGENT_EXE_PATH}\n";
   }
   
   if ($ENV{CREO_AGENT_LDP_LIST} eq '' ) {
     $ENV{CREO_AGENT_LDP_LIST} = "$ENV{COMMONPROGRAMFILES}/PTC/Creo/Platform/$ENV{MANIFEST_DIR}/manifests";
     $ENV{CREO_AGENT_LDP_LIST} =~ s#(\s\(x86\))##;
     $ENV{CREO_AGENT_LDP_LIST} =~ s|\\|/|g;     
     print "CREO_AGENT_LDP_LIST = $ENV{CREO_AGENT_LDP_LIST}\n";
   }
}
if ($ENV{R_USE_CREO_PLUS} eq "true") {
   if ($ENV{CREO_SAAS_ADMIN_USERNAME} eq "") {  
      if ($ENV{'CREO_SAAS_USERNAME_TYPE'} ne 'cpd' && $ENV{'CREO_SAAS_USERNAME_TYPE'} ne 'rtc.cpd') {
         print ("Fetching Admin user details\n");
         $ENV{CREO_SAAS_ADMIN_USERNAME} = 'cplusops1+all.config.ptc.creo.qa.auto@gmail.com';
         $ENV{CREO_SAAS_ADMIN_PASSWORD} = get_secret("$ENV{CREO_SAAS_ADMIN_USERNAME}");
      } else {
          $ENV{CREO_SAAS_ADMIN_USERNAME} = "$ENV{CREO_SAAS_USERNAME}";
          $ENV{CREO_SAAS_ADMIN_PASSWORD} = "$ENV{CREO_SAAS_PASSWORD}";  
      }
   }
}

if (defined $ENV{R_USE_CREO_PLUS} && $ENV{R_USE_CREO_PLUS} eq "true" && (not defined $ENV{R_SAAS_REGRESSION})) {   
  if ( ! -d "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{CREO_SAAS_BUILDNUM}" ) {
     print "Error: Creo Plus $ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{CREO_SAAS_BUILDNUM} is not pre-installed. Therefore aborting \n";
     exit(1);
  } 
  
  if ($ENV{CREO_SAAS_TEST_REUSE_TOKEN} eq '') {
     $ENV{CREO_SAAS_TEST_REUSE_TOKEN} = 'install_only';
     print "Warning: CREO_SAAS_TEST_REUSE_TOKEN is to default install_only \n ";
  }
  
  if (! -e "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{CREO_SAAS_BUILDNUM}\\saas_install_envs.src") {
        print "Error:missing $ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{CREO_SAAS_BUILDNUM}\\saas_install_envs.src \n";
        print "Please Un-install manually from control Panel\n";
        exit(1); 
  }

  $path_to_install_src =  "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/saas_install_envs.src";
  $path_to_install_config = "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/saas_install_envs.config".$$;  
  $path_to_install_src =~ s|\\|/|g;
  $path_to_install_config =~ s|\\|/|g;
  `csh -fc " cat \"$path_to_install_src\" | egrep -v CREO_SAAS_HOST_URL | egrep -v CREO_SAAS_APIKEY | egrep -v ^unsetenv | sed 's/^setenv//' | sed 's/^ //' | tee \"$path_to_install_config\"  "`;

   open my $env_tmp, '<', "$path_to_install_config";
   while (<$env_tmp>) {
    chomp;
    my ($env_var, $env_value) = split /\s/;
	chomp $env_value;
	$env_value =~ s/'//g;
    $ENV{$env_var} = "$env_value";
   }
   close($env_tmp);
   
   unlink($path_to_install_config) if (not defined $ENV{R_PRESERVE_SAAS_CONFIG});
  
   if ($ENV{R_USE_NUMBERED_SAAS_USERNAME} eq 'true') {
        $ENV{CREO_SAAS_TEST_ALT_USERNAME} = set_random_numbered_saas_username();
        $ENV{CREO_SAAS_USERNAME} = $ENV{CREO_SAAS_TEST_ALT_USERNAME};
        save_configure_creosaas_login("$ENV{CREO_SAAS_USERNAME}","$ENV{CREO_SAAS_PASSWORD}");
        $old_PTC_UI_SERVICE_RUN_TRAIL = "";
        $old_ZBROWSER_TRAIL_FILE = "";
        $old_CREO_SAAS_USERNAME = "";
        $old_CREO_SAAS_PASSWORD = "";
        $old_CREO_SAAS_TEST_ALT_USERNAME = "";
        $old_CREO_SAAS_TEST_ALT_PASSWORD = "";
        
        $CREO_SAAS_TEST_ALT_USERNAME_default = "$ENV{CREO_SAAS_TEST_ALT_USERNAME}";
        $CREO_SAAS_USERNAME_default = "$ENV{CREO_SAAS_USERNAME}";
    
        $CREO_SAAS_TEST_ALT_PASSWORD_default = "$ENV{CREO_SAAS_TEST_ALT_PASSWORD}" if ($ENV{CREO_SAAS_TEST_ALT_PASSWORD} ne '');
        $CREO_SAAS_PASSWORD_default = "$ENV{CREO_SAAS_PASSWORD}" if ($ENV{CREO_SAAS_PASSWORD} ne '');
      
        mkpath("$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/.for_atlas/numbered",0777) if (! -d "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/.for_atlas/numbered");
        my $pran = int(rand(1000000000));
        `$cp_cmd "$ENV{PTC_UI_SERVICE_RUN_TRAIL}" "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/.for_atlas/numbered/ui_trl_$$_${pran}.txt" `; 
        `$cp_cmd "$ENV{ZBROWSER_TRAIL_FILE}" "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/.for_atlas/numbered/new_ui_trl_$$_${pran}.txt"`;
        $ENV{PTC_UI_SERVICE_RUN_TRAIL} = "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/.for_atlas/numbered/ui_trl_$$_${pran}.txt"; 
        $ENV{ZBROWSER_TRAIL_FILE} = "$ENV{LOCAL_INSTALL_PATH_NT}/$ENV{CREO_SAAS_BUILDNUM}/.for_atlas/numbered/new_ui_trl_$$_${pran}.txt";
   }   
  
  #$ENV{PTC_UI_SERVICE_RUN_TRAIL} =~s|\\|/|g;
  
  if ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} eq "true") {
      undef $ENV{PTC_UI_SERVICE_RUN_TRAIL};
      undef $ENV{ZBROWSER_TRAIL_FILE};
      print "PTC_UI_SERVICE_RUN_TRAIL=$ENV{PTC_UI_SERVICE_RUN_TRAIL}\n";
      print "ZBROWSER_TRAIL_FILE=$ENV{ZBROWSER_TRAIL_FILE}\n";
  }
  
  if ( ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} ne "true" && lc($ENV{CLUSTER_TYPE}) ne 'test') ) {
     if ("$ENV{PTC_UI_SERVICE_RUN_TRAIL}" eq "" ) {
	   print "Error: PTC_UI_SERVICE_RUN_TRAIL $ENV{PTC_UI_SERVICE_RUN_TRAIL} not defined\n";
	   #exit(1) ;
     } else {
       $PTC_UI_SERVICE_RUN_TRAIL_default = "$ENV{PTC_UI_SERVICE_RUN_TRAIL}";

	   if (! -e "$ENV{PTC_UI_SERVICE_RUN_TRAIL}") {
		 print "Error:PTC_UI_SERVICE_RUN_TRAIL with \n $ENV{PTC_UI_SERVICE_RUN_TRAIL} file not found\n";
		exit(1);
        }
     }
     
     if ("$ENV{ZBROWSER_TRAIL_FILE}" eq "" ) {
	   print "Error: ZBROWSER_TRAIL_FILE $ENV{ZBROWSER_TRAIL_FILE} not defined\n";
	   #exit(1) ;
     } else {
	   print "ZBROWSER_TRAIL_FILE=$ENV{ZBROWSER_TRAIL_FILE}\n";
	   if (! -e "$ENV{ZBROWSER_TRAIL_FILE}") {
		 print "Error:ZBROWSER_TRAIL_FILE with \n $ENV{ZBROWSER_TRAIL_FILE} file not found\n";
		 exit(1);
        }
        $ZBROWSER_TRAIL_FILE_default = "$ENV{ZBROWSER_TRAIL_FILE}";
     } 
 
  } else {
      print "CREO_SAAS_TEST_SCRIPT_AUTH set to $ENV{CREO_SAAS_TEST_SCRIPT_AUTH}\n";
  }
  
  
  #$ENV{R_SAVE_AS} = '_ptclog';
  
  if ( ($ENV{'CREO_SAAS_BUILDNUM'} ne '') && -d ("$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}" ) ) {
     $psf_file = "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin\\$ENV{CREO_SAAS_TEST_ALT_PROFILE_FILENAME}.psf";
     $psf_file_default = "$psf_file";
     $psf_file_location = "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin";
     if (defined $ENV{PATH_TO_PSF_FILE}) {
        if (-e "$ENV{PATH_TO_PSF_FILE}") {
           $psf_file = `csh -fc  " cygpath -m $ENV{PATH_TO_PSF_FILE} " `;
           chomp($psf_file);
        } else {
            print "\n\n Warning: PATH_TO_PSF_FILE is missing $ENV{PATH_TO_PSF_FILE}\n";   
        }
     }
  }
  
  $cc_location = "$ENV{LOCAL_INSTALL_PATH_NT}\\ControlCenter";
  $creoinfo_exe = "$cc_location\\creoinfo";
  $creoinfo_exe =~ s#\\#/#g;

  if ($ENV{OS_TYPE} eq "NT") {
         $creoinfo_exe = "$creoinfo_exe.exe";
  }
  
  $local_xtop = "$ENV{PROE_START} $psf_file ";
  $local_xtop_default = "$ENV{PROE_START} $psf_file ";  
  undef $ENV{CREO_AGENT_EXE_PATH};
  undef $ENV{CREO_AGENT_LDP_LIST};
  undef $ENV{PTC_LOG_DIR};
}

if (defined $ENV{R_INSTALL_CREO_SCHEMATICS} && $ENV{R_INSTALL_CREO_SCHEMATICS} eq "true") {
	print "Installing Creo Schematics for Regression Testing ...\n\n";
	`cp $INSTALL_SCRIPTS_FOLDER/cdimage_install_uninstall_schematics.pl .`;
	my $logs = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ./cdimage_install_uninstall_schematics.pl install`;
	print "$logs\n";
	if ($?) {
		print "Installation of Creo Schematics Failed!. Please view the logs for details.\n";
		exit(1);
	}
}

my $auto_config_file = "$ENV{HOME}/.auto_config.txt";
my %auto_config_cache;
$_auto_config_cache = \%auto_config_cache;
initialize_auto_config_file();
my $REGSVR32;

if ( $OS_TYPE eq "NT") {
   $REGSVR32="$ENV{SYSTEMROOT}/system32/regsvr32";
   $REGSVR32 =~ tr/\\/\//;
   
   require Win32;
   require Win32::Registry;
   eval 'use Win32::TieRegistry';
}

$SIG{INT} = \&cleanup;

$cur_dir = cwd();
if ("$cur_dir" eq "$ENV{HOME}") {
    print "\nCurrent dir is set to \$HOME. Aborting.. \n";
    exit (1);
}

# tcsh is now able to run auto.pl outside $HOME on cygwin - Shailo 04/02/08
#if (defined($PTC_CYGWIN)) {
#   $my_home = $HOME;
#   $my_home =~ tr/\\/\//;
#   if ("$cur_dir" !~ /^$my_home/) {
#      print "\nThe auto.pl could only run under the directory\n";
#      print "which is under $HOME\n\n";
#      exit (1);
#   }
#}

if ( -e "$HOME/.no_autopl" ) {
   print "\nSORRY, the auto.pl is not allowed to run in this account.\n";
   exit (1);
}

if ( -e "$HOME/config.pro" ) {
   print "WARNING: You have config.pro in your home directory.\n";
   print "         It may affect your regression result.\n";
   print "         Make sure this is what you want to do.\n";
}

opendir(HOMEDIR, "$HOME");
while ($config_win = readdir(HOMEDIR)) {
    last if ($config_win =~ /^config\.win/);
}
closedir(HOMEDIR);
if ("$config_win" =~ /^config\.win/) {
   print "WARNING: You have $config_win in your home directory.\n";
   print "         It may affect your regression result.\n";
   print "         Make sure this is what you want to do.\n";
}

if ($PRO_MACHINE_TYPE eq "") {
   print "Auto depends on PRO_MACHINE_TYPE being set.\n";
   print "If you need help contact integration.\n";
   exit (1);
}

if (defined $ENV{R_INSTALL_CREO_SCHEMATICS} && $ENV{R_INSTALL_CREO_SCHEMATICS} eq "true") {
   	$ENV{PRO_DIRECTORY} =~  s#(\/COMMON~1)$##g;
}

if (defined $ENV{R_RUN_PYAUTOGUI_TEST} || defined $ENV{R_SAAS_REGRESSION}) {
  print "INFO: not checking for $ENV{PRO_DIRECTORY} existence\n";
} elsif (! exists $ENV{PRO_DIRECTORY}) {
   print "ERROR:  PRO_DIRECTORY is not set.\n";
   exit (1);
}
elsif (! -d $ENV{PRO_DIRECTORY}) {
   print "ERROR:  PRO_DIRECTORY:$ENV{PRO_DIRECTORY} is not a directory\n";
   exit (1);
}

if (defined $ENV{R_INSTALL_CREO} && $ENV{R_INSTALL_CREO} eq "true") {
	print "Using the Local Installed Creo at $ENV{LOCAL_INSTALL_PATH}.\n";
	if(-e "$ENV{LOCAL_INSTALL_PATH}/.creo_uninstall_progress") {
		print "Some other process is uninstalling the Creo. Exiting!\n";
		exit(0);
	}
	`touch $ENV{LOCAL_INSTALL_PATH}/$$.using_install_creo`;
}

if (defined $ENV{R_INSTALL_CREO_SCHEMATICS} && $ENV{R_INSTALL_CREO_SCHEMATICS} eq "true") {
	print "Using the Local Installed Creo Schematics at $ENV{LOCAL_INSTALL_PATH}.\n";
	if(-e "$ENV{LOCAL_INSTALL_PATH}/.creo_uninstall_progress") {
		print "Some other process is uninstalling the Creo Schematics. Exiting!\n";
		exit(0);
	}
	`touch $ENV{LOCAL_INSTALL_PATH}/$$.using_install_creo`;
}

$ENV{"INSIDE_AUTO_RUN"} = "true";
$ENV{"NOINTERACT"}="true";

if (defined $ENV{R_SUPERAUTO} && $ENV{R_SUPERAUTO} eq "true") {  
 $local_xtop = "$ENV{PTCSYS}/npobj/xtop";
 print "local_xtop = $local_xtop\n";
}

if ($r_using_local_install == 1) {
  $local_xtop = $ENV{PROE_START};
}
if ($r_using_local_install == 1 && $ENV{R_USE_CREO_PLUS} eq "true") {
  $local_xtop = "$ENV{PROE_START} $psf_file ";
}
if ( $OS_TYPE eq "NT") {
   $local_xtop =~ tr/\\/\//;
}
$cur_dir = cwd();
&convert_xtop_path if ($ENV{R_IGNORE_XTOP} ne "true");

if ($ENV{R_IGNORE_XTOP} ne "true") {
   if ( (! -e $local_xtop) && (! -l $local_xtop) ) {
      print "ERROR:  $local_xtop does not exist\n";
      exit (1);
   }
}

$ENV{"R_LOCAL_XTOP"} = $local_xtop;

if ($ENV{R_IGNORE_XTOP} ne "true") {
   if ($OS_TYPE eq "UNIX" && ! -x $local_xtop) {
       print "ERROR:  $local_xtop is not executable\n";
       exit (1) if (! -l $local_xtop);
   }
}

if ( $OS_TYPE eq "NT") {
   if (! exists $ENV{TEMP} || $ENV{TEMP} eq "") {
      print "ERROR:  TEMP environment variable is not set. Exiting...\n";
      exit (1);
   } else {
      open (TEST, ">$ENV{TEMP}/aa$$") || die ("No write access to the $ENV{TEMP}");
      close (TEST);
      unlink ("$ENV{TEMP}/aa$$");
   }
}

our $origRadarHomeEnv = getRadarHomeEnv();

#
# trail_path and obj_path defaults for Mechanica tests
# are $MECH_HOME/..
# To override the defaults, it is only necessary to specify
# trail_path, since objects are kept in the same location.
#
if ($numargs > 1) {
   $trail_path = @ARGV[1];
   $pro_trail_path = @ARGV[1];
   $mech_trail_path = @ARGV[1];
   $ENV {"R_TRAIL_PATH"} = $pro_trail_path;
}
else {
   if ( $PTCSRC eq "" ) {
      $trail_path = "/devsrc/spg/system_1";
   } elsif (defined $ENV{R_ALT_TRAIL_PATH}) {
      $trail_path = $ENV{R_ALT_TRAIL_PATH};
   } else {
      $trail_path = $PTCSRC;
   }
   $pro_trail_path = $trail_path;
   $mech_trail_path = "$MECH_HOME/..";
}

if ($numargs > 2) {
   $obj_path = @ARGV[2];
   $pro_obj_path = @ARGV[2];
   $mech_obj_path = @ARGV[2];
   $retr_obj_path = @ARGV[2];
}
else {
   $obj_path = "$PTC_REGOBJS/spg/objects";
   $pro_obj_path = "$PTC_REGOBJS/spg/objects";
   $mech_obj_path = "$PTC_REGOBJS/spg/objects";
   if (defined $ENV{R_ALT_RETR_DIR}) {
      $retr_obj_path =  $ENV{R_ALT_RETR_DIR};
   } else {
      $retr_obj_path =  $ENV{PTC_PARTLIBROOT};
   }
   if (defined $ENV{DRC_CONFIG_LOCATION}){
      $drc_obj_path = $ENV{DRC_CONFIG_LOCATION};
   }
   else {
      $drc_obj_path = $ENV{PTC_PARTLIBROOT};
   }

}

if (defined $ENV{R_RENAME_HOME_CONFIG} && $ENV{R_RENAME_HOME_CONFIG} eq "true") {
   print "Rename $HOME/config.pro to $HOME/config.pro_auto\n";
   `mv $HOME/config.pro $HOME/config.pro_auto`;
}

if (! defined $ENV{R_REGRES_BIN} && defined $ENV{P_PROJECT_PATH}
    && defined $ENV{P_CURR_PROJ}) {
   if (-d "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/$PRO_MACHINE_TYPE/obj") {
      $ENV{R_REGRES_BIN}="$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/$PRO_MACHINE_TYPE/obj";
   } else {
      $ENV{R_REGRES_BIN}="$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/obj";
   }
   print "\nNOTE: setenv R_REGRES_BIN to: $ENV{R_REGRES_BIN}\n";
}

if (defined $ENV{R_REGRES_BIN}) {
   if (! defined $ENV{R_PDEV_REGRES_BIN}) {
      $ENV{R_PDEV_REGRES_BIN} = $ENV{R_REGRES_BIN};
   } else {
      $ENV{R_PDEV_REGRES_BIN} = "$ENV{R_PDEV_REGRES_BIN} $ENV{R_REGRES_BIN}";
   }
   print "\nSet R_PDEV_REGRES_BIN to: $ENV{R_PDEV_REGRES_BIN}\n";
}

if (!defined $ENV{UWGM_ADAPTERS_PATH}) {
   if (defined $ENV{R_REGRES_BIN}) {
      if ($OS_TYPE eq "NT") {
         $ENV{UWGM_ADAPTERS_PATH}="$ENV{R_REGRES_BIN};$ENV{PRO_DIRECTORY}";
      } else {
         $ENV{UWGM_ADAPTERS_PATH}="$ENV{R_REGRES_BIN}:$ENV{PRO_DIRECTORY}";
      }
      print "\nNOTE: setenv UWGM_ADAPTERS_PATH to: $ENV{UWGM_ADAPTERS_PATH}\n";
   }
}

if (defined $ENV{R_BITMAP_LOCAL_IMAGE}) {
   if (! defined $ENV{R_BITMAPDB_PATH}) {
      $ENV{R_BITMAPDB_PATH} = "$cur_dir/images";
      mkdir ("$ENV{R_BITMAPDB_PATH}", 0777) if (! -d $ENV{R_BITMAPDB_PATH});
   }
}

$num_perf_test = 0;
$num_legacy_test = 0;
$num_bitmap_test = 0;
$gpu_supported = 1;
set_altlang;
&init_sys_env;
&init_local_build_env;
&init_proe_env;
&init_auto_env;
&fastreg_setup;
&init_others;
&load_memuse_db;
&load_autoexist;
&LoadDepIgnore;
&copy_misc;
system("net use");
&get_version if (! defined $ENV{R_NOVERSION} && $ENV{R_IGNORE_XTOP} ne "true");
$gpu_supported = is_gpu_supported() if ((not defined $ENV{RSD_BAT}) && (not defined $ENV{R_RUN_PYAUTOGUI_TEST}) && (not defined $ENV{R_SAAS_REGRESSION})) ;
$PATH_default = "$ENV{PATH}";

if ($ENV{R_RSDPROJECT} eq 'true') {
	$version = $ENV{PTC_VERSION};
}

if ($ENV{R_GRAPHICS} == '7' && $ENV{OS_TYPE} eq "NT") {
  ($screenwidth, $screenheight,$fullscreenwidth,$fullscreenheight ) = get_display_resolution();
  print "Display Resolution : ${screenwidth}".'x'."${screenheight} (SM_CXSCREEN x SM_CYSCREEN)\n";
  print "Display for full window: ${fullscreenwidth}".'x'."${fullscreenheight} (SM_CXFULLSCREEN x SM_CYFULLSCREEN)\n";
}

$R_SAVE_AS_default = "$ENV{R_SAVE_AS}";
&waiting_for_startup;
$dcad_server = $ENV{DAUTO_SERVER_EXE};
$windchill_url = undef;
@dirsToCopyServerLogs = ();
$tk_flavor_name;
$set_registry_regtest = 0;
&print_env_info;

if ($dcad_server ne "" && (not defined $ENV{R_ENABLE_DAUTO_CHECK}) ) {
  $ENV{R_ENABLE_DAUTO_CHECK} = 'true';
}

`$csh_cmd "${TOOLDIR}hwinfo >& hwinfo.log"` if (defined $ENV{R_HWINFO});
`$csh_cmd "echo $ENV{host} $ENV{PRO_MACHINE_TYPE} >& host_file"` if (defined $ENV{R_HOSTFILE});

# if ($OS_TYPE eq "UNIX" && -e "/net/foot/disk1/version/index.html") {
#   print "copy /net/foot/disk1/version/index.html to $cur_dir\n";
#   `$cp_cmd "/net/foot/disk1/version/index.html" "$cur_dir"`;
#}

if (exists $ENV{R_BITMAP} && $bitmap_save == 0 && ! -e $bitmapfile){
   @screendetails = `wmic desktopmonitor get screenheight, screenwidth`;

   if($screendetails[1] =~ m/(\d+)\s+(\d+)/ ) {
      ($screenheight, $screenwidth) = ($1, $2);
   }
  &print_bit_env;
}

if ($dcad_server eq "") {
  if (! -e "$ENV{R_AUTOTXT}") {
    print "\n ERROR: auto.txt missing $ENV{R_AUTOTXT} therefore stopping run.\n";
    exit(1);
  }
  $autotxt=$ENV{R_AUTOTXT};
  open (AUTOTXT, $autotxt);
  @auto_list = <AUTOTXT>;
  close(AUTOTXT);
  $num_tests=&get_num_tests;
  $curr_line = 0;
  $dcad_stop=1;
} else {
  $num_tests=0;
  $dcad_stop=0;
}

$test_num=0;
$result="";
$fail_no = 0;

$is_e2e_downloaded = 0;
if ($ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO} ne '') {
   $is_e2e_downloaded = 1;
}

$is_collab_test_repo_downloaded = 0;
if ($ENV{COLLAB_TEST_PLAYWRIGHT_REPO} ne '') {
   $is_collab_test_repo_downloaded = 1;
}

$is_gdx_test_repo_downloaded = 0;
if ($ENV{GDX_TEST_PLAYWRIGHT_REPO} ne '') {
   $is_gdx_test_repo_downloaded = 1;
}

while ((($dcad_server eq "") && $auto_list[$curr_line]) || ($dcad_stop == 0) 
  || $num_perf_test > 0 || $num_bitmap_test > 0 || $num_legacy_test > 0) {

   if ($OS_TYPE eq "UNIX" && $R_AUTO_CUTOFF) {
      `check_cutoff $R_AUTO_CUTOFF`;
      $status = $?;
      if ($status) {
         print "The cutoff time: $R_AUTO_CUTOFF has passed! Auto stop.\n";
         last;
      }
   }

   &reset_directives;
   $skip_tests = 0;
   $tk_flavor_ = "";
   $skip_msg = "";
   $check_for_success_status = 0;
   $uniquename = unique_string();

   $atlas_user_name1 = "";
   $atlas_user_name2 = "";
   $atlas_password1 = "";
   $atlas_password2 = "";
   $is_otheruser_xtop_only_fail = 0;
   $is_next_testname = 1;

   if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
      $check_stat = 0;
      $check_stat = basic_check_for_dauto_run();
      if ($check_stat) {
          print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
          exit($check_stat);   
      }
   }
   
   &get_unique_tmp_dir;
   `cp $rundir/auto_misc/* $tmpdir` if (-e "$rundir/auto_misc");
   chdir_safe ("$tmpdir");
   &read_a_test;
   if (parse_and_copy_a_test()) {
      mkdir ("$cur_dir/scratch_tmp", 0777);
      `$csh_cmd "$R_PRE_TEST_SCRIPT"` if ($R_PRE_TEST_SCRIPT);
      
      if ($ENV{R_VIDEO_CAPTURE} eq 'true') {     
         $ENV{CAPTURE_TIME_LOG} = true if (not defined $ENV{CAPTURE_TIME_LOG});
         $ENV{UIT_TRAIL_VIDEO_CAPTURE_OUTPUT} = `cygpath -m $cur_dir`;
         chomp($ENV{UIT_TRAIL_VIDEO_CAPTURE_OUTPUT});         
        if ($ENV{R_USE_LOCAL_VIDEO_CAPTURE} ne '') {
            $local_video_capture = CygPath($ENV{R_USE_LOCAL_VIDEO_CAPTURE});
            print "Running $local_video_capture $raw_trailname$tk_flavor_name $cur_dir \n";
            system("$csh_cmd \"$local_video_capture $raw_trailname$tk_flavor_name $cur_dir & \" ");
        } else {
          print "Running $ENV{PTC_TOOLS}/bin/video_capture.csh $raw_trailname$tk_flavor_name $cur_dir\n";
          system("$csh_cmd \"$ENV{PTC_TOOLS}/bin/video_capture.csh $raw_trailname$tk_flavor_name $cur_dir & \" ");
        }
        my $ws_trail = ${shared_workspace_trail};
         $ws_trail =~ s/(\.txt)$//;
        add_to_saveas("$raw_trailname$tk_flavor_name.vtl");
        add_to_saveas("$ws_trail.vtl") if($shared_workspace_trail_size > 0);
        add_to_saveas("$raw_trailname$tk_flavor_name.mp4");
        add_to_saveas("$ws_trail.mp4") if($shared_workspace_trail_size > 0);	
        add_to_saveas("$raw_trailname$tk_flavor_name.vcl") if ($ENV{R_SAVE_VIDEO_CAPTURE_LOG} eq 'true');  
        add_to_saveas("$ws_trail.vcl") if ($ENV{R_SAVE_VIDEO_CAPTURE_LOG} eq 'true' && $shared_workspace_trail_size > 0);  		
      }
      
      &run_a_test;
   }
   `$csh_cmd "$R_POST_TEST_SCRIPT"` if ($R_POST_TEST_SCRIPT);
   if ($directives{wildfire_test} || $directives{uwgmcc_test}) {
      if ( ( ! $non_fastreg && ($fastreg_test_flags{server}) ) || ($ENV{R_FIND_WNC_BUILD} eq "true")) {
         if ( ( defined $windchill_url && 
              ! ($keepscratch && $fastreg_test_flags{release_last}) &&
              ! ($fastreg_test_flags{keep_server} && ($result eq "SUCCESS")) ) || ($ENV{R_FIND_WNC_BUILD} eq "true")
            ) {
			if ( defined $ENV{R_USE_LOCAL_SERVER}){
				my $response = Wispauto::wisplib_release_windchill(@dirsToCopyServerLogs);
			} else {
            my $response = fastreg_release_windchill(@dirsToCopyServerLogs);
            }
            print_succfail("$response\n") if defined $response;
         }
         if ($WF_USERNAME_backup eq "") {
            delete $ENV{WF_USERNAME};
         } else {
            $ENV{WF_USERNAME} = $WF_USERNAME_backup;
         }
         if ($WF_PASSWD_backup eq "") {
            delete $ENV{WF_PASSWD};
         } else {
            $ENV{WF_PASSWD} = $WF_PASSWD_backup;
		}
      }
      &unset_mozilla_env if ($set_mozilla_env_ok);
      delete $ENV{PTC_MOZILLA_PROFILE};
      `$rm_cmd -rf "$rundir/MOZILLA_PROFILE"` if (-e "$rundir/MOZILLA_PROFILE");
# Delete WF_ROOT_DIR for every test, therefore moved out of wildfire block
      #`$rm_cmd -rf "$rundir/WF_ROOT_DIR"` if (-e "$rundir/WF_ROOT_DIR");
#      delete $ENV{PTC_NO_PVX_AUTOINSTALL};
   }
   `$rm_cmd -rf "$rundir/WF_ROOT_DIR"` if (-e "$rundir/WF_ROOT_DIR");

   #if can't delete, move it out #29420
   if (-e "$rundir/WF_ROOT_DIR") {
        my $wf_root_dir_suffix = 1;
        while (-e "$rundir/WF_ROOT_DIR$wf_root_dir_suffix") {
             $wf_root_dir_suffix++;
        }
        `mv "$rundir/WF_ROOT_DIR" "$rundir/WF_ROOT_DIR$wf_root_dir_suffix"`
   }

  if (defined $ENV{PTC_REGISTRY_REGTEST}) {
    if ($ENV{PTC_REGISTRY_REGTEST} ne "") {
      print "Running clear_regtest_registry\n";
      `$csh_cmd clear_regtest_registry`;
    }
  }
  if ($set_registry_regtest) {
    delete $ENV{PTC_REGISTRY_REGTEST};
	$set_registry_regtest = 0;
  }

   chdir_safe ("$rundir");
   opendir(TMPDIR, "$tmpdir");
   @files = grep {!/^\./} readdir(TMPDIR);
   chmod(0777, @files);
   closedir(TMPDIR);
   `$rm_cmd -rf "$tmpdir"`;
   if (exists $ENV{R_POST_PROCESSING} && -e $ENV{R_POST_PROCESSING} && -x $ENV{R_POST_PROCESSING}) {
      `$ENV{R_POST_PROCESSING}`;
   }
}

`$rm_cmd -rf "$rundir/auto_misc"` if (-e "$rundir/auto_misc");
if ($delete_creo_saas_automation_repo) {
   cleanup_playwright_data("$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}") if ("$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}" ne "");
}

if (${delete_creo_saas_automation_repo_gdx}) {
   cleanup_playwright_data("$ENV{GDX_TEST_PLAYWRIGHT_REPO}") if ("$ENV{GDX_TEST_PLAYWRIGHT_REPO}" ne "");
}

$endauto=time();
$time_str=localtime($endauto);
$total_time=cnv_sec_hms($endauto-$startsec);

if($ENV{'UWGM_HECTOR_RESULTS'} eq "true"){
   if($ENV{R_USE_LOCAL_HECTOR_XML_PL}){
      my $result = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $ENV{R_USE_LOCAL_HECTOR_XML_PL} $total_time $num_tests`;
	}
   else{
	my $result = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ${TOOLDIR}hector_xml.pl $total_time $num_tests`;    
   }
}

if($ENV{'UWGMQA_HECTOR_RESULTS'} eq "true" || $ENV{'CREOQA_HECTOR_RESULTS'} eq "true") {
	$ENV{"CREO_BUILD_VERSION"}=$version;	
	my $result = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $PTC_TOOLS/uwgmmacros/utils/uwgm_hector_xml.pl $total_time $num_tests`;
}

if ($ENV{R_USE_NUMBERED_SAAS_USERNAME} eq 'true') {
    `$rm_cmd "$PTC_UI_SERVICE_RUN_TRAIL_default"`;
    `$rm_cmd "$ZBROWSER_TRAIL_FILE_default"`;
}

print_succfail("\n\nAUTO finished at $time_str Total time $total_time\n");
if ($PRO_MACHINE_TYPE eq "ibm_rs6000" || $PRO_MACHINE_TYPE eq "i486_linux") {
   print "setting screen saver on\n";
   `xset s on`;
}
if ($old_tmpdir) {
   $ENV{TMPDIR} = $old_tmpdir;
} else {
   delete ($ENV{"TMPDIR"});
}

if (defined $ENV{R_EMAIL}) {
   if ($ENV{R_EMAIL} ne "") {
      open (TMP_MAINL, ">tmp_mail");
      print TMP_MAINL ("Regression test results\n");
      print TMP_MAINL ("Machine:\t $mach_name\n");
      print TMP_MAINL ("Directory:\t $rundir\n");
      print TMP_MAINL `see`;
      close (TMP_MAINL);
      `cat tmp_mail | mailx -s "Regression Test Done" $ENV{R_EMAIL}`;
      `$rm_cmd tmp_mail`;
   }
}
if (Uwgmreg::isUwgmTest()) {
   if (! Uwgmreg::summarizeResult()) {
       print "\nWARNING: UWGM problem in summarize";
   }
}

if ($OS_TYPE eq "NT" && ! defined($PTC_CYGWIN) && ! defined($PTC_MKS)) {
   `$csh_cmd "${TOOLDIR}auto_cleanup_o_db"`;
} else {
   `$csh_cmd "${TOOLDIR}auto_cleanup_odb"`;
}

if (-e $foreign_merge && ! -z $foreign_merge && $altlang ne "") {
   print "\nWARNING: there are records in the foreign_merge_errors.log\n\n";
}

if (defined $ENV{R_RENAME_HOME_CONFIG} && $ENV{R_RENAME_HOME_CONFIG} eq "true" && -e "$HOME/config.pro_auto") {
   print "Rename $HOME/config.pro to $HOME/config.pro_auto\n";
   `mv $HOME/config.pro_auto $HOME/config.pro`;
}

if (defined $ENV{'CDIMAGE_PERF_RUN'}) {
       delete $ENV{'R_PERF'};
}

if (defined $ENV{'R_BITMAP_RUN'}) {
       delete $ENV{'R_BITMAP'};
}
	 
if ($fail_no > 0) {
   exit (1);
} else {
   exit (0);
}

# End of main function

#This block will be prefomed on exit
END{
   if (defined $ENV{R_USE_AGENT}) {
      &creoagent_shutdown();
   }
   if (defined $ENV{R_INSTALL_CREO} && $ENV{R_INSTALL_CREO} eq "true" && not defined $ENV{R_DONOT_UNINSTALL_CREO}) {
		`rm $ENV{LOCAL_INSTALL_PATH}/$$.using_install_creo`;
		`mkdir -p $ENV{TMPDIR}`;
		
		print "\nTest Execution on Local Installed Creo is Completed. Will uninstall, if no other process is using the installation.\n\n";
		`cp $INSTALL_SCRIPTS_FOLDER/cdimage_install_uninstall.pl .`;

		if (defined $ENV{R_UNINSTALL_LOGS_DIR}){
			my $uninstall_pid = $$;
			`mkdir -p $R_UNINSTALL_LOGS_DIR`;
			open (STDOUT, ">$R_UNINSTALL_LOGS_DIR/uninstall_$uninstall_pid.log");

			print "uninstallation script starts............";
			`$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ./cdimage_install_uninstall.pl uninstall`;
			print "uninstallation script has completed!";
			close(STDOUT);
		} else {
			my $logs = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ./cdimage_install_uninstall.pl uninstall`;
			print "$logs\n";
		}
	}
   if (defined $ENV{R_INSTALL_CREO_SCHEMATICS} && $ENV{R_INSTALL_CREO_SCHEMATICS} eq "true" && not defined $ENV{R_DONOT_UNINSTALL_CREO}) {
		`rm $ENV{LOCAL_INSTALL_PATH}/$$.using_install_creo`;
		`mkdir -p $ENV{TMPDIR}`;
		
		print "\nTest Execution on Local Installed Creo Schematics is Completed. Will uninstall, if no other process is using the installation.\n\n";
		`cp $INSTALL_SCRIPTS_FOLDER/cdimage_install_uninstall_schematics.pl .`;
		my $logs = `$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ./cdimage_install_uninstall_schematics.pl uninstall`;
		print "$logs\n";
	}

#un-registration of CAD tools with WWGM on execution of the complete test desk.
 if ($OS_TYPE eq "NT") {
  if ($cadname) {
	my $uwgmregister_path = "$PTC_TOOLS/uwgmmacros/uwgmregister.exe";
	if (substr($cadname,0, 4) eq "ugnx") {
		$ENV{"PTC_WF_ROOT"} = "$rundir/NX_WF_ROOT_DIR";
		$ENV{"UGII_CUSTOM_DIRECTORY_FILE"} = "$rundir/NX_WF_ROOT_DIR/custom_dirs.dat";
	}
	my @uwgm_unregister_args = ($uwgmregister_path,"-u");
	system(@uwgm_unregister_args);
   `$rm_cmd -rf "$rundir/NX_WF_ROOT_DIR"` if (-e "$rundir/NX_WF_ROOT_DIR");
   }
 }
}

##############################################################################
# Config 
sub initialize_auto_config_file {

  #clear config file if created_at older than 7 days
  my $lock_file = "$auto_config_file.lock";
  system("touch $lock_file");
  open(my $lock_file_handle, $lock_file);
  flock($lock_file_handle, 2); #exclusive lock
  
  my $update_created_at = 0;
  my $created_at = read_auto_config_param('created_at');
  my $cur_time = time;
  my $max_age = 7 * 24 * 60 * 60;
  if (defined $created_at) {
    $created_at = $created_at + 0;
    if (($cur_time - $created_at) > $max_age) {
      $update_created_at = 1;
      print "initialize_auto_config_file: created_at of $auto_config_file is old: new val = $cur_time \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
    }  
  } else {
    $update_created_at = 1;    
    print "initialize_auto_config_file: created_at not available in $auto_config_file \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
  }
  
  if ($update_created_at == 1) { 
    #truncate config file
    open(my $conf_file_handle, "+< $auto_config_file"); #open file in read/write mode
    seek($conf_file_handle, 0, 0); truncate($conf_file_handle, 0); #truncate file
    close($conf_file_handle);  #close will release the exclusive lock    
    #delete config cache
    foreach my $key (keys %{$auto_config_cache}) {
      delete $_auto_config_cache{$key};
    }    
    write_auto_config_param('created_at', $cur_time);
  }
  
  close($lock_file_handle);
}

sub read_auto_config_param {
  my $param = shift;
  
  if (defined $_auto_config_cache{$param}) {
    print "read_auto_config_param: cache -> $param = $_auto_config_cache{$param} \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
    return $_auto_config_cache{$param};
  }
  
  if (-e $auto_config_file) {
    open(my $conf_file_handle, "$auto_config_file");
    flock($conf_file_handle, 1); #shared lock
    while(<$conf_file_handle>) {      
      my @conf_line_split = split(':', $_);
      chomp(@conf_line_split);
      $_auto_config_cache{$conf_line_split[0]} = $conf_line_split[1];
    }
    close($conf_file_handle);  #close will release the shared lock
  }
  
  return $_auto_config_cache{$param};  #if the conf file is not found then value remains undefined  
}

sub write_auto_config_param {
  my $param = shift;
  my $value = shift;
  
  if (! -e $auto_config_file) { 
    print "write_auto_config_param: touch $auto_config_file \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
    system("touch $auto_config_file");
  }
  
  open(my $conf_file_handle, "+< $auto_config_file"); #open file in read/write mode
  flock($conf_file_handle, 2); #exclusive lock
  chomp(my @conf_lines = <$conf_file_handle>); #read file
  
  my $param_found = 0;
  my $value_changed = 1;
  my @new_conf_lines;
  
  for my $conf_line (@conf_lines) {
    my @conf_line_split = split(':', $conf_line);
    chomp(@conf_line_split);
    
    if ($conf_line_split[0] eq $param) {
      $param_found = 1;
      if ($conf_line_split[1] eq $value) {
        $value_changed = 0;
        last;
      } else {      
        print "write_auto_config_param: updating -> $conf_line_split[0]:$value \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
        push @new_conf_lines, "$conf_line_split[0]:$value";
      }
    } else {
      push @new_conf_lines, "$conf_line_split[0]:$conf_line_split[1]";
    }
    
  }
  
  if ($param_found == 0) {
    print "write_auto_config_param: appending -> $param:$value \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
    push @new_conf_lines, "$param:$value"; #insert
  }
  
  if ($value_changed == 1) {
    print "write_auto_config_param: truncating config file\n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
    seek($conf_file_handle, 0, 0); truncate($conf_file_handle, 0); #truncate file
    for my $conf_line (@new_conf_lines) {    
      print $conf_file_handle "$conf_line\n";
    }
  } else {
    print "write_auto_config_param: skipping config file write -> $param:$value \n" if (defined $ENV{'DEBUG_AUTO_CONFIG'});
  }
  
  close($conf_file_handle);  #close will release the exclusive lock
}
##############################################################################
# Sub-Functions

sub init_sys_env {
   $spgid=`$csh_cmd "genid"`;
   chop($spgid);

   if ($ENV{R_PERF} eq 'true' ) {
     $ENV{"AUTO_PROC_MEM_LIMIT"} = "0" if (! exists $ENV{"AUTO_PROC_MEM_LIMIT"});
     print "using AUTO_PROC_MEM_LIMIT = $ENV{AUTO_PROC_MEM_LIMIT} for performance testing\n";
      if ($ENV{P_VERSION} >= 410) {
        if ($ENV{DISABLE_UI_TRAIL_STRICT_VALIDATION} =~ /yes/i) {
           print "WARNING:Not using UI_TRAIL_STRICT_VALIDATION\n"; 
        } else {
           $ENV{"UI_TRAIL_STRICT_VALIDATION"} = 't';
           print "using UI_TRAIL_STRICT_VALIDATION == $ENV{UI_TRAIL_STRICT_VALIDATION} for performance testing\n";               
           if ($ENV{R_ALT_ALLOWED_FAILURES_LOG} ne '') {
              print "using R_ALT_ALLOWED_FAILURES_LOG == $ENV{R_ALT_ALLOWED_FAILURES_LOG} for performance testing\n";
              if (! -d "$ENV{R_ALT_ALLOWED_FAILURES_LOG}") {
                 print "WARNING: directory R_ALT_ALLOWED_FAILURES_LOG = $ENV{R_ALT_ALLOWED_FAILURES_LOG} is missing\n";  
              }                      
           } elsif (! -e "$ENV{PTCSRC}/apps/pro_unittest/test/allowed_failures.log") {
              print "WARNING: $ENV{PTCSRC}/apps/pro_unittest/test/allowed_failures.log is missing\n"; 
           }
        }
      }
   } elsif ($ENV{PTC_MEMMGR_STYLE} eq 'slim' ) {
     $ENV{"AUTO_PROC_MEM_LIMIT"} = "0" if (! exists $ENV{"AUTO_PROC_MEM_LIMIT"});
     $ENV{"PTC_TRAIL_DELAY"} = "3600" if (! exists $ENV{"PTC_TRAIL_DELAY"});
     $ENV{"R_RUN_MECH_TEST_LONG"} = "true" if (! exists $ENV{"R_RUN_MECH_TEST_LONG"});
     print "using AUTO_PROC_MEM_LIMIT = $ENV{AUTO_PROC_MEM_LIMIT} for appverifier test run\n";
     print "using PTC_TRAIL_DELAY = $ENV{PTC_TRAIL_DELAY} for appverifier test run\n";
     print "using R_RUN_MECH_TEST_LONG = $ENV{R_RUN_MECH_TEST_LONG} for appverifier test run\n";
   } elsif ($ENV{R_SUPERAUTO} eq 'true' ) {
     $ENV{"AUTO_PROC_MEM_LIMIT"} = "0" if (! exists $ENV{"AUTO_PROC_MEM_LIMIT"});
     $ENV{"PTC_TRAIL_DELAY"} = "3600" if (! exists $ENV{"PTC_TRAIL_DELAY"});
     $ENV{"R_RUN_MECH_TEST_LONG"} = "true" if (! exists $ENV{"R_RUN_MECH_TEST_LONG"});
     $ENV{"R_REGRES_BIN"} = "$ENV{PTCSYS}/npobj" if (! exists $ENV{"R_REGRES_BIN"});
     $ENV{"R_PDEV_REGRES_BIN"} = "$ENV{PTCSYS}/npobj" if (! exists $ENV{"R_PDEV_REGRES_BIN"});
     print "using AUTO_PROC_MEM_LIMIT = $ENV{AUTO_PROC_MEM_LIMIT} for superauto test run\n";
     print "using PTC_TRAIL_DELAY = $ENV{PTC_TRAIL_DELAY} for superauto test run\n";
     print "using R_RUN_MECH_TEST_LONG = $ENV{R_RUN_MECH_TEST_LONG} for superauto test run\n";
     print "using R_REGRES_BIN = $ENV{R_REGRES_BIN} for superauto test run\n";
     print "using R_PDEV_REGRES_BIN = $ENV{R_PDEV_REGRES_BIN} for superauto test run\n";
   }   
   
   if (exists $ENV{PTC_ILLIB}) {
      $lib_add = "${PTC_ILLIB}:${PRO_DIRECTORY}/${PRO_MACHINE_TYPE}/lib";
   }
   else {
      $lib_add = "${PRO_DIRECTORY}/${PRO_MACHINE_TYPE}/illib:${PRO_DIRECTORY}/${PRO_MACHINE_TYPE}/lib";
   }

   if (exists $ENV{PTC_ADVAPPSLIB}) {
     $lib_add = "${PTC_ADVAPPSLIB}:${lib_add}";
     if ($OS_TYPE eq "NT") {
        $ENV{PATH} = "$ENV{PTC_ADVAPPSLIB};$ENV{PATH}";
     }
   }

   if (exists $ENV{R_REGRES_BIN}) {
     $lib_add = "$ENV{R_REGRES_BIN}:${lib_add}";
     if ($OS_TYPE eq "NT") {
        $ENV{PATH} = "$ENV{R_REGRES_BIN};$ENV{PATH}";
     }
   }

   if ($PRO_MACHINE_TYPE eq "hp8k" || $PRO_MACHINE_TYPE eq "hpux11_pa32") {
     if (exists $ENV{SHLIB_PATH}) {
        $ENV{SHLIB_PATH} = "$lib_add:${SHLIB_PATH}:$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj:/opt/graphics/OpenGL/lib:/opt/graphics/common/lib";
     }
     else {
        $ENV{"SHLIB_PATH"} = "$lib_add:$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj:/opt/graphics/OpenGL/lib:/opt/graphics/common/lib";
     }
   }
   if ($PRO_MACHINE_TYPE eq "sun4_solaris" || $PRO_MACHINE_TYPE eq "sun4_solaris_64") {
     push @ENV, $OGLHOME if ( ! exists $ENV{OGLHOME});
     push @ENV, $OIVHOME if ( ! exists $ENV{OGLHOME});
     $ENV{OGLHOME} = "/opt/OpenGL";
     $ENV{OIVHOME} = "/opt/OpenInventor";
     if (exists $ENV{LD_LIBRARY_PATH}) {
        $ENV{LD_LIBRARY_PATH} = "$lib_add:${LD_LIBRARY_PATH}:/usr/ucblib:/usr/openwin/lib:$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj"
     }
     else {
        $ENV{"LD_LIBRARY_PATH"} = "$lib_add:/usr/ucblib:/usr/openwin/lib:/tools/auxobjs/sun4_solaris/GL:$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj";
     }
   }
   if ($PRO_MACHINE_TYPE eq "sun_solaris_x64") {
      if (exists $ENV{LD_LIBRARY_PATH}) {
     $ENV{LD_LIBRARY_PATH} = "$lib_add:${LD_LIBRARY_PATH}";
      } else {
     $ENV{LD_LIBRARY_PATH} = "$lib_add";
      }
   }
   $old_LD_LIBRARY_PATH = ${LD_LIBRARY_PATH};
   if ($PRO_MACHINE_TYPE eq "ibm_rs6000") {
     print "setting screen saver off";
     `xset s off`;
   }
   delete $ENV{CONTINUE_FROM_OOS};
   delete $ENV{UIF_TRAIL_OOS};
   if (! exists $ENV{WAIT_FRPROE}) {
     $ENV{"WAIT_FRPROE"} = 600;
   }
   if (! exists $ENV{R_CHECK_DBGFILE}) {
     $ENV{"R_CHECK_DBGFILE"} = "true";
   }
   push @ENV, $P_MODEL if (! exists $ENV{P_MODEL});
   if (! exists $ENV{CV_ENV_HOME}) {
     $ENV{"CV_ENV_HOME"} = "$PTC_TOOLS/auxobjs/$PRO_MACHINE_TYPE/CV";
   }
   #Moved following block to sub set_altlang in GetTrlUtil.pm
   #if (! exists $ENV{LANG}) {
   #  $ENV{"LANG"} = "C";
   #}
   #if (defined $ENV{PRO_LANG}) {
   #  $ENV{LANG} = $ENV{PRO_LANG};
   #}

   if (! exists $ENV{R_EXIT_ON_CORE} || ! exists $ENV{R_SAVE_ALL_CORE}
      || ! exists $ENV{R_GETTB_CORE}) {
      if ($PRO_MACHINE_TYPE !~ /hp/ && $PRO_MACHINE_TYPE !~ /nec/
         && $PRO_MACHINE_TYPE ne "hitachi" && $OS_TYPE eq "UNIX") {
        `limit coredumpsize unlimited`;
      }
   }

   if ( -e "$HOME/.flexlmrc" ) {
      print "WARNING: You have .flexlmrc in your home directory.\n";
      print "         removing $HOME/.flexlmrc\n";
      `$rm_cmd "$HOME/.flexlmrc"`;
   }

  if (not defined $ENV{R_USE_CREO_PLUS}) {
     if (defined $ENV{R_NODE_LOCK_LIC_DIR}) {
        my $mn = `hostname`;
        chomp($mn);
        $mach_name = lc($mn);
        $ENV{PTC_D_LICENSE_FILE} = "$ENV{R_NODE_LOCK_LIC_DIR}/$mach_name.dat";
        print "R_NODE_LOCK_LIC_DIR is set to $ENV{R_NODE_LOCK_LIC_DIR} \n";
        print "PTC_D_LICENSE_FILE is set to $ENV{PTC_D_LICENSE_FILE} \n";
        if (! -e "$ENV{PTC_D_LICENSE_FILE}") {
           print "\n\n Aborting auto.pl because $ENV{PTC_D_LICENSE_FILE} file missing \n";
           exit(1);
        }
     }
      
   if (defined $ENV{R_ALT_LICENSE_FILE}) {
      $auto_license_file = $ENV{R_ALT_LICENSE_FILE};
   }
   elsif (defined $ENV{PTC_D_LICENSE_FILE} &&
      defined $ENV{R_DISABLE_AUTO_LICENSING}) {
      $auto_license_file = $ENV{PTC_D_LICENSE_FILE};
   } else {
      $auto_license_file=`$csh_cmd "getversiondir dummy flex_auto $OPER_SYS"`;
      chomp ($auto_license_file);

# This is a temperory hack to remove the prefix binary characters in
# $auto_license_file on chinese 64 bit windows platform. We may want to
# remove it after upgrading to perl 5.8

      if ($altlang =~ /chinese/) {
          $auto_license_file=~ s/\W*.*?(\d{4}\@.*)/$1/;
      }
   }
  }

   if (! defined $ENV{R_ENABLE_LICENSING}) {
      if (exists $ENV{LM_LICENSE_FILE}) {
         $LM_LICENSE_FILE_backup = $ENV{LM_LICENSE_FILE};
      } else {
         $LM_LICENSE_FILE_backup = "";
      }
      delete $ENV{LM_LICENSE_FILE};
      delete $ENV{PTC_D_LICENSE_FILE} if (! -e $ENV{PTC_D_LICENSE_FILE});
      delete $ENV{PRO_LICENSE_RES};
      delete $ENV{PROE_FEATURE_NAME};
      delete $ENV{CREOPMA_FEATURE_NAME};
      delete $ENV{CREODMA_FEATURE_NAME};
      delete $ENV{CREOSIM_FEATURE_NAME};
      delete $ENV{CREOLAY_FEATURE_NAME};
      delete $ENV{CREOSHELL_FEATURE_NAME};
   }

   if (defined $ENV{WF_USERNAME}) {
      $WF_USERNAME_backup = $ENV{WF_USERNAME};
   } else {
      $WF_USERNAME_backup = "";
   }

   if (defined $ENV{WF_PASSWD}) {
      $WF_PASSWD_backup = $ENV{WF_PASSWD};
   } else {
      $WF_PASSWD_backup = "";
   }

   if ($OS_TYPE eq "UNIX") {
      if (defined $ENV{_RLD_ARGS}) {
         $ENV{_RLD_ARGS} = "$ENV{_RLD_ARGS} -log _rld_args.log";
      } else {
         $ENV{_RLD_ARGS} = "-log _rld_args.log";
      }
   }

   if ($PRO_MACHINE_TYPE =~ /i486_nt|x86e_win64/) {
      if ($ENV{R_IGNORE_XTOP} ne "true" && $ENV{R_RUN_WF_JS_SETTINGS} ne "false") {
        if (! defined read_auto_config_param('wf_js_settings')) {
          print "Running cscript $PTC_TOOLS/bin/wf_js_settings.vbs\n" ;
          system("cscript $PTC_TOOLS/bin/wf_js_settings.vbs");
          write_auto_config_param('wf_js_settings', '1');
        } else {
          print "Used $auto_config_file: Skipping cscript $PTC_TOOLS/bin/wf_js_settings.vbs\n" ;
        }        
      }
   }

   if ($OS_TYPE eq "NT") {
       $WIN_OS = read_auto_config_param('WIN_OS');
       if (! defined $WIN_OS) {
          $WIN_OS = `$csh_cmd "win_os"`;
          chomp $WIN_OS;
          print "Obtained WIN_OS = $WIN_OS\n";  
          write_auto_config_param('WIN_OS', $WIN_OS);
       } else {
          print "Used $auto_config_file: WIN_OS = $WIN_OS\n";  
       }       
   }
   if ($r_using_local_install == 1) {
     # Required for local install to run scripts from scratch dir.
     $ENV{PATH} = "$ENV{PATH};.";
     $PATH_default = "$ENV{PATH}";
   }
}

sub CygPath
{
  my $path = shift;
  $path =~ s/\\/\//g;
  return $path;
}

sub WinPath
{
  my $path = shift;
  $path =~ s/\//\\/g;
  return $path;
}

# dirs -a reference to a  list of root dirs
# recursive - weather to traverse recursivley 
# return: a map : [<file_name> ==> <array of paths where found>]
sub get_files_from_dirs
{
   my ($dirs, $recursive) = @_;
   my %seendirs;
   my %seenfiles;

   while (my $pwd = shift @{$dirs}) {
        $pwd = CygPath($pwd);
        chomp($pwd);
        opendir(DIR,"$pwd") or die "Cannot open $pwd\n";
        my @files = readdir(DIR);
        closedir(DIR);
        foreach my $file (@files) {
          if ($recursive and -d "$pwd/$file" and ($file !~ /^\.\.?$/) and not ( "$pwd"  eq $seendirs{$file} ) ) {
             $seendirs{$file} = "$pwd";
             push @{$dirs}, "$pwd/$file";
          } 
          if (-e "$pwd/$file") {
            my @arr;

            if(exists $seenfiles{$file}){
              @arr = @{$seenfiles{$file}};
            }
            push (@arr, "$pwd");
            $seenfiles{$file} = [@arr];
         }
       }
   }
   return %seenfiles;
}

sub unpack_one_msi
{
  my $msi = shift;
  my $target_dir = shift;

  $msi = WinPath($msi);
  $target_dir = WinPath($target_dir);
  print "unpacking $msi to $target_dir\n";
  `msiexec /a \"$msi\" /quiet TARGETDIR=\"$target_dir\"`;
  return $?;
}

# pack_location: pack location
# pack_name: name of pack 
# unpacks pack to a new folder named <pack_name>.<pack type> under pack_location 
# currently supprts .zip and .msi pack types only
sub handle_unpack
{
  my $pack_location = shift;
  my $pack_name = shift; 
  my $unpack_ret_code = 0;
  my $unpack_dir = "";
  
  if($pack_name=~ /\.zip$/){
    $unpack_dir = fileparse($pack_name, ".zip");
    $unpack_dir .= ".zip.unpacked"; #unpack_dir = <zip file name>.zip.unpacked

    my $lck = _lock_file("$pack_location/unapck.lock");
    if(! -d "$pack_location/$unpack_dir"){
      print "unpacking zip:\n";
      print "unzip.exe -uo $pack_location/$pack_name -d $pack_location/$unpack_dir\n";
      $unpack_ret_code=`\"unzip.exe -uo $pack_location/$pack_name -d $pack_location/$unpack_dir\"`;
    }
    _unlock_file($lck);
  }
  elsif ($pack_name=~ /\.msi$/) {
    $unpack_dir = fileparse($pack_name, ".msi");
    $unpack_dir .= ".msi.unpacked"; #unpack_dir = <msi file name>.msi.unpacked

    my $lck = _lock_file("$pack_location/unapck.lock");
    if(! -d "$pack_location/$unpack_dir"){
      $unpack_ret_code = unpack_one_msi("$pack_location/$pack_name", "$pack_location/$unpack_dir");
    }
     _unlock_file($lck);
  }
  return ($unpack_ret_code, $unpack_dir);
}

#removes spaces from left and right of string 
sub  trim_spaces { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
sub init_local_build_env {
   my $env_vars_file = "${TOOLDIR}auto_env_vars.txt";
   return if (! defined $ENV{R_REGRES_BIN});
   return if (! -d $ENV{R_REGRES_BIN});
   return if (! -e $env_vars_file );

   if (defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
       my $local_env = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/tools/bin/auto_env_vars.txt";
       if (-r "$local_env") {
           $env_vars_file = "$local_env";
       }
   }
   open (AUTO_ENV, "$env_vars_file" );
   my (@lines) = <AUTO_ENV>;
   close (AUTO_ENV);
   chomp (@lines);
   
   my $is32FolderExists = 0;
   if (-e "$ENV{R_REGRES_BIN}32") {
		$is32FolderExists = 1;
   }

   print "\n\nSetting environment variables for local executables.....\n\n";
   foreach $line (@lines) {
      my $first_char = substr($line, 0, 1);
      next if ($first_char eq "#");
      my ($local_env, $exe_location, $cat) = split(/\s+/, $line);
      my $local_exe = undef;
      my $val = undef;
      my @opt_arr = ();
      my @location_opts = split(/:/,$exe_location);
      my $die_on_err = 0;

      if($#location_opts  == 0){
      	#<just a file name>
        $local_exe = $location_opts[0];
        my @reg_bin_list = ("$ENV{R_REGRES_BIN}");
        my %seenfiles = get_files_from_dirs(\@reg_bin_list, 0); 
        @opt_arr = @{$seenfiles{$local_exe}}; 
      }
      elsif (defined $ENV{R_AUTO_COPY_XTOP}) {
        # unpacking logic currently works only with R_AUTO_COPY_XTOP 
        # because it unpacks to R_REGRES_BIN which otherwise may point to developer's machine
        my ($unpack_ret_code, $unpack_dir) = (-1, undef);

        if($#location_opts == 1){
        	#<pack name>:<file name to look in pack>
          (my $pack_name, $local_exe) = ($location_opts[0], $location_opts[1]);
          next if ! -e "$ENV{R_REGRES_BIN}/$pack_name";
          $die_on_err = 1;
          ($unpack_ret_code, $unpack_dir) = handle_unpack("$ENV{R_REGRES_BIN}", "$pack_name");
        }
        elsif($#location_opts == 2){
          #ENV:<env name>:<file name to look in env destination>
          if ($location_opts[0] == "ENV") {
            (my $env_loc, $local_exe) = ($location_opts[1], $location_opts[2]);
            if (defined $ENV{$env_loc}) {
              my $pack_name = basename ("$ENV{$env_loc}"); $pack_name = "local."."$pack_name";
              $unpack_dir = "$pack_name";
              my $env_loc_trimmed = $ENV{$env_loc};
              chomp($env_loc_trimmed);
              $env_loc_trimmed = trim_spaces($env_loc_trimmed);
              if (-d $env_loc_trimmed) {
                `cp -rT $env_loc_trimmed $ENV{R_REGRES_BIN}/$pack_name`;     
                 $unpack_ret_code = 0;
              }
              elsif (-e  $env_loc_trimmed ) {
                $die_on_err = 1;
                `cp  $env_loc_trimmed  $ENV{R_REGRES_BIN}/$pack_name`;
                ($unpack_ret_code, $unpack_dir) = handle_unpack("$ENV{R_REGRES_BIN}", "$pack_name");    
              }
              else {
                print ("parsing auto_env_vars.txt:  $env_loc_trimmed  does not exist \n");
              }
            }
            else{ 
              print ("parsing auto_env_vars.txt: $env_loc env not defined\n");
            }
          }
          else{ 
            die ("parsing auto_env_vars.txt: unknown prefix at line $line\n");
          }
        }
        else{ 
          die ("parsing auto_env_vars.txt: unknown format at line $line\n");
        } 
        if ($unpack_ret_code == 0) {
          my @unpack_dir_list = ("$ENV{R_REGRES_BIN}/$unpack_dir");
          my %seenfiles = get_files_from_dirs(\@unpack_dir_list, 1);
          @opt_arr = @{$seenfiles{$local_exe}}; 
        }
        elsif($die_on_err == 1){
            die ("error ($unpack_ret_code) while trying to unpack \n");
        }
      }      

      my $nopts = scalar @opt_arr;
      if ($nopts > 0 ) { #the local_exe exsists either in R_REGRES_BIN or a pack
        if ($nopts > 1 ) {
            print "\nDBGWARNING: $local_exe has $nopts options to be set\n";
            print "using the one from ($opt_arr[$#opt_arr])\n\n";
        }
        if ($cat eq "path") {
            $val = "$opt_arr[$#opt_arr]";
        } 
        else {
          $val = "$opt_arr[$#opt_arr]/$local_exe";
        }       
      }  
      elsif($is32FolderExists) {
        if (-e "$ENV{R_REGRES_BIN}32/$local_exe") {
          if ($cat eq "path") {
            $val = "$ENV{R_REGRES_BIN}32";
          } 
          else {
              $val = "$ENV{R_REGRES_BIN}32/$local_exe";
          }
        }
      }

      if (defined $val) {
         # On Windows R_REGRES_BIN may have back slashes if it
         # contains a UNC share path. These backslashes cause some 
         # tests to fail. 
         $val =~ tr/\\/\//;
         $ENV{$local_env} = $val;
         print "$local_env is set to $val\n";
      }
   }
   print "\n";
}

sub run_local_collab_svc {
    if (!defined $ENV{CREO_COLLAB_SVC_EXE}){
		$ENV{CREO_COLLAB_SVC_EXE} = "$ENV{PTCSRC}/auxobjs/x86e_win64/collabsvc/collabsvc.exe";
		$keep_creo_collab_svc_exe = "false";
	}
	
    my $svc_exe = $ENV{CREO_COLLAB_SVC_EXE};
    $ENV{serverPort} = 0;
    
 	#open COLLABSVC, "csh -fc '$svc_exe' 2>&1 |" || die "can't launch svc_exe";
	
    if (-d "$cur_dir/scratch_tmp") {
       print "\nverify(collabsvc): $cur_dir/scratch_tmp  exists";
       my @filelist = glob("$cur_dir/scratch_tmp/*");
       chomp(@filelist);
       foreach (@filelist) {
           print "$_\n";
       }

       if (-e "$cur_dir/scratch_tmp/pid") {
          print "verify(collabsvc):$cur_dir/scratch_tmp/pid already exists\n";
       }
       if (-d "$cur_dir/scratch_tmp/collabsvc_store") {
          print "verify(collabsvc):$cur_dir/scratch_tmp/collabsvc_store already exists\n";
       }  
   }
    
	system("csh -fc \"$svc_exe >& collabsvc_exe.log.$$ & \"");
	$count = 0;
	while (1) {
		$count_svclog  = `$csh_cmd "wc -l collabsvc_exe.log.$$ " `;
        chomp($count_svclog);
		if (-e "collabsvc_exe.log.$$") {
		   print "count:$count,  found collabsvc_exe.log.$$, count_svclog:$count_svclog  \n";
	    } else {
			print "count:$count, not found collabsvc_exe.log.$$ \n";	
		}
		last if ( (-e "collabsvc_exe.log.$$" && $count_svclog >25 ) || $count >= 120 ) ;
		$count = $count + 1;
	}

  my $srvPort = -1;
  my $srvPID = -1;
  if (! -e "collabsvc_exe.log.$$") {	
	   print " ERROR: collabsvc_exe.log.$$ missing \n";
  } else {
	print "OPENING collabsvc_exe.log.$$\n";
	open(COLLABSVC,"< collabsvc_exe.log.$$");
    $count = 0;
    while (<COLLABSVC>) {
      $count = $count +1 ;
      if (/^Port:\s+(\d+)/) {
        $srvPort = $1;
      }
      if (/^PID:\s+(\d+)/) {
        $srvPID = $1;
      }
	  print "Looping over COLLABSVC file $count, with srvPID:$srvPID, srvPort:$srvPort \n";
      last if $srvPID != -1 && $srvPort != -1;
    }
	close(COLLABSVC);
  }

	#print "Found : Next excuting fork process\n";
    # we no longer need to directly monitor collabsvc output... but if
    # we don't it will hang. delegate that job so we can get on with
    # running tests.
    
	#my $read_pid = fork();
    #if ($read_pid == 0) {
      # child process just keeps unblocking collabsvc stdout
    #  while (<COLLABSVC>) {
     # }
    #  exit;
    #}
	
	print "Continuing with parent process, server running on $srvPort \n";
    # meanwhile back in parent process
    if ($srvPort == -1) {
        my $collabsvc_logname = "collabsvc_exe.log.$$";
        my $collabsv_log = `$csh_cmd  " cat  $collabsvc_logname " `;
        print "\n\n$collabsv_log\n\n";
    }

    return ($srvPID,$srvPort);
}

sub init_proe_env {
   if (exists $ENV{R_PROTAB}) {
      $protab_exec = $ENV{R_PROTAB};
   }
   else {
      $protab_exec = "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj/protab";
      $ENV{"R_PROTAB"} = $protab_exec;
   }
   if (exists $ENV{R_PT_TEST_ASYNC}) {
      $pt_tests_async_exec = $ENV{R_PT_TEST_ASYNC};
   } elsif ( exists $ENV{R_PDEV_REGRES_BIN}) {
      $pt_tests_async_exec = get_pdev_exe( "pt_tests_async" );
   } else {
      $pt_tests_async_exec = "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj/pt_tests_async";
   }
   if (exists $ENV{R_PT_WT_TEST_ASYNC}) {
      $pt_wt_tests_async_exec = $ENV{R_PT_WT_TEST_ASYNC};
   } elsif ( exists $ENV{R_PDEV_REGRES_BIN}) {
      $pt_wt_tests_async_exec = get_pdev_exe( "pt_wt_tests_async" );
   } else {
      $pt_wt_tests_async_exec = "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj/pt_wt_tests_async";
   }

   if ($OS_TYPE eq "UNIX" && ! -x $protab_exec) {
      print "\nWARNING:  the protab executable $protab_exec\n";
      print "does not have execute permissions, or does not exist.\n\n";
   }
   if (! exists $ENV{PROGUIDE_DIRECTORY}) {
      print "Warning:  PROGUIDE_DIRECTORY is not defined.\n";
      print "Setting to $PRO_DIRECTORY/uifdoc\n";
      $ENV{"PROGUIDE_DIRECTORY"} = "$PRO_DIRECTORY/uifdoc";
   }
   if (! exists $ENV{PROTABLE_DIRECTORY}) {
      print "Warning:  PROTABLE_DIRECTORY is not defined.\n";
      print "Setting to $PRO_DIRECTORY/protable\n";
      $ENV{"PROTABLE_DIRECTORY"} = "$PRO_DIRECTORY/protable";
   }
   if (exists $ENV{R_PROGUIDE}) {
      $proguide_exec = $ENV{R_PROGUIDE};
   }
   else {
      $proguide_exec = "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj/proguide";
   }
   if (exists $ENV{R_FBUILDER}) {
      $fbuilder_exe = $ENV{R_FBUILDER};
   } else {
      $fbuilder_exe = "$PTCSYS/obj/fbuilder";
   }
   if (exists $ENV{R_PROBATCH}) {
      $probatch_exec = $ENV{R_PROBATCH};
   } else {
      $probatch_exec = "${TOOLDIR}pro_batch";
   }
   $ENV{"PRO_JUNIOR_ACTIVE"}="false" if (! exists $ENV{PRO_JUNIOR_ACTIVE});
   if (exists $ENV{R_PROFLY}) {
      $profly_exec = $ENV{R_PROFLY};
   } else {
      $profly_exec = "$PTCSYS/obj/profly";
   }
   if (!defined $ENV{R_RUN_MECH_TEST}) {
      $ENV{"R_RUN_MECH_TEST"} = true;
   }
   $ENV{"R_RUN_DRM_TESTS"} = false if (!defined $ENV{R_RUN_DRM_TESTS});
   $ENV{"R_RUN_UWGMCC_TESTS"} = false if (!defined $ENV{R_RUN_UWGMCC_TESTS});
   $ENV{"R_RUN_OBSOLETE_TEST"} = false if (!defined $ENV{R_RUN_OBSOLETE_TEST});
   $ENV{"CREOINT_PRODUCTION_STATUS"} = PRODUCTION if (!defined $ENV{CREOINT_PRODUCTION_STATUS});

   $ENV{"GR_ANNOT_FULL"} = true;
   $ENV{"PROTOOL_DEBUG"}="crash";
#  $ENV{"PRO_MECH_COMMAND"}=$local_xtop;
   $ENV{"LOCALPROE"}=$local_xtop;
}

sub init_auto_env {
   $all_wildfire = defined $ENV{IS_WILDFIRE_TEST};
   push @ENV, $R_ALT_QCR_DIR if ( ! exists $ENV{R_ALT_QCR_DIR});
   push @ENV, $R_ALT_TRAIL_DIR if ( ! exists $ENV{R_ALT_TRAIL_DIR});
   if (exists $ENV{R_SUCC_TRAIL_DIR}) {
      mkdir ($R_SUCC_TRAIL_DIR, 0777) if (! -d $R_SUCC_TRAIL_DIR);
   if (exists $ENV{R_UPD_TRAIL_DIR}) {
      mkdir ($R_UPD_TRAIL_DIR, 0777) if (! -d $R_UPD_TRAIL_DIR);
    }
   }

   if (exists $ENV{R_BITMAP} || exists $ENV{R_BITMAP_TEXT}) {
     if (defined $ENV{R_BITMAPDB_PATH}) {
    print "NOTE: R_BITMAPDB_PATH is set, using R_BITMAPDB_PATH for path to bitdb\n";
    $bitdb_path = $ENV{R_BITMAPDB_PATH};
     } else {
    $bitdb_path = $ENV{PTCSRC};
     }
     print "R_BITMAP is set to $R_BITMAP. \n" if (exists $ENV{R_BITMAP});
     print "R_BITMAP_TEXT is set to $R_BITMAP_TEXT\n" if (exists $ENV{R_BITMAP_TEXT});
     print "This script will run in Bitmap Mode\n";
     print " Path to bitdb = $bitdb_path\n";
   }

   if (exists $ENV{R_BITMAP_SAVE} && $ENV{R_BITMAP_SAVE} eq "true") {
     $bitmap_save = 1 ;
     print "R_BITMAP_SAVE is set to $R_BITMAP_SAVE\n";
     print "This script will run in Bitmap Mode and save/copy images at the finish of each test.\n";
   }else{
     $bitmap_save = 0 ;
   }

   if (exists $ENV{R_BITMAP_TEXT_SAVE} && $ENV{R_BITMAP_TEXT_SAVE} eq "true") {
     $bitmap_text_save = 1 ;
     print "R_BITMAP_TEXT_SAVE is set to $R_BITMAP_TEXT_SAVE\n";
     print "This script will run in Bitmap Mode and save bitmap text at the finish of each test.\n";
   }else{
     $bitmap_text_save = 0 ;
   }

   if (exists $ENV{R_SPECIFIC_FILE}) {
     $image_file = $ENV{R_SPECIFIC_FILE} ;
     print "R_SPECIFIC_FILE is set to $R_SPECIFIC_FILE\n";
     print "This script will use $image_file for updations\n";
   }

   if (exists $ENV{R_BITMAP_SAVE_SPECIFIC} && $ENV{R_BITMAP_SAVE_SPECIFIC} eq "true" && $bitmap_save == "1" && exists $ENV{R_SPECIFIC_FILE}) {
     ($is_sp_ok,$testhashref) = test_updtfile($image_file);
     if($is_sp_ok){
       $bit_specific = 1;
       print "R_BITMAP_SAVE_SPECIFIC is set $R_BITMAP_SAVE_SPECIFIC\n";
       print "This script will save specific images to database\n";
     }else{
       $bit_specific = 0 ;
       print "\n\n$image_file is NOT OK\n\n";
       print "This script will save all images to database\n";
     }
   }else{
     $bit_specific = 0 ;
   }

   if (exists $ENV{R_IMAGE_TOL}) {
      print "R_IMAGE_TOL is set to $R_IMAGE_TOL\n";
      print "This script will use above image tolerence to compare bitmaps.\n";
   }

   if (exists $ENV{R_NICE}) {
      print "Increasing the nice value by $R_NICE\n";
      `$csh_cmd "nice +$R_NICE"`;
      # Don't want this recursive!!!
      delete ($ENV{"R_NICE"});
   }
   if (! exists $ENV{R_AUTOTXT}) {
      $ENV{"R_AUTOTXT"} = "auto.txt";
      print "warning:  R_AUTOTXT is not set, using default auto list $ENV{R_AUTOTXT}\n";
   }
   if (! exists $ENV{R_GPROF}) {
      $ENV{"R_GPROF"} = "false";
   }
   if (! exists $ENV{R_FLOAT_CHECK}) {
      $ENV{"R_FLOAT_CHECK"} = "false";
   }
   elsif ($R_FLOAT_CHECK eq "true") {
      $ENV{"R_RUNMODE"} = "-35628";
   }
   if (! exists $ENV{R_PERF}) {
     $ENV{"R_PERF"} = "false";
   }
   push @ENV, $R_PRODEV_REGRESS if (! exists $ENV{R_PRODEV_REGRESS});
   $ENV{R_PRODEV_REGRESS} = "true";
   if (! exists $ENV{R_RUNMODE}) {
      if ( $ENV{R_PERF} && $ENV{R_PERF} eq "true") {
         $ENV{"R_RUNMODE"} = "0";
         print "using R_RUNMODE == 0 for performance testing\n";
      } else {
         $ENV{"R_RUNMODE"} = "9029";
         print "warning:  R_RUNMODE is not set, using default run mode $ENV{R_RUNMODE}\n";
      }
   }

   # Initialise $tmp_runmode here (bugfix for #16932)
   $tmp_runmode = $ENV{"R_RUNMODE"};

   if (! exists $ENV{R_GRAPHICS}) {
      $ENV{"R_GRAPHICS"} = 0;
      print "warning:  R_GRAPHICS  is not set, using default graphics type $ENV{R_GRAPHICS}\n";
   }
   if ($DISPLAY eq "0") {
      $ENV{DISPLAY} == ":0";
   }
   if ($ENV{"R_GRAPHICS"} eq "7" && $OS_TYPE ne "NT") {
      if ($PRO_MACHINE_TYPE eq "i486_linux") {
         $mach_name=`hostname -s`;
      } else {
         $mach_name=`hostname`;
      }
      chop ($mach_name);
      if ($ENV{DISPLAY} !~ /^:0/ && $ENV{DISPLAY} ne "${mach_name}:0" && $ENV{DISPLAY} ne "unix:0") {
         print "\nPro/E not run OpenGL remotely.\n";
         print "You must run graphics tests with display set locally.\n";
         print "Exiting ...\n\n";
         exit (1);
      }
      if ($PRO_MACHINE_TYPE =~ /^sun4_solaris/ && $ENV{DISPLAY} eq "unix:0") {
         print "\nIt is wrong to set display to unix:0 on Sun.\n";
         print "Please set display to :0, or :0.0 etc.\n";
         exit (1);
      }
   }

   if (! exists $ENV{R_CONFIG_FILE}) {
      $ENV{"R_CONFIG_FILE"} = "useautodefault";
   }

   if (! defined $ENV{R_PFCLSCOM_DIR}) {
      $ENV{R_PFCLSCOM_DIR} = "$PTCSYS/obj";
   }

   if (! defined $ENV{R_IPCTEST}) {
      if (defined $ENV{R_REGRES_BIN} && 
        -e "$ENV{R_REGRES_BIN}/ipctest$exe_ext") {
     $ENV{R_IPCTEST} = "$ENV{R_REGRES_BIN}/ipctest$exe_ext";
      } else {
         $ENV{R_IPCTEST} = "$PTCSYS/obj/ipctest$exe_ext";
      }
   }

   if (! defined $ENV{R_COMM_BRK_SVC}) {
      if (defined $ENV{R_REGRES_BIN} &&
        -e "$ENV{R_REGRES_BIN}/comm_brk_svc$exe_ext") {
     $ENV{R_COMM_BRK_SVC} = "$ENV{R_REGRES_BIN}/comm_brk_svc$exe_ext";
      } else {
         $ENV{R_COMM_BRK_SVC} = "$PTCSYS/obj/comm_brk_svc$exe_ext";
      }
   }

   if (! defined $ENV{R_FLEXGENERIC}) {
      if (defined $ENV{R_REGRES_BIN} &&
        -e "$ENV{R_REGRES_BIN}/flexgeneric$exe_ext") {
     $ENV{R_FLEXGENERIC} = "$ENV{R_REGRES_BIN}/flexgeneric$exe_ext";
      } else {
     $ENV{R_FLEXGENERIC} = "$PTCSYS/obj/flexgeneric$exe_ext";
      }
   }

 #  if ($ENV{R_GRAPHICS} ne "0" || $ENV{R_PERF} eq "true") {
 #     if (-e "${TOOLDIR}$PRO_MACHINE_TYPE/move_cursor$exe_ext") {
 #        print "Running ${TOOLDIR}$PRO_MACHINE_TYPE/move_cursor\n";
 #        `$csh_cmd "${TOOLDIR}$PRO_MACHINE_TYPE/move_cursor"`;
 #     }
 #  }

   if (defined $ENV{R_PURECOV_MERGE_DIR}) {
      if (-w "$ENV{R_PURECOV_MERGE_DIR}") {
          print "R_PURECOV_MERGE_DIR is set to $R_PURECOV_MERGE_DIR\n";
          $R_PURECOV_MERGE_DIR = $ENV{R_PURECOV_MERGE_DIR};
      } else {
          print "R_PURECOV_MERGE_DIR is set to $R_PURECOV_MERGE_DIR\n".
                "ERROR: $R_PURECOV_MERGE_DIR is not writable!\n"; 
      }
   }

   if (defined $ENV{R_PURECOV_CACHE_DIR}) {
      if (-w "$ENV{R_PURECOV_CACHE_DIR}") {
          print "R_PURECOV_CACHE_DIR is set to $R_PURECOV_CACHE_DIR\n";
          $R_PURECOV_CACHE_DIR = $ENV{R_PURECOV_CACHE_DIR};
      } else {
          print "R_PURECOV_CACHE_DIR is set to $R_PURECOV_CACHE_DIR\n".
                "ERROR: $R_PURECOV_CACHE_DIR is not writable!\n"; 
      }
   }
#open the cmd window minimised for protk tests
   if (! exists $ENV{R_SUPPRESS_PROTK_PROC_WINDOW}) {
     $ENV{"R_SUPPRESS_PROTK_PROC_WINDOW"} = "true";
   }

   $ENV{"R_AUTO_RUNNING"} = "true";
   $copy_keep_files = 0;
   $skip_keep_test = 0;
}

sub record_restore_env($) {
   my $var = $_[0];
   $clean_setenv_cmds{$var} = $ENV{$var};
}

sub record_setenv($$) {
   my $var = $_[0];
   my $value = $_[1];
   my ($env_var);

   while ($value =~ /\${/) {
      my ($head, @rest_line) = split (/\$/, $value);
      my ($rest) = join("\$", @rest_line);
      $value = substr($rest, 1, length($rest)-1);
      ($env_var, @rest_line) = split (/}/, $value);
      $rest = join("}", @rest_line);
      $value = $head . $ENV{$env_var} . $rest;
   }
   &record_restore_env($var);
   $setenv_cmds{$var} = $value;
}

sub update_setenv {
   my ($var, $value);
   if (exists $setenv_hold{$cur_test_num}) {
      @array=split(/ /, $setenv_hold{$cur_test_num});
      while (@array) {
         $value = pop (@array);
         $var = pop (@array);
         $setenv_cmds{$var} = $value;
         if (! exists $clean_setenv_cmds{$var}) {
            $clean_setenv_cmds{$var} = $ENV{$var};
         }
      }
   }
}

sub apply_setenv {
  foreach $to_set_env (keys %setenv_cmds) {
    if (defined $setenv_cmds{$to_set_env}) {
      if ($directives{setenv_to_cwd_and}) {
        $ENV{$to_set_env} = cwd(). "/" . "$setenv_cmds{$to_set_env}";
        mkdir($ENV{$to_set_env}, 0777) if (! -e $ENV{$to_set_env});
        print("Running: setenv $to_set_env $ENV{$to_set_env}\n");
      } else {
         if ("${to_set_env}" eq 'R_SAVE_AS') {
           add_to_saveas("$setenv_cmds{$to_set_env}");
         } else {
           $ENV{$to_set_env} = $setenv_cmds{$to_set_env}; 
         }
        print("Running: setenv $to_set_env $setenv_cmds{$to_set_env}\n");
      } 
    } else {
      delete $ENV{$to_set_env};
      print("Running: unsetenv $to_set_env\n");
    }
  }
  
  always_unsetenv();
  
}

sub update_unsetenv {
   my ($var);
   if (exists $unsetenv_hold{$cur_test_num}) {
      @array=split(/ /, $unsetenv_hold{$cur_test_num});
      while (@array) {
     $var = pop (@array);
     $setenv_cmds{$var} = undef;
      }
   }
}

sub always_unsetenv {
    if ($ENV{R_USE_CREO_PLUS} eq "true" || $ENV{R_SAAS_REGRESSION} eq "true"){
       if (defined $ENV{COLLAB_COMPANY_ID}) {
          $ENV{COLLAB_COMPANY_ID} = undef;
          print "COLLAB_COMPANY_ID=$ENV{COLLAB_COMPANY_ID}\n";
       }
    }        
}

sub update_backward_trail_set {
   if (exists $backward_trail_hold{$cur_test_num}) {
      $directives{backward_trail} = 1;
   } else {
      $directives{backward_trail} = 0;
   }
   if (exists $backward_cmd_hold{$cur_test_num}) {
      $backward_cmd = $backward_cmd_hold{$cur_test_num};
   }
}

sub update_directive_hold {
   if (exists $directive_hold{$cur_test_num}) {
      my (@array) = split(/ /, $directive_hold{$cur_test_num});
      foreach $elem (@array) {
          $directives{$elem} = 1;
          if ($elem eq "run_only_on_test") {
              $mach_list=$run_only_mach_list_hold{$cur_test_num};
          } elsif ($elem eq "not_run_on_test") {
              $not_run_on_mach_list=$not_run_mach_list_hold{$cur_test_num};
          } elsif ($elem eq "if_exist") {
              $if_exist_list=$if_exist_list_hold{$cur_test_num};
          } elsif ($elem eq "run_with_license") {
              $license_info=$license_info_hold{$cur_test_num};
          } elsif ($elem eq "xtop_add_args") {
              $xtop_args = $xtop_args_hold{$cur_test_num};
          } elsif ($elem eq "creo_ui_resource_editor_test") {
              $cure_flag = 1;
          } elsif ($elem eq "prokernel_retr") {
              $prokernel_retr_exe = $prokernel_retr_exe_hold{$cur_test_num};
	      $prokernel_retr_args = $prokernel_retr_args_hold{$cur_test_num};
              $prokernel_retr_flag = 1;
          } elsif ($elem eq "merge_config") {
		      $merge_config_file = $merge_config_hold{$cur_test_num};
          } elsif ($elem eq "config_file") {
		      $config_file = $config_file_hold{$cur_test_num};
          }
      }
   }
}

sub reset_directives {
   if ($num_perf_test > 0 || $num_bitmap_test > 0) {
      ### need to reset to avoid multiple runs of cmds
      $directives{num_cmd}=0 ;
      return ;
   }
   foreach $key (keys(%directives)) {
      $directives{$key} = 0;
   }
   %setenv_cmds = ( ) ;
   %setenv_hold = ( );
   %unsetenv_hold = ( );
   %backward_trail_hold = ( );
   %backward_cmd_hold = ( );
   %directive_hold = ( );
   %run_only_mach_list_hold = ( );
   %not_run_mach_list_hold = ( );
   %if_exist_list_hold = ( );
   %license_info_hold = ( );
   %qcr_script = ( );
   %clean_setenv_cmds = ( ) ;
   %cmd_list = ( );
   %post_cmd = ( );
   %retr_trl = ( );
   %drc_trl = ( );
   %retr_obj_hash = ( );
   $setenv_to_cwd = "";
   %fastreg_test_flags = ();
   %xtop_args_hold = ();
   %prokernel_retr_exe_hold = ();
   %prokernel_retr_args_hold = ();
   $prokernel_retr_flag = 0;
   $cure_flag = 0;
}

sub get_unc_path {
      @drive_arr = split(/:/, $ENV{PTCSYS});
      $drive = shift(@drive_arr);
      $share_drive=`net use $drive: | grep -i "Remote Name"` ;
      chomp($share_drive);
      @arr = split(/\t| /, $share_drive) ;
      $share_name = pop(@arr)  ;
      $share_name = $share_name.$drive_arr[0];
      $share_name =~ s/\\/\//g ;
      return $share_name;
}

sub is_vista_running()
{
      my($string,$major,$minor,$build,$id)=Win32::GetOSVersion();
      return 1 if ($major >= 6);
      return 0;
}

sub init_others {
   $auto_ver="$cur_dir/auto_ver.log";
   $tmpdir="$cur_dir/scratch";
   $tmpdir =~ tr/\//\\/ if ( $OS_TYPE eq "NT" );
   `$rm_cmd -rf "$tmpdir"` if ( -e "$tmpdir");
   $rundir=$cur_dir;
   $timefile = "reg_time.log";
   $skip_tests = 0;
   $mach_type="$PRO_MACHINE_TYPE";
   $mach_name=`hostname`;
   chop($mach_name);
   $date=&date_mdy;
   $startauto=&date_hms;
   $fail="$cur_dir/fail.log";
   $succ="$cur_dir/succ.log";
   $skip_log="$cur_dir/skip.log";
   $notexists="$cur_dir/notexists.log";
   $foreign_merge="$cur_dir/foreign_merge_errors.log";
   $run_fly_tests = 0;
   $qcr_fail = 0;
   if ($PRO_MACHINE_TYPE =~ /^sun/ || $PRO_MACHINE_TYPE =~ /^sgi_/ || $OS_TYPE eq "NT") {
      $ram_size = read_auto_config_param('ram_size');
      if ( ! defined $ram_size ) {
        $ram_size = `$csh_cmd "${TOOLDIR}get_ram_size"`;
        chomp($ram_size);
        print "Obtained ram size = $ram_size\n";
        write_auto_config_param('ram_size', $ram_size);      
      } else {
        print "Used $auto_config_file: ram_size = $ram_size\n";
      }
   } else {
      $ram_size = 0;
   }
   if ($PRO_MACHINE_TYPE =~ /^sun/) {
   		`coreadm -p core.%f $$`;
   }
   if (exists $ENV{TMPDIR}) {
      $old_tmpdir=$TMPDIR;
      $ENV{TMPDIR} = "$cur_dir/scratch_tmp";
   }
   else {
      $old_tmpdir=0;
      $ENV{"TMPDIR"} = "$cur_dir/scratch_tmp";
   }
   
   $old_temp = $ENV{TEMP};
   $old_tmp = $ENV{TMP};
   if ( $OS_TYPE eq "NT") {
      $ENV{TEMP} = "$cur_dir/scratch_tmp";
      $ENV{TEMP} =~ s/\//\\/g;
      $ENV{TMP} = "$cur_dir/scratch_tmp";
      $ENV{TMP} =~ s/\//\\/g;
   }
   if ($ENV{R_GRAPHICS} eq "0") {
      $uif_graphics="-iconic";
      $ui_graphics="-nographics";
   }
   else {
      $uif_graphics=0;
      $ui_graphics="";
   }
   if ($ENV{R_RUNMODE} eq "9029" || $ENV{R_RUNMODE} eq "-9029" || defined $ENV{MEMUSAGE_ON_EXIT}) {
      $report_memory="true";
   }
   else {
      $report_memory="false";
   }

   $ENV{"PTC_WF_ROOT"} = "$rundir/WF_ROOT_DIR";

   # SETUP for Java (J-Link) multiple JRE environment

   #WARNING: starting with P-20, JLINKCLASSPATH is set individually for each jlink or otk java test
   #         and to this moment it is not set at all
   # SETTING JAVA 1.1 ENVIRONMENT ...
   $PATH_JAVA11=$ENV{JAVA1PATH};
   $CLASSPATH_JAVA11 = $ENV{JAVA1CLASSPATH}.$ENV{JLINKCLASSPATH};
   $JAVA11_COMMAND = "$JAVA1CMD $ENV{JAVA1FLAGS}";

   # in J-03 and earlier, we use special JDK's to run 1.1 tests (as "default") on some platforms
   # This can be removed once J-01/J-03 are retired from regs
   $version_str = substr($ENV{PTC_VERSION}, 0, 4);

   if ($version_str eq "J-03" || $version_str eq "J-01") {
      if ($ENV{PRO_MACHINE_TYPE} eq "hpux11_pa32") {
         # SETTING JRE 1.1 PATH AND CLASSPATH TO jdk 1.2.2 for hpux11_pa32

         $PATH_JAVA11 = $ENV{JAVA2PATH};
         $CLASSPATH_JAVA11 = $ENV{JAVA2CLASSPATH}.$ENV{JLINKCLASSPATH};
         $JAVA11_COMMAND = "java";
      }
      elsif ($ENV{PRO_MACHINE_TYPE} eq "i486_linux") {
         # SETTING JRE 1.1 PATH AND CLASSPATH TO 1.3 for linux
         $PATH_JAVA11=$ENV{JAVA3PATH};
         $CLASSPATH_JAVA11 = $ENV{JAVA3CLASSPATH}.$ENV{JLINKCLASSPATH};
         $JAVA11_COMMAND = "java";
      }
      if ($version_str eq "J-01") {
         $JAVA11_COMMAND = "$JAVA11_COMMAND com.ptc.pfc.Implementation.Starter";
      }
   }

   # SETTING JAVA 1.2 ENVIRONMENT ...
   $PATH_JAVA12=$ENV{JAVA2PATH};
   $CLASSPATH_JAVA12 = $ENV{JAVA2CLASSPATH}.$ENV{JLINKCLASSPATH};

   # SETTING JAVA 1.3 ENVIRONMENT ...
   $PATH_JAVA13=$ENV{JAVA3PATH};
   $CLASSPATH_JAVA13 = $ENV{JAVA3CLASSPATH}.$ENV{JLINKCLASSPATH};

   # SETTING JAVA 1.4 ENVIRONMENT ...
   $CLASSPATH_JAVA14 = $ENV{JLINKCLASSPATH};

   # SETTING DEFAULT CLASSPATH TO JRE 1.4
   $CLASSPATH_JAVADEFAULT = $CLASSPATH_JAVA14;
   $ENV{CLASSPATH} = $CLASSPATH_JAVADEFAULT;

   if ( $OS_TYPE eq "NT" && $ENV{PRO_MACHINE_TYPE} ne "i486_win95") {
      if (! defined $ENV{R_NO_UNINSTALL_PVX} && $ENV{R_IGNORE_XTOP} ne "true") {
         print_succfail("Running: $PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ${TOOLDIR}uninstall_pvx_silent.pl\n");
         `$csh_cmd "$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ${TOOLDIR}uninstall_pvx_silent.pl"`;
      }
      `$csh_cmd "$PTC_TOOLS/bin/$PRO_MACHINE_TYPE/sstest disable"`;
   }

#Logic for using ptcregsvr
# - if Vista running use ptcregsvr else use regsvr32
# - Register the pfcscom.dll in auto itself (as per integ case 13657)
   if ($OS_TYPE eq "NT" &&  $ENV{R_IGNORE_XTOP} ne "true" && ($ENV{P_VERSION} < 310)) {
      if(is_vista_running()){
        $unc_ptcsys = get_unc_path();
        if (-e "$unc_ptcsys/obj/ptcregsvr.exe"){
           $cmdline = "$unc_ptcsys/obj/ptcregsvr.exe $unc_ptcsys/lib/pfcscom.dll";
       print "Running: $cmdline\n";
           system("$cmdline");
        }
        else
    {
            print "ptcregsvr.exe does not exist\n";
        }
      } else {
    if (defined $ENV{PROWT_JS_DLL}) {
       print "Running: regsvr32 /s $ENV{PROWT_JS_DLL}\n";
       system("$REGSVR32 /s $ENV{PROWT_JS_DLL}");
    } else {
           print "Running: regsvr32 /s $PTCSYS/lib/pfcscom.dll\n";
           system("$REGSVR32 /s $PTCSYS/lib/pfcscom.dll");
    }
      }
   }

   #We install pvx beforehand only for Vista
   if ($OS_TYPE eq "NT" && $ENV{R_IGNORE_XTOP} ne "true") {
      if(is_vista_running()){
                $unc_ptcsys = get_unc_path();
                if (-e "$unc_ptcsys/obj/pvx_install.exe"){
                        system ("$unc_ptcsys/obj/pvx_install.exe /Q");
                }
                else {
                        print "pvx_install.exe does not exist\n";
                }
      }
   }

   if (defined $ENV{PFCLS_START_DIR}) {
      $set_PFCLS_START_DIR = 0;
   } else {
      $set_PFCLS_START_DIR = 1;
   }

   if (not defined $ENV{R_USE_CREO_PLUS}) {
      $creoinfo_exe = "___junk_value___";
   }
   
   if (defined $ENV{CREO_AGENT_EXE_PATH}) {
      $creoinfo_exe = dirname "$ENV{CREO_AGENT_EXE_PATH}";
      $creoinfo_exe = "$creoinfo_exe/creoinfo";
      if ($ENV{OS_TYPE} eq "NT") {
         $creoinfo_exe = "$creoinfo_exe.exe";
      }
   }
   
   if (! -e "$creoinfo_exe") {
      $creoinfo_exe = "$PTCSYS/obj/creoinfo";
      if ($ENV{OS_TYPE} eq "NT") {
         $creoinfo_exe = "$creoinfo_exe.exe";
      }
   }
   
   $ENV{"creoinfo_exe"} = $creoinfo_exe;
      
   #In windows we now want to launch creoinfo regardless of R_USE_AGENT env, on all supported versions. unless CREO_AGENT_EXE_PATH defined.
   #Tests that use #fresh_creo_agent will launch creoagent, so running creoinfo will make sure that agent is installed,
   #and prevent simulataneous installation attempts. 
   #this is currently locked under R_ENSURE_AGENT_INSTALLED env because of delay in run when creoinfo hangs.
   if ((($ENV{P_VERSION}) >= 290 && ($OS_TYPE eq "NT") && ! defined $ENV{CREO_AGENT_EXE_PATH} && $ENV{R_ENSURE_AGENT_INSTALLED}) || (defined $ENV{R_USE_AGENT})) {
      $ENV{CREO_AGENT_HOME}="$cur_dir/CREO_HOME_GLOBAL";

      if (defined $ENV{R_USE_AGENT}) {
        $ENV{CREO_AGENT_WAIT_FOR_CLIENT}="-1";
        $ENV{CREO_AGENT_LINGER_ON_IDLE}="-1";
      }

      print ("creoagent_start is called with ");
      print ("CREO_AGENT_HOME = $ENV{CREO_AGENT_HOME}\n");
      &creoagent_ensure_install();

      print ("creoagent_shutdown is called with \n");
      print ("CREO_AGENT_HOME = $ENV{CREO_AGENT_HOME}\n");
      #after installation complete, we can close agent if not needed
      &creoagent_shutdown() if (!defined $ENV{R_USE_AGENT});
   }
    
   %setenv_cmds = ( ) ;
   %clean_setenv_cmds = ( ) ;
   $ppid = getppid () if ($OS_TYPE ne "NT");
}

sub match_os_type {
   my $memuse_os = $_[0];

   return 1 if ( $OS_TYPE ne "NT");
   my $match = grep(/$memuse_os/, $WIN_OS);
   return 0 if ($match == 0);
   return 1;
}

sub load_memuse_db {
   my $line, $first_char, @array;
   my $test_name, $cat, $mach, $graphics, $ver, $value, $threshold;

   my $memuse_os = "";
   if (defined $ENV{R_ALT_MEMUSE_OS}) {
      open (MEMUSE_OS, "$ENV{R_ALT_MEMUSE_OS}");
   } else {
      open (MEMUSE_OS, "$PTCSRC/test/memuse_os.txt");
   }
   @array = <MEMUSE_OS>;
   close (MEMUSE_OS);
   chomp (@array);
   foreach $line (@array) {
      ($mach, $value) = split(/ +/, $line);
      if ($mach eq $PRO_MACHINE_TYPE) {
     $memuse_os = $value;
     last;
      }
   }

   if ($memuse_os ne "") {
      if (! match_os_type($memuse_os)) {
     print "\nWARNING: the OS is not match with $memuse_os, will not check memuse.\n";
     return;
      }
   }
 
   %memuse_db = ( );
   $memuse_error = 0;
   my $memuse_file = "$PTCSRC/test/memuse.txt";
   if (defined $ENV{R_ALT_MEMUSE}) {
      print "Warning: use R_ALT_MEMUSE file: $ENV{R_ALT_MEMUSE} instead\n\n";
      $memuse_file = $ENV{R_ALT_MEMUSE};
      if (! -e "$memuse_file") {
         $memuse_file = "$PTCSRC/test/memuse.txt";
         print "Warning: $ENV{R_ALT_MEMUSE} does not exist,\n";
         print "  still use $memuse_file\n\n";
      }
   }

   if (open (MEMUSE, "$memuse_file")) {
      while ($line = <MEMUSE>) {
         chomp($line);
         $first_char = substr($line, 0, 1);
         next if ($first_char eq "!" || $first_char eq "");
         ($test_name, $cat, $mach, $graphics, $ver, $value, $threshold)
                = split(/\,/, $line);
         next if ($graphics ne $ENV{R_GRAPHICS});
         next if ($mach ne $PRO_MACHINE_TYPE);
         if ("$cat" eq "memsize") {
            $memuse_db{$test_name} = "$value $threshold";
         } else {
            $memuse_db{"${test_name}_max"} = "$value $threshold";
         }
      }
      close (MEMUSE);
   }
}

sub load_autoexist {
   my $first_char, @array, @alist;
   my $keyword, $machines, $target, $alt_target;
   my %kw_count = ();

   %autoexist_db = ( );
   $autoexist_file = "$PTCSRC/test/autoexist.txt";
   if (defined $ENV{R_ALT_AUTOEXIST} && -e $ENV{R_ALT_AUTOEXIST}) {
      print "Warning: use R_ALT_AUTOEXIST file: $ENV{R_ALT_AUTOEXIST} instead\n\n";
      $autoexist_file = $ENV{R_ALT_AUTOEXIST};
   }

   if (open (AUTOEXIST, "$autoexist_file")) {
      @alist = <AUTOEXIST>;
      close (AUTOEXIST);
      chomp (@alist);
      foreach $line (@alist) {
         $first_char = substr($line, 0, 1);
         next if ($first_char eq "#" || $first_char eq "");
         ($keyword, $machines, $target, $alt_target) = split(/ +/, $line);
         $target =~ s/\\/\//g;
         $alt_target =~ s/\\/\//g;
         @array = split(/\,/, $machines);
         foreach $mach (@array) {
            if ($mach eq "ALL" || $mach eq $OS_TYPE || $mach eq $PRO_MACHINE_TYPE) {
               $kw_count{$keyword}++;
               if ($alt_target ne '') {
                  $autoexist_db{"$keyword"}{"$kw_count{$keyword}"} = [("$target", "$alt_target")];
               } else {
                  $autoexist_db{"$keyword"}{"$kw_count{$keyword}"} = [("$target")];
               }
               last;
            }
         }
      }
   }
}

sub convert_xtop_path {
   my ($real_dir);
   my ($xtop_name, $xtop_path, $xtop_ext) = fileparse($local_xtop);
   if ($xtop_name !~ /\./) {
      $xtop_name = "$xtop_name$ENV{EXE_EXT}";
   }
   die("$xtop_path does not exist.\n") if (! chdir ($xtop_path));
   $real_dir = cwd();
   if ( $real_dir =~ /\/tmp_mnt/ ) {
      $real_dir = substr($real_dir, 8, length($real_dir)-8);
   }
   $local_xtop = "$real_dir/$xtop_name";
   $local_xtop =~ tr/\//\\/ if ( $OS_TYPE eq "NT" && ! defined($PTC_CYGWIN) && ! defined($PTC_MKS));
   chdir_safe ("$cur_dir");
}

# Sets an env variable while running otk tests if R_OTK_APPLOG_DIR
# or R_OTK_APPLOG_FILE has been set. This helps in logging function 
# calls made in otk tests.
sub set_otk_testlog_env_var {
  my($n_line,$raw_trailname, $ext_name,@array,$i);

  if(defined $ENV{R_OTK_APPLOG_DIR} || defined $ENV{R_OTK_APPLOG_FILE}) {
    $n_line = @test_list;
  
    for ($i=0; $i<$n_line; $i++) {
        if ($test_list[$i] =~ /\.txt@|\.bac@/)  {
      @array = split(/@/, $test_list[$i]);
      ($raw_trailname, $ext_name) = split(/\./, $array[0]);
      break;
      }
    }
  
    &record_setenv('R_OTK_APP_NAME', $raw_trailname);
    if(defined $ENV{R_OTK_APPLOG_DIR}) {
      $applog_file = $ENV{R_OTK_APPLOG_DIR};
      &record_setenv('R_OTK_APPLOG_FILE', $applog_file."/".$raw_trailname."\.log");
    }
  }
}

sub set_directive {
   my ($line) = shift;
   chop($line);
   my ($r_directive, $r_trl, $r_obj);
   my ($i);
   my (@array) = split(/ +/, $line);
   my (@other_args);

   if ($array[0] eq "#r") {
      $directives{rec_copy} = 1;
   } elsif ($array[0] eq "#pd") {
      $directives{rec_copy} = 1;
      $directives{pd_demo_test} = 1;
      $demo_dir = $array[1];
      $demo_path = $array[2];
      $demo_path =~ tr/./\//;
   } elsif ($array[0] eq "#d") {
      $directives{rec_copy} = 1;
      $directives{demo_test} = 1;
      $demo_dir = $array[1];
      $demo_path = $array[2];
      $demo_dir =~ tr/./\//;
      $demo_path =~ tr/./\//;
      if ("$demo_path" eq "") {
         $demo_path = "demo";
      }
   } elsif ($array[0] eq "#fly_test") {
      $directives{rec_copy} = 1;
      $directives{fly_test} = 1;
   } elsif ($array[0] eq "#java_test") {
      $directives{java_test} = 1;
      $java_version = $array[1];
      &set_otk_testlog_env_var;
   } elsif ($array[0] eq "#otk_java_test") {
      $directives{otk_java_test} = 1;
      $java_version = $array[1];
      &set_otk_testlog_env_var;
   } elsif ($array[0] eq "#add_jdk7_to_path") {
      $directives{add_jdk7_to_path} = 1;
   } elsif ($array[0] eq "#add_jdk8_to_path") {
      $directives{add_jdk8_to_path} = 1;
   } elsif ($array[0] eq "#bitmap" || $array[0] eq "#bitmap_4k") {
      $directives{bitmap} = 1 if ($array[0] eq "#bitmap");
	  $directives{bitmap_4k} = 1 if ($array[0] eq "#bitmap_4k");
      if (defined $ENV{R_BITMAP_LOCAL_IMAGE}) {
     if ($num_bitmap_test <= 0) {
        $num_bitmap_test = 2;
        $bitmap_save = 1;
     }
      }
#      $directives{rec_copy} = 1;
   } elsif ($array[0] eq "#bitmap_text") {
      $directives{bitmap_text} = 1;
   } elsif ($array[0] eq "#wf_js_test") {
      $directives{wf_js_test} = 1;
      $directives{wildfire_test} = 1;
      $wildfire_test_vars = "";
   } elsif ($array[0] eq "#wildfire_pdm") {
      $directives{wildfire_pdm} = 1;
   } elsif ($array[0] eq "#distapps_dsm") {
      $directives{distapps_dsm} = 1;
   } elsif ($array[0] eq "#distapps_dbatchc") {
      $directives{distapps_dbatchc} = 1;
      $dsm_machine = $array[1];
   } elsif ($array[0] eq "#distapps_dsapi") {
      $directives{distapps_dsapi} = 1;
   } elsif ($array[0] eq "#dbatch_int_test") {
      $directives{dbatch_int_test} = 1;
   } elsif ($array[0] eq "#intralink_interaction") {
      $directives{intralink_interaction} = 1;
   } elsif ($array[0] eq "#qcr_script") {
      $directives{qcr_script} = 1;
      $qcr_script{$cur_test_num} = $array[1];
   } elsif ($array[0] eq "#wildfire_test") {
      $directives{wildfire_test} = 1;
      $wildfire_test_vars=substr($line, 15, length($line));
      &fastreg_parse_test_vars($wildfire_test_vars);
      if ($ENV{FASTREG_DEBUG} != "") {
          print_fail("Values of hash '\%fastreg_test_flags':\n");
      for my $hash_key (keys(%fastreg_test_flags)) {
            print_fail("\t\$fastreg_test_flags{$hash_key} = '$fastreg_test_flags{$hash_key}'\n");       
      }
      if (defined($windchill_solution)) {
            print_fail("Value of variable \$windchill_solution = '$windchill_solution'\n");
      } else {
            print_fail("Variable \$windchill_solution is undefined\n");
      }
      if (defined($arts_test_runmode)) {
            print_fail("Value of variable \$arts_test_runmode = '$arts_test_runmode'\n");
      } else {
            print_fail("Variable \$arts_test_runmode is undefined\n");
          }
      }
   } elsif ($array[0] eq "#uwgmcc_test") {
      $directives{uwgmcc_test} = 1;
      $directives{wildfire_test} = 1;
   } elsif ($array[0] eq "#mech_test_long") {
      $directives{mech_test_long} = 1;
      $directives{mech_test} = 1;
      $directives{check_display} = 1;
      $mech_test_type = $array[1];
      $trail_path = $mech_trail_path;
      $obj_path = $mech_obj_path;
   } elsif ($array[0] eq "#mech_test") {
      $directives{mech_test} = 1;
      $directives{check_display} = 1;
      $mech_test_type = $array[1];
      $trail_path = $mech_trail_path;
      $obj_path = $mech_obj_path;
   } elsif ($array[0] eq "#anim_test") {
      $directives{anim_test} = 1;
   } elsif ($array[0] eq "#mdx_test") {
      $directives{mdx_test} = 1;
   } elsif ($array[0] eq "#EDAcompare_test") {
      $directives{EDAcompare_test} = 1;
   } elsif ($array[0] eq "#cmd") {
      $cmd_list{"${cur_test_num}AND$directives{num_cmd}"}=substr($line, 5, length($line));
      $directives{num_cmd}++;
   } elsif ($array[0] eq "#post_cmd") {
      $post_cmd{"${cur_test_num}AND$directives{num_post_cmd}"}=substr($line, 10, length($line));
      $directives{num_post_cmd}++;
   } elsif ($array[0] eq "#run_if_set") {
      $directives{run_if_set} = 1;
      $env_list=substr($line, 12, length($line));
      $directives{check_display} = 1 if ("$env_list" =~ /MECH_HOME/);
   } elsif ($array[0] eq "#k") {
      $directives{keepscratch} = 1 if (! $directives{keep});
   } elsif ($array[0] eq "#review_test") {
      $directives{review_test} = 1;
   } elsif ($array[0] eq "#jr_test") {
      $directives{jr_test} = 1;
   } elsif ($array[0] eq "#l") {
      $directives{langtest} = 1;
   } elsif ($array[0] eq "#vo") {
      $directives{viewonly} = 1;
   } elsif ($array[0] eq "#weblink_test") {
      $directives{weblink_test} = 1;
   } elsif ($array[0] eq "#cadds5_topology_test") {
      $directives{cadds5_topology_test} = 1;
      $cv_env_version = $array[1];
   } elsif ($array[0] eq "#proevconf_test") {
      $directives{proevconf_test} = 1;
   } elsif ($array[0] eq "#ptcsetup_test") {
      $directives{ptcsetup_test} = 1;
   } elsif ($array[0] eq "#japanese_test") {
      $directives{japanese_test} = 1;
   } elsif ($array[0] eq "#chinese_test") {
      $directives{chinese_test} = 1;
   } elsif ($array[0] eq "#korean_test") {
      $directives{korean_test} = 1;
   } elsif ($array[0] eq "#latin_lang_test") {
      $directives{latin_lang_test} = 1;
   } elsif ($array[0] eq "#english_test") {
      if ($cur_test_num != 0) {
     $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}english_test ";
      } else {
         $directives{english_test} = 1;
      }
   } elsif ($array[0] eq "#perf_test") {
      $directives{perf_test} = 1;
      $directives{wildfire_test} = 1;
      if ($num_perf_test <=0) {
	     if ($ENV{R_PERF_RUN_N_TIMES} >= 1) {
           $num_perf_test = $ENV{R_PERF_RUN_N_TIMES};
         } elsif ($array[1] eq "") {
		    $num_perf_test = 3;
		 } else {
            $num_perf_test = $array[1];
         }
		 $num_perf_test_count = $num_perf_test;
         $ENV{R_PERF_RUN_N_TIMES} = $num_perf_test;
         $ENV{R_PERF_CURRENT_ITERATION_NUM} = 1;
      }
   } elsif ($array[0] eq "#vulkan") {
       $directives{vulkan} = 1;
       $directives{graphics_test} = 1 if ($ENV{R_GRAPHICS} ne "0" && $ENV{R_GRAPHICS} ne "");
       $graphics_test_modes = "7 11" if ($ENV{R_GRAPHICS} ne "0" && $ENV{R_GRAPHICS} ne "");
   } elsif ($array[0] eq "#pglview_test") {
       $directives{pglview_test} = 1;
   } elsif ($array[0] eq "#graphics_test") {
      $directives{graphics_test} = 1;
      $graphics_test_modes = substr($line, 15, length($line));
   } elsif ($array[0] eq "#not_run_with_graphics") {
      $directives{not_run_with_graphics} = 1;
      $graphics_test_modes = substr($line, 23, length($line));
   } elsif ($array[0] eq "#none_graphics_test") {
      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}none_graphics_test ";
      } else {
         $directives{none_graphics_test} = 1;
      }
   } elsif ($array[0] eq "#production_test") {
      $directives{production_test} = 1;
      if ($ENV{R_PRODUCTION_TEST} eq 'true' ) {
         if (! exists $ENV{"AUTO_PROC_MEM_LIMIT"}) {
            $clean_setenv_cmds{'AUTO_PROC_MEM_LIMIT'} = $ENV{AUTO_PROC_MEM_LIMIT};            
            $ENV{"AUTO_PROC_MEM_LIMIT"} = "0";
         }
         print "using AUTO_PROC_MEM_LIMIT = $ENV{AUTO_PROC_MEM_LIMIT} for production test(s)\n";  
      }
   } elsif ($array[0] eq "#retr_test") {
      $directives{retr_test} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
   } elsif ($array[0] eq "#drc_test") {
      $directives{drc_test} = 1;
      ($r_directive, $r_obj, $drc_drw_pth, $r_customer)=split(/ /, $line);
      $drc_trl{$cur_test_num} = $r_obj;
      $drc_obj = $r_obj;
   } elsif ($array[0] eq "#interface_retrieval") {
      $directives{interface_retrieval} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
      $retr_obj_hash{$cur_test_num} = $r_obj;
   } elsif ($array[0] eq "#gcri_test") {
      $directives{gcri_test} = 1;
      $CRI_DLL_version = $array[1];
   } elsif ($array[0] eq "#int_2d_cmp") {
      $directives{int_2d_cmp} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
      $retr_obj_hash{$cur_test_num} = $r_obj;      
   } elsif ($array[0] eq "#int_3d_cmp") {
      $directives{int_3d_cmp} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
      $retr_obj_hash{$cur_test_num} = $r_obj;    
   } elsif ($array[0] eq "#int_pdf_cmp") {
      $directives{int_pdf_cmp} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
      $retr_obj_hash{$cur_test_num} = $r_obj;
   } elsif ($array[0] eq "#multi_file") {
      $directives{multi_file} = 1;
   } elsif ($array[0] eq "#run_only_on") {
      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}run_only_on_test ";
     $run_only_mach_list_hold{$cur_test_num}=substr($line, 13, length($line));
      } else {
         $directives{run_only_on_test} = 1;
         $mach_list=substr($line, 13, length($line));
      }
   } elsif ($array[0] eq "#graphics_test_on") {
      $directives{graphics_test_on} = 1;
      $g_mach_list=substr($line, 18, length($line));
   } elsif ($array[0] eq "#no_graphics_mode_on") {
      $directives{no_graphics_mode_on} = 1;
      $g_mode_mach_list=substr($line, 21, length($line));
   } elsif ($array[0] eq "#non_graphics_test_on") {
      $directives{non_graphics_test_on} = 1;
      $g_mach_list=substr($line, 22, length($line));
   } elsif ($array[0] eq "#not_run") {
      $directives{not_run_test} = 1;
   } elsif ($array[0] eq "#not_run_on") {
      if ($cur_test_num != 0) {
     $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}not_run_on_test ";
     $not_run_mach_list_hold{$cur_test_num}=substr($line, 12, length($line));
      } else {
         $directives{not_run_on_test} = 1;
         $not_run_on_mach_list=substr($line, 12, length($line));
      }
   } elsif ($array[0] eq "#not_run_with_lang") {
      $directives{not_run_with_lang} = 1;
      $not_run_lang_list=substr($line, 19, length($line));
   } elsif ($array[0] eq "#run_only_with_lang") {
      $directives{run_only_with_lang} = 1;
      $run_only_lang_list=substr($line, 20, length($line));
   } elsif ($array[0] eq "#run_with_license") {
      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}run_with_license ";
     $license_info_hold{$cur_test_num}=substr($line, 18, length($line));
      } else {
         $directives{run_with_license} = 1;
         $license_info=substr($line, 18, length($line));
      }
      undef $ENV{CREO_SAAS_APIKEY} if ($ENV{CREO_SAAS_APIKEY} != "");
   } elsif ($array[0] eq "#keep") {
      $directives{keep} = 1;
      $directives{keepscratch} = 0;
      $keep_ext_list = substr($line, 6, length($line));
  } elsif ($array[0] eq "#gr_keep") {
      $directives{gr_keep} = 1;
  } elsif ($array[0] eq "#copy_gr_keep") {
      $directives{copy_gr_keep} = 1;
  }  elsif ($array[0] eq "#repeat_gr_trail") {
      $directives{repeat_gr_trail} = 1;
   } elsif ($array[0] eq "#plpf") {
      $directives{plpf_test} = 1;
   } elsif ($array[0] eq "#local_home_test") {
      $directives{local_home_test} = 1;
   } elsif ($array[0] eq "#prokernel_retr") {
      my ($others)=substr($line, 16, length($line));
      ($prokernel_retr_exe, @other_args) = split(/ +/, $others);
      $prokernel_retr_args = join(" ", @other_args);
      if ( defined $ENV{R_KERNEL_PARTS} ) {
         $prokernel_retr_args =~ s/%PARTS/$R_KERNEL_PARTS/g;
      } else {
         $prokernel_retr_args =~ s/%PARTS/$PTC_REGOBJS\/spg\/objects\/test\/prokernel/g;
      }
      if ( defined $ENV{R_KERNEL_QCRS} ) {
         $prokernel_retr_args =~ s/%GRANITE_QCRS/$ENV{R_KERNEL_QCRS}/g;
      } else {
         $prokernel_retr_args =~ s/%GRANITE_QCRS/$PTCSRC\/apps\/prokernel\/qa\/qcr/g;
      }
      if ($cur_test_num != 0) {
          $directive_hold{$cur_test_num} = 
          "$directive_hold{$cur_test_num}prokernel_retr ";
          $prokernel_retr_exe_hold{$cur_test_num} = $prokernel_retr_exe;
          $prokernel_retr_args_hold{$cur_test_num} = $prokernel_retr_args;
      } else { 
          $prokernel_retr_flag = 1;
      }
   } elsif ($array[0] eq "#prokernel_test") {
      $directives{prokernel_test} = 1;
      my ($others)=substr($line, 16, length($line));
      ($prokernel_exe, @other_args) = split(/ +/, $others);
      $prokernel_test_args = join(" ", @other_args);

      if ( defined $ENV{R_KERNEL_PARTS} || ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} )) {

         my ($local_file) = $prokernel_test_args =~ /(%PARTS\S+)/;
         if ( !defined $ENV{R_KERNEL_PARTS} )
         {
            $R_KERNEL_PARTS = "$ENV{P_PROJECT_PATH}\/$ENV{P_CURR_PROJ}\/reg\/spg\/objects\/test\/prokernel";
         }

         $local_file =~ s/%PARTS/$R_KERNEL_PARTS/g;
         if (-e $local_file)
         {
             print "\nUsing the Local File: $local_file\n";
             $prokernel_test_args =~ s/%PARTS/$R_KERNEL_PARTS/g;
         }
         else
         {
             $prokernel_test_args =~ s/%PARTS/$PTC_REGOBJS\/spg\/objects\/test\/prokernel/g;
         }
      } else {
         $prokernel_test_args =~ s/%PARTS/$PTC_REGOBJS\/spg\/objects\/test\/prokernel/g;
      }

      if ( defined $ENV{R_KERNEL_QCRS} || ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} )) {

            my ($local_file) = $prokernel_test_args =~ /(%GRANITE_QCRS\S+)/;

            if ( !defined $ENV{R_KERNEL_QCRS} )
            {
                $R_KERNEL_QCRS = "$ENV{P_PROJECT_PATH}\/$ENV{P_CURR_PROJ}\/apps\/prokernel\/qa\/qcr";
            }

         $local_file =~ s/%GRANITE_QCRS/$R_KERNEL_QCRS/g;

         if (-e $local_file)
         {
            print "\nUsing the Local QCR File: $local_file\n";
            $prokernel_test_args =~ s/%GRANITE_QCRS/$R_KERNEL_QCRS/g;
         }
         else
         {
            $prokernel_test_args =~ s/%GRANITE_QCRS/$PTCSRC\/apps\/prokernel\/qa\/qcr/g;
         }
      }
      else 
      {
         $prokernel_test_args =~ s/%GRANITE_QCRS/$PTCSRC\/apps\/prokernel\/qa\/qcr/g;
      }
      
      if ( defined $ENV{R_KERNEL_JAVA_QCRS} || ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) ) {

           my ($local_file) = $prokernel_test_args =~ /(%GRANITE_JAVA_QCRS\S+)/;

           if ( !defined $ENV{R_KERNEL_JAVA_QCRS})
           {
                $R_KERNEL_JAVA_QCRS = "$ENV{P_PROJECT_PATH}\/$ENV{P_CURR_PROJ}\/apps\/prokernel\/qa\/java_qcr";
           }

          $local_file =~ s/%GRANITE_JAVA_QCRS/$R_KERNEL_JAVA_QCRS/g;
          if (-e $local_file)
          {
             print "\nUsing the Local QCR File: $local_file\n";
             $prokernel_test_args =~ s/%GRANITE_JAVA_QCRS/$R_KERNEL_JAVA_QCRS/g;
          }
          else
          {
             $prokernel_test_args =~ s/%GRANITE_JAVA_QCRS/$PTCSRC\/apps\/prokernel\/qa\/java_qcr/g;
          }
      }
	  else {
             $prokernel_test_args =~ s/%GRANITE_JAVA_QCRS/$PTCSRC\/apps\/prokernel\/qa\/java_qcr/g;
      }
      
      if ( defined $ENV{R_KERNEL_GPI_QCRS} || ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} )) {     

           my ($local_file) = $prokernel_test_args =~ /(%GPI_QCRS\S+)/;

           if ( !defined $ENV{R_KERNEL_GPI_QCRS} )
            {
               $R_KERNEL_GPI_QCRS = "$ENV{P_PROJECT_PATH}\/$ENV{P_CURR_PROJ}\/apps\/prokernel\/gModules\/gProIntf\/qa\/qcr";
            }

            $local_file =~ s/%GPI_QCRS/$R_KERNEL_GPI_QCRS/g;

           if (-e $local_file)
           {
              print "\nUsing the Local QCR File: $local_file\n";
              $prokernel_test_args =~ s/%GPI_QCRS/$R_KERNEL_GPI_QCRS/g;
           }
          else
          {
             $prokernel_test_args =~ s/%GPI_QCRS/$PTCSRC\/apps\/prokernel\/gModules\/gProIntf\/qa\/qcr/g;
          }
       } 
       else {
              $prokernel_test_args =~ s/%GPI_QCRS/$PTCSRC\/apps\/prokernel\/gModules\/gProIntf\/qa\/qcr/g;
        }

      if ($directives{copy_gr_keep}) {
         if (-d "$rundir/keep_files") {
            `cp $rundir/keep_files/* "$tmpdir"`;
         } else {
            print "Could not find keep_files folder.\n";
         } 
      }

   } elsif ($array[0] eq "#setenv") {
      my ($first_word, @rest_words)=split(/ +/, substr($line, 8, length($line)));
      my ($rest_word) = join(" ", @rest_words);
      if ( ( $first_word eq "PTC_D_LICENSE_FILE" ) ||
           ( $first_word eq "PRO_LICENSE_RES" ) ||
           ( $first_word eq "LM_LICENSE_FILE" ) ||
           ( $first_word eq "CREOPMA_FEATURE_NAME" ) ) {
          # Should not allow these license related ENV to be explicitly set in auto.txt
          # Instead auto entry should use run_with_license directive
          print_fail("skipped::  #skipped because incorrect env($first_word) used. Instead use run_with_license directive\n");
          print_skip_msg("skipped::  #skipped because incorrect env($first_word) used. Instead use run_with_license directive\n");
          return -1;
      }
      # Added code from record_setenv to handle variables in setenv command
      while ($rest_word =~ /\${/) {
         my ($env_var);
         my ($head, @rest_line) = split (/\$/, $rest_word);
         my ($rest) = join("\$", @rest_line);
         $rest_word = substr($rest, 1, length($rest)-1);
         ($env_var, @rest_line) = split (/}/, $rest_word);
         $rest = join("}", @rest_line);
         $rest_word = $head . $ENV{$env_var} . $rest;
      }
      if ($cur_test_num != 0) {
         if (exists $setenv_hold{$cur_test_num}) {
           my ($tmp_setenv) = "$first_word $rest_word $setenv_hold{$cur_test_num}";
           $setenv_hold{$cur_test_num} = $tmp_setenv;
         } else {
           $setenv_hold{$cur_test_num} = "$first_word $rest_word";
         }
      } else {
         &record_setenv($first_word, $rest_word);
      }
   } elsif ($array[0] eq "#unsetenv") {
      if ($cur_test_num != 0) {
     if (exists $unsetenv_hold{$cur_test_num}) {
        $unsetenv_hold{$cur_test_num} = "$unsetenv_hold{$cur_test_num} $array[1]";
     } else {
        $unsetenv_hold{$cur_test_num} = "$array[1]";
     }
       } else {
         &record_setenv(substr($line, 10, length($line)), undef);
       }
   } elsif ($array[0] eq "#setenv_to_cwd_and") {
      $directives{setenv_to_cwd_and} = 1;
      &record_setenv($array[1], $array[2]);
   } elsif ($array[0] eq "#setenv_to_cwd") {
      $directives{setenv_to_cwd} = 1;
      if ($setenv_to_cwd ne "") {
         $setenv_to_cwd = "$setenv_to_cwd $array[1]";
      } else {
         $setenv_to_cwd = $array[1];
      }
   } elsif ($array[0] eq "#generic_uif_test") {
      $directives{generic_uif_test} = 1;
      if ($array[1] eq "protab") {
         $uif_exec=$protab_exec;
      } elsif ($array[1] eq "proetree") {
         $uif_exec="$PTCSYS/obj/proetree";
      } elsif ($array[1] eq "proguide") {
         $uif_exec=$proguide_exec;
      } else {
         $uif_exec=`$csh_cmd "${TOOLDIR}dummy_uif_exec"`;
      }
      $genuifargs = "";
      for ($i=2; $i<@array; $i++) {
         $genuifargs = "$genuifargs $array[$i]";
      }
   } elsif ($array[0] eq "#generic_ui_test") {
      $directives{generic_ui_test} = 1;
      if ($array[1] eq "protab") {
         $uif_exec=$protab_exec;
      } else {
         if (defined $ENV{R_REGRES_BIN} && -e "$ENV{R_REGRES_BIN}/$array[1]$exe_ext") {
            $uif_exec="$R_REGRES_BIN/$array[1]$exe_ext";
         } else {
            $uif_exec="$PRO_DIRECTORY/$PRO_MACHINE_TYPE/obj/$array[1]$exe_ext";
         }
         print "uif_exec: $uif_exec\n";
      }
      $genuiargs = "";
      for ($i=2; $i<@array; $i++) {
          $genuiargs = "$genuiargs $array[$i]";
      }
   } elsif ($array[0] eq "#pd_async_test") {
      $directives{pd_async_test} = 1;
   } elsif ($array[0] eq "#fbuilder_test") {
      $directives{fbuilder_test} = 1;
   } elsif ($array[0] eq "#check_ram_test") {
      if ($cur_test_num != 0) {
     $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}check_ram_test ";
      } else {
         $directives{check_ram_test} = 1;
      }
      if ($array[1] eq "") {
     $check_ram_size = 1000;
      } else {
     $check_ram_size = $array[1] * 1000;
      } 
   } elsif ($array[0] eq "#probatch_test") {
      $directives{probatch_test} = 1;
   } elsif ($array[0] eq "#zero_run_mode_test") {
      $directives{zero_run_mode_test} = 1;
      $directives{wildfire_test} = 1;
   } elsif ($array[0] eq "#java_async_test") {
      $directives{java_async_test} = 1;
      $java_version = $array[1];
   } elsif ($array[0] eq "#java_sync_test") {
      $directives{java_sync_test} = 1;
   } elsif ($array[0] eq "#pt_async_test") {
      $directives{pt_async_test} = 1;
   } elsif ($array[0] eq "#pfcvb_test") {
      $directives{pfcvb_test} = 1;
   } elsif ($array[0] eq "#open_access_test") {
      $directives{open_access_test} = 1;
   } elsif ($array[0] eq "#xtop_add_args") {
      if ($cur_test_num != 0) {
          $directive_hold{$cur_test_num} = 
          "$directive_hold{$cur_test_num}xtop_add_args ";
          $xtop_args_hold{$cur_test_num} = substr($line, 15, length($line));
      } else {
          $directives{xtop_add_args} = 1;
          $xtop_args=substr($line, 15, length($line));
      }
   } elsif ($array[0] eq "#pt_async_pic_test") {
      $directives{pt_async_pic_test} = 1;
   } elsif ($array[0] eq "#pt_simple_async_test") {
      $directives{pt_simple_async_test} = 1;
   } elsif ($array[0] eq "#prorembatch_test") {
      $directives{rembatch_test} = 1;
      if ($old_tmpdir) {
         $ENV{TMPDIR} = $old_tmpdir;
      } else {
         delete ($ENV{"TMPDIR"});
      }
      if ( $OS_TYPE eq "NT") {
         $ENV{TEMP} = $old_temp;
         $ENV{TMP} = $old_tmp;
      }
   } elsif ($array[0] eq "#check_display") {
      $directives{check_display} = 1;
   } elsif ($array[0] eq "#check_build") {
      $directives{check_build} = 1;
      $checkbuild_exes = substr($line, 13, length($line));
   } elsif ($array[0] eq "#t") {
      $directives{logtesttime} = 1;
   } elsif ($array[0] eq "#begin_fly") {
      $directives{run_fly_tests} = 1;
      &set_profly_env;
   } elsif ($array[0] eq "#end_fly") {
      $directives{run_fly_tests} = 0;
   } elsif ($array[0] eq "#pt_asynchronous_tests") {
      $directives{pt_asynchronous_tests} = 1;
   } elsif ($array[0] eq "#pt_wt_asynchronous_tests") {
      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num} = 
        "$directive_hold{$cur_test_num}pt_wt_asynchronous_tests ";
      } else {
         $directives{pt_wt_asynchronous_tests} = 1;
      }
   } elsif ($array[0] eq "#ddl_test") {
      $directives{ddl_test} = 1;
   } elsif ($array[0] eq "#batch_mode_test") {
      $directives{batch_mode_test} = 1;
   } elsif ($array[0] eq "#batch_trail_test") {
      $directives{batch_trail_test} = 1 if ($ENV{R_BATCH_TRAIL} eq "true");
   } elsif ($array[0] eq "#pvecadcompare_trail_test") {
      $directives{pvecadcompare_trail_test} = 1;
   } elsif ($array[0] eq "#pvvalidate_trail_test") {
      $directives{pvvalidate_trail_test} = 1;
   } elsif ($array[0] eq "#backward_trail") {
      if ($array[1] ne "") {
         if ($cur_test_num != 0) {
            $backward_trail_hold{$cur_test_num} = $cur_test_num;
         } else {
            $directives{backward_trail} = 1;
         }
     if (defined $ENV{R_BACKWARD}) {
        $backward_cmd = $ENV{R_BACKWARD};
     } else {
        if ($cur_test_num != 0) {
           $backward_cmd_hold{$cur_test_num} = $array[1];
        } else {
           $backward_cmd = $array[1];
        }
     }
      } 
   } elsif ($array[0] eq "#backward_retr") {
      if (defined $ENV{R_BACKWARD}) {
         $directives{backward_retr} = 1;
         $is_backward_retr = 0;
      }
   } elsif ($array[0] eq "#ug_test") {
      $directives{ug_test} = 1;
      $ugs_version = $array[1];
      $directives{flex_lic_chk} = 1;
      if ($ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
         $flexserver = "28000\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
      } else {
         $flexserver = "27005\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
      }
   } elsif ($array[0] eq "#ug_dbatch_test") {
      $directives{ug_dbatch_test} = 1;
      $ugs_version = $array[1];
      if ($ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
         $flexserver = "28000\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
      } else {
         $flexserver = "27005\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
      }
   } elsif ($array[0] eq "#force_ug") {
      $directives{force_ug} = 1;
   } elsif ($array[0] eq "#uitoolkit_app_test") {
      $directives{uitoolkit_app_test} = 1;
   } elsif ($array[0] eq "#creo_ui_resource_editor_test") {
      $directives{creo_ui_resource_editor_test} = 1;
      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num} =
         "$directive_hold{$cur_test_num}creo_ui_resource_editor_test ";
      } else {
         $cure_flag = 1;
      }
   } elsif ($array[0] eq "#mech_motion_test") {
      $directives{mech_motion_test} = 1;
   } elsif ($array[0] eq "#pt_retrieval_tests") {
      $directives{pt_retrieval_tests} = 1;
   } elsif ($array[0] eq "#script_test") {
      $directives{script_test} = 1;
   } elsif ($array[0] eq "#uwgm_test") {
      $directives{uwgm_test} = 1;
      Uwgmreg::setUwgmTest(1);
   } elsif ($array[0] eq "#wwgmint_test") {
      $directives{wwgmint_test} = 1;
	  $cadname = $array[1];
      Uwgmreg::setUwgmTest(1);
   } elsif ($array[0] eq "#wwgmpws_test") {
      $directives{wwgmpws_test} = 1;
   } elsif ($array[0] eq "#env_replace_fslash") {
	  $envname = $array[1];	
      $directives{env_replace_fslash} = 1;
   } elsif ($array[0] eq "#if_exist") {
      if ($cur_test_num != 0) {
     $directive_hold{$cur_test_num} =
        "$directive_hold{$cur_test_num}if_exist ";
     $if_exist_list_hold{$cur_test_num}=substr($line, 10, length($line));
      } else {
         $directives{if_exist} = 1;
         $if_exist_list=substr($line, 10, length($line));
      }
   } elsif ($array[0] eq "#flex_lic_chk") {
      $directives{flex_lic_chk} = 1;
      $flexserver = $array[1];
   } elsif ($array[0] eq "#no_future_mode") {
      $directives{no_future_mode} = 1;
   } elsif ($array[0] eq "#mathcad_test") {
      $directives{mathcad_test} = 1;
      $mathcad_version = $array[1];
   } elsif ($array[0] eq "#no_mathcad_test") {
      $directives{no_mathcad_test} = 1;
   } elsif ($array[0] eq "#drm_test") {
      print_succfail("Setting DRM_DISABLE_OFFLINE to true\n");
      $ENV{DRM_DISABLE_OFFLINE} = "true";
      $directives{drm_test} = 1;
      $fio_args = $array[1];
      $fio_args = "drm_test" if ($fio_args eq "");
      $fio_server = "https://april-drm:9443/edc/Login.do" ;
      if ($cur_test_num != 0) {
          if (defined $setenv_hold{$cur_test_num}) {
              $setenv_hold{$cur_test_num} = "FIO_USER $fio_args FIO_PASSWORD $fio_args R_FIO_SERVER $fio_server $setenv_hold{$cur_test_num}";
          } else {
              $setenv_hold{$cur_test_num} = "FIO_USER $fio_args FIO_PASSWORD $fio_args R_FIO_SERVER $fio_server";
          }
      } else {
          &record_setenv("FIO_USER", $fio_args);
          &record_setenv("FIO_PASSWORD", $fio_args);
          &record_setenv("R_FIO_SERVER", $fio_server);

         # Remove drm cache directory before running test
         if ($PRO_MACHINE_TYPE =~ /i486_nt|x86e_win64/) {
            system ("rd /s /q \"%USERPROFILE%/Application Data/PTC/ALCP_FIO\"");
         } else {
            system ("rm -rf $HOME/.ALCP_FIO");
         }
      }
      if ($unsetenv_hold{$cur_test_num} =~ /FIO_USER FIO_PASSWORD R_FIO_SERVER/) {
          $unsetenv_hold{$cur_test_num} =~ s/FIO_USER FIO_PASSWORD R_FIO_SERVER//;
      }
      if (defined $unsetenv_hold{$cur_test_num + 1}) {
          $unsetenv_hold{$cur_test_num + 1} = "FIO_USER FIO_PASSWORD R_FIO_SERVER $unsetenv_hold{$cur_test_num + 1}";
      } else {
          $unsetenv_hold{$cur_test_num + 1} = "FIO_USER FIO_PASSWORD R_FIO_SERVER";
      }
   } elsif ($array[0] eq "#ipc_test") {
      $directives{ipc_test} = 1;
   } elsif ($array[0] eq "#legacy_encoding_test" &&
    ! defined $ENV{R_DISABLE_LEGACY_TEST}) {
      $directives{legacy_encoding_test} = 1;
      $num_legacy_test = 2 if ($num_legacy_test <= 0);
   } elsif ($array[0] eq "#L10N") {
      # Skip if we are running in English (Case #20341)
      if ($altlang ne "") {
         $directives{L10N_test} = 1;
         $directives{langtest} = 1;
         $directives{graphics_test} = 1;
         $graphics_test_modes = 7;
      }
   } elsif ($array[0] eq "#obsolete_test") {
      $directives{obsolete_test} = 1;
   } elsif ($array[0] eq "#creoint_incubation") {
      $directives{creoint_incubation} = 1;
   } elsif ($array[0] eq "#force_drm") {
      $directives{force_drm} = 1;
   } elsif ($array[0] eq "#catia_v5_test") {
      $directives{catia_v5_test} = 1;
   } elsif ($array[0] eq "#rsd_test") {
      $directives{rsd_test} = 1;
      $ENV{RSD_BAT} = 'creoschematics.bat' if ( not defined $ENV{RSD_BAT} );
      $ENV{R_ALT_TRAIL_PATH} = "$ENV{RSDSRC}/medusa/src/kansas/test" if ( not defined $ENV{R_ALT_TRAIL_PATH} );
      $ENV{R_ALT_OBJ_DIR} = $ENV{R_ALT_TRAIL_PATH} if ( not defined $ENV{R_ALT_OBJ_DIR} );
      $trail_path = "$ENV{RSDSRC}/medusa/src/kansas/test";
   } elsif ($array[0] eq "#has_dgm_file") {
      $dgm_version = $array[1];
	  if ($ENV{RSD_DGE_LOCATION} eq "") {
		   $ENV{RSD_DGE_LOCATION} = "$ENV{PTC_COMMON}/schematicsobjects";
	  }
   } elsif ($array[0] eq "#jt_test") {
      $directives{jt_test} = 1;
   } elsif ($array[0] eq "#pv_test") {
      $directives{pv_test} = 1;
   } elsif ($array[0] eq "#solidworks_test") {
      $directives{solidworks_test} = 1;
      $solidworks_version = $array[1];
   } elsif ($array[0] eq "#add_to_config") {
      shift @array;
      $directives{add_to_config} = 1;
      $add_config_option = join (" ", @array);
   } elsif ($array[0] eq "#pvecadcompare_perform_test") {
      $directives{pvecadcompare_perform_test} = 1;
   } elsif ($array[0] eq "#pvvalidate_perform_test") {
      $directives{pvvalidate_perform_test} = 1;
   } elsif ($array[0] eq "#inventor_test") {
      $directives{inventor_test} = 1;
      shift @array;
      @inventor_versions = @array;
    } elsif ($array[0] eq "#not_run_with_xtop_md") {
      $directives{not_run_with_xtop_md} = 1;
   } elsif ($array[0] eq "#lda_test") {
      $directives{lda_test} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
   } elsif ($array[0] eq "#ptwt_test") {
      $directives{ptwt_test} = 1;
   } elsif ($array[0] eq "#otk_cpp_test") {
      $directives{otk_cpp_test} = 1;
      &set_otk_testlog_env_var;
   } elsif ($array[0] eq "#tk_flavor" 
             || $array[0] eq "#wnc_flavor"
           ) {
      $directives{tk_flavor} = 1;
      $directives{wnc_flavor} = 1 if ($array[0] eq "#wnc_flavor");
      $tk_flavor_ = $array[1];
   } elsif ($array[0] eq "#otk_cpp_async_test") {
      $directives{otk_cpp_async_test} = 1;
      &set_otk_testlog_env_var;
   } elsif ($array[0] eq "#fresh_creo_agent") {
      $directives{fresh_creo_agent} = 1;
	  print_succfail("Directive #fresh_creo_agent\n");
   } elsif ($array[0] eq "#gcri_retr_test") {
      $directives{gcri_retr_test} = 1;
      ($r_directive, $r_trl, $r_obj)=split(/ /, $line);
      $retr_trl{$cur_test_num} = $r_trl.".txt";
      $retr_obj = $r_obj;
   } elsif ($array[0] eq "#ptc_univ_ce_test") {
      $directives{ptc_univ_ce_test} = 1;
   } elsif ($array[0] eq "#merge_config") {
      my ($first_word, $rest_word)=split(/ /, $line);
      #handle variables in line
      while ($rest_word =~ /\${/) {
            my ($env_var);
            my ($head, @rest_line) = split (/\$/, $rest_word);
            my ($rest) = join("\$", @rest_line);
            $rest_word = substr($rest, 1, length($rest)-1);
            ($env_var, @rest_line) = split (/}/, $rest_word);
            $rest = join("}", @rest_line);
            $rest_word = $head . $ENV{$env_var} . $rest;
      }
   
      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num}="$directive_hold{$cur_test_num}merge_config ";
         $merge_config_hold{$cur_test_num}=$rest_word;
      } else {
        $directives{merge_config} = 1;
        $merge_config_file=$rest_word;
      }
   } elsif ($array[0] eq "#config_file") {
      my ($first_word, $rest_word)=split(/ /, $line);
      #handle variables in line
      while ($rest_word =~ /\${/) {
            my ($env_var);
            my ($head, @rest_line) = split (/\$/, $rest_word);
            my ($rest) = join("\$", @rest_line);
            $rest_word = substr($rest, 1, length($rest)-1);
            ($env_var, @rest_line) = split (/}/, $rest_word);
            $rest = join("}", @rest_line);
            $rest_word = $head . $ENV{$env_var} . $rest;
      }

      if ($cur_test_num != 0) {
         $directive_hold{$cur_test_num}="$directive_hold{$cur_test_num}config_file ";
         $config_file_hold{$cur_test_num}=$rest_word;
      } else {
        $directives{config_file} = 1;
        $config_file=$rest_word;
      }
   } elsif ($array[0] eq "#xp_not_supported") {
      $directives{xp_not_supported} = 1;
   } elsif ($array[0] eq "#fail") {
      $directives{fail} = 1;
	  $eftype = lc($array[1]); # expected fail type
	  $eflineno = $array[2]; # expected fail line no
   } elsif ($array[0] eq "#nist_analyzer_test") {
      $directives{nist_analyzer_test} = 1;
   } elsif ($array[0] eq "#simlive_test") {
      $directives{simlive_test} = 1;
      if($array[1] eq "support_non_simlive_mode"){
         $support_non_simlive_mode = 'true';
	  } else {
        $support_non_simlive_mode = 'false';
	  }
   } elsif ($array[0] eq "#do_not_run_on_hdpi") {
      $directives{do_not_run_on_hdpi} = 1;
   } elsif ($array[0] eq "#run_only_on_cdimage") {
      $directives{run_only_on_cdimage} = 1;
   } elsif ($array[0] eq "#gd_test") {
      $directives{gd_test} = 1 if ($ENV{PRO_MACHINE_TYPE} == 'x86e_win64');
   } elsif ($array[0] eq "#gmb_wip") {
      $directives{gmb_wip} = 1;
   } elsif ($array[0] eq "#gd_webapp_test") {
      $directives{gd_webapp_test} = 1;
   } elsif ($array[0] eq "#aim_test") {
      $directives{aim_test} = 1;
   } elsif ($array[0] eq "#shared_workspace") {
      $directives{shared_workspace} = 1;  
	 $collab_atlas = 'false';
     $shared_workspace_trail_size = 0;
     undef $shared_workspace_trail;
	 my $count_tokens = 0;
	 @tokens = split(/ /, $line);
	 foreach my $token (@tokens) {
	 	$count_tokens++;
		if ($count_tokens == 2) {
    	   if (lc($token) eq 'atlas') {
	 		$collab_atlas = 'true';
		   }
	       else {		   
			$shared_workspace_trail = $token;
		    $shared_workspace_trail_size = length($shared_workspace_trail);		
		   }
		}
	
		if ($count_tokens == 3 and !defined $shared_workspace_trail) {
			$shared_workspace_trail = $token;
		    $shared_workspace_trail_size = length($shared_workspace_trail);			
		}	
	}
   } elsif ($array[0] eq "#graphics_process") {
      $directives{graphics_process} = 1;
      $graphics_process_type = substr($line, 18, length($line));
      chomp($graphics_process_type);
      $graphics_process_type = (split(/\s/,$graphics_process_type))[0];
      $directives{tk_flavor} = 1;
      $tk_flavor_ = $graphics_process_type;
      
      if (($ENV{R_BITMAP} eq 'true' && $tk_flavor_ eq '') || $tk_flavor_ eq '') {
         $directives{tk_flavor} = 0;
        $directives{graphics_process} = 0;
      }  
  } elsif ($array[0] eq "#java_flavor") {
      $directives{java_flavor} = 1;
      $jdkversion = substr($line, 13, length($line));
      chomp($jdkversion);
      $jdkversion = (split(/\s/,$jdkversion))[0];
      $directives{tk_flavor} = 1;
      $tk_flavor_ = $jdkversion;
      
      if ($tk_flavor_ eq '') {
         $directives{tk_flavor} = 0;
        $directives{java_flavor} = 0;
      }  
   
    } elsif ($array[0] eq "#not_run_on_app_verifier") {
      $directives{not_run_on_app_verifier} = 1;
    }
    elsif ($array[0] eq "#coretech_kio_test") {
      $directives{coretech_kio_test} = 1;
    } 
    elsif ($array[0] eq "#ngcri_test") {
      $directives{ngcri_test} = 1;
    } elsif ($array[0] eq "#wip_test") {
      $directives{wip_test} = 1;
      $orig_trail_name = $array[1];
      $rt_integrity_id = $array[2];
    } elsif ($array[0] eq "#cpd_user") {
       $directives{cpd_user} = 1;
       $cpd_username = $array[1];
       chomp($cpd_username);
    } elsif ($array[0] eq "#run_on_cpd") {
       $directives{run_on_cpd} = 1;
       $run_on_cpd_cluster_type = $array[1];
       chomp($run_on_cpd_cluster_type);
    }
    elsif ($array[0] eq "#atlas_user") {
      $directives{atlas_user} = 1;
      $is_atlas_user_multi_session = 0;
      $atlas_user_name1 = "";
      $atlas_user_name2 = "";
      $atlas_password1 = "";
      $atlas_password2 = "";
      $atlas_s2_trail_name = "";

      @atlas_user_fullinfo = split(/ +/, $line);
      if ($shared_workspace_trail ne "") {
         $is_atlas_user_multi_session = 1 ;
         $atlas_user_name1 = (split(":", $atlas_user_fullinfo[1]))[1];
         $atlas_user_name2 = (split(":", $atlas_user_fullinfo[2]))[1];
         #$atlas_s2_trail_name = $atlas_user_fullinfo[3];
         $atlas_s2_trail_name = $shared_workspace_trail;
         
         if ($atlas_user_name2 eq "") {
           $is_atlas_user_multi_session = 0 ;
           print "\nError: Provide second user_name to #atlas_user for $atlas_s2_trail_name \n";  
         }
      } else {
         $atlas_user_name1 = (split(":", $atlas_user_fullinfo[1]))[1];
      }

      #print "atlas_user_name1:${atlas_user_name1}\n";
      #print "atlas_user_name2:${atlas_user_name2}\n";
      #print "atlas_s2_trail_name:${atlas_s2_trail_name}\n";
      
      if ($atlas_user_name1 eq "" && $atlas_user_name2 eq "" ) {
        print "\nError: Provide atleast one user_name to #atlas_user \n";
      } else { 
        $atlas_password1 = get_secret($atlas_user_name1);
        $atlas_password2 = get_secret($atlas_user_name2) if ("$atlas_user_name2" ne '');   
	  }   
    } elsif ($array[0] eq "#saas_test" || $array[0] eq "#creoplus_e2e_test" || $array[0] eq "#saas_test_on_demand") {
      $directives{saas_test} = 1;
      
      if ($array[0] eq "#saas_test_on_demand") {
          $directives{saas_test_on_demand} = 1;
      }

      if ($array[0] eq "#creoplus_e2e_test") {
          $directives{creoplus_e2e_test} = 1;
          add_to_saveas("PlaywrightConsoleLogs");
          add_to_saveas("test-results");
          add_to_saveas("allure-results");
          add_to_saveas('playwright_test.log');
          add_to_saveas('saas_monitoring_errors.log');
          add_to_saveas('genlwsc');
          $e2e_test_tsname = "";
          $e2e_test_tsname = $array[1] if ($array[1] ne '');
          $E2E_AUTOMATION_TOKEN = get_secret('e2e_testrun_token');
      }
      
    } elsif ($array[0] eq "#skip_for_cpd_run") {
      $directives{skip_for_cpd_run} = 1;
    }
    elsif ($array[0] eq "#run_only_on_cpd") {
      $directives{run_only_on_cpd} = 1;
    } elsif ($array[0] eq "#run_only_one_test") {
      $directives{run_only_one_test} = 1;
    } elsif ($array[0] eq "#uses_config_service") {
       if ( ($ENV{R_USE_CREO_PLUS} eq "true") || ($ENV{R_SAAS_REGRESSION} eq "true") ) {
           $directives{uses_config_service} = 1;
           $ENV{SAAS_CONFIGS_ON} = "true";
           $ENV{R_USE_SAAS_CONFIG_SERVICE} = "true";
       }
    } elsif ($array[0] eq "#pyautogui_test") {
       $directives{pyautogui_test} = 1; 
    } elsif ($array[0] eq "#engnotebook_test") {
       $directives{engnotebook_test} = 1; 
    } 
    elsif ($array[0] eq "#wg_generate_code") {
       $directives{wg_generate_code} = 1;
	   $ENV{R_SAVE_AS} = "gen_code";
	   $ENV{R_SAVEAS_ALWAYS} = "true";
    } 
    elsif ($array[0] eq "#wg_test_generated_code") {
       $directives{wg_test_generated_code} = 1; 
    } 
   return (0);
}

sub set_profly_env {
   push @ENV, $PROE_START if (! exists $ENV{PROE_START});
   $ENV{PROE_START} = $local_xtop;
   print "PROE_START is set to $ENV{PROE_START}\n";
   push @ENV, $PROFLY_DEBUG if (! exists $ENV{PROFLY_DEBUG});
   $ENV{PROFLY_DEBUG} = "true";
   push @ENV, $PROFLY_WRITE_TRAIL if (! exists $ENV{PROFLY_WRITE_TRAIL});
   $ENV{PROFLY_WRITE_TRAIL} = "true";
   if (! exists $ENV{PROFLY_DIRECTORY}) {
      push @ENV, $PROFLY_DIRECTORY;
      $ENV{PROFLY_DIRECTORY} = "$PTCSRC/pronav";
   }
}

sub get_version {
   if (-e $auto_ver && $dcad_server eq "") {
      $version=`cat "$auto_ver"`;
   }
   else {
      print "Finding version number of executable\n";
      mkdir ("$tmpdir", 0777);
      chdir_safe ("$tmpdir");
      $version=`$csh_cmd "fv $local_xtop"`;
      $fv_error = $?;
      $fv_error = $fv_error >> 8 if ($fv_error >= 256);
      if ($fv_error) {
          if ("$version" eq "Killed\n") {
             print "Can't start xtop, exit.\n";
          }
          if ("$version" =~ /Error: No Version/) {
              print "$local_xtop did not return a version, exit.\n";
          }
          exit (1);
      }
      chdir_safe ("$rundir");
      `$rm_cmd -rf "$tmpdir"`;
      open(VERFILE,">$auto_ver");
      print VERFILE $version;
      close (VERFILE);
   }
   chop($version);
   	 `$rm_cmd -rf "$ENV{TMP}"` if (-d "$ENV{TMP}");
	 `$rm_cmd -rf "$ENV{TEMP}"` if (-d "$ENV{TEMP}");
	 `$rm_cmd -rf WF_ROOT_DIR` if (-d "WF_ROOT_DIR");
}

sub kill_old_processs {

    @plist = ("bootstrapper"
              ,"ptc_uiservice"
              ,"creoagent"
              ,"creoinfo"
              ,"pro_comm_msg"
              ,"zbcefr"
              ,"prod_dcu"
              ,"mcp_applet_async"
              ,"genlwsc"
              ,"uisc"
              ,"creoplus"
    );

    if ($ENV{R_USE_CREO_PLUS} eq "true") {

     foreach $pname (@plist) {
       $cur_cmd = "timeout 10s pskill /accepteula -t $pname";
       print "Killing: $cur_cmd\n";
       `$csh_cmd "$cur_cmd"`;
     }
   }
	print ("\n\n********************************************************************\n");
	print ("\n			KILIING EXISTING PROCESSES IF ANY							\n");
	$cur_cmd = "timeout 10s pskill /accepteula xtop.exe";
	print "Killing: xtop\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula creostorage.exe";
	print "Killing: creostorage.exe\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula genlwsc.exe";
	print "Killing: genlwsc.exe\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula creoagent.exe";
	print "Killing: creoagent.exe\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula IEDriverServer.exe";
	print "Killing: IEDriverServer.exe\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula ChromeDriver.exe";
	print "Killing: ChromeDriver.exe\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula zbcef.exe";
	print "Killing: zbcef.exe\n";
	`$csh_cmd "$cur_cmd"`;
	
	$cur_cmd = "timeout 10s pskill /accepteula zbcefr.exe";
	print "Killing: zbcefr.exe\n";
	`$csh_cmd "$cur_cmd"`;
    
    if ($ENV{R_PERFVS} eq 'true') {
       $cur_cmd = "timeout 10s pskill /accepteula CPUStackExport.exe";
       print "Killing: CPUStackExport.exe\n";
      `$csh_cmd "$cur_cmd"`;
    }
    
    if ($ENV{R_PERFVIEW} eq 'true') {
       $cur_cmd = "timeout 10s pskill /accepteula PerfView.exe";
       print "Killing: PerfView.exe\n";
      `$csh_cmd "$cur_cmd"`;
    }
    
    print ("\n\n********************************************************************\n");
}

sub print_env_info {
   print "\n\n   This is AUTO  --  the automatic regression test script\n";
   print "       ======================================================\n\n\n";
   print "\n\nGuesses about disk space\n\n";
   print `$csh_cmd "${TOOLDIR}checkspace $cur_dir"`;
   #open (SUCCFAIL_PT, "| tee -a \"$succ\" \"$fail\"");
   print_succfail ("\n\n********************************************************************\n");
   print_succfail ("\n\n              PARAMETER/ENVIRONMENT SUMMARY\n\n");
   print_succfail("    Parameter 1 -    EXE_PATH:  $local_xtop\n");
   print_succfail ("    Parameter 2 -  TRAIL_PATH:  $trail_path\n");
   print_succfail ("    Parameter 3 -    OBJ_PATH:  $obj_path\n\n\n");
   print_succfail ("    Machine name   -->   $mach_name\n");
   print_succfail ("    Run Directory  -->   $cur_dir\n");
   print_succfail ("    PTCSRC  -->   $ENV{PTCSRC}\n");
   print_succfail ("    PTCSYS  -->   $ENV{PTCSYS}\n");
   print_succfail ("    PRO_DIRECTORY  -->   $PRO_DIRECTORY\n");
   print_succfail ("    PROTAB         -->   $PROTAB\n");
   print_succfail ("    Version String -->   $version\n");
   print_succfail ("    P_VERSION      -->   $ENV{P_VERSION}\n");
   print_succfail ("    Graphics type  -->   $ENV{R_GRAPHICS}\n");
   print_succfail ("    LANG           -->   $LANG\n");
   print_succfail ("    PRO_LANG       -->   $PRO_LANG\n") if (defined $ENV{PRO_LANG} );
   print_succfail ("    OPER_SYS       -->   $OPER_SYS\n");
   print_succfail ("    PRO_MACHINE_TYPE --> $PRO_MACHINE_TYPE\n");
   print_succfail ("    PTC_WT_SERVER  -->   $PTC_WT_SERVER\n") if (defined $ENV{PTC_WT_SERVER} );
   print_succfail ("    DISPLAY        -->   $DISPLAY\n");
   print_succfail ("    Run mode       -->   $ENV{R_RUNMODE}\n");
   print_succfail ("    Auto.txt file  -->   $ENV{R_AUTOTXT}\n");
   print_succfail ("    Today's Date   -->   $date $startauto\n");
   print_succfail ("    Alt trail path -->   $ENV{R_ALT_TRAIL_DIR}\n");
   print_succfail ("    R_GETTB_CORE   -->   $ENV{R_GETTB_CORE}\n");
   print_succfail ("    PTC_ADVAPPSLIB -->   $ENV{PTC_ADVAPPSLIB}\n") if (exists $ENV{PTC_ADVAPPSLIB});
   print_succfail ("    PRO_RES_DIRECTORY --> $PRO_RES_DIRECTORY\n") if (exists $ENV{PRO_RES_DIRECTORY});
   print_succfail ("    MECH_HOME      -->   $ENV{MECH_HOME}\n") if (exists $ENV{MECH_HOME} && $ENV{MECH_HOME} ne "");
   print_succfail ("    MECHANISM_HOME -->   $ENV{MECHANISM_HOME}\n") if (exists $ENV{MECHANISM_HOME} && $ENV{MECHANISM_HOME} ne "");
   print_succfail ("    ANIMATION_HOME -->   $ENV{ANIMATION_HOME}\n") if (exists $ENV{ANIMATION_HOME} && $ENV{ANIMATION_HOME} ne "");
   print_succfail ("    MECH_ENGINE    -->   $ENV{MECH_ENGINE}\n") if (defined $ENV{MECH_ENGINE});
   print_succfail ("    MECH_STANDALONE  --> $ENV{MECH_STANDALONE}\n") if (defined $ENV{MECH_STANDALONE});
   print_succfail ("    PROMECH_MECHANICA --> $ENV{PROMECH_MECHANICA}\n") if (defined $ENV{PROMECH_MECHANICA});
   print_succfail ("    PROMECH_MECHANISM --> $ENV{PROMECH_MECHANISM}\n") if (defined $ENV{PROMECH_MECHANISM});
   print_succfail ("    PROMECH_ANIMATION --> $ENV{PROMECH_ANIMATION}\n") if (defined $ENV{PROMECH_ANIMATION});
   print_succfail ("    MANIKIN_DLL       --> $ENV{MANIKIN_DLL}\n") if (defined $ENV{MANIKIN_DLL});
   print_succfail ("    DSTUDY_DLL        --> $ENV{DSTUDY_DLL}\n") if (defined $ENV{DSTUDY_DLL});
   print_succfail ("    SIM_STDS_PATH  -->   $ENV{SIM_STDS_PATH}\n") if (defined $ENV{SIM_STDS_PATH});
   print_succfail ("    R_ALT_SIM_STDS_PATH --> $ENV{R_ALT_SIM_STDS_PATH}\n") if (defined $ENV{R_ALT_SIM_STDS_PATH});
   print_succfail ("    Alt qcr path   -->   $R_ALT_QCR_DIR\n") if ($R_ALT_QCR_DIR);
   print_succfail ("    Checking for extra printf statements\n") if ($R_FIND_PRINTF && $R_GRAPHICS && $R_RUNMODE eq "0");
   print_succfail ("    Checking floating options\n") if ($R_FLOAT_CHECK);
   print_succfail ("    profiling xtop\n") if ($R_GPROF);
   
  if ( (not defined $ENV{R_RUN_PYAUTOGUI_TEST}) && (not defined $ENV{R_SAAS_REGRESSION}) && (not defined $ENV{RSDSYS}) && ($ENV{OS_TYPE} eq "NT") ) {
     my $filename_to_check_version;
     if (defined $ENV{R_USE_CREO_PLUS}) {
       if (-e "$cc_location/CEF/libcef.dll") {
         $filename_to_check_version = "$cc_location/CEF/libcef.dll";
       } else {
         $filename_to_check_version = "$cc_location/libcef.dll";
       }
     } else {
       if (-e "$ENV{CREO_AGENT_LDP_LIST}/../CEF/libcef.dll") {
         $filename_to_check_version = "$ENV{CREO_AGENT_LDP_LIST}/../CEF/libcef.dll";
       } else {
         $filename_to_check_version = "$ENV{CREO_AGENT_LDP_LIST}/../libcef.dll"; 
       }
       if ($ENV{CEF_AUXOBJS_PATH} ne '') {
           $filename_to_check_version = "$ENV{CEF_AUXOBJS_PATH}/libcef.dll";
       }
     }
     $LIBCEF_DLL_VERSION = get_binary_version("$filename_to_check_version");
     print_succfail ("    File version of libcef.dll   -->   $LIBCEF_DLL_VERSION\n");
     print ("    File version of libcef.dll   -->   $LIBCEF_DLL_VERSION\n");
     $LIBCEF_DLL_VERSION_SHORT = $LIBCEF_DLL_VERSION;
     my @libcefshort_t = split('\+',$LIBCEF_DLL_VERSION);
     $libcefshort = (grep {/chromium/} @libcefshort_t) [0];
     $libcefshort =~ s#^(chromium-)##;
     
     $ENV{'CEF_VERSION'} = get_string_from_gmk_files('CefVersion', 'cef_env.gmk', 'config.gmk');
     $ENV{'CEF_VERSION'} =~ s/^CEF_inh_//;
     $ENV{'CEF_VERSION'} =~ s/^CEF_//;
     print_succfail ("    CEF_VERSION --> $ENV{'CEF_VERSION'}\n");
     
     if ($ENV{R_OVERRIDE_CEF_VERSION} ne "") {
        $ENV{R_OVERRIDE_CEF_VERSION} =~ s/^CEF_//;
        print_succfail ("    R_OVERRIDE_CEF_VERSION --> $ENV{'R_OVERRIDE_CEF_VERSION'}\n") if ($ENV{R_OVERRIDE_CEF_VERSION} ne '');
        $ENV{'CEF_VERSION'} = $ENV{R_OVERRIDE_CEF_VERSION};
     }
 
    if ( ($ENV{'CEF_VERSION'} ne $libcefshort) ) {
       print ("    File version of libcef.dll (libcefshort)   -->   $libcefshort\n");
       $did_cef_mismatch = 1; 
    }
  }
  
   if ($ENV{R_CONFIG_FILE} ne "useautodefault" && -e $ENV{R_CONFIG_FILE}) {
      print_succfail ("    Config options -->\n\n");
      open (CONFIG_PT, $R_CONFIG_FILE);
      my (@config_list) = <CONFIG_PT>;
      print_succfail ("@config_list\n\n");
      close (CONFIG_PT);
   }
   &print_other_envs;
   print_succfail ("********************************************************************\n\n\n");

   if (! -d $PTC_PROLIBS) {
      print_succfail ("\nWARNING: the PTC_PROLIBS $PTC_PROLIBS is missing\n");
      print_succfail ("         Some tests might fail because of this\n\n");
   }

   if ("$config_win" =~ /^config\.win/) {
      print_succfail ("WARNING: there are $config_win in your home directory.\n");
      print_succfail ("         It may affect your regression result.\n\n");
   }

   close (SUCCFAIL_PT);
}

sub print_other_envs {
   local ($var, $value);

   `$csh_cmd "env >& env.log"`;
   
   if (-e "env.log") {
      `$csh_cmd \"cat env.log  | grep -v PASSWORD | grep -v TOKEN |  tee envtmp.log \"`;
      `$csh_cmd \"mv envtmp.log env.log \"`
   }
   
   if ($ENV{ENABLE_ENV_DUMP} eq 'true' || $dcad_server ne ""){
      print "=============== ENV DUMP START ================\n";
      print `$csh_cmd \"cat env.log \"`;
      print "=============== ENV DUMP END ================\n";
   }
   print_succfail ("---------------------------------------------------------------\n");
   print_succfail ("Other Environment Variables:\n");
   open (SETSYSENV, "${TOOLDIR}setsys_env_vars.txt");
   my (@lines) = <SETSYSENV>;
   close (SETSYSENV);
   chomp (@lines);
   %setsys_envs = ();

   foreach $line (@lines) {
      $setsys_envs{$line} = 1;
   } 

   open (ENV, "env.log");
   @lines = <ENV>;
   close (ENV);
   chomp (@lines);
   foreach $line (@lines) {
      ($var, $value) = split (/=/, $line, 2);
      if (! defined $setsys_envs{$var}) {
     if ( ! defined $ENV{R_NO_WRAP} ) {
        print_succfail (wrap ("    $var",
                  "         ",
                  " -> $value\n"));
     } else {
        print_succfail ("    $var -> $value\n");
     }
      }
   }
   print_succfail ("\n");
}

sub waiting_for_startup {
   if ($OS_TYPE eq "UNIX" && $R_AUTO_STARTUP) {
      print "Waiting for the startup time: $R_AUTO_STARTUP\n";
      while (1) {
         `check_cutoff $R_AUTO_STARTUP`;
         $status = $? >> 8;
         last if ($status);
         sleep(60);
      }
   }
   if (defined $ENV{R_INTEG_WAIT}) {
      my $show_msg=1;
      while (! -e "$PTCSYS/logs/autotest_done.nodebug") {
    if ($show_msg > 0) {
       print "Waiting for $PTCSYS/logs/autotest_done.nodebug\n";
       $show_msg=-10;
    } else {
       $show_msg++;
    }
    sleep(60);
      }
   }
   $startauto=&date_hms;
   $startsec=time();
   print "AUTO started at: $startauto\n";
}

sub get_num_tests {
   my (@num_txt, @num_comment_out);

   @num_txt = grep(/\.htm/, @auto_list);
   if (@num_txt == 0) {
      @num_txt = grep(/\.txt\@|\.bac/, @auto_list);
   }
   @num_comment_out = grep(/\!/, @num_txt);
   return (@num_txt - @num_comment_out);
}

sub cleanup {
   my ($time_str);
   kill_process_by_handle("$cur_dir") if ($ENV{R_CHECK_ORPHAN_PROCESS} eq 'true');
   
   if ($PRO_MACHINE_TYPE eq "ibm_rs6000") {
      print "setting screen saver on\n";
      `xset s on`;
   }
   if ($old_tmpdir) {
      $ENV{TMPDIR} = $old_tmpdir;
   } else {
      delete ($ENV{"TMPDIR"});
   }
   if ( $OS_TYPE eq "NT") {
      $ENV{TEMP} = $old_temp;
      $ENV{TMP} = $old_tmp;
   }

   print "Cleaning up\n";

   # Unregistering to the server (pfclscom.exe) for pfcvb tests
   if ($mach_type eq "i486_nt" || $mach_type eq "x86e_win64"){
      if (-e "$ENV{R_PFCLSCOM_DIR}/pfclscom.exe")
      { 
         system ("$ENV{R_PFCLSCOM_DIR}/pfclscom.exe ./UnregServer");
      }
      else
      {
         print "pfclscom.exe does not exist";
      }
   }

   # If a test run is interrupted, the conferencing accounts created in the run
   # might need to be cleaned (so that the next run will pass).
   if (-e "$tmpdir/ptcvconf_trl.txt.1") {
      if (exists $ENV{R_LOCAL_CSUTIL}) {
         $csutil="$ENV{R_LOCAL_CSUTIL}";
      } else {
         $csutil="$PTCSYS/obj/csutil";
      }
      `$csh_cmd ${TOOLDIR}csd_cleanup.csh $csutil`;
   }
   if ( $directives{wildfire_test} && !$non_fastreg && defined $windchill_url) {
    		if ( defined $ENV{R_USE_LOCAL_SERVER}){
				my $response = wisplib_release_windchill(@dirsToCopyServerLogs);
			} else {
      my $response = fastreg_release_windchill(@dirsToCopyServerLogs);
            }
      print_succfail("$response\n") if defined $response;
   }
   
   if ($directives{saas_test}) {
       $saas_script = "$ENV{PTC_TOOLS}/external/saas/saas-ptcagent-regtest.csh";
       if ($ENV{LOCAL_SAAS_SCRIPT} ne '') {
           $saas_script = "$ENV{LOCAL_SAAS_SCRIPT}";
       }
       $run_str = "${saas_script} --cleanup_only --keep";
       `$csh_cmd $run_str`;       
   }

   chdir_safe ("$rundir");
   if (-e "$tmpdir") {
      opendir(TMPDIR, "$tmpdir");
      @files = readdir(TMPDIR);
      chmod(0777, @files);
      closedir(TMPDIR);
      `$rm_cmd -rf "$tmpdir"`;
   }
   `$rm_cmd -rf "$cur_dir/scratch_tmp"` if ( -e "$cur_dir/scratch_tmp");
   if (-d "$cur_dir/scratch_tmp") {
       print "\n Interrupt Warning: $cur_dir/scratch_tmp still exists\n";
       my @filelist = glob($cur_dir/scratch_tmp);
       chomp(@filelist);
       foreach (@filelist) {
           print "$_\n";
       }
   }
   `$rm_cmd -rf "$rundir/auto_misc"` if (-e "$rundir/auto_misc");
   if (exists $ENV{R_POST_PROCESSING} && -e $ENV{R_POST_PROCESSING} && -x $ENV{R_POST_PROCESSING}) {
      `$ENV{R_POST_PROCESSING}`;
   }
   
   if ($delete_creo_saas_automation_repo) {
      cleanup_playwright_data("$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}") if ("$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}" ne "");
   }

   if (${delete_creo_saas_automation_repo_gdx}) {
      cleanup_playwright_data("$ENV{GDX_TEST_PLAYWRIGHT_REPO}") if ("$ENV{GDX_TEST_PLAYWRIGHT_REPO}" ne "");
   }

   $endauto=time();
   $time_str=localtime($endauto);
   $total_time=cnv_sec_hms($endauto-$startsec);
   if ($OS_TYPE eq "NT" && ! defined($PTC_CYGWIN) && ! defined($PTC_MKS)) {
      `$csh_cmd "${TOOLDIR}auto_cleanup_o_db"`;
   } else {
      `$csh_cmd "${TOOLDIR}auto_cleanup_odb"`;
   }
   if (defined $ENV{R_RENAME_HOME_CONFIG} && $ENV{R_RENAME_HOME_CONFIG} eq "true" && -e "$HOME/config.pro_auto") {
      print "Rename $HOME/config.pro to $HOME/config.pro_auto\n";
      `mv $HOME/config.pro_auto $HOME/config.pro`;
   }
   print "AUTO stopped with ctrl-c at $time_str Total time $total_time\n\n";
   if ($fail_no > 0) {
      exit (1);
   } else {
      exit (0);
   }
}

sub read_a_test {
   my ($find_end) = 0;
   my ($keepscratch) = 0;
   my ($keep) = 0;
   my ($n_line) = 0;
   my ($first_char);

   return if ($num_perf_test > 0 || $num_bitmap_test > 0 
                    || $num_legacy_test > 0);
   @test_list = ();

   if ($dcad_server ne "") {
      if (defined $ENV{DCAD_TEMP}) {
         $diskspace = checkSpace($ENV{DCAD_TEMP});
      } else {
         $diskspace = checkSpace($cur_dir);
      }
      if ($diskspace < 150000 && "$diskspace" != 0) {
         print "DAUTO -reportfailure NO ENOUGH DISK SPACE\n";
         print "diskspace is $diskspace\n";
         print_fail("Quit from auto, NO ENOUGH DISK SPACE\n");
         system ("$dcad_server -reportfalure NO ENOUGH DISK SPACE");
         exit (0);
      }
      if ("$diskspace" == 0) {
         print "WARNING: diskspace is $diskspace\n";
      }
      if (! $copy_keep_files) {
         printf "cat a test\n";
         open (AUTOTXT, "$dcad_server -readtest |");
         @auto_list = <AUTOTXT>;
         close(AUTOTXT);
         foreach $y (@auto_list) {
           print "$y\n";
         }
         $curr_line = 0;
         $dcad_stop = 1 if ($auto_list[$curr_line] eq "");
      }
   }

   if ($auto_list[$curr_line] ne "FINISH\n") {
      while ($auto_list[$curr_line]) {
         $first_char = substr($auto_list[$curr_line], 0, 1);
         if ($first_char ne "!" && $first_char ne ">") {
            my @array = split(/\s+/, $auto_list[$curr_line]);
            $keepscratch = 1 if ($array[0] eq "#k" );
            $keep = 1 if ($array[0] eq "#keep");
            $test_list[$n_line] = $auto_list[$curr_line];
            $test_list[$n_line] =~ s\ +$\\;
            if (defined $ENV{RSD_BAT} ) {
               $test_list[$n_line] =~ s/(\.txt@)/.bac@/;
            }

            if (defined $ENV{R_RUN_PYAUTOGUI_TEST} ) {
               $test_list[$n_line] =~ s/(\.txt@)/.py@/;
            }
			
            $n_line++;
            if ($array[0] eq "END") {
               if ($keepscratch && ! $keep) {
                  $keepscratch = 0;
               } else {
               last;
            }
         }
         } elsif ($first_char eq ">") {
            print_succfail($auto_list[$curr_line]);
         }
         $curr_line++;
      }
   } else {
      $dcad_stop = 1;
   }
   $curr_line++;
}

sub print_bit_env {
   $ver=`cat $auto_ver`;
   $ver =~ tr/A-Z/a-z/;
   $ve = substr($ver,8,7);
   $v = substr($ver,8,4);
   $v =~ s/-// ;
   $bitmapfile = "$cur_dir/bitmap.log";
   print_bitmap("\n\n********************************************************************\n");
   print_bitmap("\n\n              PARAMETER/ENVIRONMENT SUMMARY\n\n");
   print_bitmap("    Parameter 1 -    EXE_PATH:  $local_xtop\n");
   print_bitmap("    Parameter 2 -  TRAIL_PATH:  $trail_path\n");
   print_bitmap("    Parameter 3 -    OBJ_PATH:  $obj_path\n\n\n");
   print_bitmap("    Machine name   -->   $mach_name\n");
   print_bitmap("    Run Directory  -->   $cur_dir\n");
   print_bitmap("    PRO_DIRECTORY  -->   $PRO_DIRECTORY\n");
   print_bitmap("    PROTAB         -->   $PROTAB\n");
   print_bitmap("    Version String -->   $version\n");
   print_bitmap("    P_VERSION      -->   $ENV{P_VERSION}\n");
   print_bitmap("    Graphics type  -->   $ENV{R_GRAPHICS}\n");
   print_bitmap("    LANG           -->   $LANG\n");
   print_bitmap("    PRO_LANG       -->   $PRO_LANG\n") if (defined $ENV{PRO_LANG} );
   print_bitmap("    OPER_SYS       -->   $OPER_SYS\n");
   print_bitmap("    PRO_MACHINE_TYPE --> $PRO_MACHINE_TYPE\n");
   print_bitmap("    PTC_WT_SERVER  -->   $PTC_WT_SERVER\n") if (defined $ENV{PTC_WT_SERVER} );
   print_bitmap("    DISPLAY        -->   $DISPLAY\n");
   print_bitmap("    Screen resolution (hxw) --> $screenheight x $screenwidth\n") if ($screenheight ne "" && $screenwidth ne "");
   print_bitmap("    Run mode       -->   $ENV{R_RUNMODE}\n");
   print_bitmap("    Auto.txt file  -->   $ENV{R_AUTOTXT}\n");
   print_bitmap("    Today's Date   -->   $date $startauto\n");
   print_bitmap("    Alt trail path -->   $ENV{R_ALT_TRAIL_DIR}\n");
   print_bitmap("    R_GETTB_CORE   -->   $ENV{R_GETTB_CORE}\n");
   print_bitmap("    PTC_ADVAPPSLIB -->   $ENV{PTC_ADVAPPSLIB}\n") if (exists $ENV{PTC_ADVAPPSLIB});
   print_bitmap("    MECH_HOME      -->   $ENV{MECH_HOME}\n") if (exists $ENV{MECH_HOME} && $ENV{MECH_HOME} ne " ");
   print_bitmap("    Alt qcr path   -->   $R_ALT_QCR_DIR\n") if ($R_ALT_QCR_DIR);
   print_bitmap("    Checking for extra printf statements\n") if ($R_FIND_PRINTF && $R_GRAPHICS && $R_RUNMODE eq "0");
   print_bitmap("    Checking floating options\n") if ($R_FLOAT_CHECK);
   print_bitmap("    profiling xtop\n") if ($R_GPROF);
   print_bitmap("********************************************************************\n\n\n");
}

sub merge_config {
   my (@array, $key, $value, $find);
   my $merge_file = $_[0];
	
   return if (! -e $merge_file);
   if($directives{rsd_test}){
	   open (CONFIG_PT,"$tmpdir/creo_schematics_config.dat");
   }
   else{
	   open (CONFIG_PT,"$tmpdir/config.pro");
   }
   my (@config_list) = <CONFIG_PT>;
   close(CONFIG_PT);
   chomp (@config_list);
   open (CONFIG_PT,"$merge_file");
   my (@new_config) = <CONFIG_PT>;
   close(CONFIG_PT);
   chomp (@new_config);
   if($directives{rsd_test}){
	   open (CONFIG_PT,">$tmpdir/creo_schematics_config.dat");
   } else {
	   open (CONFIG_PT,">$tmpdir/config.pro");
   }
   if(defined $ENV{R_MERGE_PREFER_ORIG}) {
     my (@temp_config) = @config_list;
     
     @temp_config_comments = grep /^(\!|\357\273\277)/,  @temp_config; # match comment lines with(out) BOM character line
     @temp_config_list = grep !/^(\!|\357\273\277)/, @temp_config;

     @config_list = @temp_config_comments;
     push(@config_list, @new_config); 
     @new_config = @temp_config_list;
   }
   map {s/^(\357\273\277)//} @config_list;
   map {s/^(\357\273\277)//} @new_config;
   foreach $line (@config_list) {
      @array = split(/ +|\t+/, $line);
      $find = 0;
      foreach $l (@new_config) {
    ($key, $value) = split(/ +|\t+/, $l);
    if ($key eq $array[0]) {
       $find = 1;
       last;
    }
      }
      print CONFIG_PT "$line\n" if (! $find);
   }
   print CONFIG_PT "\n";
   foreach $l (@new_config) {
      print CONFIG_PT "$l\n";
   }
   print CONFIG_PT "\n";
   close(CONFIG_PT);
}

sub disable_gmb {
  
   open (CONFIG_PT,">>$tmpdir/config.pro");
   
   print CONFIG_PT "\n";
   print CONFIG_PT "enable_multibody no\n";
   print CONFIG_PT "rt_7124349_cleanup_conf no\n";
   print CONFIG_PT "skip_def_body_geom_list no\n";
   
   close(CONFIG_PT);
}

sub validate_config_for_gmb {
   
   open (CONFIG_PT,"$tmpdir/config.pro");
   my (@config_list) = <CONFIG_PT>;
   close(CONFIG_PT);
   chomp(@config_list);
   
   my @matched = grep /^(enable_multibody|rt_7124349_cleanup_conf|skip_def_body_geom_list)/, @config_list;
   if (scalar(@matched))  {
      foreach $match (@matched) {
	     $gmb_matched .= "," if ($gmb_matched ne "");
	     ($key, $value) = split(/ +|\t+/, $match);
		 $gmb_matched .= $key.":".$value;
	  }
      print_fail("skipped::  #skipped because config.pro have $gmb_matched\n");
      print_skip_msg("skipped::  #skipped $raw_trailname because config.pro have $gmb_matched \n");
      return (1);
   }
   return(0);
}

sub sleep_for_a_while {
  my $path_wait_time = 300;
  if(defined $ENV{R_NW_DRIVE_WAIT_TIME}) {
    $path_wait_time = $ENV{R_NW_DRIVE_WAIT_TIME}
  }
  print_succfail("Waiting for $path_wait_time seconds \n");;

  sleep($path_wait_time);
}

sub wait_for_network_drive {
  my $path_to_wait = $_[0];
  my $delay_run = 0;
  print "Trail path = $path_to_wait \n";
  if (! -e "$path_to_wait") {
     $delay_run = 1;
     print "$path_to_wait not available, when running $raw_trailname. Is it due to missing LUN on iSCSI?  \n";
  }
  else {
     `wc $path_to_wait`;
      $delay_run = $?;
      print "$path_to_wait could not be opened($delay_run), when running $raw_trailname. Is it due to missing LUN on iSCSI?  \n";
  }
  if ($delay_run != 0) {
    sleep_for_a_while();
  }
}

sub parse_and_copy_a_test {
   my ($first_char, $first_trail, $n_line, $i, @file_list, $cur_test);
   my (@array);
   my ($raw_name, $ext);

   $n_line = @test_list;
   $cur_test_num = 0;
   for ($i=0; $i<$n_line; $i++) {
      $first_char = substr($test_list[$i], 0, 1);
      if ($first_char eq "#") {
         $result = set_directive($test_list[$i]);
         if ($result == -1) {
           $result = "FAILURE";
           $fail_no++;
           &fail_skip(0, 0);
           return (0);
         }
      }
      $cur_test_num++ if ($test_list[$i] =~ /^END/ );
   }

   if(defined $ENV{P_VERSION} && $ENV{P_VERSION} >= 310) {
    if ($directives{wildfire_test}) {
        $directives{fresh_creo_agent} = 1;
        $ENV{IS_WILDFIRE_TEST} = "true";
    }
   }

   for ($i=0; $i<$n_line; $i++) {
       if ($test_list[$i] =~ /\.txt@|\.bac@|\.py@/)  {
      @array = split(/@/, $test_list[$i]);
      ($raw_trailname, $ext_name) = split(/\./, $array[0]);
      $result = &pre_directive_process_skip;
      if ($result != 0) {
             if ($directives{mech_test}) {
          $trail_path = $pro_trail_path;
          $obj_path = $pro_obj_path;
             }
             if ($result == 1) {
        $result = "SUCCESS";
        &succ_skip(0);
             } elsif ($result == -1) {
        $result = "FAILURE";
        $fail_no++;
        &fail_skip(0, 0);
             }
             if ($directives{wildfire_test} && ! $all_wildfire) {
               delete $ENV{IS_WILDFIRE_TEST};
             }
             return (0);
      }
      last;
        }
   }

   $bitmap_save = 0 if ($num_bitmap_test == 1);
   $cur_test_num = 0;
   for ($i=0; $i<$n_line; $i++) {
      $first_char = substr($test_list[$i], 0, 1);

      if ((exists $ENV{R_BITMAP} && ($directives{bitmap} || $directives{bitmap_4k}) && $bitmap_save == 1) ||
      (exists $ENV{R_BITMAP_TEXT} && ($directives{bitmap_text}) && $bitmap_text_save == 1)) {
         if ($test_list[$i] =~ /\.txt@|\.bac@/) {
            $test_list[$i];
            @array = split(/@/, $test_list[$i]);
            $array[1] =~ tr/./\//;
            chomp($array[1]);
            if ($directives{interface_retrieval}) {
                ($raw_name, $ext) = split (/\./, $array[0]);
                $ENV{PATH_TO_BITDB} = "test/intf_retr/$raw_name";
            } elsif ($directives{lda_test}) {
                ($raw_name, $ext) = split (/\./, $array[0]);
                $ENV{PATH_TO_BITDB} = "test/lda/$raw_name";
            } elsif ($directives{int_2d_cmp}) {
                ($raw_name, $ext) = split (/\./, $array[0]);
                $ENV{PATH_TO_BITDB} = "test/2dintf_retr_bitmap/$raw_name";
            } elsif ($directives{int_3d_cmp}) {
                ($raw_name, $ext) = split (/\./, $array[0]);
                $ENV{PATH_TO_BITDB} = "test/3dintf_retr_bitmap/$raw_name";                
            } elsif ($directives{int_pdf_cmp}) {
                ($raw_name, $ext) = split (/\./, $array[0]);
                $ENV{PATH_TO_BITDB} = "test/pdf_export_bitmap/$raw_name";
            } else {
                $ENV{PATH_TO_BITDB} = "$array[1]";
            }
         }
      }
      if (exists $ENV{R_BITMAP} && ($directives{bitmap} || $directives{bitmap_4k}) && $bitmap_save != 1) {
         copy_images($test_list[$i]) if ($test_list[$i] =~ /\.txt@|\.bac@/);
      }
      if (exists $ENV{R_BITMAP_TEXT} && $directives{bitmap_text}  && $bitmap_text_save != 1) {
         copy_images_text($test_list[$i]) if ($test_list[$i] =~ /\.txt@|\.bac@/);
      }

      $first_string = "$test_list[$i]";
      chomp($first_string);
      if (($first_char eq "*") && ("${first_string}" =~ /^\*\.\*\@/m)) {
         $retr_obj_save = $retr_obj;
         $retr_obj = $retr_obj_hash{$cur_test_num} if ($retr_obj_hash{$cur_test_num} ne "");
         $msg = copy_objects($test_list[$i]);
         $retr_obj = $retr_obj_save;
     if ("$msg" ne "") {
        print_fail("skipped::  #skipped $raw_trailname because improper integration $msg");
        print_skip_msg("skipped::  #skipped $raw_trailname because improper integration $msg\n");
        $skip_msg = "skipped:  #skipped $raw_trailname because improper integration $msg";
        if ($directives{rsd_test}) {
         wait_for_network_drive("$trail_path/auto.txt");
        } else {
           wait_for_network_drive("$trail_path/test/auto.txt"); 
        }
        $offset = 1;
        while ($test_list[$i-$offset] !~ /\.txt@|\.bac@|\.py@/) {
          $offset++;
        }
        &fail_skip($i-$offset, 0);
        return (0);
     }
      }
    
      $cur_test_num++ if ($test_list[$i] =~ /^END/ );
   }
   $first_trail = 1;
   $cur_test_num = 0;
   for ($i=0; $i<$n_line; $i++) {
      $first_char = substr($test_list[$i], 0, 1);
      if ($test_list[$i] =~ /\.txt@|\.bac@|\.py@/) {
         $cur_test = $test_list[$i];
         if ($directives{tk_flavor}) {
           $cur_test =~ s/(_|\+)$tk_flavor_\.txt/.txt/;
           $tk_flavor_extension = $1;
           print "stripped flavor ext: $tk_flavor_extension\n";
         }
         chop($cur_test);
         $cur_test =~ s\ +$\\;
         if ($directives{anim_test} || $directives{mdx_test}) {
            $result = pre_directive_process($first_trail);
            if ($result != 0) {
               if ($directives{mech_test}) {
                  $trail_path = $pro_trail_path;
                  $obj_path = $pro_obj_path;
               }
               if ($result == 1) {
                  $result = "SUCCESS";
                  &succ_skip($i);
               } elsif ($result == -1) {
                  $result = "FAILURE";
                  $fail_no++;
                  &fail_skip($i, 0);
               } elsif ($result == -2) {
                  &notexists_skip($i);
               }
               return (0);
            }
         }
         if ($directives{pd_demo_test}) {
            copy_pd_demo_trail($cur_test, $first_trail);
         } elsif ($directives{demo_test}) {
            copy_demo_trail($cur_test, $first_trail);
         } elsif ($directives{mech_test}) {
            @array = split(/@/, $cur_test);
            @path_array = split(/\./, $array[1]);
            $mech_test_type = $path_array[1] if ($mech_test_type eq "");
            $array[1] =~ tr/./\//;
            ($raw_trailname, $ext_name) = split(/\./, $array[0]);

            $result = pre_directive_process($first_trail);
            if ($result != 0) {
               $trail_path = $pro_trail_path;
               $obj_path = $pro_obj_path;
               if ($result == 1) {
                  $result = "SUCCESS";
                  &succ_skip($i);
               } elsif ($result == -1) {
                  $result = "FAILURE";
                  $fail_no++;
                  &fail_skip($i, 0);
               } elsif ($result == -2) {
                  &notexists_skip($i);
               }
               return (0);
            }

            if (! -e "$trail_path/$array[1]") {
               $trail_path = "$MECH_HOME/..";
            }
            if ($PRO_MACHINE_TYPE eq "i486_win95") {
               `$csh_cmd "z:/tools/bin/run_and_get_status $PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $cur_dir/copy_mech.pl $trail_path $mech_test_type $raw_trailname $array[1] $obj_path"`;
               $rc = `cat $TEMP/status.log`;
            } else {
                   $rc=system("$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $cur_dir/copy_mech.pl $trail_path $mech_test_type $raw_trailname $array[1] $obj_path");
            }
            if ($rc)  {
               $result = "FAILURE";
               print_fail("skipped::  #skipped because copy failed\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because copy failed\n");
               &fail_skip($i, 0);
               $fail_no++;
               $trail_path = $pro_trail_path;
               $obj_path = $pro_obj_path;
               return (0);
            }
         } elsif ($directives{rec_copy} && ! ($directives{retr_test} || $directives{gcri_retr_test}
            || $directives{interface_retrieval} || $directives{lda_test} || $directives{int_2d_cmp} || $directives{int_3d_cmp} || $directives{int_pdf_cmp})) {
             if ($directives{wip_test}) {
                      $cur_test_orig = $cur_test;
                      if ($rt_integrity_id ne "") {
						$cur_test_orig =~ s/_wip(_)*([0-9])*\.txt@/.txt@/; 
					 } else {
						$cur_test_orig =~ s/(_wip.txt@)/.txt@/;
					 }
					  $cur_test_orig =~ s/(_wip_*([0-9])*)$//;
                      rec_copy_trail($cur_test_orig, $first_trail, $add_config_option);       
                }
            rec_copy_trail($cur_test, $first_trail, $add_config_option);
         } elsif (! ($directives{prokernel_test} || $directives{prokernel_retr})) {
            # check if it is externalized ARTS test which is located MASTERPACK
            # the foolowing condition is true only if it is ARTS test 
            if (defined($windchill_solution) && defined($arts_test_runmode) && ($arts_test_runmode ne "0")) {
              setRadarHomeEnv ($origRadarHomeEnv);
              $msg = copyARTSTest($cur_test, $first_trail);
              # For Hybrid tests RADAR_HOME is set to the current scratch folder
              setRadarHomeEnv ($tmpdir);
            } else {
                $retr_obj_save = $retr_obj;
                $retr_obj = $retr_obj_hash{$cur_test_num} if ($retr_obj_hash{$cur_test_num} ne "");
                if ($directives{wip_test}) {
                      $cur_test_orig = $cur_test;
                      if ($rt_integrity_id ne "") {
						$cur_test_orig =~ s/_wip(_)*([0-9])*\.txt@/.txt@/; 
					 } else {
						$cur_test_orig =~ s/(_wip.txt@)/.txt@/;
					 }
					  $cur_test_orig =~ s/(_wip_*([0-9])*)$//;
                    $msg = copy_trail($cur_test_orig, $first_trail, $add_config_option);         
                }
                $msg = copy_trail($cur_test, $first_trail, $add_config_option);
                $retr_obj = $retr_obj_save;
            }
            print_fail($msg) if ("$msg" ne "");
         }
         if (($directives{bitmap} || $directives{bitmap_4k}) && exists $ENV{R_BITMAP}) {
		    apply_setenv();
            parse_txt_for_bitmap($cur_test);
         }
         if ($directives{bitmap_text} && exists $ENV{R_BITMAP_TEXT} && ! exists $ENV{R_BITMAP}) {
            parse_txt_for_bitmap_text($cur_test);
         }
         if ($directives{gmb_wip} && (not defined $ENV{R_REPORT_GMB_WIP}) && validate_config_for_gmb()) {
            $result = "FAILURE";
	        $fail_no++;
            fail_skip($i, 0);
            return (0);
         }
         $first_trail = 0;
      }
      $cur_test_num++ if ($test_list[$i] =~ /^END/ );
   }
   if ($directives{batch_trail_test}) {
      $first_trail = 1;
      for ($i=0; $i<$n_line; $i++) {
         if ($test_list[$i] =~ /\.txt@|\.bac@|\.py@/) {
            @array = split(/@/, $test_list[$i]);
            if ( $first_trail) {
               my ($this_name, $ext) = split(/\./, $array[0]);
               open(BATFILE, ">$tmpdir/$this_name\.bat");
               $first_trail = 0;
            }
            print BATFILE "$array[0]\n";
         }
      }
      close(BATFILE);
   }
   if (-e $R_CONFIG_FILE) {
      `cat $R_CONFIG_FILE >> "$tmpdir/config.pro"`;
   }

   disable_gmb() if ($directives{gmb_wip} && (not defined $ENV{R_REPORT_GMB_WIP}));
   merge_config($ENV{R_MERGE_CONFIG}) if (defined $ENV{R_MERGE_CONFIG});
   `cp "$rundir/keep_files"/* .` if ($copy_keep_files);

   opendir(TMPDIR, "$tmpdir");
   @retrieved_file_list = grep {!/^\./} readdir(TMPDIR);
   chmod(0777, @retrieved_file_list);
   chomp(@retrieved_file_list);
   closedir(TMPDIR);
   if ($PRO_MACHINE_TYPE eq "nec_mips") {
      `chmod +w *.*`;
   }
   if (! $ENV{R_EXIT_ON_CORE} && ! exists $ENV{R_SAVE_ALL_CORE}
        && ! $ENV{R_GETTB_CORE} ) {
      `touch core`;
      chmod(0000, "core");
      `touch core.xtop`;
      chmod(0000, "core.xtop");
   }
   $num_perf_test-- if ($directives{perf_test});
   if (defined $ENV{R_BITMAP_LOCAL_IMAGE}) {
      $num_bitmap_test--;
      if ($num_bitmap_test == 0) {
         $cur_test_num = 0;
         update_backward_trail_set;
         update_directive_hold;
      }
   }
   if ($directives{legacy_encoding_test}) {
      $num_legacy_test--;
      if ($num_legacy_test == 0) {
     $ENV{R_PDEV_REGRES_LEGACY} = true;
      }
   }
   return (1);
}

sub printEnvTable {
  foreach $key (sort keys(%ENV)) {
    printf("%-30.30s: $ENV{$key}\n", $key);
  }
  return;
}

sub getRadarHomeEnv {
  return $ENV{"RADAR_HOME"};
}

sub setRadarHomeEnv {
  my $newRadarHome = shift;
  if (defined $newRadarHome) {
    $ENV{"RADAR_HOME"} = $newRadarHome;
  } else {
    delete $ENV{"RADAR_HOME"};
  }
  return;
}

sub test_updtfile {
   my($infile) = $_[0];
   my $testname;
   my $images;
   open(UP,"<$infile");
   @tests = <UP>;
   close(UP);
   $cntl = @tests;
   print "\n checking if $infile file is ok !\n";
   foreach $line (@tests) {
      chomp($line);
      @tn = split(/ /,$line);
      $testname = $tn[0];
      $images = $tn[1];
      print "\t\nchecking ....\n\n";
      if ($images eq ""){
         $pass = 0 ;
         print "\tsome problem with $testname\n";
         print "\tshould be of the form rad_pat_axis rad_axis_2.img\n";
         print "\tor\n";
         print "\tshould be of the form rad_pat_axis rad_axis_1.img,rad_axis_2.img\n";
         last;
      }
      print "$testname is ok !\n";
      $pass = 1;
   }
   return ($pass) ;
}

sub test_updtfilehash {
   my($infile) = $_[0];
   my $testname;
   my $images;
   open(UP,"<$infile");
   @tests = <UP>;
   close(UP);
   foreach $line (@tests) {
      chomp($line);
      @tn = split(/ /,$line);
      $testname = $tn[0];
      $images = $tn[1];
#     print "inside hashbuilding - $testname --> $images\n";
      $testhash{$testname} = $images;
      $pass = 1 ;
   }
   return (\%testhash);
}

sub parse_txt_for_bitmap {
   my ($line) = @_;
   my (@array) = split(/@/, $line);
   $array[1] =~ tr/./\//;
   $this_test = $array[0];
   chomp($this_test);
   my ($outfile) = "$this_test.$$";
   my ($tol) = $ENV{R_IMAGE_TOL};
   
   if (exists $ENV{R_BITMAP_RMS} && $ENV{R_BITMAP_RMS} eq "true")   {
      if ($ENV{R_IMAGE_TOL_RMS} ne "") {
          $tol = $ENV{R_IMAGE_TOL_RMS};
      } else {
          $tol = "";
      }
   }

   $ver=`cat $auto_ver`;
   chomp($ver);
   @par = split(/ /,$ver);
   $ver1 = $par[1];
   $ver1 =~ tr/A-Z/a-z/;
   $ve = substr($ver1,0,4);
   $ve =~ s/-//;
   open (IN,"<$this_test");
   open (OUT,">:raw","$outfile");
   while (<IN>) {
      if ($_ =~ /^\!#.*\.[iI][mM][gG]/ ) {
         print OUT ("~ Command `ProCmdUtilDebug` \n");
         print OUT ("#BITMAP\n");
         print OUT ("#REPAINT\n");
		 
		 if ($bitmap_save != 1 && exists $ENV{R_BITMAP_RMS} && $ENV{R_BITMAP_RMS} eq "true") {
		    print OUT ("#RMS COMPARE\n");
		 } elsif ($bitmap_save != 1) {
		    print OUT ("#LOAD/COMPARE\n");
		 }
		 
         print OUT ("#SAVE BITMAP\n") if ($bitmap_save == 1);
         $_ =~ /!#(.*).[iI][mM][gG]\b/ ;
         print OUT ("$1.img\n") if ($bitmap_save != 1);
         print OUT ("$1\n") if ($bitmap_save == 1);
         
		 if ($tol == "") {
			if ($bitmap_save != 1 && exists $ENV{R_BITMAP_RMS} && $ENV{R_BITMAP_RMS} eq "true" ) {
			   print OUT ("2\n");
			 } elsif ($bitmap_save != 1) {
			   print OUT ("15\n");
			 }
		 } else {
		    print OUT ("$tol\n") if ($bitmap_save != 1);
		 }
		 
         print OUT ("~ Command `ProCmdViewRepaint`\n");
         #print OUT ("~ Activate `main_dlg_cur` `resizer_button_2` \\ \n") if ($ve eq "j03") ;
         #print OUT ("0\n") if ($ve eq "j03");
      } elsif ($_ =~ /^\!#.*\.[pP][nN][gG]/ ) {
         print OUT ("~ Command `ProCmdUtilDebug` \n");
         print OUT ("#BITMAP\n");
         print OUT ("#COMPARE PNG\n");
         print OUT ("#SAVE DIFF\n");
         print OUT ("#REPAINT\n");
         
		 if ($bitmap_save != 1 && exists $ENV{R_BITMAP_RMS} && $ENV{R_BITMAP_RMS} eq "true") {
		    print OUT ("#RMS COMPARE\n");
		 } elsif ($bitmap_save != 1) {
		    print OUT ("#LOAD/COMPARE\n");
		 }
		 
         print OUT ("#SAVE BITMAP\n") if ($bitmap_save == 1);
         $_ =~ /!#(.*).[pP][nN][gG]\b/ ;
         print OUT ("$1.png\n") if ($bitmap_save != 1);
         print OUT ("$1\n") if ($bitmap_save == 1);
		 if ($tol == "") {
			if ($bitmap_save != 1 && exists $ENV{R_BITMAP_RMS} && $ENV{R_BITMAP_RMS} eq "true" ) {
			   print OUT ("2\n");
			 } elsif ($bitmap_save != 1) {
			   print OUT ("15\n");
			 }
		 } else {
		    print OUT ("$tol\n") if ($bitmap_save != 1);
		 }
         print OUT ("~ Command `ProCmdViewRepaint`\n");
      }
      print OUT ("$_");
   }
   close(IN);
   close(OUT);
   copy($outfile, $this_test);
   if ($OS_TYPE ne "NT"){
      $this_tmp = "/tmp/$this_test.$$";
   }else{
      $this_tmp = $TEMP;
   }
   `$rm_cmd -f "$outfile"` if (-e "$outfile");
}

sub parse_txt_for_bitmap_text {
   my ($line) = @_;
   my (@array) = split(/@/, $line);
   $array[1] =~ tr/./\//;
   $this_test = $array[0];
   chomp($this_test);
   my ($outfile) = "$this_test.$$";
   open (IN,"<$this_test");
   open (OUT,">:raw",$outfile);
   while (<IN>) {
      if ($_ =~ /^\!#.*\.[iIpP][mMnN][gG]/ ) {
         print OUT ("~ Command `ProCmdUtilDebug` \n");
         print OUT ("#GRAPHICS DEBUG\n");
		 
		 
         print OUT ("#CURRENT WINDOW\n") if ($bitmap_text_save == 1);
         print OUT ("#COMPARE WINDOW\n") if ($bitmap_text_save != 1);
         $_ =~ /!#(.*).[iIpP][mMnN][gG]\b/ ;
         print OUT ("$1\n");
         
		 
      } 
      print OUT ("$_");
   }
   close(IN);
   close(OUT);
   copy($outfile, $this_test);
   if ($OS_TYPE ne "NT"){
      $this_tmp = "/tmp/$this_test.$$";
   }else{
      $this_tmp = $TEMP;
   }
   `$rm_cmd -f "$outfile"` if (-e "$outfile");
}

sub copy_images {
   my ($line) = shift;
   my ($raw_name, $ext);
   print "$line\n";
   chop ($line);
   $ver=`cat $auto_ver`;
   $ver =~ tr/A-Z/a-z/;
   $ve = substr($ver,8,4);
   $ve =~ s/-//;
   $line =~ s\ +$\\;
   my (@array) = split(/@/, $line);
   $array[1] =~ tr/./\//;
    my $tk_flavor_b = '_gpu' if ($tk_flavor_ eq 'gpu');
    my $bitmap_type = 'bitmap';
    if ($ENV{GRAPHICSCONFIG} =~ m/VULKAN/i) {
       $bitmap_type = 'bitmap_vulkan';
       $bitmap_type = 'bitmap' if (defined $ENV{VULKAN_USE_OPENGL_IMAGES});
    }
   if ($directives{interface_retrieval}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_path = "$bitdb_path/test/intf_retr/$raw_name/${bitmap_type}/$mach_type${tk_flavor_b}";
   } elsif ($directives{lda_test}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_path = "$bitdb_path/test/lda/$raw_name/${bitmap_type}/$mach_type${tk_flavor_b}";
   } elsif ($directives{int_2d_cmp}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_path = "$bitdb_path/test/2dintf_retr_bitmap/$raw_name/bitmap/$mach_type";
   } elsif ($directives{int_3d_cmp}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_path = "$bitdb_path/test/3dintf_retr_bitmap/$raw_name/bitmap/$mach_type";       
   } elsif ($directives{int_pdf_cmp}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_path = "$bitdb_path/test/pdf_export_bitmap/$raw_name/bitmap/$mach_type";
   } else {
       $img_path = "$bitdb_path/$array[1]/${bitmap_type}/$mach_type${tk_flavor_b}" ;
   }
   
   $primary_img_path  ="";
   if ($directives{wip_test} && ( ($array[1] =~ /(_wip_$rt_integrity_id)$/) || $array[1] =~ /(_wip)$/)) {
      my $primary_img_dir = $array[1];
      $primary_img_dir =~ s/_wip$//;
      $primary_img_dir =~ s/_wip_$rt_integrity_id$//;
      $primary_img_path ="$bitdb_path/$primary_img_dir/${bitmap_type}/$mach_type${tk_flavor_b}";
   }

   if ($directives{wip_test}) {
      if (-d "$primary_img_path") {
         print "Copying images of $primary_img_path\n";
         while (! chdir ("$primary_img_path")) {}
         `$cp_cmd * "$tmpdir"`;
         while (! chdir_safe ("$tmpdir")) {}
      }
   }
   
   if (-d "$img_path") {
      print "Copying images of $img_path\n";
      while (! chdir ("$img_path")) {}
      `$cp_cmd * "$tmpdir"`;
      while (! chdir_safe ("$tmpdir")) {}
   }

   if ($directives{wip_test}) {
       if ((! -d "$img_path") && (! -d "$primary_img_path")) {
         print_fail("Both $img_path and $primary_img_path DOES NOT EXIST for WIP test\n");                 
       }   
   } else {
       if (! -d "$img_path") {
         print_fail("$img_path DOES NOT EXIST\n");  
       }
   }

   opendir(GZIMG,"$tmpdir") ;
   while ($gzname = readdir(GZIMG)) {
      if ($gzname =~ /img.gz/){
         chdir_safe("$tmpdir");
         $bc = system("gunzip -f $gzname");
      }
   }
   closedir(GZIMG);
}

sub copy_images_text {
   my ($line) = shift;
   my ($raw_name, $ext);
   print "$line\n";
   chomp ($line);
   $ver=`cat $auto_ver`;
   $ver =~ tr/A-Z/a-z/;
   $ve = substr($ver,8,4);
   $ve =~ s/-//;
   $line =~ s\ +$\\;
   my (@array) = split(/@/, $line);
   $array[1] =~ tr/./\//;
   my $tk_flavor_b = '_gpu' if ($tk_flavor_ eq 'gpu');
   if ($directives{interface_retrieval}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_text_path = "$bitdb_path/test/intf_retr/$raw_name/bitmap_text${tk_flavor_b}";
   } elsif ($directives{lda_test}) {
       ($raw_name, $ext) = split (/\./, $array[0]);
       $img_text_path = "$bitdb_path/test/lda/$raw_name/bitmap_text${tk_flavor_b}";
   } else {
       $img_text_path = "$bitdb_path/$array[1]/bitmap_text${tk_flavor_b}" ;
   }
   if ( -d "$img_text_path" ) {
      print "Copying images text of $img_path\n";
      while (! chdir ("$img_text_path")) {}
      `$cp_cmd * "$tmpdir"`;
      while (! chdir_safe ("$tmpdir")) {}
   } else {
      print_fail("$img_text_path DOES NOT EXIST\n");
   }
}

sub copy_specific_image {
   my($test_nm) = $_[0];
   my($stripped_name) = $_[1];
   my($img_path) = $_[2];
   my $inar = 0 ;
   my @array = split(/\//,$test_nm);
   @array = reverse(@array);
   my $test = $array[0];
   my $testhashref = test_updtfilehash($image_file);
   $imagestr = $$testhashref{$test};
   @imagelist = split(/,/,$imagestr);
   foreach $nm (@imagelist){
      chomp($nm);
      if($stripped_name =~ /$nm/){
         $inar = 1;
         last;
      }
   }

   if($inar){
      copy("$tmpdir/$stripped_name.gz", "$img_path/$stripped_name.gz") ;
   }
}

sub copy_images_to_bitDB {
   my ($line) = shift;
   my $format;
   chomp ($line);
   $ver=`cat $auto_ver`;
   chomp($ver);
   @par = split(/ /,$ver);
   $ver1 = $par[1];
   $ver1 =~ tr/A-Z/a-z/;
   $ve = substr($ver1,0,4);
   $ve =~ s/-//;
   my $tk_flavor_b = '_gpu' if ($tk_flavor_ eq 'gpu');
   my $bitmap_type = 'bitmap';
   if ($ENV{GRAPHICSCONFIG} =~ m/VULKAN/i) {
       $bitmap_type = 'bitmap_vulkan'; 
   }
   $img_path = "$bitdb_path/$line/${bitmap_type}/$mach_type${tk_flavor_b}" ;
   if(! -d $img_path){
      mkpath($img_path,0777) ;
   }
   opendir(IMG,"$tmpdir") ;

   while ($name = readdir(IMG)) {
      if ($name =~ /(img|png).1/ || $name =~ /^.*\.png/) {
         chomp($name);
         print"\nname is $name\n";
         $name =~ /(.*).(img|png)(.*)/ ;
         $format=$2;
         $stripped_name = $1 . ".img"  if ($format eq "img");
         $stripped_name = $1 . ".png"  if ($format eq "png");
         print"\nstripped name is $stripped_name\n";
         move("$name", "$stripped_name")  if ($format eq "img");
         $rc = system("gzip -f $stripped_name") if ($format eq "img");
         if($rc == 0 && $format eq "img"){
            stat($img_path);
            if($bit_specific){
               copy_specific_image("$line","$stripped_name", "$img_path");
            }elsif(!$bit_specific){
               copy("$stripped_name.gz", "$img_path/$stripped_name.gz");
            }
            else{
               print"\n\nnot copied !!!images \n";
            }
         }
         if($format eq "png") {
            copy("$stripped_name","$img_path/$stripped_name");
         }
      }
   }
   
   closedir(IMG);
}

sub copy_images_text_to_bitDB {
   my ($line) = shift;
   my $format;
   chomp ($line);
    my $tk_flavor_b = '_gpu' if ($tk_flavor_ eq 'gpu');
   $img_text_path = "$bitdb_path/$line/bitmap_text${tk_flavor_b}" ;
   if(! -d $img_text_path){
      mkpath($img_text_path,0777) ;
   }
   opendir(IMG,"$tmpdir") ;

   while ($name = readdir(IMG)) {
      if ($name =~ /^.*_png\.dat/) {
         chomp($name);
         print"\nname is $name\n";
         $name =~ /(.*).(dat)(.*)/ ;
         $format=$2;
         $stripped_name = $1 . ".dat"  if ($format eq "dat");
         $destination_name = $1 . ".qcr"  if ($format eq "dat");
         print"\nstripped name is $stripped_name.\n destination name is $destination_name.\n";
         if($format eq "dat") {
            copy("$stripped_name","$img_text_path/$destination_name");
         }
      }
   }
   
   closedir(IMG);
}

sub copy_misc {
   opendir(RUNDIR, "$rundir");
   my (@files) = readdir(RUNDIR);
   closedir(RUNDIR);
   `$rm_cmd -rf "$rundir/auto_misc"` if (-e "$rundir/auto_misc");
   foreach $file (@files) {
      if (! exclude_file($file)) {
         mkdir ("$rundir/auto_misc",0777) if (! -e "$rundir/auto_misc");
         print "cp $file $rundir/auto_misc\n";
         `cp $file "$rundir/auto_misc"`;
      }
   }
}

sub exclude_file {
   my ($file) = shift;
   return (1) if ($file eq "." || $file eq "..");
   if ($file =~ /\.h$|\.aux$|\.xsl$|\.html$|\.js$|\.bif$|\.res$|\.crc$|\.dat$|\.txt$|\.add$|\.ndx$|\.cmp$|\.mnu$|\.dtl$|\.rbn$|_db\.chg$|\.png$|\.sdf$/) {
      return (1) if ($file =~ /auto/ && $file =~ /\.txt$/ || $file eq "msgerror.txt" || $file =~ /dbgfile\.dat/);
      return (0);
   }
   return (1);
}

sub succ_skip {
   my ($n) = @_;
   my ($n_line, @array, $i);
   $n_line = @test_list;

   &reset_envs;
   $result = "SUCCESS";
   print_succ("\nSkip following tests\n");
   print_skip_msg("\nSkip following tests\n");
   for ($i=$n; $i < $n_line; $i++) {
      if ($test_list[$i] =~ /\.txt@|\.bac@|\.py@/) {
         @array = split(/@/, $test_list[$i]);
         $array[1] =~ tr/./\//;
         chop($array[1]);
         $trailfile = "$trail_path/$array[1]/$array[0]";
         if ($directives{batch_trail_test}) {
            print_succ("skipped::  #skipped because the test run with batch trail\n");
            print_skip_msg("skipped::  #skipped because the test run with batch trail\n");
         }
         print_succ("skipped#$trailfile\n");
         print_succ("$result\n");
         print_skip_msg("$trailfile\n");
         print_skip_msg("$result\n");
         if (exists $ENV{R_PERF_SKIP_COPIER}) {
        print_skip_msg("note: R_PERF_SKIP_COPIER is set, running $R_PERF_SKIP_COPIER\n");
            `$csh_cmd "$R_PERF_SKIP_COPIER $array[0]"`;
         }

         if ($dcad_server ne "") {
            if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
               $check_stat = 0;
               $check_stat = basic_check_for_dauto_run();
               if ($check_stat) {
                 print "DAUTO -reportsuccess SKIPPED - not reporting SUCCESS for $raw_trailname\n";
                 print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
                 exit($check_stat);   
               }
            }     
            print "DAUTO -reportsuccess SKIPPED\n";
            system ("$dcad_server -reportsuccess SKIPPED");
         }
         $test_num++;
#         return if ($cur_test_num != 0 && 
#     ($directives{run_only_on_test} || $directives{not_run_on_test}));
      }
   }
   $num_perf_test = 0;
   $num_bitmap_test = 0;
   $num_legacy_test = 0;
   $skip_tests = 1;
   if ($directives{keep}) {
      $succ_skip_keep_test = 1;
      $copy_keep_files = 1;
   }
#   $test_num--;
}

sub fail_skip {
   my ($n, $associa) = @_;
   my ($n_line, @array, $i, $print_skip, $raw_trailname, $ext_name);
   $n_line = @test_list;

   $print_skip = 1;
   $result = "FAILURE";
   for ($i=$n; $i < $n_line; $i++) {
      if ($test_list[$i] =~ /\.txt@|\.bac@|\.htm@|\.py@/) {
      if ($print_skip) {
         print_fail("\nSkip following tests\n");
         print_skip_msg("\nSkip following tests\n");
         $print_skip = 0;
      }
      $test_num++;
      @array = split(/@/, $test_list[$i]);
      $array[1] =~ tr/./\//;
      chop($array[1]);
      $trailfile = "$trail_path/$array[1]/$array[0]";
      if ($directives{batch_trail_test}) {
         print_fail("skipped::  #skipped because the test run with batch trail\n");
         print_skip_msg("skipped::  #skipped because the test run with batch trail\n");
      }
      print_fail("skipped#$trailfile\n");
          print_fail("$result\n");
      if ($associa) {
         print_skip_msg("skipped#$trailfile because associated test failed\n");
      } else {
         print_skip_msg("skipped#$trailfile\n");
      }
      print_skip_msg("$result\n");
      chop($array[0]);
      ($raw_trailname, $ext_name) = split(/\./, $array[0]);
      $raw_trail_output_name = "${raw_trailname}${tk_flavor_extension}${tk_flavor_}";
      print_fail("skipped::  #skipped ${raw_trail_output_name}\n");
      print_skip_msg("skipped::  #skipped ${raw_trail_output_name}\n");
	  
	  $prefix_host_name = `hostname`;	
      chomp($prefix_host_name);
	  if ($skip_msg ne "") {
         print "RESULT:  FAIL + SKIP\n";
         print ("${raw_trail_output_name} skipped $skip_msg");
         $message = "$prefix_host_name,${raw_trail_output_name} skipped \n $skip_msg ";
         create_message_file("$message");
         save_extra_logs();
         if (exists $ENV{R_KEEP_FAILURE_DATA} && $ENV{R_KEEP_FAILURE_DATA} eq 'true') {
            if ($dcad_server eq "") { # for non-dauto runs
               `$rm_cmd -rf "$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}"` if (-e "$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}");
               `$rm_cmd -rf "$rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}"` if (-e "$rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}");
            }
            $ctmpdir =  `cygpath -m $tmpdir`;
            chomp($ctmpdir);
            mkpath ("$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}", 0777);
            `$cp_cmd $ctmpdir/* $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}`;
            if ($directives{wildfire_test}) {
               `$cp_cmd $rundir/WF_ROOT_DIR $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR`;
               chmod(0777, "$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR");
              `$rm_cmd -f $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR/.cache/0-IMMITATION/*/*/*/*.UGC`;
              `$rm_cmd -rf $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR/.cache/0-IMMITATION/*/DB`;
              if (defined $windchill_url) {
                 push @dirsToCopyServerLogs, "$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}";
              }
            }
         }
         $message = "";
	  }
		 
      if ($dcad_server ne "") {
         if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
               $check_stat = 0;
               $check_stat = basic_check_for_dauto_run();
               if ($check_stat) {
                 print "DAUTO -reportfailure SKIPPED - not reporting FAILURE for $raw_trail_output_name\n";
                 print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
                 exit($check_stat);   
               }
         }

        if ($skip_msg ne "") {
            print "DAUTO -reportfailure\n";
            system ("$dcad_server -reportfalure");     
		} else {
         print "DAUTO -reportfailure SKIPPED\n";
         system ("$dcad_server -reportfalure SKIPPED");
		}
      }
      $associa = 1;
      if ($skip_msg ne "") {
         $trail_name = $raw_trailname.'.txt';
         post_run_process($trail_name,$raw_trail_output_name);
         $skip_msg = "";
      }
      }     
   }
   
   &reset_envs;
   
   if ($directives{intralink_interaction}) {
      `$csh_cmd "${TOOLDIR}kill_xmx256m"`;
      $ENV{PTC_WF_ROOT} = $PTC_WF_ROOT_save;
   }
   if (defined $ENV{R_PDEV_REGRES_LEGACY}) {
      delete $ENV{R_PDEV_REGRES_LEGACY};
   }

   if ($directives{keep}) {
        $copy_keep_files = 1;
   } else {
        $copy_keep_files = 0;
   }

   $skip_tests = 1;
   $num_perf_test = 0;
   $num_legacy_test = 0;
   $num_bitmap_test = 0;
}

sub notexists_skip {
   my ($n) = @_;
   my ($n_line, @array, $i, $print_skip, $raw_trailname, $ext_name);
   $n_line = @test_list;

   &reset_envs;
   $print_skip = 1;
   for ($i=$n; $i < $n_line; $i++) {
      if ($test_list[$i] =~ /\.txt|\.htm/) {
         if ($print_skip) {
            print_notexists("\nSkip following tests\n");
            $print_skip = 0;
         }
         $test_num++;
         @array = split(/@/, $test_list[$i]);
         $array[1] =~ tr/./\//;
         chop($array[1]);
         $trailfile = "$trail_path/$array[1]/$array[0]";
         print_notexists("skipped#$trailfile\n");
         chop($array[0]);
         ($raw_trailname, $ext_name) = split(/\./, $array[0]);
         print_notexists("skipped::  #skipped $raw_trailname\n");

         if ($dcad_server ne "") {
            if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
               $check_stat = 0;
               $check_stat = basic_check_for_dauto_run();
               if ($check_stat) {
                  print "DAUTO -reportfailure TRAIL NOT FOUND - not reporting FAILURE for $raw_trailname\n";
                  print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
                  exit($check_stat);   
               }
            }
            print "DAUTO -reportfailure TRAIL NOT FOUND\n";
            system ("$dcad_server -reportfalure TRAIL NOT FOUND");
         }
      }
   }
   $skip_tests = 1;
}

sub missing_qcrs {
    my ($trail) = $_[0];
    my $miss_qcr = 0;
    my ($raw_name, $ext, @array);

    open (TRAIL, "$trail");
    my @lines = <TRAIL>;
    close(TRAIL);

    foreach $line (@lines) {
       if ("$line" =~ /\.qcr/ && "$line" !~ /^!/ && "$line" !~ / /) {
      chomp ($line);
      ($raw_name, $ext) = split(/\./, $line);
      @array=split(/\//, $line);
      @array = reverse(@array);
      if (! -e "$array[0]" && "$raw_name" !~ /_\${OS_TYPE}$/) {
         print_fail("The file $array[0] is missing\n");
         $miss_qcr = 1;
      }
       }
    }
    return $miss_qcr;
}

sub run_a_test {
   my ($n_line, @array, $i, $first_trail);
   $n_line = @test_list;
   #chomp(@test_list);

#   if ($directives{num_cmd}) {
#      if (run_commands()) {
#         $result = "FAILURE";
#         &fail_skip(0);
#         return (0);
#      }
#   }

   $first_trail = 1;
   $skip_qcr = 0;
   $cur_test_num = 0;
   $cur_test_keepscratch = 0;
   $cur_test_agent_setup_done = 0;
   @dirsToCopyServerLogs = ();

   for ($i=0; $i < $n_line; $i++) {
      my @tmparray = split(/\s+/, $test_list[$i]);
      $cur_test_keepscratch = 1 if ($tmparray[0] eq "#k");
	
      if ($test_list[$i] =~ /\.txt@|\.bac@|\.py@/) {
         if ($directives{tk_flavor}) {
           $test_list[$i] =~ s/(_|\+)$tk_flavor_\.txt/.txt/;
           $tk_flavor_extension = $1;
           if ($directives{rsd_test}) {
              chomp($test_list[$i]);
              $test_list[$i] =~ s/(_|\+)$tk_flavor_\.bac/.bac/;
             $tk_flavor_extension = $1;
           }
           print "\nstripped flavor: $tk_flavor_\n";
           print "stripped flavor ext: $tk_flavor_extension\n";
           
           if ($tk_flavor_extension eq "") {
              $result = "FAILURE";
              $fail_no++;
              $skip_msg = "because tk_flavor is $tk_flavor_ but trailname format in auto.txt is not ${raw_trailname}_${tk_flavor_} \n\n i.e. trailname_<tk_flavor>";
              if ($ENV{R_WNC_RELEASE} ne "") {
              $skip_msg = "because wnc_flavor is $tk_flavor_ but trailname format in auto.txt is not ${raw_trailname}_${tk_flavor_} \n\n i.e. trailname_<wnc_flavor>\n\n";
              }
              fail_skip($i);
              $skip_msg = "";
              if ($directives{keep}) {
                $copy_keep_files = 1;
              } else {
                $copy_keep_files = 0;
              }
             return (0);              
           }
         }
         
         if ($did_cef_mismatch) {
              $result = "FAILURE";
              $fail_no++;
              $skip_msg = "because CEF_VERSION $ENV{'CEF_VERSION'} not matching LIBCEF_DLL_VERSION $libcefshort\n";
              $skip_msg = "because R_OVERRIDE_CEF_VERSION $ENV{'R_OVERRIDE_CEF_VERSION'} not matching LIBCEF_DLL_VERSION $libcefshort \n\n" if ($ENV{R_OVERRIDE_CEF_VERSION} ne '');
              fail_skip($i);
              $skip_msg = "";
               return (0);              
         }
         
         @array = split(/@/, $test_list[$i]);
         if (defined $ENV{RSD_BAT} ) {
            $array[0] =~ s/(\.txt)$/.bac/;
         }
         
         if (! -e $array[0] && ! $directives{mech_test}
           && ! $directives{prokernel_test} 
           && ! $directives{otk_cpp_test}
           && ! $directives{otk_cpp_async_test}
           && ! $directives{pyautogui_test}
           && ! $directives{pglview_test} ) {
            ($raw_trailname, $ext_name) = split(/\./, $array[0]);
            print_skip_msg("skipped::  #skipped $raw_trailname because improper integration, could not find $array[0]\n");
        print_fail("skipped::  #skipped $raw_trailname because improper integration could not find $array[0]\n");
        $skip_msg = "skipped:  #skipped $raw_trailname because improper integration could not find $array[0]";
        
        if ($directives{rsd_test}) {
         wait_for_network_drive("$trail_path/auto.txt");
        } else {
           wait_for_network_drive("$trail_path/test/auto.txt"); 
        }
            $result = "FAILURE";
            $fail_no++;
            &fail_skip($i);
            if ($directives{keep}) {
                $copy_keep_files = 1;
            } else {
                $copy_keep_files = 0;
            }
            return (0);
         } elsif ($copy_keep_files && 
        ($skip_keep_test || $succ_skip_keep_test)) {
        if ($skip_keep_test) {
           if ($directives{keep}) {
              $copy_keep_files = 1;
           } else {
              $copy_keep_files = 0;
           }
           $skip_keep_test = 0;
           &fail_skip($i, 1);
        } elsif ($succ_skip_keep_test) {
           if ($directives{keep}) {
              $copy_keep_files = 1;
           } else {
              $copy_keep_files = 0;
           }
           $succ_skip_keep_test = 0;
           &succ_skip($i);
        }
         } else {
#       if ( -e $array[0] ) {
#          if (missing_qcrs($array[0])) {
#         print_skip_msg("skipped::  #skipped $raw_trailname because improper integration, missing qcr files\n");
#         print_fail("skipped::  #skipped $raw_trailname because improper integration, missing qcr files\n");
#         $result = "FAILURE";
#         $fail_no++;
#         &fail_skip($i);
#         return (0);
#          }
#       }
            &wait_for_executable if ($ENV{R_IGNORE_XTOP} ne "true");
            $test_num++;
            $array[1] =~ tr/./\//;
            chop($array[1]);
            $trailfile = "$trail_path/$array[1]/$array[0]";
            update_setenv if ($cur_test_num != 0);
            update_unsetenv if ($cur_test_num != 0);
            update_backward_trail_set if ($cur_test_num != 0);
            update_directive_hold if ($cur_test_num != 0);
            merge_config($ENV{R_MERGE_CONFIG}) if (defined $ENV{R_MERGE_CONFIG});
            #&prev_run_process($array[0], $array[1]);
            print "\nDoing: $trailfile  $test_num/$num_tests\n";
            &run_trail($array[0], $i, $first_trail, $trailfile);
            $first_trail = 0;
            $cur_test_num++;
            
            if ($result eq "FAILURE" || is_last_trail($i)) {
                if(defined $ENV{P_VERSION} && $ENV{P_VERSION} >= 310) {
                    if ($directives{wildfire_test} && ! $all_wildfire) {
                        delete $ENV{IS_WILDFIRE_TEST};
                    }
                }
            }
            
            if (($result eq "FAILURE" || is_last_trail($i)) && $cur_test_agent_setup_done) {
               if ($old_creo_agent_home ne "") {
               $ENV{CREO_AGENT_HOME} = "$old_creo_agent_home";
               } else {
                  delete $ENV{CREO_AGENT_HOME};
               }
               

               if ("$to_unset_r_use_agent" eq "t") {
                  # we set them, we remove them
                  delete $ENV{CREO_AGENT_WAIT_FOR_CLIENT};
                  delete $ENV{CREO_AGENT_LINGER_ON_IDLE};
                  delete $ENV{R_USE_AGENT};
               }
            }
            return (0) if ($skip_tests);
            if ($result eq "FAILURE" && $directives{keepscratch}
                 && (! $qcr_fail || $skip_qcr) && ! $memuse_error) {
               &fail_skip($i+2, 1);
               return (0);
            } elsif ($directives{batch_trail_test}) {
               if ($result eq "FAILURE") {
                  &fail_skip($i+2, 0);
               } else {
                  &succ_skip($i+2);
               }
               return (0);
        }

            $qcr_fail = 0;
            $memuse_error = 0;
         }
		 $cur_test_keepscratch = 0;
      }
   }
}

sub run_commands {
   my ($stat, $i, $cur_cmd, @array);
   for ($i=0; $i<$directives{num_cmd}; $i++) {
      next if (! exists $cmd_list{"${cur_test_num}AND$i"});
      $cur_cmd = $cmd_list{"${cur_test_num}AND$i"};
	  changemod_recursive($tmpdir);
      $run_cmd_time_start = &date_hmsmd;
      print "Run Cmd Start Time: $run_cmd_time_start \n";
      if ($directives{otk_cpp_async_test}) {
        my @OTKSYNCOBJS = ("$ENV{PTCSYS}/obj");
        if ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
          $PROJDIR = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}";
          unshift (@OTKSYNCOBJS, "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/$ENV{PRO_MACHINE_TYPE}/obj");
        }
        $cur_cmd =~ s!%PTCSRC!$ENV{PTCSRC}!g; 
        while ($cur_cmd =~ m!%(\w+)/(\S+)!) {
          ($otkstr) = grep(-f || -d , map "$_/$2$exe_ext", @OTKSYNCOBJS);
          if ($otkstr) { 
            $cur_cmd =~ s!%(\w+)/(\S+)!$otkstr!; 
          }
          else {
             print_fail("skipped:: #skipped $raw_trailname because - NO SUBSTITUTION FOUND for %$1/$2\n");
			 print_fail("\nSkip following tests\n");
             print_skip_msg("\nSkip following tests\n");
		    print_skip_msg("skipped::  #skipped $raw_trailname\n");
			print_fail("skipped#$trailfile\n");
			print_fail("skipped::  #skipped $raw_trailname\n");
            $cur_cmd =~ s!%(\w+)!CHECK_THIS_LINE!;
            if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
                $check_stat = 0;
                $check_stat = basic_check_for_dauto_run();
                if ($check_stat) {
                   print "DAUTO -reportfailure  SKIPPED - not reporting FAILURE for $raw_trailname\n";
                   print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
                   exit($check_stat);   
                }
            }
			
			if ($dcad_server ne "") {
			   print "DAUTO -reportfailure SKIPPED\n";
			   system ("$dcad_server -reportfalure SKIPPED");
			}
            return (-1);
          }
        }         
      }
      $directives{dlltest} = 1 if ($cur_cmd =~ /dll/);
      @array = split(/ /, $cur_cmd);
      if ( -e "$rundir/$array[0]$CSH_EXT" ) {
         print_succfail("$rundir/$cur_cmd\n") if ($R_VERBOSE);
         if ("$cur_cmd" =~ /dsq_start_nmsd/) {
            $stat = system("$csh_cmd \"$rundir/$cur_cmd\"");
         } else {
            print `$csh_cmd "$rundir/$cur_cmd"`;
            $stat = $? >> 8;
         }
      } else {
         print_succfail("$cur_cmd\n") if ($R_VERBOSE);
         if ("$cur_cmd" =~ /dsq_start_nmsd/) {
            $stat = system("$csh_cmd \"$cur_cmd\"");
         } else {
            $cmd_res =  `$csh_cmd "$cur_cmd"`;
            print $cmd_res;
            $stat = $? >> 8;
         }
      }
      if ($stat) {
     if ($stat == 99) {
            print_succ("status is: $stat from $cur_cmd\n");
            print_succ($cmd_res);
            print_succ("Passing this test because $cur_cmd returns 99\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because $cur_cmd returns 99\n");
     } else {
            print "RESULT:  FAIL + SKIP\n";
            print_fail("status is: $stat from $cur_cmd\n");
            print_fail($cmd_res);
            print_fail("skipped::  #skipped because $cur_cmd failed\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because $cur_cmd failed\n");
           
            $message = "#skipped because $cur_cmd failed, \n $cmd_res ";
            create_message_file("$message");
            $message = "";
     }
         return ($stat);
      }
      $run_cmd_time_end = &date_hmsmd;
      print "Run Cmd Finish Time: $run_cmd_time_end \n";
   }
   return (0);
}

sub run_timeout_cmd {
   my $timeout_val = shift;
   my ($command_line) = @_;
   if ($ENV{OS_TYPE} eq "UNIX") {
       my $old_timeout = $ENV{R_TIMEOUT};
	   $ENV{R_TIMEOUT} = ceil($timeout_val / 60); #to minutes, round up
	   $ENV{R_RUN_CMD_SILENT} = 't';
       `$csh_cmd "$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ${TOOLDIR}run_cmd.pl $command_line"`;
	   delete $ENV{R_RUN_CMD_SILENT};
	   $ENV{R_TIMEOUT} = $old_timeout;
   } else {
	   open FILE, "$ENV{PTC_TOOLS}/bin/$ENV{PRO_MACHINE_TYPE}/run_nt_job.exe \"$command_line\" $timeout_val 0 1 |";
	   while (<FILE>) {}
	   close(FILE);
   }
}

sub creoagent_start {
   if (defined $ENV{CREO_AGENT_HOME} && ! -d $ENV{CREO_AGENT_HOME}) {
      mkpath($ENV{CREO_AGENT_HOME});
    }
   &apply_setenv; # some envs may affect agent services
   #since creoinfo.exe may hang, we open it with a timeout after which it will be killed.

  return if (defined $ENV{R_SAAS_REGRESSION});
  if ($ENV{R_USE_CREO_PLUS} eq "true") {
     if (defined $ENV{CREO_SAAS_CREO_WAIT_READY}) {      
        system("$csh_cmd \"$creoinfo_exe -wait-ready \"");
        $cs_stat = ($? >> 8);
        print("$creoinfo_exe -wait-ready finished with return code $cs_stat\n");
     } else {
        system("$csh_cmd \"$creoinfo_exe \"");
        $cs_stat = ($? >> 8);
        print("$creoinfo_exe finished with return code $cs_stat\n");        
     }
  } else {  
     run_timeout_cmd(120, "$creoinfo_exe") ;
  }

}

sub creoagent_ensure_install {
   #we use lock to prevent multiple instances from simultaneously trying to install creoagent.msi
   if ($ENV{OS_TYPE} eq "NT") {
      _lock();
   }
   &creoagent_start();
   if ($ENV{OS_TYPE} eq "NT") {
      _unlock();
   }
}

sub creoagent_shutdown {
   return if (defined $ENV{R_SAAS_REGRESSION});
   
   if ($ENV{R_USE_CREO_PLUS} eq "true") {
     print "Running(creoagent_shutdown): $creoinfo_exe -logout -fail\n";
     print "CREO_AGENT_HOME(creoagent_shutdown -fail)=$ENV{CREO_AGENT_HOME}\n";
     system("$csh_cmd \"$creoinfo_exe -logout -fail\"");
	 $cs_stat = ($? >> 8);
     print("$creoinfo_exe -logout -fail finished with return code $cs_stat\n");			
   }
   
   
   print "Running(creoagent_shutdown): $creoinfo_exe -shutdown\n";
   print "CREO_AGENT_HOME(creoagent_shutdown -shutdown)=$ENV{CREO_AGENT_HOME}\n";
   
   if ($ENV{R_USE_CREO_PLUS} eq "true") {
      system("$csh_cmd \"$creoinfo_exe -shutdown\"");
	  $cs_stat = ($? >> 8);
      print("$creoinfo_exe -shutdown finished with return code $cs_stat\n");
   } else {
      run_timeout_cmd(60, "$creoinfo_exe -shutdown") ;
   }
   if ( defined $ENV{CREO_AGENT_HOME} && -d $ENV{CREO_AGENT_HOME} ) {
      `$rm_cmd -rf "$ENV{CREO_AGENT_HOME}"`;
   }
}

sub _lock_file()
{
  my $file = shift;
  my $fh = undef;
  open($fh, '>>', $file) or die "Could not open '$file' - $!";
  flock($fh, LOCK_EX) or die "Could not lock '$file' - $!";
  return $fh;
}

sub _unlock_file()
{
  my $fh = shift;
  close($fh);
}

sub _lock {
  my $tmp_path = "";
  if (defined $ENV{DCAD_TEMP} && -d $ENV{DCAD_TEMP}) {
     $tmp_path = $ENV{DCAD_TEMP};
  } elsif (defined $old_temp && -d $old_temp) {
     $tmp_path = $old_temp;  
  } elsif (defined $old_tmp && -d $old_tmp) {
     $tmp_path = $old_tmp;  
  } else {
     $tmp_path = "$ENV{HOME}/tmp";
     if (! -d $tmp_path) {
		mkpath($tmp_path);
     }
  }
  
  my $lockfile_path = "$tmp_path/autolock.lck";

  open (LOCKFILE, ">>$lockfile_path") or die ("Can't open lockfile");
  flock (LOCKFILE, LOCK_EX) or die "\nCannot lock file $!";
}

sub _unlock {
  close (LOCKFILE);
}

sub prev_run_process {
   my ($trail_name, $trail_dir) = @_;

   if ($ENV{R_CHECK_DBGFILE} eq "true" && $trail_name =~ /\.txt/
            && -e $trail_name) {
      print "\nRemoving any #CRASH from $trail_name\n";
      &remove_crash_from_trail("$tmpdir/$trail_name");
   }

   if (-e "../fixit") {
      print "\nFixing ... $trail_name\n";
       if( $OS_TYPE eq "UNIX" ) {
         `../fixit $trail_name`;
       } else {
         `$csh_cmd "../fixit $trail_name"`;
       }
   }

   if (defined $ENV{R_FIX_TRAIL_SCRIPT} && -e $ENV{R_FIX_TRAIL_SCRIPT}) {
      print "\nRunning $ENV{R_FIX_TRAIL_SCRIPT} $trail_name .... \n";
      `$ENV{R_FIX_TRAIL_SCRIPT} $trail_name`;
      if (defined $ENV{R_FIXTRAIL_BASE_DIR}) {
     if (! -d "$ENV{R_FIXTRAIL_BASE_DIR}") {
        mkdir ("$ENV{R_FIXTRAIL_BASE_DIR}", 0777);
     }
     my @array=split(/\//, $trail_dir);
     @array = reverse(@array);
     if (! -d "$ENV{R_FIXTRAIL_BASE_DIR}/$array[0]") {
        mkdir ("$ENV{R_FIXTRAIL_BASE_DIR}/$array[0]", 0777);
     }
     print "Copying $trail_name $ENV{R_FIXTRAIL_BASE_DIR}/$array[0]\n";
     copy "$trail_name", "$ENV{R_FIXTRAIL_BASE_DIR}/$array[0]";
      }
   }

   if ($R_FLOAT_CHECK eq "true") {
      print "Modifying $trail_name for floating options check\n";
      open(SEDPRG, ">sedprg");
      print SEDPRG "2 a\\\n";
      print SEDPRG "\#MISC\\\n";
      print SEDPRG "\#DEBUG\\\n";
      print SEDPRG "\#TOGGLE OPTS\\\n";
      print SEDPRG "\#DONE\\\n";
      print SEDPRG "\#MODE\\\n";
      print SEDPRG "\#MODE\\\n";
      print SEDPRG "\#MODE\\\n";
      print SEDPRG "\#MODE\n";
      close(SEDPRG);
      `sed -f sedprg $trail_name > $trail_name.tmp`;
      `mv -f $trail_name.tmp $trail_name`;
      `$rm_cmd -f sedprg`;
   }

   if ($ENV{R_CONFIG_FILE} eq "useautodefault") {
      open(TRAIL_PT, "$trail_name");
      my (@trail_file) = <TRAIL_PT>;
      close(TRAIL_PT);
      chop($trail_file[0]);
      my (@array) = split(/ /, $trail_file[0]);
      @array = reverse(@array);
      if ($directives{weblink_test}) {
         open(CONFIG_PT,">>$tmpdir/config.pro");
         print CONFIG_PT "start_appmgr no\n";
         close(CONFIG_PT);
      }
   }

   if ( ( ! $keep_agent_home_folder ) && ( ($directives{fresh_creo_agent} && ($OS_TYPE eq "NT") && !$cur_test_agent_setup_done) || ( (defined $ENV{R_USE_CREO_PLUS}) && $OS_TYPE eq "NT") ) ) {
      if (defined $ENV{CREO_AGENT_HOME}) {
      $old_creo_agent_home = "$ENV{CREO_AGENT_HOME}";
      } else {
        $old_creo_agent_home = 0;
      }
      $ENV{CREO_AGENT_HOME} = "$cur_dir/CREO_HOME_$trail_name";


      $ENV{CREO_AGENT_HOME} = "$cur_dir/CREO_HOME_$uniquename";

      $to_unset_r_use_agent = 'f';

      if (!defined $ENV{R_USE_AGENT}) {
	 $to_unset_r_use_agent = 't';
	 $ENV{R_USE_AGENT} = 't';
	 $ENV{CREO_AGENT_WAIT_FOR_CLIENT}="-1";
	 $ENV{CREO_AGENT_LINGER_ON_IDLE}="-1";
      }

      $cur_test_agent_setup_done = 1;
   }

   if ( ( $directives{fresh_creo_agent} && ($OS_TYPE eq "NT") ) || ( (defined $ENV{R_USE_CREO_PLUS}) && $OS_TYPE eq "NT" ) ) {
      # ensure that we use a clean agent home, in case for some reason previous one was not cleaned properly
      if (-d $ENV{CREO_AGENT_HOME} && !$keep_agent_home_folder) {
         `$rm_cmd -rf "$ENV{CREO_AGENT_HOME}"`;

         #if can't delete, create a new agent home folder
         if (-d $ENV{CREO_AGENT_HOME}) {
            my $agentfolder_suffix = 1;
            while (-d $ENV{CREO_AGENT_HOME}) {
               $ENV{CREO_AGENT_HOME} = "$cur_dir/CREO_HOME_CURR_TEST$agentfolder_suffix";
               $agentfolder_suffix++;
            }
         }
      }
      
      &creoagent_start() if ( (! defined $ENV{R_USE_CREO_PLUS}) && (not defined $ENV{R_SHARED_CREO_HOME}));
    }

   $keep_agent_home_folder = 0;
   print `$csh_cmd "$PRE_RUN_SCRIPT"` if ($PRE_RUN_SCRIPT);
}

sub wait_for_executable {
   my($wait_for) = 0;
   while ($OS_TYPE eq "UNIX" && ! -x $local_xtop || ! -e $local_xtop) {
      $wait_for = 1;
      print "$local_xtop is missing, waiting.\n";
      sleep(60);
   }
   if ($wait_for) {
      print "$local_xtop is back, proceeding.\n";
      if ($OS_TYPE eq "UNIX") {
         print "Sleep 5 minutes to make sure the xtop is ready...\n";
         sleep(300);
      } else {
         print "Sleep 30 minutes to make sure the xtop is ready...\n";
         sleep(1800);
      }
      $wait_for=0;
   }
}

sub run_trail {
   my ($trail_name, $n, $first_trail, $trail_dir) = @_;

   @array = split(/\./, $trail_name);
   $raw_trailname = $array[0];

   $result = pre_directive_process($first_trail);
   if ($result == 1) {
      $result = "SUCCESS";
      $test_num--;
      &succ_skip($n)
   } elsif ($result == -1) {
      $result = "FAILURE";
      $fail_no++;
      $test_num--;
      &fail_skip($n, 0);
   } elsif ($result == -2) {
      $test_num--;
      &notexists_skip($n);
   } else {

      if (defined $memuse_db{$trail_name}) {
     $ENV{"R_MEMUSE"} = true;
      } else {
     delete $ENV{R_MEMUSE} if (defined $ENV{R_MEMUSE});
      }
	  prev_run_process($trail_name, $trail_dir);			
      run_trail_low($trail_name, $n);
   }
}

sub get_pdev_exe {
   my ($exe_name) = @_;
   my (@exe_pathes) = split(/ +/, $R_PDEV_REGRES_BIN);

   foreach $p (@exe_pathes) {
      if (-e "$p/$exe_name$EXE_EXT") {
         return "$p/$exe_name";
      }
   }
   return "$PTCSYS/obj/$exe_name";
}

sub is_db_client_trail {
   my ($trail_name) = @_;
   open(TRAIL, "$trail_name");
   my (@trail_lines) = <TRAIL>;
   close(TRAIL);
   return 1 if ("$trail_lines[1]" =~ /db_client/);
   return 0;
}

sub is_oos_failure {
   my ($msg_file, $even_on_nt) = @_;
   if ($OS_TYPE eq "NT" && ! $even_on_nt) {
        $msg_file = "std.out";
   }
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   chop(@msg_lines);
   @msg_lines = reverse(@msg_lines);
   my ($oos_line_no) = 0;
   if (-e "OOS.qcr") {
      open(MSG, "OOS.qcr");
      $oos_line_no = <MSG>;
      close(MSG);
      chop($oos_line_no);
   }
   for ($i=0; $i<8; $i++) {
      if ("$msg_lines[$i]" =~ /file out of sequence at line/) {
     return 1 if ($oos_line_no == 0);
     my (@array) = split(/file out of sequence at line /, $msg_lines[$i]);
     my ($this_oos_line, $other) = split(/\./, $array[1]);
     return 1 if ($this_oos_line == $oos_line_no);
     return 0;
      }
   }
   return 0;
}

sub is_groove_import_vcard {
   my ($msg_file) = @_;
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   if ($OS_TYPE eq "NT") {
      $msg_file = "std.out";
      open(MSG, "$msg_file");
      my (@more_msg_lines) = <MSG>;
      push(@msg_lines, @more_msg_lines);
      close(MSG);
   }
   chop(@msg_lines);
   foreach $line (@msg_lines) {
      return 1 if ("$line" =~ /CS Error 19 in vconfConferenceGrooveInterface::DoAddContact/);
      return 1 if ("$line" =~ /Can not connect to CS server/);
   }
   return 0;
}

sub is_wrong_csd_server {
   my ($msg_file) = @_;
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   if ($OS_TYPE eq "NT") {
      $msg_file = "std.out";
      open(MSG, "$msg_file");
      my (@more_msg_lines) = <MSG>;
      push(@msg_lines, @more_msg_lines);
      close(MSG);
   }
   chop(@msg_lines);
   foreach $line (@msg_lines) {
      return 1 if ("$line" =~ /Conference Server is not compatible with this version of the Conference Center/);
   }
   return 0;
}

sub is_server_overload {
   my ($msg_file) = @_;
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   if ($OS_TYPE eq "NT") {
      $msg_file = "std.out";
      open(MSG, "$msg_file");
      my (@more_msg_lines) = <MSG>;
      push(@msg_lines, @more_msg_lines);
      close(MSG);
   }
   chop(@msg_lines);
   foreach $line (@msg_lines) {
      return 1 if ("$line" =~ /test skipped because of server overload/);
   }
   return 0;
}

sub is_server_problem {
   my ($msg_file) = @_;
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   if ($OS_TYPE eq "NT") {
      $msg_file = "std.out";
      open(MSG, "$msg_file");
      my (@more_msg_lines) = <MSG>;
      push(@msg_lines, @more_msg_lines);
      close(MSG);
   }
   chop(@msg_lines);
   foreach $line (@msg_lines) {
      return 1 if ("$line" =~ /Warning: TrailServer problem/);
   }
   return 0;
}

sub is_server_is_reboot {
   my ($msg_file) = @_;
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   if ($OS_TYPE eq "NT") {
      $msg_file = "std.out";
      open(MSG, "$msg_file");
      my (@more_msg_lines) = <MSG>;
      push(@msg_lines, @more_msg_lines);
      close(MSG);
   }
   chop(@msg_lines);
   foreach $line (@msg_lines) {
      return 1 if ("$line" =~ /ConfServer was down\/rebooting while the test was running/);
   }
   return 0;
}

sub is_connect_time_out {
   my ($msg_file) = @_;
   open(MSG, "$msg_file");
   my (@msg_lines) = <MSG>;
   close(MSG);
   if ($OS_TYPE eq "NT") {
      $msg_file = "std.out";
      open(MSG, "$msg_file");
      my (@more_msg_lines) = <MSG>;
      push(@msg_lines, @more_msg_lines);
      close(MSG);
   }
   chop(@msg_lines);
   foreach $line (@msg_lines) {
      return 1 if ("$line" =~ /connection timed out/);
   }
   return 0;
}

sub run_backward_retr_low {
   my ($run_str, $raw_trailname) = @_;

   print "running: $run_str\n";
   if ($ENV{OS_TYPE} eq 'UNIX' ) {
      `$csh_cmd "$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ${TOOLDIR}run_cmd.pl $run_str >& $raw_trailname.msg"`;
   } else {
      `$csh_cmd "$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $r_nt_job_pl $run_str >& $raw_trailname.msg"`;
   }
   $status = $?;

   return 0 if ($status);
   return 1;
}

sub run_backward_retr {
   my ($raw_trailname) = @_;
   my ($obj_trail, $status, @files);
   my ($old_obj_name) = "";
   my ($old_obj_ext) = "";

   if ($directives{retr_test} || $directives{gcri_retr_test}) {
      @files = `ls $retr_obj.*`;
      chop(@files);
      sort (@files);
      @files = reverse(@files);
      $retr_obj = $files[0];
      $obj_trail = $raw_trailname.".txt";
      &create_retr_trail("$retr_trl{$cur_test_num}", $obj_trail);
      print_succfail("Retrieving $retr_obj\n");
      if ($directives{retr_test}) {
         if ($ENV{R_RUNMODE} eq "9029") {
            $run_str="$ENV{R_BACKWARD} -151 $ENV{R_GRAPHICS} 1 $obj_trail";
         } else {
            $run_str="$ENV{R_BACKWARD} $ENV{R_RUNMODE} $ENV{R_GRAPHICS} 1 $obj_trail";
         }
      }
      if ($directives{gcri_retr_test}) {
         $run_str="$ENV{R_BACKWARD} 9029 $ENV{R_GRAPHICS} 1 $obj_trail";
      }
      return run_backward_retr_low($run_str, $raw_trailname);
   } else {
      @files = `ls *.*.*`;
      chop(@files);
      sort (@files);
      @files = reverse(@files);
      foreach $f (@files) {
         my ($obj_name, $obj_ext, $obj_no) = split (/\./, $f);
         next if ($obj_ext eq "txt");
         next if ($obj_name eq $old_obj_name && $obj_ext eq $old_obj_ext);
         $old_obj_name = $obj_name;
         $old_obj_ext = $obj_ext;
         $obj_trail = $obj_ext."1.txt";
         next if (! -e "$trail_path/test/retrieval/$obj_trail");
         `cp $trail_path/test/retrieval/$obj_trail .`;
         $retr_obj = $f;
         &create_retr_trail($obj_trail, $obj_trail);
         print_succfail("Retrieving $f\n");
     if ($ENV{R_RUNMODE} eq "9029") {
            $run_str="$ENV{R_BACKWARD} -151 $ENV{R_GRAPHICS} 1 $obj_trail";
     } else {
        $run_str="$ENV{R_BACKWARD} $ENV{R_RUNMODE} $ENV{R_GRAPHICS} 1 $obj_trail";
     }
         if (! run_backward_retr_low($run_str, $raw_trailname)) {
            open(MSG, ">>$raw_trailname.msg");
            print MSG "The test failed when retrieving $f with $ENV{R_BACKWARD}\n";
            close (MSG);
            return 0;
         }
      }
   }
   return 1;
}

sub is_last_trail {
   my ($n) = @_;
   my ($n_line);

   return 1 if (!$directives{keepscratch});
   $n_line = @test_list;
   for ($i=$n+1; $i < $n_line; $i++) {
       return 0 if ($test_list[$i] =~ /\.txt|\.htm/);
   }
   return 1;
}

sub run_trail_low {
   my ($trail_name, $n) = @_;
   my ($start, $runtime, $run_stat, $stop);
   my ($run_str, $my_local_xtop, $raw_trailname, @array);
   my ($tsd, $vconf, $csutil, $no_cleanup, $my_run_mode, $preexec, $existcheck, $j);
   my (@file_list);
   $tk_flavor_name="";

   if ($directives{tk_flavor}) {
      $tk_flavor_name = $tk_flavor_extension.$tk_flavor_;
   }

   @array = split(/ /, $local_xtop);
   $preexec = "";
   $existcheck = 0;
   if (-e "$rundir/xtop.exe" && @array > 1) {
      $my_local_xtop = "..\\xtop.exe";
      print "\nWARNING!!! auto has changed xtop path to: $my_local_xtop.\n\n";
   } else {
      $my_local_xtop = "$local_xtop";
   }
   
   if ($r_using_local_install && defined $ENV{'RSD_BAT'}) {
       $my_local_xtop = "$ENV{PTC_TOOLS}/RSD/bin/rsdlocal_run.csh";
       if (defined $ENV{'R_USE_LOCAL_RSD_CSH'}) {
          $my_local_xtop = $ENV{'R_USE_LOCAL_RSD_CSH'};
       }
	   print "WARNING!!! auto has changed Creo Schematics path to: $my_local_xtop. For local install run with RSD_BAT $ENV{'RSD_BAT'}.\n";
   } elsif ($r_using_local_install == 1) {
      $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../Parametric/bin/parametric.exe";
      $ENV{'PRO_MECH_COMMAND'} = "$ENV{'PRO_DIRECTORY'}/../Parametric/bin/parametric.exe";      
	   if (defined($ENV{'CREO_APP'}) && (($ENV{'CREO_APP'} eq "DMA")||($ENV{'CREO_APP'} eq "dma")))
	   {
		  if (-d "$ENV{'PRO_DIRECTORY'}/../Direct/bin")
		  {
			 $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../Direct/bin/direct.exe";
		  }
	   }
	   if (defined($ENV{'CREO_APP'}) && ($ENV{'CREO_APP'} eq "OPTM"))
	   {
		  if (-d "$ENV{'PRO_DIRECTORY'}/../Option~1/bin")
		  {
			 $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../OPTION~1/bin/optionsmodeler.exe";
		  }
	   }
	   if (defined($ENV{'CREO_APP'}) && ($ENV{'CREO_APP'} eq "LAYOUT"))
	   {
		  if (-d "$ENV{'PRO_DIRECTORY'}/../Layout/bin")
		  {
			 $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../Layout/bin/layout.exe";
		  }
	   }
	   if (defined($ENV{'CREO_APP'}) && ($ENV{'CREO_APP'} eq "SHELL"))
	   {
		  if (-d "$ENV{'PRO_DIRECTORY'}/../photorender/bin")
		  {
			 $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../photorender/bin/photorender.exe";
		  }
	   }
	   if (defined($ENV{'CREO_APP'}) && (($ENV{'CREO_APP'} eq "MECHANICA") || ($ENV{'CREO_APP'} eq "SIMULATE")))
	   {
		  if (-d "$ENV{'PRO_DIRECTORY'}/../Simulate/bin")
		  {
			  $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../Simulate/bin/simulate.exe";
			  $ENV{'PRO_MECH_COMMAND'} = "$ENV{'PRO_DIRECTORY'}/../Simulate/bin/simulate.exe";
		  }
	   }
       
	   if ((defined($ENV{'CREO_APP'}) && ($ENV{'CREO_APP'} eq "PMA")) ||
		   !defined($ENV{'CREO_APP'})
		   ) {
                if (-d "$ENV{'PRO_DIRECTORY'}/../Parametric/bin") {
                   $my_local_xtop = "$ENV{'PRO_DIRECTORY'}/../Parametric/bin/parametric.exe";
                   $ENV{'PRO_MECH_COMMAND'} = "$ENV{'PRO_DIRECTORY'}/../Parametric/bin/parametric.exe";
                }
      
                if ( ($ENV{R_USE_CREO_PLUS} eq 'true') && -d "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin") {
                    
                   use_cpd_user() if ( $directives{cpd_user} && ( defined $ENV{R_USE_CREO_PLUS} ) );
                   
                   if ($directives{run_with_license} || $ENV{LANG} ne 'C' || $ENV{R_SAAS_PROFILE_NAME} ne '' || ("$ENV{R_UPDATE_PSF_ENV}" ne '')) {
                      $l2r_username = lc($l2r_username);
                      $old_psf_file = $psf_file;
                      $psf_file = create_psf_file($psf_file,$ENV{$l2r_feature_name_var},$ENV{LANG},$ENV{R_SAAS_PROFILE_NAME},"$ENV{R_UPDATE_PSF_ENV}");
                      $psf_filename = basename($psf_file);
                      `mv $psf_file $psf_file_location`;
                      $psf_file = "$psf_file_location\\$psf_filename";
                   }
                   
                   if ($directives{run_with_license}) {
                      save_configure_creosaas_login($l2r_username,$l2r_password);
                   }

                   $my_local_xtop = "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin\\parametric.exe $psf_file";
	               $ENV{'PRO_MECH_COMMAND'} = "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin\\parametric.exe $psf_file";

                   print "\n";
                   #print "CREO_SAAS_TEST_REUSE_TOKEN=$ENV{CREO_SAAS_TEST_REUSE_TOKEN}\n";
                   print "CREO_SAAS_HOST_URL=$ENV{CREO_SAAS_HOST_URL}\n";
                   #print "CREO_SAAS_BASEURL=$ENV{CREO_SAAS_BASEURL}\n";
                   print "CREO_SAAS_TEST_ALT_SERVER=$ENV{CREO_SAAS_TEST_ALT_SERVER}\n";
                   print "PTC_WF_ROOT=$ENV{PTC_WF_ROOT}\n";
                   print "CREO_AGENT_HOME=$ENV{CREO_AGENT_HOME}\n";
                   print "PTC_LOG_DIR=$ENV{PTC_LOG_DIR}\n";
                   #print "PRO_PACKAGE_ONDEMAND_AUTO_WAIT=$ENV{PRO_PACKAGE_ONDEMAND_AUTO_WAIT}\n";
                   #print "UPDATE_INITIAL_CHECK_DELAY=$ENV{UPDATE_INITIAL_CHECK_DELAY}\n";
                   #print "IS_WILDFIRE_TEST=$ENV{IS_WILDFIRE_TEST}\n";
				   #print "PTC_UI_SERVICE_RUN_TRAIL=$ENV{PTC_UI_SERVICE_RUN_TRAIL}\n";
                   #print "ZBROWSER_TRAIL_FILE=$ENV{ZBROWSER_TRAIL_FILE}\n";
                   #print "CREO_SAAS_APIKEY=$ENV{CREO_SAAS_APIKEY}\n";
                   #print "CREO_SAAS_AUTHORIZATION=$ENV{CREO_SAAS_AUTHORIZATION}\n";
                   print "\n";
                   
                   if ($ENV{CREO_SAAS_TEST_ALT_USERNAME} eq '') {
                     print ("\n CREO_SAAS_TEST_ALT_USERNAME not found \n");
                     exit(1);
                   } else {
                     print "CREO_SAAS_TEST_ALT_USERNAME=$ENV{CREO_SAAS_TEST_ALT_USERNAME}\n";
                   }
				  
				   if ($ENV{CREO_SAAS_USERNAME} eq '') {
                     print ("\n CREO_SAAS_USERNAME not found \n");
                     exit(1);
                   } else {
                     print "CREO_SAAS_USERNAME=$ENV{CREO_SAAS_USERNAME}\n";
                   }

                   if ($ENV{USE_ATLAS_SERVER} eq 'true') {
                      if ($ENV{CREO_SAAS_TEST_ALT_PASSWORD} eq '') {
                         print ("\n Error:  CREO_SAAS_TEST_ALT_PASSWORD not found \n");
                         exit(1);
                      } else {
                         print "CREO_SAAS_TEST_ALT_PASSWORD is set : <OMITTED>\n";
                      }
                  
                      if ($ENV{CREO_SAAS_PASSWORD} eq '') {
                         print ("\n Error: CREO_SAAS_PASSWORD not found \n");
                         exit(1);
                      } else {
                         $ENV{CREO_SAAS_PASSWORD} = $ENV{CREO_SAAS_PASSWORD};
                         print "CREO_SAAS_PASSWORD is set : <OMITTED>\n";
                      }
				   }
              }
     }
     
	 if ($ENV{'CREO_APP'} ne "") {
        print "WARNING!!! auto has changed xtop path to: $my_local_xtop. For local install run and CREO_APP set to $ENV{'CREO_APP'}\n";
    } else {
            print "WARNING!!! auto has changed xtop path to: $my_local_xtop. For local install run.\n\n";
    }   
   }
   
   if (defined $ENV{R_BITMAP_LOCAL_IMAGE}) {
      if ($num_bitmap_test > 0) {
     if (defined $ENV{R_BITMAP_IMAGE_XTOP}) {
         $my_local_xtop = $ENV{R_BITMAP_IMAGE_XTOP};
     } else {
         $my_local_xtop = "$PTCSYS/obj/xtop";
     }
      }
   }

   perf_tool_start ($trail_name) if($ENV{'PERF_TEST_AUTO'} ne "NO" && $ENV{'R_PERF'} eq "true");
   print ("perf testname=$trail_name for iteration=$ENV{R_PERF_CURRENT_ITERATION_NUM}/$ENV{R_PERF_RUN_N_TIMES}\n") if ($ENV{'R_PERF'} eq "true");

   mkdir ("$cur_dir/scratch_tmp", 0777) if (! -e "$cur_dir/scratch_tmp");
   @array = split(/\./, $trail_name);
   $raw_trailname = $array[0];

   if (defined $ENV{R_IF_EXIST_CHECK}) {
      if ($ENV{PRO_MACHINE_TYPE} =~ /^sun/) {
        if ($directives{mech_test} || $directives{mech_test_long}) {
                print "NOTE: skipping R_IF_EXIST_CHECK. Not supported with #mech_test, #mech_test_long directive.\n";
        } else {
                $preexec = "truss -f -t open,exec,execve -o $raw_trailname.truss ";
                $existcheck = 1;
        }
      } else {
        print "WARNING: R_IF_EXIST_CHECK not supported on $ENV{PRO_MACHINE_TYPE}\n";
      }
   }

   if ($directives{zero_run_mode_test}) {
      $my_run_mode = 0;
   } elsif ($directives{drc_test}){
      $my_run_mode = 0;
   }
    else {
      $my_run_mode = $ENV{R_RUNMODE};
   }

   if ($directives{L10N_test} && $altlang ne "") {
      `$csh_cmd "${TOOLDIR}trail_localization/L10N.csh $trail_name`;
   }
   if ($directives{pd_async_test}) {
      if (exists $ENV{R_PDEV_REGRES_BIN}) {
         $pd_async_exe = get_pdev_exe ("pd_async");
         $run_str="$pd_async_exe $my_local_xtop $PTCSRC/prodevelop/prodev_appls/pd_async $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      } else {
             $run_str="$PTCSYS/obj/pd_async $my_local_xtop $PTCSRC/prodevelop/prodev_appls/pd_async $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      }
   } elsif ($directives{pt_asynchronous_tests}) {
      if ($trail_name =~ /3264/ ){
         if ( $PRO_MACHINE_TYPE eq sun4_solaris_64) {
            $pt_tests_async_exec = "$PRO_DIRECTORY/sun4_solaris/obj/pt_tests_async";
         }
         if ( $PRO_MACHINE_TYPE eq hpux_pa64) {
            $pt_tests_async_exec = "$PRO_DIRECTORY/hpux11_pa32/obj/pt_tests_async";
         }
         if ( $PRO_MACHINE_TYPE eq sgi_elf4) {
            $pt_tests_async_exec = "$PRO_DIRECTORY/sgi_mips4/obj/pt_tests_async";
         }
         if ( $PRO_MACHINE_TYPE eq x86e_win64) {
            $pt_tests_async_exec = "$PRO_DIRECTORY/i486_nt/obj/pt_tests_async";
         }
      }
      $run_str="${TOOLDIR}run_pt_tests_async $pt_tests_async_exec $my_local_xtop $PTCSRC/protoolkit/protk_tests/pt_tests $my_run_mode $ENV{R_GRAPHICS}";

   } elsif ($directives{pt_wt_asynchronous_tests}) {
      $run_str="$pt_wt_tests_async_exec $my_local_xtop $PTCSRC/protoolkit/protk_tests/pt_tests $my_run_mode $ENV{R_GRAPHICS}";

   } elsif ($directives{pt_retrieval_tests}) {
      $run_str="$PTCSYS/obj/pt_retrieve";

   } elsif ($directives{fly_test}) {
      $run_str="$profly_exec -trail $trail_name";

   } elsif ($directives{plpf_test}) {
      $run_str="$ENV{R_FLEXGENERIC} -f $trail_name";

   } elsif ($directives{ipc_test}) {
      $run_str="$ENV{R_IPCTEST} -f $trail_name";

   } elsif ($directives{mech_test}) {
        $run_str="$ENV{PTC_TOOLS}/perl510/$ENV{PRO_MACHINE_TYPE}/bin/perl $cur_dir/run_mech.pl $mech_test_type $raw_trailname $my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1";

   } elsif ($directives{fbuilder_test}) {
      $run_str="$fbuilder_exe  -runmode 9029  -uilog  -uitrail $trail_name -nographics";

   } elsif ($directives{wwgmint_test}) {
	  #For running test in Creo pipeline.Explicitly call uwgm_client.exe
	  if ($ENV{R_WWGM_CREO_TEST}){
		$run_str="$PTCSYS/obj/uwgm_client.exe -uirunmode 9029 -uwgm_uilog -uitrail $trail_name";		
	  } else {
	  #To run the WWGM client with additional arguments added with environement {R_UWGM_CMD_ARGS}.
	  if ($ENV{R_UWGM_CMD_ARGS}) {
         $run_str="$local_xtop $ENV{R_UWGM_CMD_ARGS} -uirunmode 9029 -uwgm_uilog -uitrail $trail_name";
      } else {
      $run_str="$local_xtop -uirunmode 9029 -uwgm_uilog -uitrail $trail_name";
	  }
	}
   } elsif ($directives{uitoolkit_app_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$ENV{R_UITOOLKIT_APP}  -uirunmode 9029  -uilog  -uitrail $trail_name -nographics | tee std.out";
      } else {
         $run_str="$ENV{R_UITOOLKIT_APP}  -uirunmode 9029  -uilog  -uitrail $trail_name | tee std.out";
      }

   } elsif ($cure_flag) {
      if ($ENV{R_CURE_APP}) {
         $run_str="$ENV{R_CURE_APP}";
      } elsif (exists $ENV{CREO_UI_EDITOR}) {
      		$run_str="$ENV{CREO_UI_EDITOR}";
      		if ($run_str =~ /ui_dialog_editor.exe/ && exists $ENV{R_DEFAULT_LICENSE}) {
      		  
              if ($ENV{P_VERSION} >= 380) {
                 $run_str = "$ENV{PTCSRC}/applications/creouieditor/bin/creo_ui_editor.bat"; 
              } else {
                 $run_str = "$ENV{PTCSRC}/creo_ui_editor/bin/creo_ui_editor.bat";
              }
      		}
      	}
            
       else {
         $run_str="$PTCSYS/obj/creo_ui_editor";
         if ($ENV{OS_TYPE} eq "NT") {
            $run_str = "$run_str.exe";
         }
      }

      $run_str="$run_str -uirunmode -1 -uilog -uitrail $trail_name";
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$run_str -nographics";
      }

      $cure_flag = 0;

   } elsif ($directives{prokernel_test}) {
      $run_str="$ENV{TOOLDIR}$prokernel_exe $prokernel_test_args";
   } elsif ($prokernel_retr_flag) {
      $run_str="$ENV{TOOLDIR}$prokernel_retr_exe $prokernel_retr_args";
      $prokernel_retr_flag = 0;

   } elsif ($directives{probatch_test}) {
      $run_str="$probatch_exec -uitrail $trail_name -nographics -reg -proecmd $my_local_xtop";

   } elsif ($directives{generic_uif_test}) {
      $run_str="$uif_exec -uiftrail $trail_name $uif_graphics $genuifargs";

   } elsif ($directives{generic_ui_test}) {
      $run_str="$uif_exec -uitrail $trail_name $ui_graphics -uilog $genuiargs";

   } elsif ($directives{weblink_test}) {
      pre_run_weblink_test($trail_name);
      if ($OS_TYPE eq "NT") {
         $run_str="$netscape_exec file://$tmpdir/$trail_name";
      } else {
         $run_str="$netscape_exec $trail_name";
      }
   } elsif ($directives{java_test} || $directives{otk_java_test}) {
      pre_run_java_test();
      $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
   } elsif ($directives{pt_async_test}) {
      if ( exists $ENV{R_PDEV_REGRES_BIN} ) {
             $pt_async_exe = get_pdev_exe ("pt_async");
         $run_str="$pt_async_exe $my_local_xtop $PTCSRC/protoolkit/protk_appls/pt_async $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      } else {
         $run_str="$PTCSYS/obj/pt_async $my_local_xtop $PTCSRC/protoolkit/protk_appls/pt_async $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      }

   } elsif ($directives{pfcvb_test}) {
      # Unregistering/Registering to the server (pfclscom.exe) for pfcvb tests
      if ($ENV{R_IGNORE_XTOP} ne "true") {
         if ($mach_type eq "i486_nt" || $mach_type eq "x86e_win64"){
            if (-e "$ENV{R_PFCLSCOM_DIR}/pfclscom.exe")
            { 
               if (! $registered_pfclscom) { # Register once only
                  print "Unregistering pfclscom.exe ...\n";
                  system ("$ENV{R_PFCLSCOM_DIR}/pfclscom.exe ./UnregServer");
                  print "Registering pfclscom.exe ...\n";
                  system ("$ENV{R_PFCLSCOM_DIR}/pfclscom.exe ./RegServer");
                  $registered_pfclscom = 1;
               }
            }
            else
            {
               print "pfclscom.exe does not exist\n";
            }
         }
      }
      #Running pfcvb tests --> reg tests for VB APIs
      $ENV{PFCLS_START_DIR} = $tmpdir if ($set_PFCLS_START_DIR);
      if ( exists $ENV{R_PDEV_REGRES_BIN} ) {
       $pfcvb_tests_exe = get_pdev_exe ("pfcvb_tests");
       $run_str="$pfcvb_tests_exe $my_local_xtop ";
      } else {
       `cp $PTCSRC/$PRO_MACHINE_TYPE/obj/pfcvb_tests.exe .`;
       `cp $PTCSRC/$PRO_MACHINE_TYPE/obj/pfcvb_tests.pdb .`;
       `cp $PTCSRC/$PRO_MACHINE_TYPE/obj/pfcls.dll .`;
       $pfcvb_tests_exe = "pfcvb_tests.exe";
       $run_str="$pfcvb_tests_exe $my_local_xtop ";
      }
   } elsif ($directives{java_async_test}) {
      $run_str="${raw_trailname}.csh $java_version";
   } elsif ($directives{java_sync_test}) {
      pre_run_java_test();
      $run_str="$PTCSRC/test/java/jlinktestsynch/jlinktestsynch.csh";

   } elsif ($directives{pt_async_pic_test}) {
      if (exists $ENV{R_PDEV_REGRES_BIN}) {
         $pt_async_pic_exe = get_pdev_exe ("pt_async_pic");
         $run_str="$pt_async_pic_exe $my_local_xtop $PTCSRC/protoolkit/protk_appls/pt_async_pic $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      } else {
         $run_str="$PTCSYS/obj/pt_async_pic $my_local_xtop $PTCSRC/protoolkit/protk_appls/pt_async_pic $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      }

   } elsif ($directives{pt_simple_async_test}) {
      if (exists $ENV{R_PDEV_REGRES_BIN}) {
         $pt_simple_async_exe = get_pdev_exe ("pt_simple_async");
         $run_str="$pt_simple_async_exe +$my_local_xtop +holesblock.prt";
      } else {
         $run_str="$PTCSYS/obj/pt_simple_async +$my_local_xtop +holesblock.prt";
      }

   } elsif ($directives{rembatch_test}) {
      $run_str="${TOOLDIR}auto_rembatch $my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";

   } elsif ($directives{cadds5_topology_test}) {
      $run_str="${TOOLDIR}auto_cadds5 $my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";

   } elsif ($directives{proevconf_test}) {
      if (exists $ENV{R_LOCAL_VCONF}) {
        $vconf="$ENV{R_LOCAL_VCONF}";
      } else {
        $vconf="$PTCSYS/obj/ptcvconf$exe_ext";
      }
      if (exists $ENV{R_LOCAL_TSD}) {
        $tsd="$ENV{R_LOCAL_TSD}";
      } else {
        $tsd="$PTCSYS/obj/tsd$exe_ext";
      }
      if (exists $ENV{R_LOCAL_CSUTIL}) {
        $csutil="$ENV{R_LOCAL_CSUTIL}";
      } else {
        $csutil="$PTCSYS/obj/csutil$exe_ext";
      }
      if ($directives{keepscratch}) {
         $no_cleanup="true";
      } else {
         $no_cleanup="";
      }

      $run_str="${TOOLDIR}ts_run_auto_test.csh $tsd $vconf $csutil $my_local_xtop $trail_name $ENV{R_GRAPHICS} $no_cleanup";

   } elsif ($directives{ptcsetup_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$ENV{TOOLDIR}ptcsetup -s -reg -nodump -uilog -uitrail $trail_name -nographics";
      } else {
         $run_str="$ENV{TOOLDIR}ptcsetup -s -reg -nodump -uilog -uitrail $trail_name";
      }
   } elsif ($directives{retr_test}) {
      if ($ENV{R_RUNMODE} eq "9029") {
         $run_str="$my_local_xtop -151 $ENV{R_GRAPHICS} 1 $trail_name";
      } else {
         $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      }
   } elsif ($directives{gcri_retr_test}) {
         $run_str="$my_local_xtop 9029 $ENV{R_GRAPHICS} 1 $trail_name";
   } elsif ($directives{batch_mode_test}) {
      $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 3 -batchfile $trail_name";

   } elsif ($directives{distapps_dsm}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$ENV{TOOLDIR}dsq_start_dsqm -reg -uilog -uitrail $trail_name -nographics";
      } else {
         $run_str="$ENV{TOOLDIR}dsq_start_dsqm -reg -uilog -uitrail $trail_name";
      }
   } elsif ($directives{distapps_dbatchc}) {
      if (! is_db_client_trail($trail_name)) {
         $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
      } elsif ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$ENV{TOOLDIR}dsq_start_dbatchc -reg -uilog -uitrail $trail_name -nographics";
      } else {
         $run_str="$ENV{TOOLDIR}dsq_start_dbatchc -reg -uilog -uitrail $trail_name";
      }
   } elsif ($directives{distapps_dsapi}) {
       if (exists $ENV{R_LOCAL_DS_C_CLNT}) {
         $run_str="${R_LOCAL_DS_C_CLNT}";
      } elsif (exists $ENV{R_LOCAL_DS_CLNT_TESTS}) {
         $run_str="${R_LOCAL_DS_CLNT_TESTS}";
      } else {
         $run_str="${PTCSYS}/obj/ds_c_clnt_tests$exe_ext";
      }
   } elsif ($directives{wildfire_test}) {
      if ($directives{wf_js_test}) {
         `$csh_cmd "$ENV{TOOLDIR}wf_js_prerun.csh"`;
         pre_run_wf_js_test_test($trail_name);
      }

      if ($OS_TYPE eq "NT" && $ENV{R_GRAPHICS} eq "0" && ! $default_graphics) {
         if (defined $ENV{P_VERSION} && $ENV{P_VERSION} > 250) {
            if (!$fastreg_test_flags{server}) {
               $wf_graphics=$ENV{R_GRAPHICS};
            } elsif ( $windchill_solution !~ /626/ ) {
               $wf_graphics=$ENV{R_GRAPHICS};
            } else {
               print "Switching to Graphics Mode for a WildFire Test\n";
               $wf_graphics=7;
            }
         } else {
            print "Switching to Graphics Mode for a WildFire Test\n";
            $wf_graphics=7;
         }
      } else {
         $wf_graphics=$ENV{R_GRAPHICS};
      }
      $run_str="$my_local_xtop $my_run_mode $wf_graphics 1 $trail_name";

   } elsif ($directives{batch_trail_test}) {
      $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $raw_trailname\.bat";
   } elsif ($directives{pvecadcompare_trail_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$my_local_xtop -mode pvecadcompare -uitrail $trail_name -nographics -uirunmode $ENV{R_RUNMODE}";
      }
      else {
         $run_str="$my_local_xtop -mode pvecadcompare -uitrail $trail_name -uirunmode $ENV{R_RUNMODE}";
      }

   } elsif ($directives{pvvalidate_trail_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$my_local_xtop -mode pvvalidate -uitrail $trail_name -nographics -uirunmode $ENV{R_RUNMODE}";
      }
      else {
         $run_str="$my_local_xtop -mode pvvalidate -uitrail $trail_name -uirunmode $ENV{R_RUNMODE}";
      }
      
   } elsif ($directives{pvecadcompare_perform_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="perl pvecadperform.pl $my_local_xtop -mode pvecadcompare -uitrail $trail_name -nographics -uirunmode $ENV{R_RUNMODE}";
      }
      else {
         $run_str="perl pvecadperform.pl $my_local_xtop -mode pvecadcompare -uitrail $trail_name -uirunmode $ENV{R_RUNMODE}";
      }   
      
   } elsif ($directives{pvvalidate_perform_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="perl pvecadperform.pl $my_local_xtop -mode pvvalidate -uitrail $trail_name -nographics -uirunmode $ENV{R_RUNMODE}";
      }
      else {
         $run_str="perl pvecadperform.pl $my_local_xtop -mode pvvalidate -uitrail $trail_name -uirunmode $ENV{R_RUNMODE}";
      }   
   } elsif ($directives{otk_cpp_test}) {
      $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS}";
   } elsif ($directives{otk_cpp_async_test}) {
       warn "xtop isn't run for otk_cpp_async_tests\n";
       $result = 1;
   } elsif ($directives{pyautogui_test}) {
      add_to_saveas("AUTOGUI_REPORTS");
      add_to_saveas("ExecutedCdImages.json");
      `$cp_cmd $ENV{PTC_TOOLS}/gui_automation/* .`;
      
      if ($ENV{R_ALT_GUI_AUTOMATION_DIR} ne '') {
        $alt_gui_dir = `cygpath -m ${R_ALT_GUI_AUTOMATION_DIR}`;
        chomp($alt_gui_dir);
        if (-d "$alt_gui_dir") {
           print "copying $alt_gui_dir data \n";
           `$cp_cmd $alt_gui_dir/* .`;
        } else {
           print "$alt_gui_dir is missing \n";
        }
      }
      $run_str = "$ENV{PTC_TOOLS}/bin/ptc_py311 autoguiTestrunner.py -t $trail_name";
   } else {  
      $run_str="$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
   }
   
   if ($directives{backward_trail}) {
      opendir(TMPDIR, "$tmpdir");
      @file_list = readdir(TMPDIR);
      closedir(TMPDIR);
      foreach $f (@file_list) {
          if ($f =~ /\.cmp|\.res/) {
              print_succfail ("Deleting $f for backward trail\n");
              unlink ($f);
          }
      }
      if (exists $ENV{PTC_ADVAPPSLIB}) {
          $save_PTC_ADVAPPSLIB = $PTC_ADVAPPSLIB;
          print_succfail ("unsetenv PTC_ADVAPPSLIB for backward trail\n");
          delete $ENV{PTC_ADVAPPSLIB};
      }
      if (exists $ENV{PRO_RES_DIRECTORY}) {
          $save_PRO_RES_DIRECTORY = $PRO_RES_DIRECTORY;
          print_succfail ("unsetenv PRO_RES_DIRECTORY for backward trail\n");
          delete $ENV{PRO_RES_DIRECTORY};
      }
      delete $ENV{LOCALPROE};
      print_succfail("Running backward_trail test with $backward_cmd\n");
      $run_str="$backward_cmd $my_run_mode $ENV{R_GRAPHICS} 1 $trail_name";
   }

   if ($directives{xtop_add_args}) {
      if ($directives{otk_cpp_test}) {
        my @OTKOBJS = ("$PTC_REGOBJS/spg/objects/test/otk_cpp_tests");
        my @PTKOBJS = ("$PTC_REGOBJS/spg/objects/test/protoolkit");
        my @OTKTSTS = ("$PTCSRC/test/otk_cpp_tests");
        
        if (defined $ENV{R_ALT_TRAIL_PATH}){
          $OTK_TEST_DIR = "$R_ALT_TRAIL_PATH/test/otk_cpp_tests";
          unshift (@OTKTSTS, $OTK_TEST_DIR);
        }
        
        if ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
          $PROJDIR = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}";
          $OTK_OBJ_DIR = "$PROJDIR/reg/spg/objects/test/otk_cpp_tests";
          unshift (@OTKOBJS, $OTK_OBJ_DIR);
          $PTK_OBJ_DIR = "$PROJDIR/reg/spg/objects/test/protoolkit";
          unshift (@PTKOBJS, $PTK_OBJ_DIR);
          $OTK_TEST_DIR = "$PROJDIR/test/otk_cpp_tests";
          unshift (@OTKTSTS, $OTK_TEST_DIR);
        }
        my %otksubs = (
          OTKOBJ => \@OTKOBJS,
          PTKOBJ => \@PTKOBJS,
          OTKTST => \@OTKTSTS,
        );
       while ($xtop_args =~ m!%(\w+)/(\S+)!) {
          ($otkstr) = grep(-f || -d , map "$_/$2", @{$otksubs{$1}});
          if ($otkstr) { 
            $xtop_args =~ s!%(\w+)/(\S+)!$otkstr!; 
          }
          else {
             print_fail("skipped:: #skipped $raw_trailname because - NO SUBSTITUTION FOUND for %$1/$2\n");
		     print_fail("\nSkip following tests\n");
             print_skip_msg("\nSkip following tests\n");
		     print_skip_msg("skipped::  #skipped $raw_trailname\n");
			 print_fail("skipped#$trailfile\n");
			 print_fail("skipped::  #skipped $raw_trailname\n");
            $xtop_args =~ s!%(\w+)!CHECK_THIS_ARG!;
		   	
			if ($dcad_server ne "") {
              if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
                $check_stat = 0;
                $check_stat = basic_check_for_dauto_run();
                if ($check_stat) {
                   print "DAUTO -reportfailure SKIPPED - not reporting FAILURE for $raw_trailname\n";
                   print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
                  exit($check_stat);   
                }
              }
			   print "DAUTO -reportfailure SKIPPED\n";
			   system ("$dcad_server -reportfalure SKIPPED");	
		   }
            return (-1);
          }
		  
        }         
      }
      
      $run_str="$run_str $xtop_args";
      $xtop_args = "";
   }

   if ($directives{script_test}) {
      print_succfail("Running script test\n");
      $run_str= "./".$raw_trailname.".csh";
   }
   
   #For converting frontslash in environment value to backslash.
   if ($directives{env_replace_fslash}) {
		if ($OS_TYPE eq "NT") {
			$envvalue=$ENV{$envname};
			$envvalue =~ s/\//\\/g;
			$ENV{$envname}=$envvalue;
			print_succ("env_replace_fslash:: converted $envname enviornment value to $ENV{$envname}.\n");
		}
   }
   
  #For registration/un-registration of CAD tool with WWGM and copy the macro file to current directory based on the flag set for directive #wwgmint_test.
    if ($directives{wwgmint_test}) 	{
	
		#Check for environment which needs to be used for automation run.
		if (defined $ENV{R_WWGMINT_CADVERSION}) {			
			$cadname = $ENV{R_WWGMINT_CADVERSION}	   
		}	
	
		if ($cadname) {
		 my %cad_install_registry = (		            
			"ac2013" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R19.0//ACAD-B001:409", "versionname" => "AutoCAD 2013"},
			"ac2014" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R19.1//ACAD-D001:409", "versionname" => "AutoCAD 2014"},
			"ac2015" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R20.0//ACAD-E001:409", "versionname" => "AutoCAD 2015"},
			"ac2016" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R20.1//ACAD-F001:409", "versionname" => "AutoCAD 2016"},
			"ac2017" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R21.0//ACAD-0001:409", "versionname" => "AutoCAD 2017"},
			"ac2018" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R22.0//ACAD-1001:409", "versionname" => "AutoCAD 2018"},
			"ac2019" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R23.0//ACAD-2001:409", "versionname" => "AutoCAD 2019"},
			"ace2013" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R19.0//ACAD-B007:409", "versionname" => "AutoCAD Electrical 2013"},
			"ace2014" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R19.1//ACAD-D007:409", "versionname" => "AutoCAD Electrical 2014"},
			"ace2015" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R20.0//ACAD-E007:409", "versionname" => "AutoCAD Electrical 2015"},
			"ace2016" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R20.1//ACAD-F007:409", "versionname" => "AutoCAD Electrical 2016"},		
			"ace2017" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R21.0//ACAD-0007:409", "versionname" => "AutoCAD Electrical 2017"},		
			"ace2018" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R22.0//ACAD-1007:409", "versionname" => "AutoCAD Electrical 2018"},
			"ace2019" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R23.0//ACAD-2007:409", "versionname" => "AutoCAD Electrical 2019"},
			"acm2013" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R19.0//ACAD-B005:409", "versionname" => "AutoCAD Mechanical 2013"},
			"acm2014" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R19.1//ACAD-D005:409", "versionname" => "AutoCAD Mechanical 2014"},
			"acm2015" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R20.0//ACAD-E005:409", "versionname" => "AutoCAD Mechanical 2015"},
			"acm2016" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R20.1//ACAD-F005:409", "versionname" => "AutoCAD Mechanical 2016"},
			"acm2017" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R21.0//ACAD-0005:409", "versionname" => "AutoCAD Mechanical 2017"},		
			"acm2018" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R22.0//ACAD-1005:409", "versionname" => "AutoCAD Mechanical 2018"},
			"acm2019" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//AutoCAD//R23.0//ACAD-2005:409", "versionname" => "AutoCAD Mechanical 2019"},
			"sw2013" => {"key" => "HKEY_CURRENT_USER//Software//SolidWorks//SolidWorks 2013//General//Last Run SolidWorks", "versionname" => "SolidWorks 2013"},
			"sw2014" => {"key" => "HKEY_CURRENT_USER//Software//SolidWorks//SolidWorks 2014//General//Last Run SolidWorks", "versionname" => "SolidWorks 2014"},
			"sw2015" => {"key" => "HKEY_CURRENT_USER//Software//SolidWorks//SolidWorks 2015//General//Last Run SolidWorks", "versionname" => "SolidWorks 2015"},
			"sw2016" => {"key" => "HKEY_CURRENT_USER//Software//SolidWorks//SolidWorks 2016//General//Last Run SolidWorks", "versionname" => "SolidWorks 2016"},
			"sw2017" => {"key" => "HKEY_CURRENT_USER//Software//SolidWorks//SolidWorks 2017//General//Last Run SolidWorks", "versionname" => "SolidWorks 2017"},
			"sw2018" => {"key" => "HKEY_CURRENT_USER//Software//SolidWorks//SolidWorks 2018//General//Last Run SolidWorks", "versionname" => "SolidWorks 2018"},
			"ai2013" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion17.0", "versionname" => "Inventor 2013"},
			"ai2014" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion18.0", "versionname" => "Inventor 2014"},
			"ai2015" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion19.0", "versionname" => "Inventor 2015"},
			"ai2016" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion20.0", "versionname" => "Inventor 2016"},
			"ai2017" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion21.0", "versionname" => "Inventor 2017"},
			"ai2018" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion22.0", "versionname" => "Inventor 2018"},
			"ai2019" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Autodesk//Inventor//RegistryVersion23.0", "versionname" => "Inventor 2019"},
			"ugnx8"  => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Unigraphics Solutions//NX//8.0", "versionname" => "NX 8"},
			"ugnx85" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Unigraphics Solutions//NX//8.5", "versionname" => "NX 8.5"},
			"ugnx9"  => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Unigraphics Solutions//NX//9.0", "versionname" => "NX 9"},
			"ugnx10" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Unigraphics Solutions//NX//10.0","versionname" => "NX 10"},				
			"ugnx11" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Unigraphics Solutions//NX//11.0","versionname" => "NX 11"},	
			"ugnx12" => {"key" => "HKEY_CURRENT_USER//SOFTWARE//Unigraphics Solutions//NX//12.0","versionname" => "NX 12"},
			"ccd1900" => {"key" => "HKEY_CURRENT_USER//Software//PTC//Drafting//19.0","versionname" => "Creo Elements/Direct Drafting 19.0"},
			"ccd2000" => {"key" => "HKEY_CURRENT_USER//Software//PTC//Drafting//20.0","versionname" => "Creo Elements/Direct Drafting 20.0"},				
			"ccd2010" => {"key" => "HKEY_CURRENT_USER//Software//PTC//Drafting//20.1","versionname" => "Creo Elements/Direct Drafting 20.1"},
			"ccm1900" => {"key" => "HKEY_CURRENT_USER//Software//CoCreate","versionname" => "Creo Elements/Direct Modeling 19.0"},
			"ccm2000" => {"key" => "HKEY_CURRENT_USER//Software//CoCreate","versionname" => "Creo Elements/Direct Modeling 20.0"},				
			"ccm2010" => {"key" => "HKEY_CURRENT_USER//Software//CoCreate","versionname" => "Creo Elements/Direct Modeling 20.1"},
			"mcd14" => {"key" => "HKEY_CURRENT_USER//Software//MathSoft//Mathcad 14","versionname" => "Mathcad 14"},
			"mcdpr01" => {"key" => "HKEY_CURRENT_USER//Software//PTC//Mathcad Prime","versionname" => "Mathcad Prime"},
			#For CADDS5 need to get the key. Need to update below
			"ucac5r161" => {"key" => "HKEY_CURRENT_USER//Software","versionname" => "CADDS5"}, 
		);		

		if ($OS_TYPE eq "NT") {
			my $is_cadtool_installed="false";
			if (exists($cad_install_registry{$cadname}{"key"})) {
				$Registry->Delimiter("//");				
				$is_cadtool_installed = "true" if ($Registry->{$cad_install_registry{$cadname}{"key"}});				
			}
	
			if (! defined $ENV{R_WWGMINT_ENABLE}) {				  
			    print_succ("skipped::  #skipped $raw_trailname test because R_WWGMINT_ENABLE is not set to true.\n");
				print_skip_msg("skipped::  #skipped $raw_trailname test because R_WWGMINT_ENABLE is not set to true.\n");
				return (1);
			}
			
			if ($is_cadtool_installed eq "false"){
			   print_succ("skipped::  #skipped $raw_trailname test because " . $cad_install_registry{$cadname}{"versionname"} . " authoring application is not installed or CAD registry profile is not created.\n");
			   print_skip_msg("skipped::  #skipped $raw_trailname test because " . $cad_install_registry{$cadname}{"versionname"} . " authoring application is not installed or CAD registry profile is not created.\n");
			   return (1);			
			}
			
			my $uwgmregister_path = "$PTC_TOOLS/uwgmmacros/uwgmregister.exe";
			if ($registered_cadtool ne $cadname){
				if (substr($cadname,0, 4) eq "ugnx") {
					$ENV{"PTC_WF_ROOT"} = "$rundir/NX_WF_ROOT_DIR";
					$ENV{"UGII_CUSTOM_DIRECTORY_FILE"} = "$rundir/NX_WF_ROOT_DIR/custom_dirs.dat";
				}
				my @uwgm_unregister_args = ($uwgmregister_path,"-u");
				system(@uwgm_unregister_args);
				
				if (substr($cadname,0, 4) eq "ugnx") {
					` $rm_cmd -rf "$rundir/NX_WF_ROOT_DIR"` if (-e "$rundir/NX_WF_ROOT_DIR");
					if (! -d "$rundir/NX_WF_ROOT_DIR") {
						mkdir ("$rundir/NX_WF_ROOT_DIR", 0777);
					}					
					open(ugii_cust_file,">>$rundir/NX_WF_ROOT_DIR/custom_dirs.dat");
					close ugii_cust_file;					
				}
				
				my @uwgm_args = ($uwgmregister_path,"-a");
				system(@uwgm_args);
				my @uwgmreg_args = ($uwgmregister_path,"-r",$cadname);
				system(@uwgmreg_args);
				$registered_cadtool=$cadname;
				$ENV{"PTC_WF_ROOT"} = "$tmpdir/WF_ROOT_DIR"
			}
			
			#For NX Sys Logs/Reuse XML Files/Temp files need to set $UGII_TMP_DIR.
			if (substr($cadname,0, 4) eq "ugnx") {
				if (! -d "$tmpdir/nx_tmp_dir") {
					mkdir ("$tmpdir/nx_tmp_dir", 0777);
				}
				my $nxconvtmpdir = "$tmpdir/nx_tmp_dir";
				$nxconvtmpdir =~ s/\//\\/;
				$ENV{UGII_TMP_DIR} = "$nxconvtmpdir";			
				$ENV{UGII_KEEP_SYSTEM_LOG} = "Yes";	
			}
			
		}
		my %cad_macro = (
			"ac2013", "acad_2013.dvb",
			"ac2014", "acad_2014.dvb",
			"ac2015", "acad_2015.dvb",
			"ac2016", "acad_2016.dvb",
			"ac2017", "acad_2017.dvb",
			"ac2018", "acad_2018.dvb",
			"ac2019", "acad_2019.dvb",			
			"ace2013", "acad_2013.dvb",
			"ace2014", "acad_2014.dvb",
			"ace2015", "acad_2015.dvb",
			"ace2016", "acad_2016.dvb",
			"ace2017", "acad_2017.dvb",
			"ace2018", "acad_2018.dvb",
			"ace2019", "acad_2019.dvb",			
			"acm2013", "acad_2013.dvb",
			"acm2014", "acad_2014.dvb",
			"acm2015", "acad_2015.dvb",
			"acm2016", "acad_2016.dvb",
			"acm2017", "acad_2017.dvb",
			"acm2018", "acad_2018.dvb",
			"acm2019", "acad_2019.dvb",
			"sw2013", "swx2013.swp",
			"sw2014", "swx2014.swp",
			"sw2015", "swx2015.swp",
			"sw2016", "swx2016.swp",
			"sw2017", "swx2017.swp",
			"sw2018", "swx2018.swp",
			"ai2013", "inv_2013.ivb",
			"ai2014", "inv_2014.ivb",
			"ai2015", "inv_2015.ivb",
			"ai2016", "inv_2016.ivb",
			"ai2017", "inv_2017.ivb",
			"ai2018", "inv_2018.ivb",
			"ai2019", "inv_2019.ivb",
			"ugnx8", "nx8.dll",
			"ugnx85", "nx85.dll",
			"ugnx9", "nx9.dll",
			"ugnx10", "nx10.dll",		
			"ugnx11", "nx11.dll",
			"ugnx12", "nx12.dll",	
			"mcd14", "mcd.vbs",
		);
		my %macro_name = (
			"ac2013", "acad.dvb",
			"ac2014", "acad.dvb",
			"ac2015", "acad.dvb",
			"ac2016", "acad.dvb",
			"ac2017", "acad.dvb",
			"ac2018", "acad.dvb",
			"ac2019", "acad.dvb",
			"ace2013", "acad.dvb",
			"ace2014", "acad.dvb",
			"ace2015", "acad.dvb",
			"ace2016", "acad.dvb",
			"ace2017", "acad.dvb",
			"ace2018", "acad.dvb",
			"ace2019", "acad.dvb",
			"acm2013", "acad.dvb",
			"acm2014", "acad.dvb",
			"acm2015", "acad.dvb",
			"acm2016", "acad.dvb",			
			"acm2017", "acad.dvb",
			"acm2018", "acad.dvb",
			"acm2019", "acad.dvb",
			"sw2013", "swx.swp",
			"sw2014", "swx.swp",
			"sw2015", "swx.swp",
			"sw2016", "swx.swp",
			"sw2017", "swx.swp",
			"sw2018", "swx.swp",
			"ai2013", "inv.ivb",
			"ai2014", "inv.ivb",
			"ai2015", "inv.ivb",
			"ai2016", "inv.ivb",
			"ai2017", "inv.ivb",
			"ai2018", "inv.ivb",
			"ai2019", "inv.ivb",
			"ugnx8",  "nxmacro.dll",
			"ugnx85", "nxmacro.dll",
			"ugnx9",  "nxmacro.dll",
			"ugnx10", "nxmacro.dll",					
			"ugnx11", "nxmacro.dll",		
			"ugnx12", "nxmacro.dll",
			"mcd14", "mcd.vbs",			
		);
		
		my %scripts = (
			"ac2013", "acad_2013.scr",
			"ac2014", "acad_2014.scr",
			"ac2015", "acad_2015.scr",
			"ac2016", "acad_2016.scr",
			"ac2017", "acad_2017.scr",
			"ac2018", "acad_2018.scr",
			"ac2019", "acad_2019.scr",
			"ace2013", "acad_2013.scr",
			"ace2014", "acad_2014.scr",
			"ace2015", "acad_2015.scr",
			"ace2016", "acad_2016.scr",
			"ace2017", "acad_2017.scr",	
			"ace2018", "acad_2018.scr",	
			"ace2019", "acad_2019.scr",	
			"acm2013", "acad_2013.scr",
			"acm2014", "acad_2014.scr",
			"acm2015", "acad_2015.scr",
			"acm2016", "acad_2016.scr",	
			"acm2017", "acad_2017.scr",	
			"acm2018", "acad_2018.scr",	
			"acm2019", "acad_2019.scr",	
			"sw2013", "swx_2013.bat",
			"sw2014", "swx_2014.bat",
			"sw2015", "swx_2015.bat",
			"sw2016", "swx_2016.bat",
			"sw2017", "swx_2017.bat",
			"sw2018", "swx_2018.bat",
			"ai2013", "inv_2013.txt",
			"ai2014", "inv_2014.txt",
			"ai2015", "inv_2015.txt",
			"ai2016", "inv_2016.txt",
			"ai2017", "inv_2017.txt",
			"ai2018", "inv_2018.txt",
			"ai2019", "inv_2019.txt",
			"ugnx8",  "load_options_ugnx8.def",
			"ugnx85", "load_options_ugnx85.def",
			"ugnx9",  "load_options_ugnx9.def",
			"ugnx10", "load_options_ugnx10.def",
			"ugnx11", "load_options_ugnx11.def",	
			"ugnx12", "load_options_ugnx12.def",			
		);
		
		my %startup_file = (
			"ac2013", "acad_startup.scr",
			"ac2014", "acad_startup.scr",
			"ac2015", "acad_startup.scr",
			"ac2016", "acad_startup.scr",
			"ac2017", "acad_startup.scr",
			"ac2018", "acad_startup.scr",
			"ac2019", "acad_startup.scr",			
			"ace2013", "acad_startup.scr",
			"ace2014", "acad_startup.scr",
			"ace2015", "acad_startup.scr",
			"ace2016", "acad_startup.scr",
			"ace2017", "acad_startup.scr",
			"ace2018", "acad_startup.scr",
			"ace2019", "acad_startup.scr",
			"acm2013", "acad_startup.scr",
			"acm2014", "acad_startup.scr",
			"acm2015", "acad_startup.scr",
			"acm2016", "acad_startup.scr",
			"acm2017", "acad_startup.scr",
			"acm2018", "acad_startup.scr",
			"acm2019", "acad_startup.scr",
			"sw2013", "swx_startup.bat",
			"sw2014", "swx_startup.bat",
			"sw2015", "swx_startup.bat",
			"sw2016", "swx_startup.bat",
			"sw2017", "swx_startup.bat",
			"sw2018", "swx_startup.bat",
			"ai2013", "inv_startup.xml",
			"ai2014", "inv_startup.xml",
			"ai2015", "inv_startup.xml",
			"ai2016", "inv_startup.xml",
			"ai2017", "inv_startup.xml",
			"ai2018", "inv_startup.xml",
			"ai2019", "inv_startup.xml",
			"ugnx8",  "load_options.def",
			"ugnx85", "load_options.def",
			"ugnx9",  "load_options.def",
			"ugnx10", "load_options.def",
			"ugnx11", "load_options.def",
			"ugnx12", "load_options.def",				
		);
		
		my $currentDirectoryPath = cwd();
		if (exists($cad_macro{$cadname})) {
			#NX Specific settings
			if (substr($cadname,0, 4) eq "ugnx") {
				#Added for old NX macro.
				my %nx_cad_macro;
				$nx_cad_macro{"ugnx8"}{bit32} = "NX8_32bit.dll";
				$nx_cad_macro{"ugnx8"}{bit64} = "NX8_64bit.dll";
				
				$nx_cad_macro{"ugnx85"}{bit32} = "NX8.5_32bit.dll";
				$nx_cad_macro{"ugnx85"}{bit64} = "NX8.5_64bit.dll";
				
				$nx_cad_macro{"ugnx9"}{bit64} = "NX9_64bit.dll";
				$nx_cad_macro{"ugnx10"}{bit64} = "NX10_64bit.dll";
				$nx_cad_macro{"ugnx11"}{bit64} = "NX11_64bit.dll";
				$nx_cad_macro{"ugnx12"}{bit64} = "NX12_64bit.dll";
					
				if ($PRO_MACHINE_TYPE ne "i486_nt") {	
					copy ("$PTC_TOOLS\/uwgmmacros\/$nx_cad_macro{$cadname}{bit64}", "$currentDirectoryPath\/nx.dll");	
				}
				else {
					copy ("$PTC_TOOLS\/uwgmmacros\/$nx_cad_macro{$cadname}{bit32}", "$currentDirectoryPath\/nx.dll");	
				}
				
				#For copying WWGMTK testing.
				my %nx_wwgmtk_dll;
				$nx_wwgmtk_dll{"ugnx10"} = "wwgmtkugcadcustomtest_ugnx10.dll";
				$nx_wwgmtk_dll{"ugnx11"} = "wwgmtkugcadcustomtest_ugnx11.dll";
				$nx_wwgmtk_dll{"ugnx12"} = "wwgmtkugcadcustomtest_ugnx12.dll";
				
				copy ("$PTC_TOOLS\/uwgmmacros\/$nx_wwgmtk_dll{$cadname}", "$currentDirectoryPath\/wwgmtkugcadcustomtest.dll");	
			
				#For NX Configuration files 
				my %nx_cust_files = (
				  "ugnx9" => {
								  "DpvFile" => "NX90_user.dpv",
								  "XslFile" => "NX90_user.xsl",
							  },
				  "ugnx10" => {
								  "DpvFile" => "NX100_user.dpv",
								  "XslFile" => "NX100_user.xsl",
							  },
				  "ugnx11" => {
								  "DpvFile" => "NX110_user.dpv",
								  "XslFile" => "NX110_user.xsl",
							  },
				  "ugnx12" => {
								  "DpvFile" => "NX120_user.dpv",
								  "XslFile" => "NX120_user.xsl",
							  }
				);
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$nx_cust_files{$cadname}{"DpvFile"},"$currentDirectoryPath\/".$nx_cust_files{$cadname}{"DpvFile"});	
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$nx_cust_files{$cadname}{"XslFile"},"$currentDirectoryPath\/".$nx_cust_files{$cadname}{"XslFile"});	
				
				#Set NX load option and user defaults
				$ENV{UGII_LOAD_OPTIONS}="$currentDirectoryPath\/load_options.def";				
				$ENV{UGII_LOCAL_USER_DEFAULTS}="$currentDirectoryPath\/".$nx_cust_files{$cadname}{"DpvFile"};
			}	
						
			copy ("$PTC_TOOLS\/uwgmmacros\/$cad_macro{$cadname}", "$currentDirectoryPath\/$macro_name{$cadname}");	
			copy ("$PTC_WGM_ROOT\/.Settings\/appregistry.xml", "$currentDirectoryPath\/appregistry.xml");
			copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/$scripts{$cadname}", "$currentDirectoryPath\/$startup_file{$cadname}");	
			
		}
		
		#For CoCreate Modeling: Copy default files
			if (substr($cadname,0, 3) eq "ccm") {
			my %ccm_cust_files = (
				  "ccm1900" => {
								  "folderName" => "ccm_19.0",
								  "appPathFolder" => "Creo Elements Direct Modeling 19.0",
								  "versionName" => "19.0"
							  },
				  "ccm2000" => {
								  "folderName" => "ccm_20.0",
								  "appPathFolder" => "Creo Elements Direct Modeling 20.0",
								  "versionName" => "20.0"
							  },
				  "ccm2010" => {
								  "folderName" => "ccm_20.1" ,
								  "appPathFolder" => "Creo Elements Direct Modeling 20.1",
								  "versionName" => "20.1"
							  }							  
				  
				);
				
				my $appdata = $ENV{appdata}; 
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$ccm_cust_files{$cadname}{"folderName"}."\/"."all_data.lsp" ,"$appdata\/PTC\/".$ccm_cust_files{$cadname}{"appPathFolder"}."\/".$ccm_cust_files{$cadname}{"versionName"}."\/"."all_data.lsp" );	
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$ccm_cust_files{$cadname}{"folderName"}."\/"."cfg_data.lsp" ,"$appdata\/PTC\/".$ccm_cust_files{$cadname}{"appPathFolder"}."\/".$ccm_cust_files{$cadname}{"versionName"}."\/"."cfg_data.lsp" );	
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$ccm_cust_files{$cadname}{"folderName"}."\/"."sd_browser_search_and_filter.lsp" ,"$appdata\/PTC\/".$ccm_cust_files{$cadname}{"appPathFolder"}."\/".$ccm_cust_files{$cadname}{"versionName"}."\/"."sd_browser_search_and_filter.lsp" );	
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$ccm_cust_files{$cadname}{"folderName"}."\/"."sd_data.lsp" ,"$appdata\/PTC\/".$ccm_cust_files{$cadname}{"appPathFolder"}."\/".$ccm_cust_files{$cadname}{"versionName"}."\/"."sd_data.lsp" );	
						
			}	
		
		#For CoCreate Drafting: Copy default files
			if (substr($cadname,0, 3) eq "ccd") {
			my %ccd_cust_files = (
				  "ccd1900" => {
								  "folderName" => "ccd_19.0",
								  "appPathFolder" => "Creo Elements Direct Drafting 19.0",
								  "versionName" => "19.0"
							  },
				  "ccd2000" => {
								  "folderName" => "ccd_20.0",
								  "appPathFolder" => "Creo Elements Direct Drafting 20.0",
								  "versionName" => "20.0"
							  },
				  "ccd2010" => {
								  "folderName" => "ccd_20.1" ,
								  "appPathFolder" => "Creo Elements Direct Drafting 20.1",
								  "versionName" => "20.1"
							  }							  
				  
				);
				
				my $appdata = $ENV{appdata}; 
				copy ("$PTC_TOOLS\/uwgmmacros\/cad_startup\/".$ccd_cust_files{$cadname}{"folderName"}."\/"."environment.m" ,"$appdata\/PTC\/".$ccd_cust_files{$cadname}{"appPathFolder"}."\/".$ccd_cust_files{$cadname}{"versionName"}."\/"."environment.m" );	
										
			}	

			
				#Replace WWGM version specific QCR/XML files and folders.
		if (defined $ENV{R_WWGM_RELEASE}) {			
			$wwgm_release = $ENV{R_WWGM_RELEASE};	   
			my $replaceReleaseStr = "_" . $wwgm_release;
			my @fileList = glob "$currentDirectoryPath\/*" . $wwgm_release ."*";

			foreach (@fileList) {
				my $oldname_withrelease = $_;
				s/$replaceReleaseStr//;
				rename $oldname_withrelease, $_ ;			   
			}
		}
		#Replace CAD version specific QCR/XML files and folders.
		my $replaceStr = "_" . $cadname;
		my @fileList = glob "$currentDirectoryPath\/*" . $cadname ."*";

		foreach (@fileList) {
			my $oldname = $_;
			s/$replaceStr//;
			rename $oldname, $_ ;			   
		}
		
	}
   }
   
   
   if ($directives{uwgm_test}) {
     my $trailname_as_stored = $raw_trailname;
     my $uwgm_bkup_file = "./" . $raw_trailname . ".txt";
     
     $trailname_as_stored =~ s/.*\+//;
     my $uwgm_trail_file = "./" . $trailname_as_stored . ".txt";
     if ($ENV{FASTREG_DEBUG} != "") {
        my $currentDirectoryPath = cwd();
        print_succfail("    Current directory = '$currentDirectoryPath'\n");
        print_succfail("       \$uwgm_trail_file = '$uwgm_trail_file'\n");
        print_succfail("       \$uwgm_bkup_file  = '$uwgm_bkup_file'\n");
        print_succfail("       \$raw_trailname   = '${raw_trailname}'\n");
     } 
     #`$cp_cmd $uwgm_trail_file $uwgm_bkup_file`;
     #`$rm_cmd $uwgm_trail_file`;
     print_succfail("Calling Uwgmreg::TrailSubstitutionByEnv($uwgm_bkup_file, $uwgm_trail_file)\n");
     if (! Uwgmreg::TrailSubstitutionByEnv($uwgm_bkup_file, $uwgm_trail_file)) {
         my $msg = "Problem in additional trail substitutions for UWGM test\n";
         print_fail($msg);
         return 0;
     }
     $uwgm_script = "./".$trailname_as_stored.".csh";
     if ($ENV{R_GRAPHICS} eq "0") {
         $run_str="$uwgm_script -nographics";
      } else {
         $run_str="$uwgm_script";
      }
      print "run_str is $run_str\n";
      Uwgmreg::TimeoutWatchStart();
      print "Uwgmreg::TimeoutWatchStart() in auto.txt\n";
   }

   # RSD test directive --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   if ($directives{rsd_test} && $ENV{RSD_DGE_CREATION} eq 'true') {
     $run_str = "$my_local_xtop $my_run_mode $ENV{R_GRAPHICS} 1 new_export_trail.txt";
     add_to_saveas('.dge');
   } elsif ($directives{rsd_test}) {
        $run_str="$my_local_xtop -uitrail $trail_name";
        $ENV{RSD_TRAIL_PLAY_EXIT}="true";
        $ENV{UI_NO_SPLASH}="true";
   }
   
   if ($directives{rsd_test}) {
       if ((not defined $ENV{PTC_D_LICENSE_FILE}) || $ENV{PTC_D_LICENSE_FILE} == "") {
           #print "Warning: PTC_D_LICENSE_FILE not found : $ENV{PTC_D_LICENSE_FILE}\n";
           $ENV{PTC_D_LICENSE_FILE} = $auto_license_file;
           #print "   Therefore setting PTC_D_LICENSE_FILE:$ENV{PTC_D_LICENSE_FILE}\n";
       }
   }
   # RSD test directive --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
   if ($directives{pglview_test}) {
      my $pglgraph = $ENV{'R_GRAPHICS'};
      my $pgltest = $trail_name;
      my $pglview_exe = '$PTCSYS/obj/pglview';

      $pgltest =~ s/\.txt$//g;
      $pglgraph = 0  if ($ENV{'R_GRAPHICS'} ne '11' || not defined $ENV{'R_GRAPHICS'});
      
      if (exists $ENV{R_PDEV_REGRES_BIN}) {
         $pglview_exe = get_pdev_exe( "pglview" );
      }
      
      $run_str = "$pglview_exe $pglgraph -t $pgltest";
      
      if ($directives{tk_flavor} && $tk_flavor_ ne "") {
         $run_str = $run_str . " -p " . $tk_flavor_;
      }
   }
   
   if ($directives{saas_test}) {
       my $saastest = $trail_name;

       $saas_script = "$ENV{PTC_TOOLS}/external/saas/saas-ptcagent-regtest.csh";
       if ($ENV{LOCAL_SAAS_SCRIPT} ne '') {
           $saas_script = "$ENV{LOCAL_SAAS_SCRIPT}";
       }
      
       $run_str = "${saas_script} -t $saastest --keep";
       if ($ENV{CREO_SAAS_TEST_FORCE_USE_SERVER} eq '' && $ENV{CREO_SAAS_TEST_REUSE_INSTALL} eq '') {
           my $my_local_xtop_dir = dirname $my_local_xtop;
           $run_str = $run_str . " -s -x $my_local_xtop_dir";
       }
   }

    if ($ENV{R_PERF} eq 'true' &&  $ENV{R_PERFVIEW} eq 'true') {
           $ENV{R_SAVEAS_ALWAYS} = 'true';

           if (defined $ENV{R_LOCAL_PF_PROFILE}) {
              $run_str_pv = $ENV{R_LOCAL_PF_PROFILE}; 
           } else {
              $run_str_pv = "$ENV{PTC_TOOLS}/scripts/perf_tools/bin/runperfview_profile";
           }
           
           if ($ENV{XTOP_PERF_SCRIPTS_DIR} eq '') {
               $ENV{XTOP_PERF_SCRIPTS_DIR} = "$ENV{PTC_TOOLS}/scripts/perf_tools";
           }

           if (not defined $ENV{_NT_SYMBOL_PATH}) {
              print "WARNING: _NT_SYMBOL_PATH not set\n";
              $ENV{_NT_SYMBOL_DIR} = "$ENV{HOME}\\SymbolCache\\perfview";
              #$ENV{_NT_SYMBOL_PATH} = "SRV*$ENV{HOME}\\SymbolCache\\perfview*http://msdl.microsoft.com/download/symbols";
              $ENV{_NT_SYMBOL_PATH} = "SRV*$ENV{_NT_SYMBOL_DIR}*http://msdl.microsoft.com/download/symbols";
              if (! -d "$ENV{HOME}/SymbolCache/perfview") {
               mkpath("$ENV{HOME}/SymbolCache/perfview",0777);
              }
              print "_NT_SYMBOL_PATH=$ENV{_NT_SYMBOL_PATH}\n";
           }

           if ($ENV{ALWAYS_CLEANUP_SYMBOL} eq 'true' && (-d $ENV{_NT_SYMBOL_DIR})) {
                  `rm -rf $ENV{_NT_SYMBOL_DIR}/* `;
           }
           
           $dact_name = "ALL";
           if ($ENV{PERF_ACTION_NAME} ne '') {
            $dact_name = "$ENV{PERF_ACTION_NAME}";
            $clean_setenv_cmds{'PERF_ACTION_NAME'} = $ENV{PERF_ACTION_NAME};            
           }
           ${act_name} = uc(${dact_name});

           if (! -f "$tmpdir/PERF_AGENDA") {
              `echo ${act_name} > $tmpdir/PERF_AGENDA`;
           }
           
           add_to_saveas("${raw_trailname}-PV-${act_name}");
           
           $run_str_pv = "$run_str_pv $act_name $trail_name $my_local_xtop ";
           $run_str = $run_str_pv;       
    }
    
    if ($ENV{R_PERF} eq 'true' &&  $ENV{R_PERFVS} eq 'true') {
           $ENV{R_SAVEAS_ALWAYS} = 'true';
           if (defined $ENV{R_LOCAL_VSDIAG}) {
              $run_str_pv = $ENV{R_LOCAL_VSDIAG};
           } else {
              $run_str_pv = "$ENV{PTC_TOOLS}/scripts/perf_tools/bin/runvsdiag";
           }

           if ($ENV{XTOP_PERF_SCRIPTS_DIR} eq '') {
               $ENV{XTOP_PERF_SCRIPTS_DIR} = "$ENV{PTC_TOOLS}/scripts/perf_tools";
           }
           
           if (not defined $ENV{_NT_SYMBOL_PATH}) {
              print "WARNING: _NT_SYMBOL_PATH not set\n";
              $ENV{_NT_SYMBOL_DIR} = "$ENV{HOME}\\SymbolCache\\vsdiag";
              #$ENV{_NT_SYMBOL_PATH} = "SRV*$ENV{HOME}\\SymbolCache\\vsdiag*http://msdl.microsoft.com/download/symbols";
              $ENV{_NT_SYMBOL_PATH} = "SRV*$ENV{_NT_SYMBOL_DIR}*http://msdl.microsoft.com/download/symbols";
              if (! -d "$ENV{HOME}/SymbolCache/vsdiag") {
               mkpath("$ENV{HOME}/SymbolCache/vsdiag",0777);
              }
              print "_NT_SYMBOL_PATH=$ENV{_NT_SYMBOL_PATH}\n";
           }

           if ($ENV{ALWAYS_CLEANUP_SYMBOL} eq 'true' && (-d $ENV{_NT_SYMBOL_DIR})) {
                  `rm -rf $ENV{_NT_SYMBOL_DIR}/* `;
           }
           
           if ($ENV{VSINSTALLDIR} eq "") {
              print "\n Warning: VSINSTALLDIR environment not set for VS profiler run \n";
              print "example:\n\nsetenv VSINSTALLDIR C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional \n\n";
              
              $VSINSTALLDIR_tmp = $ENV{'ProgramW6432'}.'\Microsoft Visual Studio\2022\Professional';
              $VSINSTALLDIR_tmp =~ s#\\#\\\\#g;
              if (-d "${VSINSTALLDIR_tmp}") {
                $ENV{VSINSTALLDIR} = "$VSINSTALLDIR_tmp";  
              }
              print "VSINSTALLDIR=$ENV{VSINSTALLDIR}\n";
           }
           
           $dact_name = "ALL";
           if ($ENV{PERF_ACTION_NAME} ne '') {
            $dact_name = "$ENV{PERF_ACTION_NAME}";
            $clean_setenv_cmds{'PERF_ACTION_NAME'} = $ENV{PERF_ACTION_NAME};            
           }
           ${act_name} = uc(${dact_name});

           if (! -f "$tmpdir/PERF_AGENDA") {
              `echo ${act_name} > $tmpdir/PERF_AGENDA`;
           }
           
           add_to_saveas("${raw_trailname}-VS-${act_name}");
            
           if ($ENV{R_USE_CREO_PLUS} eq "true") {
             $run_str_pv = "$run_str_pv $act_name $trail_name $my_local_xtop";            
           } else {
            if ($ENV{R_DONT_USE_VSDIAG_APIDLL} eq 'true') {
              $run_str_pv = "$run_str_pv $act_name $trail_name $my_local_xtop";
            } else {
              $run_str_pv = "$run_str_pv $act_name $trail_name $my_local_xtop use_dlls";
            }              
           }
           
           $run_str = $run_str_pv;       
    }
   
   if ( defined $ENV{R_WRAPPER_SCRIPT}) {
      $wrapped_run_str = "$ENV{R_WRAPPER_SCRIPT} $run_str";
      $run_str = $wrapped_run_str;
      }

   run_collab_other($run_str) if ($directives{shared_workspace} || $directives{atlas_user});

   if ($ENV{R_USEKEY} eq "true") {
      $start=&date_hmsmd;
      print "CREO_AGENT_HOME=$ENV{CREO_AGENT_HOME}\n" if (defined $ENV{CREO_AGENT_HOME});
      print "START TIME: $start\n";
      $run_str=`$ENV{R_KEYPATH} $my_run_mode $ENV{R_GRAPHICS} 1 $trailname`;
      $run_stat=system("$my_local_xtop $run_str >& $raw_trailname.msg");
   } else {
      if ($ENV{R_PURECOVOPTIONS} eq "true") {
         @CurRegTestName = split(/\./, $trail_name);
         $TestName = $CurRegTestName[0] . ".pcv";
         $ENV{PURECOVOPTIONS} = "-cache-dir=$R_PURECOV_CACHE_DIR -counts-file=../$TestName";
         print("PURECOVOPTIONS: $ENV{PURECOVOPTIONS}\n");
      }
      print "CREO_AGENT_HOME=$ENV{CREO_AGENT_HOME}\n" if (defined $ENV{CREO_AGENT_HOME});
      
      if (defined $ENV{R_USE_CREO_PLUS} && $ENV{R_USE_CREO_PLUS} eq "true") {
         $run_str =~ s|\\|\\\\|g ;
         
         if ( ($ENV{R_USE_SAAS_CONFIG_SERVICE} eq 'true') && ($is_next_testname) ) {
            upload_config_to_server();
         }
         print "CREO_SAAS_CONFIGS_AUTO_PREFIX_ID=$ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID}\n" if ($ENV{R_USE_SAAS_CONFIG_SERVICE} eq 'true');
         
         if (("$ENV{CREO_SAAS_APIKEY}" eq "") || ($ENV{R_SAAS_ALWAYS_RENEW_APIKEY} eq 'true')) {
            $ENV{R_SAAS_RENEW_APIKEY} = "false";
         } else {
            $ENV{R_SAAS_RENEW_APIKEY} = "true";  
         }

         if ($ENV{R_USE_CREO_PLUS} eq "true" && ($ENV{R_SAAS_RENEW_APIKEY} ne "true")) {
           if ( lc($ENV{CLUSTER_TYPE}) eq 'test' || $ENV{CREO_SAAS_TEST_SCRIPT_AUTH} eq "true") {
            print ("\n Renewing Creo SaaS APIKEY \n");
            creoplus_refresh_APIKEY();
           }
         }
         creoagent_start() if (not defined $ENV{R_SHARED_CREO_HOME});
      }

      print "running: $preexec$run_str\n";
      $start=&date_hmsmd;
	  $run_str =~ s|\\|\\\\|g if (defined $ENV{R_USE_CREO_PLUS} && $ENV{R_USE_CREO_PLUS} eq "true");
      print "START TIME: $start\n";
      if ($PRO_MACHINE_TYPE eq "i486_win95") {
         `$csh_cmd "z:/tools/bin/run_and_get_status $run_str"`;
         $run_stat = `cat $TEMP/status.log`;
         chop($run_stat);
      } else {
         if ($ENV{OS_TYPE} eq 'UNIX' ) {
            if ($directives{mech_test}) {
               `$csh_cmd "$run_str >& $raw_trailname.msg"`;
            } else {
               `$csh_cmd "$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl ${TOOLDIR}run_cmd.pl $preexec$run_str >& $raw_trailname.msg"`;
            }
         } else {
            #if ($directives{mech_test} || $directives{proevconf_test} || $directives{pt_asynchronous_tests} || $directives{distapps_dsm} || $directives{distapps_dbatchc}  || $directives{distapps_dsapi} || $directives{uwgm_test}) {
            if ($directives{mech_test}) {
               `$csh_cmd "$run_str >& $raw_trailname.msg"`;
            } else {
               `$csh_cmd "$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $r_nt_job_pl $run_str >& $raw_trailname.msg"`;
            }
         }
         $run_stat = $?;
         $run_stat = $run_stat >> 8 if ($run_stat >= 256);
         print "run_stat return val: $run_stat\n";
         if ($directives{otk_cpp_async_test}) {
           $run_stat = 0;
         }
      }
   }

   if ($directives{probatch_test}) {
      if (! $run_stat) {
         $run_str="$my_local_xtop $ENV{R_RUNMODE} $ENV{R_GRAPHICS} 1 proe_compare.txt";
         print "running: $run_str\n";
         `$csh_cmd "$run_str >& $raw_trailname.msg"`;
         $run_stat = $?;
      }
   }

   if ($directives{qcr_script} && $altlang eq "") {
      if (exists $qcr_script{$cur_test_num}) {
         print "Runn qcr_script $qcr_script{$cur_test_num}\n";
         `$csh_cmd "$qcr_script{$cur_test_num}"`;
         $run_stat = $?;
      }
   }
   if ($directives{uwgm_test}) {
      sleep 1;
      if (not Uwgmreg::isLocked()) {
         my $msg = "UWGM test has been timed out (" . Uwgmreg::getTimeoutSec() . " sec.)\n";
         print_fail($msg);
      } else {
         Uwgmreg::TimeoutWatchEnd();
      }
   }

   $stop=&date_hmsmd;
   print "STOP TIME: $stop\n";

   my ($server_is_reboot) = 0;
   my ($groove_import_vcard) = 0;
   my ($wrong_csd_server) = 0;
   my ($connect_time_out) = 0;
   my ($server_overload) = 0;
   my ($server_problem) = 0;
   $aflineno = ""; # actual fail line no
   $aftype = ""; # actual fail type

   if ($run_stat || $directives{fail}) {
      if ($run_stat) {
	    ($aflineno, $aftype) = get_fail_info("std.out") 
	  } elsif ($directives{fail}) {
	     my $FH;
	     open ($FH,">>std.out");
		 print $FH "Error: trail was #fail $eftype $eflineno, but ran successfully\n";
         close ($FH);		 
	  }

     if ($directives{fresh_creo_agent}) {
        my $FH;
        open ($FH,">>std.out");
        print $FH "CREO_AGENT_EXE_PATH:${CREO_AGENT_EXE_PATH}\n";
        print $FH "CREO_AGENT_LDP_LIST:${CREO_AGENT_LDP_LIST}\n";
        close ($FH);
     }
     
     if ($ENV{R_USE_CREO_PLUS} eq 'true') {
        my $FH;
        open ($FH,">>std.out");
        my @saas_envs = (grep /CREO_SAAS/, keys %ENV);
        foreach my $k (@saas_envs) {
           next if ($k =~ /PASSWORD/ || $k =~ /TOKEN/ || $k =~ /APIKEY/);
           print $FH  "$k=$ENV{$k}\n"; 
        }
        close ($FH);
     }

      $fail_no++;
      $result="FAILURE";
      if ($directives{run_with_license} && $oktofail) {
         if (is_oos_failure("$raw_trailname.msg", 0)) {
            $fail_no--;
            $result="SUCCESS";
         }
      }
	  
	  if ($directives{fail} && ($aftype eq $eftype) && ($aflineno eq $eflineno)) {
            $fail_no--;
            $result = "SUCCESS";
      }

      if ($directives{proevconf_test}) {
         if (is_server_problem("$raw_trailname.msg")) {
            $server_problem = 1;
         } elsif (is_server_is_reboot("$raw_trailname.msg")) {
            $server_is_reboot = 1;
         } elsif (is_groove_import_vcard("$raw_trailname.msg")) {
            $groove_import_vcard = 1;
         } elsif (is_wrong_csd_server("$raw_trailname.msg")) {
            $wrong_csd_server = 1;
         } elsif (is_connect_time_out("$raw_trailname.msg")) {
            $connect_time_out = 1;
         } elsif (is_server_overload("$raw_trailname.msg")) {
            $server_overload = 1;
         }
      }
   } else {
      if ($directives{run_with_license} && $oktofail) {
         $result="FAILURE";
      } else {
         if ($directives{backward_retr}) {
            if (is_last_trail($n)) {
               $is_backward_retr = 1;
               if (run_backward_retr($raw_trailname)) {
                  $result="SUCCESS";
               } else {
                  $result="FAILURE";
               }
            } else {
               $result="SUCCESS";
            }
         } else {
            $result="SUCCESS";
         }
      }
   }
   if ($TMP_DIR_DEBUG eq "true" && $run_stat == 0 && `ls -A $cur_dir/scratch_tmp` ne "") {
      $run_stat = 1;
      $result="FAILURE";
      `echo "files in TMPDIR not removed" >> $raw_trailname.msg`;
   }

   $runtime = get_runtime($start,$stop);
   $perf_runtime = $runtime if ($ENV{'R_PERF'} eq "true");

   if ($directives{proevconf_test}) {
      if ($result eq "FAILURE" || is_last_trail($n)) {
         if (exists $ENV{R_LOCAL_CSUTIL}) {
            $csutil="$ENV{R_LOCAL_CSUTIL}";
         } else {
            $csutil="$PTCSYS/obj/csutil";
         }
        `$csh_cmd ${TOOLDIR}csd_cleanup.csh $csutil`;
      }
   }
   
   if (-e "$cur_dir/scratch_tmp/collabsvc.log") {
      `$cp_cmd "$cur_dir/scratch_tmp/"collabsvc.log $tmpdir`;
   }
# check for failure of the second xtop for shared_workspace tests

if (($directives{shared_workspace}  && $shared_workspace_trail_size > 0 ) || ($directives{atlas_user} && $is_atlas_user_multi_session )) {
	  my $second_xtop_failed = "false";
	  my $oos = "Trail file out of sequence";
      $is_otheruser_xtop_only_fail = 0;
      my $result_bak = $result;
      if ($is_atlas_user_multi_session) {
         $shared_workspace_trail = $atlas_s2_trail_name;
      }
      

      rm_dbgfile_for_non_langtest();
      my @files;  
   if (-d "$cur_dir/${collab_other_pid}_otheruser") {
      #opendir(DIR,"$tmpdir\\other_user") or die "Cannot open $tmpdir\\other_user\n";
      opendir(DIR,"$cur_dir/${collab_other_pid}_otheruser");
      @files = readdir(DIR);
      closedir(DIR);
   } else {
     print "Error: $cur_dir/${collab_other_pid}_otheruser missing ($shared_workspace_trail)\n";
   }
   
      foreach my $file (@files) {
          $second_xtop_failed = "true" if ($file eq "traceback.log");      
          $second_xtop_failed = "true" if ($file eq "dbgfile.dat"); 
          
		  if ($file eq "trail.txt.1" || $file eq "std.out") {
	        #$second_xtop_failed = "true" if (is_oos_failure("$tmpdir\\other_user/$file", 1));
            $second_xtop_failed = "true" if (is_oos_failure("$cur_dir/${collab_other_pid}_otheruser/$file", 1));
		  }
      }	     
      
      if ($second_xtop_failed eq "true" || $result_bak eq 'FAILURE') {
         add_to_saveas('protractor_test.log');
         add_to_saveas("reports");
         add_to_saveas("${shared_workspace_trail}_otheruser");
         add_to_saveas("collabsvc.log");
      }
      
	  if ($second_xtop_failed eq "true") {
	   	  $result = "FAILURE";
		  $fail_no++;
          if ($result_bak eq 'SUCCESS')  {

             $is_otheruser_xtop_only_fail = 1;
             print("\nFailed due to collab otheruser xtop failure while second xtop passed . Please check otheruser folder\n");             
		     print_fail("Failed due to collab otheruser xtop failure while second xtop passed . Please check otheruser folder\n");
             # append std.out and trail.txt.1 to scratch's file
          } else  {
             print("\nFailed due to collab otheruser xtop failure while second xtop also failed . Please check both second and otheruser folder\n");
             print_fail("Failed due to collab otheruser xtop failure while second xtop also failed . Please check both second and otheruser folder\n");
          }
	  }      
}

  if ($result eq 'SUCCESS') {
    if (defined $ENV{R_VERIFY_SUCCESS}) {
       if ("$run_str" =~ /xtop.exe/ || "$run_str" =~ /parametric.exe/) {
         check_for_success();
       }
    }
  }	
if ((($directives{shared_workspace} || $directives{atlas_user} ) && (! $is_atlas_user_multi_session ) ) && $shared_workspace_trail eq '' && $result eq "FAILURE" ) {
    add_to_saveas('protractor_test.log');
    add_to_saveas("reports");
    add_to_saveas("collabsvc.log");
}
	  
   if ($existcheck) {
           if (-e "${raw_trailname}.truss") {
                my $trussstat = &ProcessTruss("$raw_trailname");
                my $deppath = "";
                if (defined $ENV{R_ALT_DEPEND_PATH}) {
                       print "NOTE: R_ALT_DEPEND_PATH is set, copying .${raw_trailname}.depend to $ENV{R_ALT_DEPEND_PATH}..\n";
                       $deppath = $ENV{R_ALT_DEPEND_PATH};
                } else {
                       $deppath = $cur_dir;
                }
                if ($trussstat) {
                        mkdir("$deppath", 0777) or
                             die "ERROR: can't write dir $deppath, $!\n" if (! -d "$deppath");
                        `$cp_cmd ${raw_trailname}.depend $deppath/`;
                }
                if (defined $ENV{R_SAVE_TRUSS}) {
                        print "   saving ${raw_trailname}.truss..\n";
                        `$cp_cmd ${raw_trailname}.truss $deppath/`;
                }
           } else {
                print "ERROR: no R_IF_EXIST_CHECK data was generated for ${raw_trailname}.txt .\n";
                print "Please file a Integration helpdesk case.\n";
           }
   }

   &post_run_process($trail_name,$raw_trailname);
   # Including post run script time as well for time taken by test. #29481
   $stop=&date_hmsmd;
   print "POST RUN SCRIPT FINISH TIME: $stop\n";
   $runtime = get_runtime($start,$stop);
   if (-e "${PTC_WF_ROOT}/.ssrd/CreoAgent") {
     print "WF_ROOT_DIR/.ssrd/CreoAgent exists. Does this test need to have directive fresh_creo_agent???\n";
   }
   if (-e "${PTC_WF_ROOT}/.ssrd/GenLWSC") {
     print "WF_ROOT_DIR/.ssrd/GenLWSC exists. Does this test need to have directive fresh_creo_agent???\n";
   }

   if ($result eq "FAILURE") {
      `cat "$tmpdir/prodev.dat" >> fail.log` if (-e "$tmpdir/prodev.dat");
      if ($groove_import_vcard) {
         print_fail("skipped::  #skipped because groove import vcard problem\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because groove import vcard problem\n");
         print_fail("skipped#$trailfile\n");
         print_fail("$result\n");
      } elsif ($wrong_csd_server) {
         print_fail("skipped::  #skipped because csd server version is incompatible\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because csd server version is incompatible\n");
         print_fail("skipped#$trailfile\n");
         print_fail("$result\n");
      } elsif ($server_overload) {
         print_fail("skipped::  #skipped because of server overload\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because of server overload\n");
         print_fail("skipped#$trailfile\n");
         print_fail("$result\n");
      } elsif ($connect_time_out) {
         print_fail("skipped::  #skipped because connection timed out\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because connection timed out\n");
         print_fail("skipped#$trailfile\n");
         print_fail("$result\n");
      } elsif ($server_is_reboot) {
         print_fail("skipped::  #skipped because ConfServer has been rebooted - please rerun the test\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because ConfServer has been rebooted - please rerun the test\n");
         print_fail("skipped#$trailfile\n");
         print_fail("$result\n");
      } elsif ($server_problem) {
         print_fail("skipped::  #skipped because server has problem - please rerun the test\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because server has problem - please rerun the test\n");
         print_fail("skipped#$trailfile\n");
         print_fail("$result\n");
      } else {
     if ($num_legacy_test == 1 && $dcad_server ne "") {
            ### Report all successes to DAUTO server as these are not reported
        for ($j = 0; $j < $cur_test_num; $j++) {
            
          if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
            $check_stat = 0;
            $check_stat = basic_check_for_dauto_run();
            if ($check_stat) {
              print "DAUTO -reportsuccess  legacy test - not reporting SUCCESS for $raw_trailname\n";
              print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
              exit($check_stat);   
            }
          }
          
           if ($num_perf_test <= 0) {
              print "DAUTO -reportsuccess legacy test\n";
              system ("$dcad_server -reportsuccess");
           } else {
              print "SKIPPING DAUTO -reportsuccess legacy test for now because num_perf_test is $num_perf_test for $raw_trailname\n"; 
           }
        }
     }
          &write_fail_result($raw_trailname,$start,$stop,$runtime,$run_stat,$run_str);
      }
   } else {
      if ($num_legacy_test == 0) {
         &write_succ_result($raw_trailname,$start,$stop,$runtime,$run_str);
      }
   }
   
   if ($shared_workspace_trail ne "") {
      `rm -rf  $cur_dir/${collab_other_pid}_otheruser`; 
      `rm $cur_dir/.${shared_workspace_trail}_collab_other.pid`;
      undef $shared_workspace_trail;
   }
   
   if($ENV{'UWGM_HECTOR_RESULTS'} eq "true" || $ENV{'CREOQA_HECTOR_RESULTS'} eq "true"){
       &create_hector_file($raw_trailname, $runtime, $run_stat);
   }
   
   if($ENV{'UWGMQA_HECTOR_RESULTS'} eq "true"){
       &create_hector_file($raw_trailname, $runtime, $run_stat, $cadname);
   }
   
   if (-e "$tmpdir/msgerror.txt") {
      open(MSGERROR, ">>$rundir/msgerror.txt");
      print MSGERROR "$raw_trailname\n";
      close(MSGERROR);
      `cat "$tmpdir/msgerror.txt" >> "$rundir/msgerror.txt"`;
   }
   if ($memuse_error) {
      print "RESULT:  $result - MEMUSE\n";
   } else {
      print "RESULT:  $result\n";
   }
   if ($ENV{R_PURECOVOPTIONS} eq "true" && $PRO_MACHINE_TYPE eq "sun_solaris_x64") {
      if ($result eq "SUCCESS") {
         print "\nPROCESSING: $CurRegTestName[0].pcv ....\n";
         process_pcv_file("$CurRegTestName[0].pcv");
         print "Done!\n";
      } else {
         print "\nREMOVING: $CurRegTestName[0].pcv ....\n";
         system("rm ../$CurRegTestName[0].pcv");
      }
   } 

   if ($ENV{R_SUPERAUTO} eq "true" && $PRO_MACHINE_TYPE eq "x86e_win64") {
      if ($result eq "SUCCESS" || $result eq "FAILURE") {
         print "\nPROCESSING funclist files for $raw_trailname ....\n";
         process_funclist_file("$raw_trailname");
         print "Done!\n";
      }
   }
         

   if ($dcad_server ne "") {
     if ($result eq "SUCCESS") {
       if ($num_legacy_test == 0) {

         if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
            $check_stat = 0;
            $check_stat = basic_check_for_dauto_run();
            if ($check_stat) {
              print "DAUTO -reportsuccess - not reporting SUCCESS for $raw_trailname\n";
              print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
              exit($check_stat);   
            }
         }
           if ($num_perf_test <= 0) {
              print "DAUTO -reportsuccess\n";
              system ("$dcad_server -reportsuccess");
           } else {
              print "SKIPPING DAUTO -reportsuccess for now because num_perf_test is $num_perf_test for $raw_trailname \n"; 
           }
       }
       if ( defined $ENV{R_SUPERAUTO} && (defined $ENV{R_PURECOVOPTIONS} || defined $ENV{R_GPROF})) {
          print "\nREMOVING: $raw_trailname data ....\n";
          `$rm_cmd "$rundir/${raw_trailname}.sat"`;
          `$rm_cmd "$rundir/${raw_trailname}.out"`;
       }
     } else {
         
       if ($ENV{R_ENABLE_DAUTO_CHECK} eq 'true') {
            $check_stat = 0;
            $check_stat = basic_check_for_dauto_run();
            if ($check_stat) {
              print "DAUTO -reportfailure - not reporting FAILURE for $raw_trailname\n";
              print "\n\nTherefore aborting auto.pl with status $check_stat\n\n";
              exit($check_stat);   
            }
        }

        if ($num_perf_test <= 0) { 
          print "DAUTO -reportfailure\n";
          
          # Schematics - skip saving extra logs.
          if ($directives{rsd_test} && (! defined $ENV{SCHEMATICS_SAVE_EXTRA_LOGS})) {
             print "Schematics - skip saving extra logs.\n";
          } else {
            # Save extra logs.
            save_extra_logs();
          }
          system ("$dcad_server -reportfalure");
        } else {
           print "SKIPPING DAUTO -reportfailure for now because num_perf_test is $num_perf_test for $raw_trailname \n"; 
        }
     }
   }
}

sub process_pcv_file {
   my $pcvfile = $_[0];
   my $wait = 1000;
   my $my_test = "";
   my $func_name = "";

   $pcvfile =~ m/(.*)\.pcv/;
   $my_test = $1;
   $export = "../$my_test.out";
   $sauto_file = "../$my_test.sat";
   while (! -e "../$pcvfile" && $wait > 0) {
      print "$pcvfile not found!! Waiting... !!\n";
      sleep 3;
      $wait = $wait - 3;
   }

   if ($wait <= 0) {
     print "Did not find $pcvfile.";
     if ($dcad_server ne "") {
       $auto_list[$curr_line] = "FINISH\n";
       return;
     } else {
       exit(1);
     }
   }

   my($cmd,$file,$unblk,$blk,$unlin,$lin,$calls,$func);
   my $ec = "purecov -export \.\.\/$pcvfile";
   my $fh = new FileHandle("$ec |");
   my $oh = new FileHandle(">$export");

   while (<$fh>) {
      chomp;
      if (/^di/) { ($cmd, $dir) = split(/\t/); }
      if (/^fi/) { ($cmd, $file) = split(/\t/); }
      if (/^fu/) { ($cmd, $func, $unblk, $blk, $unlin, $lin, $calls)
                                        = split(/\t/); }
      if ((/^efu/) && ($calls > 0) && (! defined $ENV{R_PUREVERBOSE})) {
        if (defined $ENV{R_SUPERAUTO}) {
          ($func_name, $junk) = split(/\(/, $func);
          $func_name =~ s/\s+//g;
          printf $oh ("%s \n", $func_name) if ($func_name !~ /\*unknown_func/);
        } else {
          printf $oh ("%s\t%s\t%d\n", $file, $func, $calls);
        }
      } elsif ((/^efu/) && ($ENV{R_PUREVERBOSE} eq "true")) {
         printf $oh ("%s\t%s\t%s\t%d\t%d\n", $dir, $file, $func,&get_pct($unused, $total), $calls);
      }
   }
   close ($fh); close ($oh);

# Merge purecoverage pcv file on dauto server 

   if (defined $R_PURECOV_MERGE_DIR) {
       $merge_pcv = "merged_${mach_name}_${ppid}.pcv";
       $previous_pcv = "previous_${mach_name}_${ppid}.pcv";
       $mergelog = "merged_${mach_name}_${ppid}.pcv.log";
       $errorlog = "merged_${mach_name}_${ppid}.pcv.err";
       if (-e "../$merge_pcv" && -e "../$pcvfile") {
       print "MERGING: $pcvfile ...\n";
       `mv ../$merge_pcv ../$previous_pcv`;
       `purecov -merge=../$merge_pcv ../$pcvfile ../$previous_pcv`;
       $status = $? >> 8;
       if ($status == 0) {
           `echo $pcvfile >> ../$mergelog`;
           `rm  ../$previous_pcv`;
           print "Copying $merge_pcv to $R_PURECOV_MERGE_DIR ...\n";
           `cp ../$merge_pcv $R_PURECOV_MERGE_DIR`;
           `cp ../$mergelog $R_PURECOV_MERGE_DIR`;
       } else {
           `mv ../$previous_pcv ../$merge_pcv`;
           `echo $pcvfile >> ../$errorlog`;
           `cp ../$errorlog $R_PURECOV_MERGE_DIR`;
       }
       } else {
       `mv ../$pcvfile ../$merge_pcv`;
           `echo $pcvfile >> ../$mergelog`;
       }
   }
   print "REMOVING: $pcvfile ....\n";
   system("rm ../$pcvfile");

   if ( defined $ENV{R_SUPERAUTO} ) {
     print "SORTING: $export to $sauto_file\n";
     `sort -u $export > $sauto_file`;
   }
}

sub process_funclist_file {

   my $my_test = $_[0];
   my $sauto_file = "../$my_test.sat";
   my $tmpfile = "$my_test.tmp";
   my $oh = new FileHandle(">$tmpfile");
   my @funclistfiles = glob("*.funclist");
   my $flist; 

   foreach $flist (@funclistfiles) {
     print "Processing $flist to $tmpfile\n";
     my $flist_h = new FileHandle("<$flist");

    while (<$flist_h>) {
      chomp;
      if (/scalar\ deleting\ destructor/ || /dynamic\ initializer\ for/ || /default\ constructor\ closure/ || /vector\ deleting\ destructor/ || /vbase\ destructor/) {
               next;
      } else {
               $_ =~ s/"//g;
               print $oh ("$_ \n"); 
      }
    }
    close($flist_h);
    move("$flist","$flist.processed.$cur_test_num"); 
   }
   close($oh);
  if (@funclistfiles) {
      print "SORTING: $tmpfile to $sauto_file\n";
      `sort -u $tmpfile > $sauto_file`;
  } else {
      if ($result eq "SUCCESS") {  
        print_succ("R_SUPERAUTO: funclist file for $my_test.txt not found \n"); 
      } else {
        print_fail("R_SUPERAUTO: funclist file for $my_test.txt not found \n"); 
      }
  }
  
  #To create json file and post it to solr
  if ((defined $ENV{R_SUPERAUTO_SOLR}) && ($ENV{R_SUPERAUTO_SOLR} eq "true") && (-f "$sauto_file")) {
     my $superauto_solr = "andcsv-solind1d-new.ptcnet.ptc.com";
     my $superauto_solr_port = "8983";
	 my $superauto_solr_core = $version;
	 $superauto_solr_core =~ s/^Version\s+//;
	 $superauto_solr_core =~ s/-//g;
	 $superauto_solr_core =~ tr/A-Z/a-z/;
	 chomp($superauto_solr_core);
   
     my $json_file = "../$my_test.json";
	 my $url = "http://".$superauto_solr.":".$superauto_solr_port."/solr/".$superauto_solr_core."/update?commit=true";

     open(JSON_FH,">:raw",$json_file);
     print JSON_FH "[{\"test_name\":\"".$my_test."\",\n";
     print JSON_FH "\"function_name\":\"\n";
     close(JSON_FH);
		
     `cat $sauto_file >> $json_file`;
	 
	 open(JSON_FH,">>:raw",$json_file);
	 print JSON_FH "\"}]\n";
	 close(JSON_FH);

     my $ua = LWP::UserAgent->new();
     my $req = HTTP::Request->new(POST => $url);

     $req->content_type('application/json');
	 open(JSON_FH,"<",$json_file);
	 my $content="";
	 while(<JSON_FH>) {
		   $content=$content.$_;
	 }
	 close(JSON_FH);
	 $req->content($content);
		
     #pass request
	 my $solr_response = $ua->request($req);
	 #check the outcome of the response
	 if ($solr_response->is_success() != 1) {
	    if ($result eq "SUCCESS") {  
           print_succ("R_SUPERAUTO_SOLR: solr post for $my_test.txt failed \n"); 
        } else {
           print_fail("R_SUPERAUTO_SOLR: solr post for $my_test.txt failed \n"); 
        }
	 } else {
        unlink($sauto_file) if (not defined $ENV{R_KEEP_SUPERAUTO_SAT});
     }
     unlink($json_file);
	}
}

sub get_pct {
    my ($part, $whole) = @_;
    ($whole == 0) ? return(100) : return(int(($part * 100) / $whole));
}

sub find_dbgfile_dirs {
    my ($cur_find_dir) = @_;
    my ($dbgfile_dirs) = "";
    my ($dbgfile_dir);

    opendir (CUR_FIND_DIR, "$cur_find_dir");
    my (@files) = readdir(CUR_FIND_DIR);
    closedir (CUR_FIND_DIR);
    foreach $file (@files) {
       if (substr($file, 0, 1) ne ".") {
          if ($file eq "dbgfile.dat") {
         if ("$dbgfile_dirs" eq "") {
        $dbgfile_dirs = "$cur_find_dir";
         } else {
            $dbgfile_dirs = "$dbgfile_dirs $cur_find_dir";
         }
          } elsif (-d "$cur_find_dir/$file") {
         $dbgfile_dir = &find_dbgfile_dirs("$cur_find_dir/$file");
         if ("$dbgfile_dirs" eq "") {
        $dbgfile_dirs = "$dbgfile_dir";
         } else {
            $dbgfile_dirs = "$dbgfile_dirs $dbgfile_dir";
         }
          }
       }
    }
    return $dbgfile_dirs;
}

sub second_xtop_kill {
   my $sec_xtop_pid_file = "$cur_dir/.${shared_workspace_trail}_other_xtop_pid";
   my $sec_xtop_pid = 0;
   my $cur_handle;
   my $sec_xtop_working_dir = "$cur_dir\\${shared_workspace_trail}_otheruser";
   my $loc;
   my $kill_sec_xtop = "false";
   
 if (-e "$sec_xtop_pid_file") {
   open(FH, '<', $sec_xtop_pid_file);

   while(<FH>){
      $sec_xtop_pid = $_;
   }

   close(FH);

   my @handle_xtop = `$ENV{PTC_APPS}/SysInternals/handle.exe -p $sec_xtop_pid`;  
   foreach (@handle_xtop) {
      $cur_handle = $_;
      $loc = index($cur_handle, $sec_xtop_working_dir);  

      if ($loc > -1){
	   $kill_sec_xtop = "true";
      }
   }  
  
   if ($kill_sec_xtop eq "true" ) {  
      $cur_cmd = "timeout 10s pskill -t $sec_xtop_pid";
      `$csh_cmd "$cur_cmd"`;   
   }
 } else {
   print ("\nError: $sec_xtop_pid_file is missing\n");  
 }
 
}

sub post_run_process {
   my ($trail_name,$raw_trailname) = @_;
   
   &rm_dbgfile_for_non_langtest;
   
   if (-e "$tmpdir/${raw_trailname}.cbp.1") {
     `$cp_cmd "$tmpdir/${raw_trailname}.cbp.1" "$rundir/${raw_trailname}.cbp"`;
   }

   if ($ENV{POST_RUN_SCRIPT}) {
      `$csh_cmd "$POST_RUN_SCRIPT $trail_name |& tee -a \"$succ\" \"$fail\""`;
   }

   if ($directives{ug_test} || $directives{ug_dbatch_test}) {
    if (! defined $ENV{R_TEST_SPR}) {
       my $cur_cmd;
       if ($ENV{OS_TYPE} eq 'UNIX') {
            my $pid = `$csh_cmd "${TOOLDIR}get_pid $ugExecName"`;
            if ("$pid" ne "") {
                   my @pids = split(/\n/, $pid);
           $cur_cmd = "running: kill -9 @pids\n";
                   kill (9, @pids);
        }
           } else {
                $cur_cmd = "timeout 10s pskill /accepteula $ugExecName$exe_ext";
        print "running: $cur_cmd\n";
                `$csh_cmd "$cur_cmd"`;
       }
        }
   }

   if ($directives{num_post_cmd}) {
      for ($i=0; $i<$directives{num_post_cmd}; $i++) {
      next if (! exists $post_cmd{"${cur_test_num}AND$i"});
      my $cur_cmd = $post_cmd{"${cur_test_num}AND$i"};
          print "Running $cur_cmd\n";
          print `$csh_cmd "$cur_cmd"`;
      }
   }

   if ($directives{prokernel_test}) {
      $ENV{"PTCNMSPORT"} = $save_PTCNMSPORT if ($save_PTCNMSPORT ne "");
   }
   if ($directives{proevconf_test}) {
      $ENV{"PTCNMSPORT"} = $save_PTCNMSPORT if ($save_PTCNMSPORT ne "");
   }
   if ($directives{distapps_dsm} || $directives{distapps_dbatchc} || $directives{distapps_dsapi}) {
      print_succfail("Running ${TOOLDIR}dsq_stop_nmsd\n");
      `$csh_cmd "${TOOLDIR}dsq_stop_nmsd"`;
      $ENV{"PTCNMSPORT"} = $old_PTCNMSPORT if ($old_PTCNMSPORT ne "");
      if ($old_PTCNMS_SERVICE_DIR ne "") {
         $ENV{"PTCNMS_SERVICE_DIR"} = $old_PTCNMS_SERVICE_DIR;
      }
      if ($old_PTCNMS_SERVICE_LIST ne "") {
     $ENV{"PTCNMS_SERVICE_LIST"} = $old_PTCNMS_SERVICE_LIST;
      }
   }
   if ($directives{intralink_interaction} && ! $directives{keepscratch}) {
      `$csh_cmd "${TOOLDIR}kill_xmx256m"`;
      $ENV{PTC_WF_ROOT} = $PTC_WF_ROOT_save;
   }

   if ($ENV{ENABLE_MULTI_CLIENT_SYNC} eq "true" && $directives{shared_workspace}) {
       print "\nRunning $ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/integ_tools/cu_multiclient_trail_sync.py -c -p $ENV{TC_MULTI_CLIENT_SYNC} -e ";
       system("csh -fc \"$ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/integ_tools/cu_multiclient_trail_sync.py -c -p $ENV{TC_MULTI_CLIENT_SYNC} -e \"");
	   delete $ENV{TC_MULTI_CLIENT_SYNC};
     }

   if ($directives{drc_test}){
      print "\nRunning $ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/bin/drc_convert_compare_plt.py --output_file $raw_trailname.msg\n";
      $drc_result = `csh -fc "$ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/bin/drc_convert_compare_plt.py --output_file $raw_trailname.msg"`;
      chomp($drc_result);
      $result = $drc_result;
   }

   if (($directives{shared_workspace} || $directives{atlas_user}) && (! $cur_test_keepscratch || $result eq "FAILURE")) {
      if (! $directives{atlas_user}) {
          if ($srvPID != -1) {
            delete $ENV{CREO_COLLAB_SVC_EXE} if ($keep_creo_collab_svc_exe eq "false");
            $cur_cmd = "timeout 10s pskill $srvPID";
            `$csh_cmd "$cur_cmd"`;	  
            #close(COLLABSVC);
            $srvPID = -1;
          } else{
            # for separate collabsvc, delete sessions
            if (($ENV{PHA_COLLAB_URL} ne "") && (($result ne "FAILURE") || (! exists $ENV{R_KEEP_FAILURE_DATA}) || ($ENV{R_KEEP_FAILURE_DATA} ne 'true'))) {
              my $url = "$ENV{PHA_COLLAB_URL}/DELETE";
              my $ua = LWP::UserAgent->new();
              my $response = $ua->post($url, 
                                       # new server
                                       "X-PTC-Collaboration-AppId", "auto",
                                       "X-PTC-Collaboration-UserName", $ENV{USERNAME},
                                       "X-PTC-Company-Id", "auto",
                                       # old server
                                       "X-CGM-Collaboration-appid", "auto",
                                       "X-CGM-Collaboration-userid", $ENV{USERNAME},
                                       );
            }
          }
      }
      
      if ($directives{shared_workspace} && $shared_workspace_trail_size > 0) {	  
        second_xtop_kill();  
	  }
      
      delete $ENV{COLLABSVC_URL} if($collabsvc_url_set eq "true" );
      delete $ENV{PHA_COLLAB_URL};
      delete $ENV{PHA_COLLAB_TOKEN};
      delete $ENV{serverPort};
	  
	  if ($collab_atlas eq 'true' || $directives{atlas_user}) {
	      #reset PATH variable to remove node and npm, and reset envs that were set for Atlas
	      $ENV{PATH} = $old_shared_workspace_PATH;

	      $ENV{R_USE_AGENT} = $old_r_use_agent;
		  $ENV{IS_AUTOMATION_TEST} = $old_is_automation_test;
		  $ENV{IS_HYBRID_TEST} = $old_is_hybrid_test;
		  $ENV{COLLAB_TEST} = $old_collab_test;
		  $ENV{PTC_ZB_CEF_DISABLE_ZOOM} = $old_ptc_zb_cef_disable_zoom ;    
 		  $ENV{CEF_DEBUG_PORT} = $old_cef_debug_port;

          if (defined $ENV{PHA_COLLAB_USER}) {
               delete ($ENV{PHA_COLLAB_USER});
          }
          if (defined $ENV{PHA_COLLAB_PWD}) {
               delete ($ENV{PHA_COLLAB_PWD});
          }
          if (defined $ENV{COLLABSVC_URL}) {
               delete ($ENV{COLLABSVC_URL});
          }
      }

   }
   
   if ($directives{distapps_dbatchc}) {
      if ($PROE_START_old eq "") {
         delete $ENV{PROE_START};
      } else {
         $ENV{PROE_START} = $PROE_START_old;
      }
      $ENV{PATH} = $old_PATH;
   }

   if ($directives{creo_ui_resource_editor_test} || $directives{otk_cpp_async_test} || $directives{pfcvb_test}) {
         $ENV{PATH} = $old_PATH;
   }
   
   if ($directives{gcri_test}) {
      delete $ENV{CRI_DLL};
   }

   if ($directives{no_mathcad_test}) {
      if ($OS_TYPE eq "NT") {
     delete $ENV{DBG_MATHCAD_INSTALL};
      }
   }

   if (defined $ENV{R_PDEV_REGRES_LEGACY}) {
      delete $ENV{R_PDEV_REGRES_LEGACY};
   }
   

   if ($directives{ug_test} || $directives{ug_dbatch_test}) {
      if ($ugs_version eq "ugsnx2" || $ugs_version eq "ugsnx3"
         || $ugs_version eq "ugsnx4" || $ugs_version eq "ugsnx5"|| $ugs_version eq "ugsnx6"
         || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8"|| $ugs_version eq "ugsnx85"
         || $ugs_version eq "ugsnx9") { 
     if ($PRO_MACHINE_TYPE eq "sun4_solaris_64" || 
        $PRO_MACHINE_TYPE eq "hpux_pa64") {
        $ENV{LD_LIBRARY_PATH} = $old_LD_LIBRARY_PATH;
         }
     if ($PRO_MACHINE_TYPE eq "i486_nt" || $PRO_MACHINE_TYPE eq "x86e_win64") {
        $ENV{PATH} = $old_PATH;
     }
      }
   }

   if ( $directives{add_jdk7_to_path} ) {
     if ($PRO_MACHINE_TYPE eq "i486_nt" || $PRO_MACHINE_TYPE eq "x86e_win64") {
        $ENV{PATH} = $old_PATH;
     }
   }

   if ( $directives{add_jdk8_to_path} || $directives{java_flavor}) {
     if ($PRO_MACHINE_TYPE eq "i486_nt" || $PRO_MACHINE_TYPE eq "x86e_win64") {
        $ENV{PATH} = $old_PATH;
     }
   }

   # Temp fix. remove when spr 1184257 is fixed.
   if (($directives{perf_test} && $ENV{R_PERF} eq "true") || 
       ($directives{catia_v5_test} && $result eq "FAILURE")) {
      if (! defined $ENV{R_TEST_SPR}) {
         if ($ENV{OS_TYPE} eq 'UNIX') {
            my $pid = `$csh_cmd "${TOOLDIR}get_pid CatiaToPro"`;
            if ("$pid" ne "") {
               my @pids = split(/\n/, $pid);
               print "killing CatiaToPro";
               kill (9, @pids);
            }
         } else {
              $cur_cmd = "timeout 10s pskill /accepteula CatiaToPro.exe";
              print "running: $cur_cmd\n";
              `$csh_cmd "$cur_cmd"`;
         }
      }
   }   

   if ($directives{jt_test}) {
      if ($ENV{OS_TYPE} eq 'UNIX') {
      my $pid = `$csh_cmd "${TOOLDIR}get_pid JtToPro"`;
      if ("$pid" ne "") {
         my @pids = split(/\n/, $pid);
         print "killing JtToPro";
         kill (9, @pids);
      }
       } else {
        $cur_cmd = "timeout 10s pskill /accepteula JtToPro.exe";
        print "running: $cur_cmd\n";
        `$csh_cmd "$cur_cmd"`;
       }
   }

   if ($directives{pv_test}) {
      if ($ENV{OS_TYPE} eq 'UNIX') {
      my $pid = `$csh_cmd "${TOOLDIR}get_pid PvToPro"`;
      if ("$pid" ne "") {
         my @pids = split(/\n/, $pid);
         print "killing PvToPro";
         kill (9, @pids);
      }
       } else {
        $cur_cmd = "timeout 10s pskill /accepteula PvToPro.exe";
        print "running: $cur_cmd\n";
        `$csh_cmd "$cur_cmd"`;
       }
   }

   if ($directives{keep}) {
      if ($result eq "FAILURE") {
     $skip_keep_test = 1;
      } else {
         my @array = split(/\s+/, $keep_ext_list);
        if (!$directives{gr_keep}) {
            `$rm_cmd -rf "$rundir/keep_files"` if (-d "$rundir/keep_files");
             mkdir ("$rundir/keep_files", 0777);
        }
        foreach $ext (@array) {
        `cp *.$ext "$rundir/keep_files"`;
          }
      }
      $copy_keep_files = 1;
   } else {
      $copy_keep_files = 0;
   }

   $ENV{"LOCALPROE"}=$local_xtop;

   &find_printf($raw_trailname) if ($R_FIND_PRINTF);
   &run_gprof($raw_trailname) if ($R_GPROF eq "true");
   &create_new_file($raw_trailname);
   &check_memuse($raw_trailname) if ($altlang eq "" && $result ne "FAILURE");
   if ($ENV{R_CHECK_DBGFILE} eq "true") {
       if ($directives{mech_test}) {
          my $rc = 0;
          $rc=system("$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $cur_dir/diff_mech.pl $mech_test_type $raw_trailname");
          if (defined $ENV{R_NO_MECH_DATA} && $ENV{R_NO_MECH_DATA} ne "false") {
             if (-d "$rundir/$raw_trailname") {
                `$rm_cmd -rf "$rundir"/$raw_trailname`;
             }
          }
          if ( $rc > 256 ) {
              $result="FAILURE";
              &gettraceback($raw_trailname) if (defined $ENV{R_GETTB_CORE});
              #&reset_envs;
              #return;
          }
      }
      
      my ($dbgfile_dirs) = &find_dbgfile_dirs("$tmpdir");
      if ( "$dbgfile_dirs" ne "" && $ENV{R_RUN_SKIP_SIMLIVE_SOLVER} eq 'true' && $aftype eq '') {
          $result = "SUCCESS"; 
      } else {
          &check_dbgfile($raw_trailname, $dbgfile_dirs) if ( "$dbgfile_dirs" ne "");
      }
      
      if ($is_otheruser_xtop_only_fail) {
         my ($dbgfile_dirs) = &find_dbgfile_dirs("$cur_dir/${collab_other_pid}_otheruser");
         &check_dbgfile($raw_trailname, $dbgfile_dirs) if ( "$dbgfile_dirs" ne "");
      }
   }

   my $raw_trail_name ="$raw_trailname$tk_flavor_name";
   if ($result eq "FAILURE") {
      my $trailfiledir = "$rundir/$raw_trail_name";
      mkdir("$trailfiledir", 0777) if (! -d "$trailfiledir");
      if (-e "$tmpdir/$raw_trailname.txt") {
        `cp "$tmpdir/$raw_trailname.txt" "$trailfiledir"`;
      }      
   }
 
   &check_bitmaps($raw_trailname) if ($R_CHECK_BITMAPS && -e $raw_trailname);
   if (($directives{bitmap} || $directives{bitmap_4k}) && $bitmap_save == 1) {
        $path_to_bitdb = $ENV{PATH_TO_BITDB};
        chomp($path_to_bitdb);
        copy_images_to_bitDB($path_to_bitdb);
   }
   if ($directives{bitmap_text} && $bitmap_text_save == 1) {
        $path_to_bitdb = $ENV{PATH_TO_BITDB};
        chomp($path_to_bitdb);
        copy_images_text_to_bitDB($path_to_bitdb);
   }
   if (($directives{bitmap} || $directives{bitmap_4k}) && $bitmap_save == 0) {
        &check_bitmap_file($raw_trailname) if (-e "$tmpdir/bitmap_fail.dat");
        &check_bitmaps($raw_trailname);
   }

   &gettraceback($raw_trailname) if (defined $ENV{R_GETTB_CORE} && $result eq "FAILURE");
   if ($OS_TYPE eq "UNIX") {
      &save_all_core($raw_trailname) if (exists $ENV{R_SAVE_ALL_CORE});
      &exit_on_core if ($R_EXIT_ON_CORE);
   }
   if ($altlang ne "") {
      my ($old_lang) = $LANG;
      $LANG = C;
      `grep foreign_merge $raw_trailname.msg >> $foreign_merge`;
      $LANG = $old_lang;
   }
   perf_tool_stop ($trail_name) if($ENV{'PERF_TEST_AUTO'} ne "NO" && $ENV{'R_PERF'} eq "true");
   &get_perf_results($raw_trailname) if ($ENV{'R_PERF'} eq "true");

   if ($ENV{'R_PERF'} eq "true") {
    $ENV{R_PERF_CURRENT_ITERATION_NUM}++ if ((! $cur_test_keepscratch) && ($num_perf_test > 0));
   }
   
   my $to_save_as = 0;
   my $to_save_filter_as = 0;
   $to_save_as = 1 if (defined $ENV{R_SAVE_AS});
   if (defined $ENV{R_SAVE_FILTER} && 
	    (($result eq "FAILURE" && !defined $ENV{R_KEEP_SUCC_SAVE_FILTER}) || ($result ne "FAILURE" && defined $ENV{R_KEEP_SUCC_SAVE_FILTER}) )) {
		$to_save_filter_as = 1;
	}

   if (defined $save_PTC_ADVAPPSLIB) {
       $ENV{PTC_ADVAPPSLIB} = $save_PTC_ADVAPPSLIB;
       undef $save_PTC_ADVAPPSLIB;
   }
   if (defined $save_PRO_RES_DIRECTORY) {
       $ENV{PRO_RES_DIRECTORY} = $save_PRO_RES_DIRECTORY;
       undef $save_PRO_RES_DIRECTORY;
   }
   if ($directives{solidworks_test} && $solidworks_version ne "") {
       system("$REGSVR32 /u /s z:\\apps\\sw${solidworks_version}\\$PRO_MACHINE_TYPE\\$sw_os\\SwDocumentMgr.dll");
       $ENV{PATH} = $pre_sw_PATH;
   }
   if ($directives{cadds5_topology_test}) {
      if ($old_CV_ENV_HOME) {
        $ENV{CV_ENV_HOME} = $old_CV_ENV_HOME;
      } else {
        delete $ENV{CV_ENV_HOME};
      }
   }

   #copy agent home
   if ( ( $directives{fresh_creo_agent} || $ENV{R_USE_CREO_PLUS} eq "true" ) && ($result eq "FAILURE" || defined $ENV{R_KEEP_SUCC_AGENT_HOME})) {
      if (defined $ENV{CREO_AGENT_HOME} && -d "$ENV{CREO_AGENT_HOME}") {
      print "\nCopying CREO_AGENT_HOME with $ENV{CREO_AGENT_HOME} to $cur_dir/${raw_trailname}${tk_flavor_name}_creoagent_home \n ";
			 if ($ENV{R_EXTRA_LOGGING} eq 'true') {
               list_current_dir();
               log_current_diskspace_ram();
             }	
         `$cp_cmd "$ENV{CREO_AGENT_HOME}" "$cur_dir/${raw_trailname}${tk_flavor_name}_creoagent_home"`;
      } else {
          print "CREO_AGENT_HOME with value $ENV{CREO_AGENT_HOME} \n ";
          if (! -d "$ENV{CREO_AGENT_HOME}") {
            print "$ENV{CREO_AGENT_HOME} directory is missing  \n ";
            print_fail ("$ENV{CREO_AGENT_HOME} directory is missing\n ");
			 if ($ENV{R_EXTRA_LOGGING} eq 'true') {
                list_current_dir(); 
                list_current_process();
             }			
          }
      }
   }
   
   if ( ( $directives{fresh_creo_agent} || $ENV{R_USE_CREO_PLUS} eq "true" ) && ($OS_TYPE eq "NT")) {
      if ((-d $ENV{"CREO_AGENT_HOME"}) && (not defined $ENV{R_SAAS_REGRESSION})) {
         if ( (defined $ENV{CREO_SAAS_TELECON_FLUSH_ON_EXIT}) && ($ENV{R_USE_CREO_PLUS} eq "true")) {
             print "Running: $creoinfo_exe -telecon-flush\n";
			 system("$csh_cmd \"$creoinfo_exe -telecon-flush\"");
	          $cs_stat = ($? >> 8);
              print("$creoinfo_exe -telecon-flush finished with return code $cs_stat\n"); 
         }
         if ($ENV{R_USE_CREO_PLUS} eq "true") {
            print "CREO_AGENT_HOME(-logout -fail)=$ENV{CREO_AGENT_HOME}\n";
			print "Running:$creoinfo_exe -logout -fail\n";
	        system("$csh_cmd \"$creoinfo_exe -logout -fail\"");
	        $cs_stat = ($? >> 8);
            print("$creoinfo_exe -logout -fail finished with return code $cs_stat\n");
         }
         print "Using creoinfo -shutdown to shut the agent\n";
         print "CREO_AGENT_HOME(-shutdown)=$ENV{CREO_AGENT_HOME}\n";

         if ($ENV{R_USE_CREO_PLUS} eq "true") {
		    system("$csh_cmd \"$creoinfo_exe -shutdown \"");
	        $cs_stat = ($? >> 8);
            print("$creoinfo_exe -shutdown finished with return code $cs_stat\n");
         } else {
            run_timeout_cmd(60, "$creoinfo_exe -shutdown"); 
         } 
      }
      
      if ($directives{shared_workspace} && $shared_workspace_trail_size > 0) {
        my $ptc_wf_root_backup = $ENV{PTC_WF_ROOT};
         $ENV{PTC_WF_ROOT} = "$cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser/wfroot";
         my $creo_agent_home_backup = $ENV{CREO_AGENT_HOME};
         my $ptc_log_dir_backup = $ENV{PTC_LOG_DIR};
         
         $ENV{CREO_AGENT_HOME} = "$cur_dir/CREO_HOME_${collab_other_pid}_otheruser";
         $ENV{PTC_LOG_DIR} = "$cur_dir/${collab_other_pid}_otheruser_ptclog";
         print "CREO_AGENT_HOME:$ENV{CREO_AGENT_HOME} of ${shared_workspace_trail}\n";
                           
         if ((-d $ENV{"CREO_AGENT_HOME"}) && (not defined $ENV{R_SAAS_REGRESSION})) {
            if ( (defined $ENV{CREO_SAAS_TELECON_FLUSH_ON_EXIT}) && ($ENV{R_USE_CREO_PLUS} eq "true")) {
             print "running $creoinfo_exe -telecon-flush\n";
			 system("$csh_cmd \"$creoinfo_exe -telecon-flush\"");
	         $cs_stat = ($? >> 8);
             print("$creoinfo_exe -telecon-flush finished with return code $cs_stat\n");
            }
            
            if ($ENV{R_USE_CREO_PLUS} eq "true") {
               print "s1. Running: $creoinfo_exe -logout -fail\n";
               print "s1. CREO_AGENT_HOME (-logout -fail)=$ENV{CREO_AGENT_HOME}\n";
               system("$csh_cmd \"$creoinfo_exe -logout -fail\"");
	           $cs_stat = ($? >> 8);
               print("$creoinfo_exe -logout -fail finished with return code $cs_stat\n");		   
            }
            
            print "s1. CREO_AGENT_HOME(-shutdown)=$ENV{CREO_AGENT_HOME}\n";
            print "s1. Using creoinfo -shutdown to shut the agent\n";
            if ($ENV{R_USE_CREO_PLUS} eq "true") {
		       system("$csh_cmd \"$creoinfo_exe -shutdown\"");
	           $cs_stat = ($? >> 8);
               print("$creoinfo_exe -shutdown finished with return code $cs_stat\n");
            } else {
               run_timeout_cmd(60, "$creoinfo_exe -shutdown");   
            }
         }

         my $otheruser_CREO_AGENT_HOME = "CREO_HOME_${collab_other_pid}_otheruser";
         if ((-d $otheruser_CREO_AGENT_HOME) && (not defined $ENV{R_SAAS_REGRESSION})) {
            my $tmp_CREO_AGENT_HOME = $ENV{CREO_AGENT_HOME};
            $ENV{CREO_AGENT_HOME} = "$otheruser_CREO_AGENT_HOME";
            print "otheruser: creoinfo -shutdown:CREO_AGENT_HOME=$ENV{CREO_AGENT_HOME}\n";
            print "otheruser: Using creoinfo -shutdown to shut the agent\n";
            if ( (defined $ENV{CREO_SAAS_TELECON_FLUSH_ON_EXIT}) && ($ENV{R_USE_CREO_PLUS} eq "true")) {
               print "otheruser: running $creoinfo_exe -telecon-flush\n";
		       system("$csh_cmd \"$creoinfo_exe -telecon-flush\"");
	           $cs_stat = ($? >> 8);
               print("$creoinfo_exe -telecon-flush finished with return code $cs_stat\n");
            }
            
            if ($ENV{R_USE_CREO_PLUS} eq "true") {
              print "otheruser(s2): running $creoinfo_exe -logout -fail\n";
              print "otheruser(s2): CREO_AGENT_HOME (-logout -fail)=$ENV{CREO_AGENT_HOME}\n";
			   system("$csh_cmd \"$creoinfo_exe -logout -fail\"");
	          $cs_stat = ($? >> 8);
                print("$creoinfo_exe -logout -fail finished with return code $cs_stat\n");
            }
            
            if ($ENV{R_USE_CREO_PLUS} eq "true") {
		      system("$csh_cmd \"$creoinfo_exe -shutdown\"");
	          $cs_stat = ($? >> 8);
              print("$creoinfo_exe -shutdown finished with return code $cs_stat\n");
            } else {
              run_timeout_cmd(60, "$creoinfo_exe -shutdown");
            }            
            $ENV{CREO_AGENT_HOME} = $tmp_CREO_AGENT_HOME;
         }          
         
         #following wait is temporary
		 sleep(60);
         
         if (-d "$cur_dir/${collab_other_pid}_otheruser_ptclog") {
            print "\n Copying ${collab_other_pid}_otheruser_ptclog \n ";
            `$cp_cmd "$cur_dir/${collab_other_pid}_otheruser_ptclog" "$tmpdir/${shared_workspace_trail}_otheruser_ptclog"`;
         }
         
         if (-d "$cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser") {
            print "\n Copying $cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser \n ";
            `$cp_cmd "$cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser" "$tmpdir/${shared_workspace_trail}_otheruser_wfroot"`;
         }
         
         if (-d "$cur_dir/CREO_HOME_${collab_other_pid}_otheruser") {
            
			print "\n Copying CREO_AGENT_HOME(otheruser) with $ENV{CREO_AGENT_HOME}, $cur_dir/CREO_HOME_${collab_other_pid}_otheruser to $cur_dir/${raw_trailname}_creoagent_home $tmpdir/CREO_HOME_${shared_workspace_trail}_otheruser \n \n ";

           `$cp_cmd "$cur_dir/CREO_HOME_${collab_other_pid}_otheruser" "$tmpdir/CREO_HOME_${shared_workspace_trail}_otheruser"`;
		   
			 if ($ENV{R_EXTRA_LOGGING} eq 'true') {
                  list_current_dir();
                  log_current_diskspace_ram();                  
             }
         } else {
			 print "\n $cur_dir/CREO_HOME_${collab_other_pid}_otheruser of otheruser($shared_workspace_trail) missing \n";
			 print_fail ("$cur_dir/CREO_HOME_${collab_other_pid}_otheruser of otheruser($shared_workspace_trail) missing\n ");
			 if ($ENV{R_EXTRA_LOGGING} eq 'true') {
                list_current_dir();
                list_current_process();
                log_current_diskspace_ram();                
             }			
		 }
         
         if (-d "$cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser") {
            `$rm_cmd -rf $cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser ` ; 
          }

         if (-d "$cur_dir/scratch_tmp_${collab_other_pid}_otheruser") {
            `$rm_cmd -rf $cur_dir/scratch_tmp_${collab_other_pid}_otheruser ` ; 
          }
         
         if (-d "$cur_dir/CREO_HOME_${collab_other_pid}_otheruser") {
           #`$cp_cmd "$cur_dir/CREO_HOME_${shared_workspace_trail}_otheruser" "$tmpdir/CREO_HOME_${shared_workspace_trail}_otheruser"`;
            ` $rm_cmd -rf "$cur_dir/CREO_HOME_${collab_other_pid}_otheruser" `;
         }
         
         if (-d "$cur_dir/${collab_other_pid}_otheruser_ptclog") {
            `$rm_cmd -rf $cur_dir/${collab_other_pid}_otheruser_ptclog ` ; 
         }
         
         $ENV{PTC_WF_ROOT} = $ptc_wf_root_backup;  
         $ENV{CREO_AGENT_HOME} = $creo_agent_home_backup;
         $ENV{PTC_LOG_DIR} = $ptc_log_dir_backup;         
       }

        #for #k tests we want to keep the creo agent home
         if (!$cur_test_keepscratch || ($result eq "FAILURE")) {
            `$rm_cmd -rf "$ENV{CREO_AGENT_HOME}"`;
         } else {
            $keep_agent_home_folder = 1;
            $is_next_testname = 0;
         }
    }

   if ($shared_workspace_trail ne '' && $is_otheruser_xtop_only_fail) {
	   `$cp_cmd $tmpdir/$raw_trailname.new $cur_dir/${collab_other_pid}_otheruser/${raw_trailname}_trl_1.secondxtop`;
	   `$cp_cmd $tmpdir/std.out $cur_dir/${collab_other_pid}_otheruser/${raw_trailname}_std_out.secondxtop`;
	   `$cp_cmd $tmpdir/std.err $cur_dir/${collab_other_pid}_otheruser/${raw_trailname}_std_err.secondxtop`;
   }

   if ($directives{shared_workspace}  && $shared_workspace_trail_size > 0) {
      `$cp_cmd "$cur_dir/${collab_other_pid}_otheruser" "$tmpdir/${shared_workspace_trail}_otheruser"`; 
       `rm $cur_dir/.${shared_workspace_trail}_other_xtop_pid`;
   }

   if ( $directives{atlas_user}  ) {
      $is_atlas_user_multi_session = 0;
   }
   
   if ($orig_R_DELAY_PRO_COMM_MSG_LAUNCH) {
       $ENV{R_DELAY_PRO_COMM_MSG_LAUNCH} = $orig_R_DELAY_PRO_COMM_MSG_LAUNCH;
       undef $orig_R_DELAY_PRO_COMM_MSG_LAUNCH;
   }
   
   if ($directives{gd_test}) {	  
	  my @apilogs = glob("$ENV{CREO_TRUESOLID_API_LOG_DIR}/${raw_trailname}.ts.apilog.*.txt");
	  foreach my $apilog (@apilogs) {
	     `$csh_cmd "$PTC_TOOLS/python36/$PRO_MACHINE_TYPE/python $PRO_SRC/libs/TrueSOLID/tools/scripts/ts_apilog_to_source.py $apilog"`;
		 
		 my $apicppfile = $apilog;
		 $apicppfile =~ s/\.txt$/.cpp/;

		 if (-e $apicppfile) {
			if ($ENV{R_COMPILE_TSAPI} eq 'true' && $ENV{PRO_MACHINE_TYPE} eq 'x86e_win64') {
			   `mkdir -p apifiles/${raw_trailname}` ;
			   chdir("apifiles/${raw_trailname}");
			   $apicppcompilestr = "cl $apicppfile /nologo /Zi /W3 /WX /EHsc /I".$ENV{TS_HOME}."/trs_source /link /LIBPATH:".$TS_HOME."/x86e_win64/obj";
			   print "compiling $apicppfile for ${raw_trailname}\n";
			   `$csh_cmd "$apicppcompilestr"`;
			   chdir("$tmpdir");
			   `7za a "$tmpdir/${raw_trailname}.apilog.7za" "$tmpdir/apifiles/${raw_trailname}"`;
			}
		 } else {
		    print ("\napicpp file for ${raw_trailname}.txt not found \n");
		    if ($result eq "SUCCESS") {  
               print_succ("\nCREO_TRUESOLID_API_LOG: $apicppfile file for ${raw_trailname}.txt not found \n");
			   
            } else {
               print_fail("\nCREO_TRUESOLID_API_LOG: $apicppfile file for ${raw_trailname}.txt not found \n"); 
			}
		 }
      }
	  
	  if ( $#apilogs < 0) {
	      print("\napilog - $ENV{CREO_TRUESOLID_API_LOG_DIR}/${raw_trailname}.ts.apilog.*.txt - file for ${raw_trailname}.txt not found \n"); 
          if ($result eq "SUCCESS") {  
            print_succ("CREO_TRUESOLID_API_LOG: apilog file for ${raw_trailname}.txt not found \n"); 
          } else {
            print_fail("CREO_TRUESOLID_API_LOG: apilog file for ${raw_trailname}.txt not found \n");
          }	   
      }
  }
  
  if (($directives{pglview_test} || $directives{vulkan}) && $save_user_graphics_mode ne "") {
     $ENV{R_GRAPHICS} = $save_user_graphics_mode;
     undef $save_user_graphics_mode;
     print "R_GRAPHICS is set back to $ENV{R_GRAPHICS}\n";
  }
  
  if ($directives{java_flavor} && $save_user_pro_java_command ne "") {
     $ENV{PRO_JAVA_COMMAND} = $save_user_pro_java_command;
     undef $save_user_pro_java_command;
     print "PRO_JAVA_COMMAND is set back to $ENV{PRO_JAVA_COMMAND}\n";
  }
  
  #reset PATH variable to remove node and npm
  if ($ENV{GD_STACKNAME} ne "") {
     $ENV{PATH} = $old_PATH;
  }

  if ( $ENV{RSD_DGE_LOCATION} ne '' && $ENV{RSD_DGE_CREATION} eq 'true') { 
	 my $dgm_save_location_top = $ENV{RSD_DGE_LOCATION};
	 	$cversion = substr($ENV{PTC_VERSION}, 0, 4);
	    $dgm_save_location_top .= "/".$cversion;
     mkdir($dgm_save_location_top, 0777) if ( ! -d "$dgm_save_location_top" );

     mkpath("$dgm_save_location_top/trails/$raw_trailname", 0777);     
     `$cp_cmd "$tmpdir/"*.dge "$dgm_save_location_top/trails/$raw_trailname"`;
  }
  
  if ( ! $keep_agent_home_folder ) {        
      if ($ENV{R_USE_CREO_PLUS} eq "true" && $ENV{R_USE_SAAS_CONFIG_SERVICE} eq 'true') {
         delete_config_from_server();
         if ($ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID_OTHER_USER} ne "" ) {
             $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID} = $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID_OTHER_USER};
             $ENV{CREO_SAAS_TEST_ALT_USERNAME} = "$atlas_user_name2";
             $ENV{CREO_SAAS_USERNAME} =  "$ENV{CREO_SAAS_TEST_ALT_USERNAME}";
             $ENV{CREO_SAAS_TEST_ALT_PASSWORD} = "$atlas_password2";
             $ENV{CREO_SAAS_PASSWORD} = "$ENV{CREO_SAAS_TEST_ALT_PASSWORD}";
             delete_config_from_server();
             undef $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID_OTHER_USER}
         }
         undef $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID} if (defined $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID});
      }
  }
   
  if ($old_PTC_UI_SERVICE_RUN_TRAIL ne "") {
     if (-f "$ENV{PTC_UI_SERVICE_RUN_TRAIL}" && (not defined $ENV{DONT_REMOVE_PTC_UI_TRAIL})) {
         ` rm $ENV{PTC_UI_SERVICE_RUN_TRAIL} `;
     }
     #$ENV{PTC_UI_SERVICE_RUN_TRAIL} =  $old_PTC_UI_SERVICE_RUN_TRAIL;
     $ENV{PTC_UI_SERVICE_RUN_TRAIL} =  $PTC_UI_SERVICE_RUN_TRAIL_default;
     undef $old_PTC_UI_SERVICE_RUN_TRAIL;
  }
  
  if ($old_ZBROWSER_TRAIL_FILE ne "") {
     if (-f "$ENV{ZBROWSER_TRAIL_FILE}" && (not defined $ENV{DONT_REMOVE_PTC_UI_TRAIL})) {
         ` rm $ENV{ZBROWSER_TRAIL_FILE} `;
     }
     
     #$ENV{ZBROWSER_TRAIL_FILE} =  $old_ZBROWSER_TRAIL_FILE;
     $ENV{ZBROWSER_TRAIL_FILE} =  $ZBROWSER_TRAIL_FILE_default;
     undef $old_ZBROWSER_TRAIL_FILE;
  }
  
  if ($old_CREO_SAAS_TEST_ALT_USERNAME ne "") {
     #$ENV{CREO_SAAS_TEST_ALT_USERNAME} =  $old_CREO_SAAS_TEST_ALT_USERNAME;
     $ENV{CREO_SAAS_TEST_ALT_USERNAME} =  $CREO_SAAS_TEST_ALT_USERNAME_default;
     undef $old_CREO_SAAS_TEST_ALT_USERNAME;
  }
  
  if ($old_CREO_SAAS_TEST_ALT_PASSWORD ne "") {
     #$ENV{CREO_SAAS_TEST_ALT_PASSWORD} =  $old_CREO_SAAS_TEST_ALT_PASSWORD;
     $ENV{CREO_SAAS_TEST_ALT_PASSWORD} =  $CREO_SAAS_TEST_ALT_PASSWORD_default;
     undef $old_CREO_SAAS_TEST_ALT_PASSWORD;
  }
  
  if ($old_CREO_SAAS_USERNAME ne "") {
     #$ENV{CREO_SAAS_USERNAME} =  $old_CREO_SAAS_USERNAME;
     $ENV{CREO_SAAS_USERNAME} =  $CREO_SAAS_USERNAME_default;
     undef $old_CREO_SAAS_USERNAME;
  }
  
  if ($old_CREO_SAAS_PASSWORD ne "") {
     #$ENV{CREO_SAAS_PASSWORD} =  $old_CREO_SAAS_PASSWORD;
     $ENV{CREO_SAAS_PASSWORD} =  $CREO_SAAS_PASSWORD_default;
     undef $old_CREO_SAAS_PASSWORD;
  }
  
  if ($directives{pyautogui_test}) {
    `cp $cur_dir/ExecutedCdImages.json $tmpdir`;
  }
  
  if ($ENV{R_PERF} eq 'true' &&  $ENV{R_PERFVIEW} eq 'true') {
     #following is special case
     print "\n Waiting for perfview CPU dump finish status $tmpdir/perfview_cpu_dump.finish\n";
     $counter = 0;
     $max_wait_secs = 300; # default 5 minutes
     $max_wait_secs = $ENV{R_PROFILER_MAX_SECS_WAIT} if ((defined $ENV{R_PROFILER_MAX_SECS_WAIT}) && ($ENV{R_PROFILER_MAX_SECS_WAIT} ne ''));
     while (1) {
        $counter = $counter + 1;
        if (! -e "$tmpdir/perfview_cpu_dump.start") {
              last; 
        }
        if (-e "$tmpdir/perfview_cpu_dump.finish" || ($max_wait_secs == $counter) ) {
              last; 
        }
     }
     #mkpath("$tmpdir/${raw_trailname}-PV-${act_name}",0777);
     ` mkdir -p "$tmpdir/${raw_trailname}-PV-${act_name}" `;
     `cp $cur_dir/${raw_trailname}.perf $tmpdir/${raw_trailname}-PV-${act_name}`;
     `cp $tmpdir/out*.vsg $tmpdir/${raw_trailname}-PV-${act_name}`;
     `cp $tmpdir/out.vsg $tmpdir/${raw_trailname}-PV-${act_name}/${raw_trailname}.vsg`;
     `cp $tmpdir/myCPU.View1.perfView.xml.zip $tmpdir/${raw_trailname}-PV-${act_name}`;
     `cp $tmpdir/${raw_trailname}.new $tmpdir/${raw_trailname}-PV-${act_name}`;

     if (defined $ENV{PERFVIEW_SAVE_TTS}) {
        `cp $tmpdir/myTTS.View1.perfView.xml.zip $tmpdir/${raw_trailname}-PV-${act_name}`;
     }
    
     if (defined $ENV{PERFVIEW_SAVE_ETL}) {
        `cp $tmpdir/*etl.zip $tmpdir/${raw_trailname}-PV-${act_name}`;
     }

     if ($directives{shared_workspace} && $shared_workspace_trail_size > 0) {
        #following is special case
        print "\n Waiting for perfview CPU dump finish status $cur_dir/${collab_other_pid}_otheruser/perfview_cpu_dump.finish\n";
        $counter = 0;
        while (1) {
            $counter = $counter + 1;
            if (! -e "$cur_dir/${collab_other_pid}_otheruser/perfview_cpu_dump.start") {
              last; 
            }
            if (-e "$cur_dir/${collab_other_pid}_otheruser/perfview_cpu_dump.finish" || ($max_wait_secs == $counter)) {
              last; 
            }
        }
        print("running a sleep of 60 secs for profiler CPU data\n");
        sleep(60);
        $act_name_bak = ${act_name};
        $act_name = $ENV{COLLAB_OTHER_ACTION_NAME} if (defined $ENV{COLLAB_OTHER_ACTION_NAME});
        ` mkdir -p "$tmpdir/${shared_workspace_trail}-PV-${act_name}" `;
         `cp $cur_dir/${collab_other_pid}_otheruser/myCPU.View1.perfView.xml.zip "$tmpdir/${shared_workspace_trail}-PV-${act_name}" `;
         `cp $cur_dir/${collab_other_pid}_otheruser/trail.txt.1 "$tmpdir/${shared_workspace_trail}-PV-${act_name}/${shared_workspace_trail}.new" `;
     
         if (defined $ENV{PERFVIEW_SAVE_TTS}) {
            `cp $cur_dir/${collab_other_pid}_otheruser/myTTS.View1.perfView.xml.zip "$tmpdir/${shared_workspace_trail}-PV-${act_name}" `;
         }

         if (defined $ENV{PERFVIEW_SAVE_ETL}) {
            `cp $cur_dir/${collab_other_pid}_otheruser/*etl.zip "$tmpdir/${shared_workspace_trail}-PV-${act_name}" `;
         }
         add_to_saveas("${shared_workspace_trail}-PV-${act_name}");
         $act_name = ${act_name_bak};
     }
     kill_old_processs();
  }
  
    if ($ENV{R_PERF} eq 'true' &&  $ENV{R_PERFVS} eq 'true') {
      #following is special case
      print "\n Waiting for cpuexportstack finish status $tmpdir/cpuexportstack.finish\n";
      $counter = 0;
      $max_wait_secs = 300; # default 5 minutes
      $max_wait_secs = $ENV{R_PROFILER_MAX_SECS_WAIT} if ((defined $ENV{R_PROFILER_MAX_SECS_WAIT}) && ($ENV{R_PROFILER_MAX_SECS_WAIT} ne ''));
      while (1) {
         $counter = $counter + 1;
         if (! -e "${tmpdir}/cpuexportstack.start") {
            last; 
         }
         if (-e "${tmpdir}/cpuexportstack.finish" || ($max_wait_secs == $counter)) {
            last; 
         }
      }
        
     #mkpath("$tmpdir/${raw_trailname}-VS-${act_name}",0777);
     ` mkdir -p "$tmpdir/${raw_trailname}-VS-${act_name}" `;
     `cp $cur_dir/${raw_trailname}.perf "$tmpdir/${raw_trailname}-VS-${act_name}" `;
     `cp $tmpdir/*.vsg "$tmpdir/${raw_trailname}-VS-${act_name}" `;
     `cp $tmpdir/${raw_trailname}.new "$tmpdir/${raw_trailname}-VS-${act_name}" `;
     
     if (defined $ENV{VSDIAG_SAVE_DIAGSESSION}) {
        `cp $tmpdir/*.diagsession "$tmpdir/${raw_trailname}-VS-${act_name}" `;
     }
 
     if ($directives{shared_workspace} && $shared_workspace_trail_size > 0) { 
        #following is special case
        print "\n Waiting for cpuexportstack finish status $cur_dir/${collab_other_pid}_otheruser/cpuexportstack.finish\n";
        $counter = 0;
        while (1) {
           $counter = $counter + 1;
           if (! -e "${cur_dir}/${collab_other_pid}_otheruser/cpuexportstack.start") {
              last; 
           }
           if (-e "${cur_dir}/${collab_other_pid}_otheruser/cpuexportstack.finish" || ($max_wait_secs == $counter)) { 
              last; 
           }
        }
        print("running a sleep of 180 secs for profiler vsg data\n");
        sleep(180);
        $act_name_bak = ${act_name};
        $act_name = $ENV{COLLAB_OTHER_ACTION_NAME} if (defined $ENV{COLLAB_OTHER_ACTION_NAME});
        ` mkdir -p "$tmpdir/${shared_workspace_trail}-VS-${act_name}" `;
         `cp $cur_dir/${collab_other_pid}_otheruser/*.vsg "$tmpdir/${shared_workspace_trail}-VS-${act_name}" `;
         `cp $cur_dir/${collab_other_pid}_otheruser/trail.txt.1 "$tmpdir/${shared_workspace_trail}-VS-${act_name}/${shared_workspace_trail}.new" `;
     
         if (defined $ENV{VSDIAG_SAVE_DIAGSESSION}) {
            `cp $cur_dir/${collab_other_pid}_otheruser/*.diagsession "$tmpdir/${shared_workspace_trail}-VS-${act_name}" `;
         }

         add_to_saveas("${shared_workspace_trail}-VS-${act_name}");
         $act_name = ${act_name_bak};
     }
     kill_old_processs();
  }
  
  if (-d $ENV{PTC_LOG_DIR} && ($result eq 'FAILURE' || $ENV{R_SAVEAS_ALWAYS} eq 'true')) {
      add_to_saveas("${raw_trailname}_ptclog");
       print "Copying PTC_LOG_DIR = $ENV{PTC_LOG_DIR} \n ";       
       mkpath("$tmpdir/${raw_trailname}_ptclog", 0777) if (! -d "$tmpdir/${raw_trailname}_ptclog");
       `$cp_cmd "$ENV{PTC_LOG_DIR}/"* "$tmpdir/${raw_trailname}_ptclog/"`;
       `$cp_cmd $psf_file "$tmpdir/${raw_trailname}_ptclog/"` if ($psf_file ne '');
       if ($ENV{CREO_SAAS_LOCAL_BACKEND} eq 'true') {
          print_local_backend_status() if ($ENV{R_PRINT_SAAS_BACKEND_STATUS} eq 'true');
          if ($ENV{R_SAVE_SAAS_BACKEND_LOGS} eq 'true') {
            if (-d "$ENV{HOME}/$ENV{SAAS_BACKEND_SERVICE_TOP}/apps/service") {
             print ("\nCopying $ENV{HOME}/$ENV{SAAS_BACKEND_SERVICE_TOP}/apps/service/creo_saas_backend.log\n");
            `$cp_cmd "$ENV{HOME}/$ENV{SAAS_BACKEND_SERVICE_TOP}/apps/service/"creo_saas_backend.log* "$tmpdir/${raw_trailname}_ptclog/"`;
            } elsif ( -d "$ENV{SAAS_BACKEND_SERVICE_TOP}/apps/service") {
             print ("\n Copying $ENV{SAAS_BACKEND_SERVICE_TOP}/apps/service/creo_saas_backend.log\n");
             `$cp_cmd "$ENV{SAAS_BACKEND_SERVICE_TOP}/apps/service/"creo_saas_backend.log* "$tmpdir/${raw_trailname}_ptclog/"`;
            }
         }
       }
   }
   
  if ($old_psf_file ne "") {
     
     if (not defined $ENV{R_PRESERVE_PSF}) {
        print "Removing temporary psfile:$psf_file\n";
        `rm $psf_file`;
     }

     #$psf_file =  $old_psf_file;
     $psf_file =  $psf_file_default;
     print "Reverting psf_file to $psf_file\n";
     
     undef $old_psf_file;
  }
   
   if ($ENV{R_VIDEO_CAPTURE} eq 'true' && ($result eq "SUCCESS" || $ENV{R_ALWAYS_SAVE_VIDEO} eq 'true')) {
       if (-e "$cur_dir/${raw_trail_name}.mp4") {
         `cp $cur_dir/${raw_trail_name}.mp4 "$tmpdir"`;
       } else {
          print "mp4 missing for ${raw_trail_name}\n";
          if ($result eq "SUCCESS") {  
             print_succ("R_VIDEO_CAPTURE: mp4 file for ${raw_trail_name} not found \n"); 
          } else {
            print_fail("R_VIDEO_CAPTURE: mp4 file for ${raw_trail_name} not found \n"); 
          }
       }
       
       if (-e "$cur_dir/${raw_trail_name}.vtl") {
         `cp $cur_dir/${raw_trail_name}.vtl "$tmpdir"`;
       } else {
          print "timelog missing for ${raw_trail_name}\n";
          if ($result eq "SUCCESS") {  
             print_succ("R_VIDEO_CAPTURE: timelog file for ${raw_trail_name} not found \n"); 
          } else {
            print_fail("R_VIDEO_CAPTURE: timelog file for ${raw_trail_name} not found \n"); 
          }
       }
       
       if(-e "$cur_dir/${raw_trail_name}.vcl") {
         `cp $cur_dir/${raw_trail_name}.vcl "$tmpdir"`;
       } else {
         print "videolog missing for ${raw_trail_name}\n";
         if ($result eq "SUCCESS") {  
             print_succ("R_VIDEO_CAPTURE: videolog file for ${raw_trail_name} not found \n"); 
         } else {
            print_fail("R_VIDEO_CAPTURE: videolog file for ${raw_trail_name} not found \n"); 
         }
       }

      if($shared_workspace_trail_size > 0) {
         my $ws_trail = ${shared_workspace_trail};
         $ws_trail =~ s/(\.txt)$//;
         if (-e "$cur_dir/${ws_trail}.mp4") {
            `cp $cur_dir/${ws_trail}.mp4 "$tmpdir"`;
          } else {
             print "mp4 missing for shared workspace trail ${shared_workspace_trail}\n";
              if ($result eq "SUCCESS") {  
                print_succ("R_VIDEO_CAPTURE: mp4 file for shared workspace trail ${shared_workspace_trail} not found \n"); 
              } else {
                 print_fail("R_VIDEO_CAPTURE: mp4 file for shared workspace trail ${shared_workspace_trail} not found \n"); 
              }
          }

          if (-e "$cur_dir/${ws_trail}.vtl") {
            `cp $cur_dir/${ws_trail}.vtl "$tmpdir"`;
          } else {
            print "timelog missing for ${shared_workspace_trail}\n";
            if ($result eq "SUCCESS") {  
             print_succ("R_VIDEO_CAPTURE: timelog file for shared workspace trail ${shared_workspace_trail} not found \n"); 
            } else {
             print_fail("R_VIDEO_CAPTURE: timelog file for shared workspace trail ${shared_workspace_trail} not found \n"); 
            }
          }
  
          if(-e "$cur_dir/${ws_trail}.vcl" && $ENV{R_SAVE_VIDEO_CAPTURE_LOG} eq 'true') {
            `cp $cur_dir/${ws_trail}.vcl "$tmpdir"`;
          } else {
            print "videolog missing for ${shared_workspace_trail}\n";
            if ($result eq "SUCCESS") {  
             print_succ("R_VIDEO_CAPTURE: videolog file for shared workspace trail ${shared_workspace_trail} not found \n"); 
            } else {
            print_fail("R_VIDEO_CAPTURE: videolog file for  shared workspace trail${shared_workspace_trail} not found \n"); 
            }
          }
	   }  
   }
    
   if ((! $keep_agent_home_folder) && (defined $ENV{R_SAVE_COLLABSVC_LOG}) && ($directives{shared_workspace} && $collab_atlas eq 'false')) {
                mkpath("$tmpdir/collabsvc_exe_log",0777) ;
                `$cp_cmd $cur_dir/scratch_tmp/* "$tmpdir/collabsvc_exe_log/" `;
                add_to_saveas("collabsvc_exe_log");
   }

   if ($ENV{IS_COLLAB_PLAYWRIGHT_TEST} =~ /yes/i) {
      if (-d "$ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}") {
        if (-d "$ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/playwright-report") {
            `$cp_cmd $ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/playwright-report $tmpdir`;
        } else {
           print "Warning:Directory $ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/playwright-report missing \n";  
        }
        
        if (-d "$ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/test-results") {
         `$cp_cmd $ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/test-results $tmpdir`; 
        } else {
           print "Warning:Directory $ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/test-results missing \n";
        }
        
        if (($result eq "FAILURE") && (defined $ENV{R_CHECK_REPO_EXISTS})) {
          print ("Content list of directory COLLAB_TEST_PLAYWRIGHT_REPO \n");
          print (`ls -lrtR $ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'}/* `);
        }
      } else {
         print "Warning:Directory COLLAB_TEST_PLAYWRIGHT_REPO=$ENV{'COLLAB_TEST_PLAYWRIGHT_REPO'} missing \n";
      }
   }
     
   if ($ENV{IS_GDX_PLAYWRIGHT_TEST} =~ /yes/i) {
      if (-d "$ENV{'GDX_TEST_PLAYWRIGHT_REPO'}") {
        if (-d "$ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/playwright-report") {
         `$cp_cmd $ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/playwright-report $tmpdir`; 
        } else {
          print "Warning:Directory $ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/playwright-report missing \n";  
        }
        
        if (-d "$ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/test-results") {
         `$cp_cmd $ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/test-results $tmpdir`;
        }  else {
          print "Warning:$ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/test-results missing \n";
        }

        if (($result eq "FAILURE") && (defined $ENV{R_CHECK_REPO_EXISTS})) {
          print ("Content list of directory GDX_TEST_PLAYWRIGHT_REPO \n");
          print (`ls -lrtR $ENV{'GDX_TEST_PLAYWRIGHT_REPO'}/* `);
        }  
      } else {
         print "Warning:Directory GDX_TEST_PLAYWRIGHT_REPO=$ENV{'GDX_TEST_PLAYWRIGHT_REPO'} missing \n";   
      }
   }  
       
  $to_save_as = 1 if (defined $ENV{R_SAVE_AS});
    if ($to_save_as || $to_save_filter_as) {
	 if ($result eq "FAILURE" || ($ENV{R_SAVEAS_ALWAYS} eq 'true')) {
      my $save_value;
      if ($to_save_as && $to_save_filter_as) {
         $save_value = "$ENV{R_SAVE_AS},$ENV{R_SAVE_FILTER}";
      } else {
         if ($to_save_as) {
           $save_value = $ENV{R_SAVE_AS};
         } else {
           $save_value = "$ENV{R_SAVE_FILTER}";
         }
      }
      my @save_array = ();

      my $cfound = grep /,/, $save_value;
      if ($cfound == 0) {
         push @save_array, "$save_value";
      } else {
         @save_array = split(/,/, $save_value);
      }
      my $fi;
      print "Saving files with extension $save_value ...\n";
      foreach $fi (@save_array) {
         my @savefiles = glob "$tmpdir/*${fi}*";
         my $savenum = @savefiles;
         print "$savenum $fi files found to save.\n";
         if ($savenum != 0) {
            mkdir ("$cur_dir/${raw_trailname}_saveas", 0777) if (! -d "$cur_dir/${raw_trailname}_saveas");
            print "Saving *${fi}* files to $cur_dir/${raw_trailname}_saveas..\n";
            `$cp_cmd  "$tmpdir/"*${fi}* "$cur_dir/${raw_trailname}_saveas"`;
            if (-d ${fi}) {
				if ($directives{wg_generate_code}) {
                    $tcur_dir = cwd();
                    $tcur_dir = `cygpath -m ${tcur_dir}`;
                    chomp($tcur_dir);
                    chdir_safe ("${fi}");
                    `zip -qr ../${fi}.zip .`;
                    chdir_safe ("$tcur_dir");
                    undef $tcur_dir;
                    `$cp_cmd $tmpdir/${fi}.zip $cur_dir/${raw_trailname}_saveas`;
                    `rm ${fi}.zip`;
                } else { 
                    `7za a ${fi}.7za ${fi}`;
                    `$cp_cmd $tmpdir/${fi}.7za $cur_dir/${raw_trailname}_saveas`;
                    `rm ${fi}.7za`;
			    }
            }
         } else {
            print "No $fi files not found to save.\n";
         }
      }
    }	  
   }

   if ( ($ENV{R_CHECK_ORPHAN_PROCESS} eq 'true') && (! $keep_agent_home_folder) ) {
      kill_process_by_handle("$cur_dir");
   }
   
   if ($ENV{R_USE_CREO_PLUS} eq "true" && -d $ENV{PTC_LOG_DIR} && (! $keep_agent_home_folder) ) {
    `$csh_cmd " rm -rf $ENV{PTC_LOG_DIR} "`;
    $ctmpdir =  `cygpath -m $tmpdir`;
    chomp($ctmpdir);
    `$csh_cmd " rm -rf $ctmpdir/${uniquename}_ptclog "`;
   }

   # Schematics test failure.
   if ($directives{rsd_test} && ($result eq "FAILURE")) {
     print "Schematics test failure - saving test data, tmp_dir=$tmpdir, run_dir=$rundir, raw_trail_name=$raw_trail_name\n";
	 
     schematics_post_fail_save_bac_in_rundir(tmp_dir=>$tmpdir, run_dir=>$rundir, raw_trl_name=>$raw_trail_name);
     schematics_post_fail_save_test_files_in_rundir(tmp_dir=>$tmpdir, run_dir=>$rundir, raw_trl_name=>$raw_trail_name);
     schematics_post_fail_save_std_out_in_rundir(tmp_dir=>$tmpdir, run_dir=>$rundir, raw_trl_name=>$raw_trail_name);
   }
   
   if ( ! $keep_agent_home_folder ) {
      if ( $R_SAVE_AS_default ne '' ) {
         $ENV{R_SAVE_AS} = $R_SAVE_AS_default;  
      } else {
         undef $ENV{R_SAVE_AS};
      }
   }
   
   if ( (! $keep_agent_home_folder) && ( ($collab_atlas eq 'true') || $directives{atlas_user} || ($shared_workspace_trail_size > 0) )) {
      if (defined $ENV{PHA_COLLAB_USER}) {
         delete ($ENV{PHA_COLLAB_USER});
      }
      
      if (defined $ENV{PHA_COLLAB_PWD}) {
          delete ($ENV{PHA_COLLAB_PWD});
      }
      
      if (defined $ENV{COLLABSVC_URL}) {
         delete ($ENV{COLLABSVC_URL});
      } 
      
      if (defined $ENV{CEF_DEBUG_PORT}) {
         delete ($ENV{CEF_DEBUG_PORT});
      }
      
      if (defined $ENV{ZB_DEBUG_PORT}) {
         delete ($ENV{ZB_DEBUG_PORT});
      }
      
      if (defined $ENV{COLLAB_SESSION_NAME_PREFIX}) {
          delete ($ENV{COLLAB_SESSION_NAME_PREFIX});
      }
   }

   if ( ($PATH_default ne '') && (! $keep_agent_home_folder) ) {
    $ENV{PATH} = $PATH_default;  
   }
   
   if (! $keep_agent_home_folder ) {
      unlink("$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}/repo-in-use.lock.$$") if (-e "$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}/repo-in-use.lock.$$");
      unlink("$ENV{GDX_TEST_PLAYWRIGHT_REPO}/repo-in-use.lock.$$") if (-e "$ENV{GDX_TEST_PLAYWRIGHT_REPO}/repo-in-use.lock.$$");
   }
   
   if ($ENV{CREO_SAAS_APIKEY} != "" && $directives{run_with_license}) {
        undef $ENV{CREO_SAAS_APIKEY};
   }
   
  &reset_envs;
  
  if ( ! $keep_agent_home_folder ) {
      if ($directives{uses_config_service}) {
        $ENV{'SAAS_CONFIGS_ON'} = $saas_config_on_default;
        undef $ENV{R_USE_SAAS_CONFIG_SERVICE} if ($ENV{'SAAS_CONFIGS_ON'} ne 'true');
      }          
  }
  
   `$rm_cmd -rf "$cur_dir/scratch_tmp"`;
   if (-d "$cur_dir/scratch_tmp") {
       print "\n\nWarning: $cur_dir/scratch_tmp still exists\n";
       my @filelist = glob("$cur_dir/scratch_tmp/*");
       chomp(@filelist);
       foreach (@filelist) {
           print "$_\n";
       }
   }
}

sub convert_path_win_to_posix_slashes {
    # Convert Windows slashes '\' path to Posix '/'.
    my %params = @_;
    my $path = $params{'path'};

    $path =~ s/\\/\//g;

    return $path;
}

sub schematics_post_fail_save_bac_in_rundir {
    # Schematics post failure saves .bac in rundir.
    my %params = @_;
    my $tmp_dir = convert_path_win_to_posix_slashes(path => $params{'tmp_dir'});
    my $run_dir = convert_path_win_to_posix_slashes(path => $params{'run_dir'});
    my $raw_trl_name = $params{'raw_trl_name'};
	my $cp_to = "$run_dir/$raw_trl_name";
    my $extension = ".bac";
    my $msg = "Schematics post failure save $extension -";

    my @files = glob "$tmp_dir/*${extension}*";
    foreach my $file (@files) {
        print "$msg found $file\n";
    }

    my $file_count = @files;
    if ($file_count != 0) {
        print "$msg saving $file_count *${extension}* files to $cp_to\n";
        `$cp_cmd "$tmp_dir/"*${extension}* "$cp_to"`;
    }
}

sub schematics_post_fail_save_std_out_in_rundir {
    # Schematics post failure saves 'std.out' in rundir.
    my %params = @_;
    my $tmp_dir = convert_path_win_to_posix_slashes(path => $params{'tmp_dir'});
    my $run_dir = convert_path_win_to_posix_slashes(path => $params{'run_dir'});
    my $raw_trl_name = $params{'raw_trl_name'};
	my $cp_to = "$run_dir/$raw_trl_name";
    my $std_out = "std.out";
    my $std_out_path = "$tmp_dir/$std_out";
    my $msg = "Schematics post failure save $std_out -";

    if (-e $std_out_path) {
        print "$msg saving $std_out to $cp_to\n";
        `$cp_cmd $std_out_path "$cp_to"`;
    }
}

sub schematics_get_schematics_file_from_dat_line {
    # Get Schematics file from .dat line. return file's Posix path or empty string.
    my %params = @_;
    my $line = $params{'line'};
    my $schematics_file = "";
    my $msg = "Schematics get test file -";

    if (length($line) > 0) {
        # Match valid Posix path?
        if ($line =~ m|^(?:/[^/]+)*$|) {
           $schematics_file = $line; 
        } 
        # Match valid Windows path start?
        if ($line =~ qr/^[a-zA-Z]:/) {
            # Convert Windows path to Posix.
            $schematics_file = convert_path_win_to_posix_slashes(path => $line);
        }
        
        # Possibly a valid path, does it exist?
        if (length($schematics_file) > 0) {
            if (-e $schematics_file) {
                print "$msg Schematics .dat line: '$line' is a Schematics file: $schematics_file.\n";
            } else {
                $schematics_file = "";
            }
        }
    }

    return $schematics_file; 
}

sub schematics_parse_dat {
    # Schematics parse .dat files to find test files.
    my %params = @_;
    my $dat_file =  $params{'dat_file'};
    my @schematics_files;
    my $msg = "Schematics parse dat -";

    open my $fh, '<', $dat_file or warn "$msg could not open '$dat_file' for reading: $!";

    if ($fh) {
        print "$msg parsing: $dat_file\n";
        while (<$fh>) {
            chomp;
            $_ =~ s/\s+//g;  # Remove all whitespace.    
            my $schematics_file = schematics_get_schematics_file_from_dat_line(line => $_);
            if (length($schematics_file) > 0) {
                push @schematics_files, $schematics_file;
            }
        }

        close $fh or warn "Could not close '$dat_file': $!";
    } else {
        print "$msg skipping '$dat_file', failed to open!.\n";
    }

    return @schematics_files;   
}

sub schematics_post_fail_save_test_files_in_rundir {
    # Schematics post failure saves test files (.qcr etc.) which are parsed from .dat in rundir.
    my %params = @_;
    my $tmp_dir = convert_path_win_to_posix_slashes(path => $params{'tmp_dir'});
    my $run_dir = convert_path_win_to_posix_slashes(path => $params{'run_dir'});
	my $raw_trl_name = $params{'raw_trl_name'};
	my $cp_to = "$run_dir/$raw_trl_name";
    my $extension = ".dat";
    my @test_files;
    my $msg = "Schematics post failure save test files -";

    # Parse .dat files to find test files.
    my @files = glob "$tmp_dir/*${extension}*";
    foreach my $file (@files) {
        my @schematics_files = schematics_parse_dat(dat_file => $file);
        my $schematics_files_count = @schematics_files;
        if ($schematics_files_count > 0 ) {
            push @test_files, @schematics_files; # test files.
            push @test_files, $file; # .dat
        }
    }
    # Save test files (.qcr etc.) to rundir.
    foreach my $test_file (@test_files) {
        print "$msg saving: $test_file to $cp_to\n";
        `$cp_cmd "$test_file" "$cp_to/"`;
    }  
}

sub restore_alt_c5_converter_env {
   if ($save_CADDS5_LINK_PATH eq "") {
      delete ($ENV{"CADDS5_LINK_PATH"});
   } else {
      $ENV{CADDS5_LINK_PATH} = $save_CADDS5_LINK_PATH;
   }
   $ENV{CV_ENV_HOME} = $old_CV_ENV_HOME;
}

sub set_dm_user_passwd {
   my ($first_char, @array);
   $ENV{WF_USERNAME} = $wfusername if (! defined $setenv_cmds{WF_USERNAME});
   $ENV{WF_PASSWD} = $wfpasswd if (! defined $setenv_cmds{WF_PASSWD});

   if (-e "$tmpdir/config.pro") {
      open(CONFIG_PT, "$tmpdir/config.pro");
      my (@config_list) = <CONFIG_PT>;
      close(CONFIG_PT);
      chomp(@config_list);
      foreach $line (@config_list) {
         chomp $line;
         $first_char = substr($line, 0, 1);
         next if ($first_char eq "!");
         @array = split(/\s+/, $line);
         $ENV{WF_USERNAME} = $array[1] if ($array[0] eq "dm_user");
         $ENV{WF_PASSWD} = $array[1] if ($array[0] eq "dm_passwd");
      }
   }
   if ( -e "$tmpdir/wgmclient.ini") {
     open(CONFIG_PT, "$tmpdir/wgmclient.ini");
     my (@config_list) = <CONFIG_PT>;
     close(CONFIG_PT);
     chomp(@config_list);
     foreach $line (@config_list) {
       chomp $line;
       $first_char = substr($line, 0, 1);
       next if ($first_char eq "!");
       @array = split(/=/, $line);
       $ENV{WF_USERNAME} = $array[1] if ($array[0] eq "dm.user");
       $ENV{WF_PASSWD} = $array[1] if ($array[0] eq "dm.passwd");
     }
   }
   print ("Setting WF_USERNAME to $ENV{WF_USERNAME}\n");
   print ("Setting WF_PASSWD to $ENV{WF_PASSWD}\n");
}

sub pre_directive_process_skip {
   my (@array);
   
  #check if creoagent exe exists. For windows fresh_creo_agent tests skipfail if not
  if (($directives{fresh_creo_agent}) && ($OS_TYPE eq "NT")) {
     my $creo_agent_path = "$ENV{PTCSYS}/obj/creoagent.exe";
     if (defined $ENV{CREO_AGENT_EXE_PATH}) {
        $creo_agent_path = $ENV{CREO_AGENT_EXE_PATH};
     }
	 
	 if (defined $ENV{R_USE_CREO_PLUS}) {
        $creo_agent_path = "$cc_location\\creoagent";
		if ($ENV{OS_TYPE} eq "NT") {
         $creo_agent_path = "$creo_agent_path.exe";
        }
     }
     
     if (! -e $creo_agent_path) {
        print_fail("skipped::  #skipped because $creo_agent_path does not exist\n");
        print_skip_msg("\nskipped::  #skipped $raw_trailname because $creo_agent_path does not exist\n");
        return (-1);
     }
  }
   
  if ($directives{obsolete_test} && $ENV{R_RUN_OBSOLETE_TEST} ne "true") {
     print_succ("skipped::  #skipped because R_RUN_OBSOLETE_TEST is not set to true\n");
     print_skip_msg("\nskipped::  #skipped $raw_trailname because R_RUN_OBSOLETE_TEST is not set to true\n");
     return (1);
  }
  
  if ($directives{creoint_incubation} && $ENV{CREOINT_PRODUCTION_STATUS} eq "PRODUCTION") {
     print_succ("skipped::  #skipped because test has directive #creoint_incubation and CREOINT_PRODUCTION_STATUS is PRODUCTION\n");
     print_skip_msg("\nskipped::  #skipped $raw_trailname because test has directive #creoint_incubation and CREOINT_PRODUCTION_STATUS is PRODUCTION\n");
     return (1);
  }
  
  if (!$directives{creoint_incubation} && $ENV{CREOINT_PRODUCTION_STATUS} eq "INCUBATION") {
     print_succ("skipped::  #skipped because test does not have directive #creoint_incubation and CREOINT_PRODUCTION_STATUS is INCUBATION\n");
     print_skip_msg("\nskipped::  #skipped $raw_trailname because test does not have directive #creoint_incubation and CREOINT_PRODUCTION_STATUS is INCUBATION\n");
     return (1);
  }

  if ($directives{uwgmcc_test} && $ENV{R_RUN_UWGMCC_TESTS} ne "true") {
        print_succ("\nskipped::  #skipped because R_RUN_UWGMCC_TESTS is not set to true\n");
        print_skip_msg("\nskipped::  #skipped $raw_trailname because R_RUN_UWGMCC_TESTS is not set to true\n");
        return (1);
  }

  if ($directives{drm_test}) {
     if ($ENV{R_RUN_DRM_TESTS} ne "true" && !$directives{force_drm}) {
        print_succ("\nskipped::  #skipped because R_RUN_DRM_TESTS is not set to true\n");
        print_skip_msg("\nskipped::  #skipped $raw_trailname because R_RUN_DRM_TESTS is not set to true\n");
        return (1);
     }
     if ($PRO_MACHINE_TYPE =~ /hpux/ && ! -e "/dev/urandom") {
        print_fail("\nskipped::  #skipped because /dev/urandom is not found\n");
        print_skip_msg("\nskipped::  #skipped because /dev/urandom is not found\n");
        return (-1);
     }
  }

  if ($directives{interface_retrieval} && $ENV{R_EXCLUDE_INTF} eq "true") {
     print_succ("skipped::  #skipped interface_retrieval test because R_EXCLUDE_INTF is set to true\n");
     print_skip_msg("skipped::  #skipped interface_retrieval test because R_EXCLUDE_INTF is set to true\n");
     return (1);
  }

  if ($directives{retr_test} && $ENV{R_EXCLUDE_RETR} eq "true") {
     print_succ("skipped::  #skipped retr_test test because R_EXCLUDE_RETR is set to true\n");
     print_skip_msg("skipped::  #skipped retr_test test because R_EXCLUDE_RETR is set to true\n");
     return (1);
  }
  if ($directives{gcri_retr_test} && $ENV{R_EXCLUDE_RETR} eq "true") {
     print_succ("skipped::  #skipped gcri_retr_test test because R_EXCLUDE_RETR is set to true\n");
     print_skip_msg("skipped::  #skipped gcri_retr_test test because R_EXCLUDE_RETR is set to true\n");
     return (1);
  }

  if ($directives{perf_test} && $ENV{R_PERF} ne "true") {
     $num_perf_test = 0;
     print_succ("skipped::  #skipped perf_test because R_PERF is not set to true. perf_test should use the perform script instead of auto.\n");
     print_skip_msg("skipped::  #skipped perf_test because R_PERF is not set to true. perf_test should use the perform script instead of auto.\n");
     return (1);
  }
  if (!$directives{perf_test} && $ENV{R_PERF} eq "true") {
     print_succ("skipped::  #skipped because R_PERF is set to true but this is not a perf_test\n");
     print_skip_msg("skipped::  #skipped because R_PERF is set to true but this is not a perf_test\n");
     return (1);
  }
  if ($directives{production_test}) {
     if (!exists $ENV{R_PRODUCTION_TEST} || $ENV{R_PRODUCTION_TEST} ne "true"){
        print_succ("skipped::  #skipped $raw_trailname because R_PRODUCTION_TEST is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_PRODUCTION_TEST is not true\n");
        return (1);
     }
  }

  if ($directives{uitoolkit_app_test}) {
     if (! defined $ENV{R_UITOOLKIT_APP}) {
        print_fail("skipped::  #skipped because R_UITOOLKIT_APP is not set\n");
        print_skip_msg("skipped::  #skipped because R_UITOOLKIT_APP is not set\n");
        return (-1);
     }
  }

  if (defined $ENV{R_SKIP_JAVA}) {
     if ($directives{java_test} || $directives{java_async_test} || $directives{otk_java_test}
        || $directives{wf_js_test}) {
        print_fail("skipped::  #skipped because R_SKIP_JAVA is set\n");
        print_skip_msg("skipped::  #skipped because R_SKIP_JAVA is set\n");
        return (-1);
     }
  }

  if (defined $ENV{R_SKIP_TOOLKIT}) {
     if ($directives{pt_asynchronous_tests} || $directives{pt_async_test} ||
     $directives{pd_async_test} || $directives{pt_simple_async_test} ||
     $directives{distapps_dsapi} || $directives{pfcvb_test} ) { 
        print_fail("skipped::  #skipped because R_SKIP_TOOLKIT is set\n");
        print_skip_msg("skipped::  #skipped because R_SKIP_TOOLKIT is set\n");
        return (-1);
     } else {
    if ($directives{num_cmd}) {
       foreach $key (keys(%cmd_list)) {
           if ($cmd_list{$key} =~ /prodevdat_setup/) {
          print_fail("skipped::  #skipped because R_SKIP_TOOLKIT is set\n");
          print_skip_msg("skipped::  #skipped because R_SKIP_TOOLKIT is set\n");
          return (-1);
           }
       }
    }
     }
  }


  if ($directives{mech_motion_test}) {
     if ( $OS_TYPE eq "NT") {
        if (! defined $ENV{MM_C_HOME} || ! defined $ENV{MM_ALT_LIB_DIR}) {
            print_succ("skipped::  #skipped MM_C_HOME/MM_ALT_LIB_DIR are not set\n");
            print_skip_msg("skipped::  #skipped MM_C_HOME/MM_ALT_LIB_DIR are not set\n");
            return (1);
        }
     }
  }

  if ($directives{mech_test_long}) {
     if (defined $ENV{R_RUN_MECH_TEST_LONG}) {
        if ($ENV{R_RUN_MECH_TEST_LONG} ne "true"){
           print_fail("skipped::  #skipped because R_RUN_MECH_TEST_LONG is not true\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_MECH_TEST_LONG is not true\n");
           return (-1);
        }
     } else {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_MECH_TEST_LONG is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_MECH_TEST_LONG is not true\n");
        return (1);
     }
  }

  if ($directives{mech_test}) {
     if ($ENV{R_RUN_MECH_TEST} ne "true"){
        print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_MECH_TEST is not true\n");
        return (-1);
     }
  }

  if ($directives{ug_test} || $directives{ug_dbatch_test}) {
     if ($ENV{R_UG_ENABLE} ne "true" && ! $directives{force_ug}) {
        print_succ("skipped::  #skipped ug_test test because R_UG_ENABLE is not set to true\n");
        print_skip_msg("skipped::  #skipped ug_test test because R_UG_ENABLE is not set to true\n");
        return (1);
     }
  }

  if ($directives{ptwt_test}) {
     if (not defined $ENV{RUN_WILDFIRE_PDM}) {
            print_succ("skipped::  #skipped $raw_trailname because RUN_WILDFIRE_PDM is not set\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because RUN_WILDFIRE_PDM is not set\n");
            return (1);
     }
  }

  if ($directives{ptwt_test}) {
    &apply_setenv;
    &fastreg_parse_test_vars($wildfire_test_vars);
    fastreg_setup();
  } else {
    if ( ($directives{wildfire_test} && $fastreg_test_flags{server}) || 
        ($directives{wildfire_test} && $directives{wnc_flavor}) ) {
      if (!$run_wildfire_pdm) {
        print_succ("skipped::  #skipped RUN_WILDFIRE_PDM is not \"true\"\n");
        print_skip_msg("skipped::  #skipped RUN_WILDFIRE_PDM is not \"true\"\n");
        return (1);
      }
	if (!defined $ENV{R_USE_LOCAL_SERVER}) {	
      if ( !defined($fastreg_server) || !defined($fastreg_pool) ) {
        print_fail("skipped::  #skipped because fastregs server and/or pool are not set\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because fastregs server and/or pool are not set\n");
        return (-1);
      }
	} 	
    }
  }
  if ($directives{prokernel_test} && defined $ENV{SKIP_PROKERNEL_TEST}) {
     if ($directives{keep}) {
    $skip_keep_test = 1;
    $copy_keep_files = 1;
     }
     print_fail("skipped::  #skipped because SKIP_PROKERNEL_TEST is set\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because SKIP_PROKERNEL_TEST is set\n");
     return (-1);
  }

  if ($directives{not_run_test}) {
    if (! defined $ENV{R_NOT_RUN_ENABLE} || $ENV{R_NOT_RUN_ENABLE} ne "true") {
       print_succ("skipped::  #skipped because this test is not run by default. Set variable R_NOT_RUN_ENABLE to true if you want to run this test.\n");
       print_skip_msg("skipped::  #skipped $raw_trailname because this test is not run by default. Set variable R_NOT_RUN_ENABLE to true if you want to run this test.\n");
       return (1);
    }
  }

   if ($directives{not_run_on_test}) {
      @array = split(/ +/, $not_run_on_mach_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
            print_succ("skipped::  #skipped because the test not run on $mach_list\n");
            print_skip_msg("skipped::  #skipped because the test not run on $mach_list\n");
            return (1);
         }
      }
   }

   if ($directives{not_run_with_lang}) {
      @array = split(/ +/, $not_run_lang_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $altlang) {
            print_succ("skipped::  #skipped because the test not run with $not_run_lang_list\n");
            print_skip_msg("skipped::  #skipped because the test not run with $not_run_lang_list\n");
            return (1);
         }
      }
   }

   if ($directives{run_only_with_lang}) {
      if ($run_only_lang_list !~ /$altlang/) {
         if ($altlang ne "") {
            print_succ("skipped::  #skipped because the test run only with $run_only_lang_list\n");
            print_skip_msg("skipped::  #skipped because the test run only with $run_only_lang_list\n");
            return (1);
         } else {
            if ($run_only_lang_list !~ /english/) {
               print_succ("skipped::  #skipped because the test run only with $run_only_lang_list\n");
               print_skip_msg("skipped::  #skipped because the test run only with $run_only_lang_list\n");
               return (1);
            }
         }
      }
   }

   if ($directives{run_only_on_test}) {
      if ($mach_list !~ /$PRO_MACHINE_TYPE\b/) {
         print_succ("skipped::  #skipped $raw_trailname because the test only run on $mach_list\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because the test only run on $mach_list\n");
         return (1);
      }
   }
   if ($directives{graphics_test_on} && $ENV{R_GRAPHICS} eq "0") {
      @array = split(/ +/, $g_mach_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
            print_succ("skipped::  #skipped because the test is only run with graphics on $PRO_MACHINE_TYPE\n");
            print_skip_msg("skipped::  #skipped because the test is only run with graphics on $PRO_MACHINE_TYPE\n");
            return (1);
         }
      }
   }

   if ($directives{non_graphics_test_on} && $ENV{R_GRAPHICS} ne "0") {
      @array = split(/ +/, $g_mach_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
            print_succ("skipped::  #skipped because the test is only run without graphics on $PRO_MACHINE_TYPE\n");
            print_skip_msg("skipped::  #skipped because the test is only run without graphics on $PRO_MACHINE_TYPE\n");
            return (1);
         }
      }
   }

   if ($directives{no_graphics_mode_on} && $ENV{R_GRAPHICS} ne "0") {
      @array = split(/ +/, $g_mode_mach_list);
      if ($array[0] eq $ENV{R_GRAPHICS}) {
     for ($i=1; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
        print_succ("skipped::  #skipped because the test is not run with graphics mode $array[0] on $PRO_MACHINE_TYPE\n");
        print_skip_msg("skipped::  #skipped because the test is not run with graphics mode $array[0] on $PRO_MACHINE_TYPE\n");
            return (1);
         }
     }
      }
   }

   if ($directives{no_future_mode} && $ENV{R_SKIP_FUTURE_MODE} eq "true") {
      print_succ("skipped::  #skipped because the test is not run in the future mode\n");
      print_skip_msg("skipped::  #skipped because the test is not run in the future mode\n");
      return (1);
   }

   if (defined $ENV{R_SUPERAUTO}) {
      if ($directives{plpf_test} ||
         $directives{generic_uif_test} || $directives{generic_ui_test} ||
         $directives{java_async_test} || $directives{java_sync_test} ||
         $directives{pt_async_pic_test} || $directives{prokernel_test} ) {

         print_succ("skipped::  #skipped because R_SUPERAUTO is set\n");
         print_skip_msg("skipped::  #skipped because R_SUPERAUTO is set\n");
         return (1);
      }
   }
   if ($directives{chinese_test} && $altlang ne "chinese_tw") {
      print_succ("skipped::  #skipped because the test only run in Chinese\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Chinese\n");
      return (1);
   }
   if ($directives{korean_test} && $altlang ne "korean") {
      print_succ("skipped::  #skipped because the test only run in Korean\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Korean\n");
      return (1);
   }
   if ($directives{latin_lang_test} && !$latin_lang) {
      print_succ("skipped::  #skipped because the test only run in Latin language\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Latin language\n");
      return (1);
   }

   if ($directives{english_test} && $altlang ne "") {
      print_succ("skipped::  #skipped $raw_trailname because the test only run in English\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in English\n");
      return (1);
   }
   if ($directives{not_run_with_graphics}) {
      @array = split(/ +/, $graphics_test_modes);
      my ($match_graphics) = 0;
      for ($i=0; $i<@array; $i++) {
      if ($array[$i] eq $ENV{R_GRAPHICS}) {
         $match_graphics = 1;
         last;
      }
      }
      if ($match_graphics) {
     print_succ("skipped::  #skipped because the test not run with $array[$i] graphics mode\n");
     print_skip_msg("\nskipped::  #skipped $raw_trailname because the test not run with $array[$i] graphics mode\n");
     return (1);
      }
   }
   if ($directives{graphics_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         print_succ("skipped::  #skipped because the test only run as graphics\n");
         print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run as graphics\n");
         return (1);
      } else {
         if ("$graphics_test_modes" ne "") {
            @array = split(/ +/, $graphics_test_modes);
            my ($match_graphics) = 0;
            for ($i=0; $i<@array; $i++) {
               if ($array[$i] eq $ENV{R_GRAPHICS}) {
                  $match_graphics = 1;
                  last;
               }
            }
            if (! $match_graphics) {
               print_succ("skipped::  #skipped because the test only run with $graphics_test_modes graphics mode\n");
               print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run with $graphics_test_modes graphics mode\n");
               return (1);
            }
         }
      }
   }
   if ($directives{none_graphics_test} && $ENV{R_GRAPHICS} ne "0") {
      print_succ("skipped::  #skipped because the test only run as non graphics\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run as non graphics\n");
      return (1);
   }
   if ($directives{check_ram_test} && $ram_size > 0 && $ram_size < $check_ram_size) {
      print_fail("skipped::  #skipped because the RAM size is $ram_size and the test on run on > $check_ram_size RAM machine\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the RAM size is $ram_size and thetest on run on > $check_ram_size RAM machine\n");
      return (-1);
   }
   if ($directives{japanese_test} && $altlang ne "japanese") {
      print_succ("skipped::  #skipped because the test only run in Japanese\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Japanese\n");
      return (1);
   }

   if ($directives{distapps_dsapi}) {
      if (! (defined $ENV{R_LOCAL_DS_C_CLNT} || defined $ENV{R_LOCAL_DS_CLNT_TESTS})) {
         if (! -e "${PTCSYS}/obj/ds_c_clnt_tests$exe_ext") {
            print_fail("skipped::  #skipped because ${PTCSYS}/obj/ds_c_clnt_tests$exe_ext does not exist\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because ${PTCSYS}/obj/ds_c_clnt_tests$exe_ext does not exist\n");
            return (-1);
         }
      }
   }

   if ($directives{pfcvb_test}) {
      if (! -e "$ENV{R_PFCLSCOM_DIR}/pfclscom.exe") {
     print_fail("skipped::  #skipped because $ENV{R_PFCLSCOM_DIR}/pfclscom.exe not exist\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because $ENV{R_PFCLSCOM_DIR}/pfclscom.exe not exist\n");
     return (-1);
      }
   }

   if ($directives{anim_test}) {
      ## This R_RUN_MECH_TEST check was put in for Integ testing purpose
      if ($ENV{R_RUN_MECH_TEST} ne "true") {
         print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
         print_skip_msg("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
         return (-1);
      }
      if (! defined $ENV{ANIMATION_HOME}) {
         print_fail("skipped::  #skipped because ANIMATION_HOME is not set\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because ANIMATION_HOME is not set\n");
     &fail_skip($i, 0);
         return (-1);
      } elsif (! -d "$ENV{ANIMATION_HOME}") {
         print_fail("skipped::  #skipped because ANIMATION_HOME is not exist\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because ANIMATION_HOME is not exist\n");
         return (-1);
      }
   }

   if ($directives{ipc_test}) {
      if (! -e "$ENV{R_IPCTEST}") {
     print_fail("skipped::  #skipped because $ENV{R_IPCTEST} is missing\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because $ENV{R_IPCTEST} is missing\n");
     return (-1);
      }
      if (! -e "$ENV{R_COMM_BRK_SVC}") {
         print_fail("skipped::  #skipped because $ENV{R_COMM_BRK_SVC} is missing\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because $ENV{R_COMM_BRK_SVC} is missing\n");
     return (-1);
      }
   }

   if ($directives{EDAcompare_test}) {
      if (! defined $ENV{EDACOMPAREHOME}) {
     print_fail("skipped::  #skipped because EDAcompare is not installed\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because EDAcompare is not installed\n");
     return (-1);
      }
      if (! defined $ENV{ICMHOME}) {
     print_fail("skipped::  #skipped because ICM is not installed\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because ICM is not installed\n");
     return (-1);
      }
   }
   if ($directives{mdx_test}) {
      ## This R_RUN_MECH_TEST check was put in for Integ testing purpose
      if ($ENV{R_RUN_MECH_TEST} ne "true") {
         print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
         print_skip_msg("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
         return (-1);
      }
      if (! defined $ENV{MECHANISM_HOME} && $r_using_local_install == 0) {
         print_fail("skipped::  #skipped because MECHANISM_HOME is not set\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because MECHANISM_HOME is not set\n");
     &fail_skip($i, 0);
         return (-1);
      } elsif (! -d "$ENV{MECHANISM_HOME}" && $r_using_local_install == 0) {
         print_fail("skipped::  #skipped because MECHANISM_HOME is not exist\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because MECHANISM_HOME is not exist\n");
         return (-1);
      }
   }

   if ($directives{run_if_set}) {
      @array = split(/ +/, $env_list);
      for ($i=0; $i<@array; $i++) {
     next if ($array[$i] eq "");
         if ((("$array[$i]" eq "MECH_HOME") || 
          ("$array[$i]" eq "MECHANISM_HOME") || 
          ("$array[$i]" eq "ANIMATION_HOME")) && 
          ($ENV{R_RUN_MECH_TEST} ne "true")) {
                   print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
                   print_skip_msg("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
                   return (-1);
         }
         ## animation home and mechanism home are not needed for local install.
         if (! exists $ENV{$array[$i]} && 
              ((("$array[$i]" ne "ANIMATION_HOME") && ("$array[$i]" ne "MECHANISM_HOME")) || $r_using_local_install == 0)) {
                  print_fail("skipped:: #skipped because $array[$i] is not set\n");
                  print_skip_msg("skipped::  #skipped because $array[$i] is not set\n");
                  return (-1);
               }
      }
      
   }

   if ($directives{check_display}) {
      return (-1) if (test_display());
   }

   if ($directives{if_exist} && $ENV{R_ENABLE_IF_EXIST} eq "true") {
      @array = split(/ +/, $if_exist_list);
      if ($array[0] eq "" && $array[1] eq "") {
         print_fail("skipped::  #skipped because no keywords specified for #if_exist directive\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because no keywords specified for #if_exist directive\n");
         return (-1);
      }
      foreach $if_exist_target (@array) {
         next if ($if_exist_target eq "" || $autoexist_db{$if_exist_target}{'1'}[0] eq "NA");
         if (! defined $autoexist_db{$if_exist_target}) {
            print_fail("skipped::  #skipped because no $if_exist_target for $PRO_MACHINE_TYPE is defined in $autoexist_file\n"); 
            print_skip_msg("skipped::  #skipped $raw_trailname because no $if_exist_target for $PRO_MACHINE_TYPE is defined in $autoexist_file\n");
            return (-1);
         }

         foreach $count (keys %{$autoexist_db{$if_exist_target}}) {
            $target = $autoexist_db{$if_exist_target}{$count}[0];
            $alt_target = $autoexist_db{$if_exist_target}{$count}[1];
            if ($alt_target eq '' && ! -e "$PTCSYS/$target") {
               print_fail("skipped::  #skipped because $PTCSYS/$target doesn't exist\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $PTCSYS/$target doesn't exist\n");
               if (defined $ENV{R_WAIT_FOR_BINARY}) {
                 sleep_for_a_while();
               }

               return (-1);
            }
            if ($alt_target ne '' && ! -e "$PTCSYS/$target" && ! -e "$alt_target") {
               print_fail("skipped::  #skipped because $PTCSYS/$target or $alt_target doesn't exist\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $PTCSYS/$target or $alt_target doesn't exist\n");
               return (-1);
            }
         }
         if (-e "$PTCSYS/$target") {
            print "\n  $PTCSYS/$target exists, continuing ..\n\n";
         }
         if (-e "$alt_target") {
            print "\n  $alt_target exists, continuing ..\n\n";
         }
      }
   }

   if ($directives{mathcad_test}) {
       if ($OS_TYPE eq "NT") {
           $Registry->Delimiter("/");
           my $math = "";
           foreach (keys %{$Registry->{"HKEY_CLASSES_ROOT/AppID"}}) {
               if (/Mathcad.EXE/i) {
                   $math = "true";
                   last;
               }
           }
           my $mathprime = "";
           foreach (keys %{$Registry->{"HKEY_CLASSES_ROOT"}}) {
               if (/MathcadPrime.EXE/i) {
                   $mathprime = "true";
                   last;
               }
           }
           if ($mathcad_version eq "prime" && $mathprime eq "")  {
               print_fail("skipped::  #skipped because MathCad $mathcad_version is not installed\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because MathCad $mathcad_version is not installed\n");
               return (-1);
           }
           if (($mathcad_version eq "13" || $mathcad_version eq "14" || $mathcad_version eq "15") && $math eq "") {
               print_fail("skipped::  #skipped because MathCad $mathcad_version is not installed\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because MathCad $mathcad_version is not installed\n");
               return (-1);
           }

     if (($mathcad_version eq "13" || $mathcad_version eq "14" || $mathcad_version eq "15") && $math ne "") {
        print_succfail("Running ${PTC_TOOLS}/bin/mathcad_register $mathcad_version\n");
        $stat = system("$csh_cmd \"${PTC_TOOLS}/bin/mathcad_register $mathcad_version\"");
                if ($stat) {
                    print_fail("skipped::  #skipped because status bad from mathcad_register\n");
                    print_skip_msg("skipped::  #skipped $raw_trailname because status bad from mathcad_register\n");
                    return (-1);
                }
     }
      }
   }

   if ($directives{no_mathcad_test}) {
      if ($OS_TYPE eq "NT") {
     $ENV{DBG_MATHCAD_INSTALL} = "FALSE";
      }
   }

   if ($directives{flex_lic_chk}) {
      print "\nChecking license server $flexserver for available licenses ..\n";

      print "${TOOLDIR}license_check -s $flexserver\n";
      my @scriptout = `$csh_cmd "${TOOLDIR}license_check -s $flexserver"`;
      my $serverstat = grep /: UP$/, @scriptout;

      if ($serverstat == 0) {
     print_fail("skipped::  #skipped because license server $flexserver is down\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because license server $flexserver is down\n");
         return (-1);
      } else {
     my $scripterr = grep /^ERROR: /, @scriptout;
     if ($scripterr != 0) {
        print_fail("skipped::  #skipped because ${TOOLDIR}license_check has errors\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because ${TOOLDIR}license_check has errors\n");
        foreach $l (@scriptout) {
            print "$l";
        }
        return (-1);
         } else {
        foreach $feature (@scriptout) {
        chomp($feature);
            next if ($feature eq "" or $feature =~ /: UP/);
        my ($fname,$licensesvalues) = split(/:/, $feature);
        my ($free,$inuse,$total) = split(/\//, $licensesvalues);
            if ($free == 0 || $free !~ /\d+/) {
                print_fail("skipped::  #skipped because no licenses are free for feature $fname on $flexserver\n");
                print_skip_msg("skipped::  #skipped $raw_trailname because no licenses are free for feature $fname on $flexserver\n");
                return (-1);
            }
        }
     }
      }
      print "Licenses are available, continuing ..\n\n";
   }
   if ($directives{solidworks_test}) {
       $sw_os = "XP" if ($WIN_OS =~ /XP/i);
       $sw_os = "VISTA" if ($WIN_OS =~ /VISTA|Windows 7|Windows 8|Windows 8\.1|Windows 10|Windows Server/i);
       $pre_sw_PATH = $ENV{PATH};
      
       if ($solidworks_version ne "") {
           print_succfail("Running regsvr32 /s z:/apps/sw${solidworks_version}/$PRO_MACHINE_TYPE/$sw_os/SwDocumentMgr.dll\n");
           $stat = system("$REGSVR32 /s z:\\apps\\sw${solidworks_version}\\$PRO_MACHINE_TYPE\\$sw_os\\SwDocumentMgr.dll");
           if ($stat) {
               print_fail("skipped::  #skipped because status bad from regsvr32 SwDocumentMgr.dll\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because status bad from regsvr32 SwDocumentMgr.dll\n");
               return (-1);
           }
           $ENV{PATH} = "z:\\apps\\sw${solidworks_version}\\$PRO_MACHINE_TYPE\\$sw_os;$ENV{PATH}";
       }
   }

   if ($directives{inventor_test}) {
       if ($ENV{R_INVENT_ENABLE} eq "true") {
           my $installed_inventor_version = -1;
           if ($OS_TYPE eq "NT") {
               $Registry->Delimiter("/");
			   $installed_inventor_version = 23 if ($Registry->{"HKEY_LOCAL_MACHINE/SOFTWARE/Autodesk/Inventor/RegistryVersion27.0"});
			   $installed_inventor_version = 24 if ($Registry->{"HKEY_LOCAL_MACHINE/SOFTWARE/Autodesk/Inventor/RegistryVersion28.0"});               
           }
		   print_succfail("Running on inventor version $installed_inventor_version\n");
           unless (grep (/$installed_inventor_version/, @inventor_versions)) {
               print_fail("skipped::  #skipped inventor_test test because specified Inventor version is not installed\n");
               print_skip_msg("skipped::  #skipped inventor_test test because specified Inventor version is not installed\n");
               return (-1);
           }
       } else {
           print_succ("skipped::  #skipped inventor_test test because R_INVENT_ENABLE is not set to true\n");
           print_skip_msg("skipped::  #skipped inventor_test test because R_INVENT_ENABLE is not set to true\n");
           return (1);
       }
   }

   if ($directives{not_run_with_xtop_md} && $local_xtop =~ /xtop_md.exe/) {
          print_succ("\nskipped::  #skipped because $raw_trailname is not supported by xtop_md.exe\n");
          print_skip_msg("\nskipped::  #skipped because $raw_trailname is not supported by xtop_md.exe\n");
          return (1);
   }
   if ($directives{wf_js_test}) {
       $src = "$ENV{PRO_SRC}/apps/pfcweblink/weblinktests";
       if ($OS_TYPE eq "NT") {
           $src =~ s/\\/\//g;
           $src =~ s/.://;
           $src =~ s/portsrc/sportsrc/;
           $src =~ s/rpsrcl01/srpsrcl01/;
           $src =~ s/rpsrcl03/srpsrcl03/;
       }
       $src = "http://rdweb.ptc.com/ptcsrc".$src;
       $result = head($src);
       unless ($result) {
           print_fail("skipped:: #skipped $raw_trailname because weblink $src does not exist"); 
           print_skip_msg("skipped:: #skipped $raw_trailname because weblink $src does not exist"); 
           return (-1);
       }
   }
   if ($directives{cadds5_topology_test} && $OS_TYPE eq "NT") {
	  unless ($ENV{NUTCROOT}) {
		  print_succ("skipped::  #skipped cadds5_topology_test because NUTCROOT is not set\n");
		  print_skip_msg("skipped::  #skipped cadds5_topology_test because NUTCROOT is not set\n");
		  return (1);
	  }
   }
  if ($directives{ptc_univ_ce_test}) {
     if (defined $ENV{R_RUN_PTC_UNIV_CE_TEST}) {
        if ($ENV{R_RUN_PTC_UNIV_CE_TEST} ne "true"){
           print_fail("skipped::  #skipped because R_RUN_PTC_UNIV_CE_TEST is not true\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_PTC_UNIV_CE_TEST is not true\n");
           return (-1);
        }
     } else {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_PTC_UNIV_CE_TEST is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_PTC_UNIV_CE_TEST is not true\n");
        return (1);
     }
  }
  
  if ($directives{nist_analyzer_test}) {
     if ($ENV{R_RUN_NIST_ANALYZER_TEST} ne "true") {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_NIST_ANALYZER_TEST is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_NIST_ANALYZER_TEST is not true\n");
        return (1);      
     }
     if ($OS_TYPE eq "NT") {
        if (! is_sfa_installed()) {
          print_fail("skipped::  #skipped $raw_trailname because IFCsvrR300 setup is not installed\n");
          print_skip_msg("skipped::  #skipped $raw_trailname because IFCsvrR300 setup is not installed\n");
          $skip_msg = "because Registry(HKLM/SOFTWARE/Classes/IFCsvr.R300) not found, IFCsvrR300 setup is not installed\n";
          return (-1);
		 }
      }
   }

 if ($directives{simlive_test}) {
    if ((defined $ENV{R_RUN_SIMLIVE}) || $support_non_simlive_mode eq 'true') {

        if (($ENV{R_RUN_SIMLIVE} eq "true") && ($ENV{R_GRAPHICS} == 0 || $ENV{R_GRAPHICS} eq "")) { 
           print_succ("skipped::  #skipped because R_GRAPHICS is set to 0\n");
           print_skip_msg("skipped::  #skipped because R_GRAPHICS is set to 0\n");
           return (1);
        } 

        if (($ENV{R_RUN_SIMLIVE} ne "true") && $support_non_simlive_mode ne 'true'){
           print_fail("skipped::  #skipped because R_RUN_SIMLIVE is not true\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_SIMLIVE is not true\n");
           return (-1);
        } 

        if ($ENV{R_RUN_SIMLIVE} eq "true") {
           if (defined $ENV{R_RUN_SKIP_SIMLIVE_SOLVER}) {
              print "Removing ENV R_RUN_SKIP_SIMLIVE_SOLVER \n";
              delete $ENV{R_RUN_SKIP_SIMLIVE_SOLVER};  
		      }
              
              if (! exists $ENV{"AUTO_PROC_MEM_LIMIT"}) {
                 $clean_setenv_cmds{'AUTO_PROC_MEM_LIMIT'} = $ENV{AUTO_PROC_MEM_LIMIT};           
                 $ENV{"AUTO_PROC_MEM_LIMIT"} = "10000";
              }
              print "using AUTO_PROC_MEM_LIMIT (Megabyte) = $ENV{AUTO_PROC_MEM_LIMIT} for simlive_test\n";
        } elsif ($ENV{R_RUN_SIMLIVE} ne "true") {
            $clean_setenv_cmds{R_RUN_SKIP_SIMLIVE_SOLVER} = $ENV{R_RUN_SKIP_SIMLIVE_SOLVER};
            $ENV{R_RUN_SKIP_SIMLIVE_SOLVER} = 'true';
            print "R_RUN_SKIP_SIMLIVE_SOLVER is set $ENV{R_RUN_SKIP_SIMLIVE_SOLVER}\n";
        }
     } else {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_SIMLIVE is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_SIMLIVE is not true\n");
        return (1);
     }
   }

 if ($directives{do_not_run_on_hdpi}) {
    if (defined $ENV{R_HDPI_RUN} &&  $ENV{R_HDPI_RUN} eq 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_HDPI_RUN is true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_HDPI_RUN is true\n");
        return (1);
     }
   }

 if ($directives{run_only_on_cdimage}) {
    if (! $r_using_local_install) {
       print_succ("skipped::  #skipped $raw_trailname because test is to run on CD image install\n");
       print_skip_msg("skipped::  #skipped $raw_trailname because test is to run on CD image install\n");
        return (1);
     }
 }    

 if ($directives{wwgmint_test}) {
    if ( $r_using_local_install) {
       print_succ("skipped::  #skipped $raw_trailname because wwgm test is not run on CD image install\n");
       print_skip_msg("skipped::  #skipped $raw_trailname because wwgm test is not run on CD image install\n");
        return (1);
     }
 }    

    if ($directives{gd_test}) {
        if ($ENV{PRO_MACHINE_TYPE} ne 'x86e_win64') {
            print_succ("skipped::  #skipped $raw_trailname because gd_test is to run only on x86e_win64\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because gd_test is to run only on x86e_win64\n");
            return (1);
        }
    }
    
    if ($directives{graphics_process} && $tk_flavor_ eq 'gpu' && $ENV{PRO_MACHINE_TYPE} eq 'x86e_win64') {
      if ($gpu_supported) {
            print_succ("skipped::  #skipped $raw_trailname because Hardware not supported for GPU run \n");
            print_skip_msg("skipped::  #skipped $raw_trailname because Hardware not supported for GPU run \n");
            return (1);
      } 
   }

   if ($directives{java_flavor}) {
      my $jdkver = (split(/jdk/,$tk_flavor_)) [1];
      $jdkver =~ s/ $//g;
      if ($tk_flavor_ =~ /^ac/) {
        if (not defined $ENV{R_LOCAL_AC_JDK_PATH}) {
          $jdkloc = "$ENV{PTC_TOOLS}/apps/corretto/$ENV{PRO_MACHINE_TYPE}/acjdk$jdkver";
        } else {
          $jdkloc = $ENV{R_LOCAL_AC_JDK_PATH};
        }
      } else {
        if (not defined $ENV{R_LOCAL_JDK_PATH}) {
          $jdkloc = "$ENV{PTC_TOOLS}/advapps/$ENV{PRO_MACHINE_TYPE}/jdk$jdkver";
        } else {
          $jdkloc = $ENV{R_LOCAL_JDK_PATH};
        }
      }

      if (! -e $jdkloc) {
          print_fail("skipped::  #skipped $raw_trailname because $jdkloc is missing\n");
          print_skip_msg("skipped::  #skipped $raw_trailname because $jdkloc is missing\n");
            return (1);
     }
   }
   
  if ($PRO_MACHINE_TYPE eq "i486_nt" || $PRO_MACHINE_TYPE eq "x86e_win64") {
     if ($directives{add_jdk7_to_path}) {
           $old_PATH = $ENV{PATH};
           $ENV{PATH} = "$JAVA7PATH;$ENV{PATH}";
     }
     
     if ($directives{add_jdk8_to_path} || $directives{java_flavor}) {
        my $jdkver = (split(/jdk/,$tk_flavor_)) [1];
         $jdkver =~ s/ $//g;

           $old_PATH = $ENV{PATH};
           $ENV{PATH} = "$jdkloc/bin;$ENV{PATH}";
        
        print "PATH after adding jdk \n";
        print "$ENV{PATH}\n";  
     }
  }
  
   if ($directives{not_run_on_app_verifier}) {
    if (defined $ENV{PTC_MEMMGR_STYLE} &&  $ENV{PTC_MEMMGR_STYLE} eq 'slim') {
        print_succ("skipped::  #skipped $raw_trailname because in App verifier run \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because in App verifier run \n");
        return (1);
     }
   }

   if ($directives{coretech_kio_test}) {
    if (! defined $ENV{R_RUN_CORETECH_TEST} ||  $ENV{R_RUN_CORETECH_TEST} ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_CORETECH_TEST not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_CORETECH_TEST not true \n");
        return (1);
     }
   }
   
   if ($directives{ngcri_test}) {
    if (! defined $ENV{R_RUN_NGCRI_TEST} ||  $ENV{R_RUN_NGCRI_TEST} ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_NGCRI_TEST not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_NGCRI_TEST not true \n");
        return (1);
     }
   }
   
  if ($directives{vulkan} || $directives{pglview_test}) {
     if (defined $ENV{GRAPHICSCONFIG}) {
        if ($ENV{GRAPHICSCONFIG} !~ m/VULKAN/i){
           print_fail("skipped::  #skipped because GRAPHICSCONFIG is not set to VULKAN\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because GRAPHICSCONFIG is not set to VULKAN\n");
           return (-1);
        }
     } else {
        print_succ("skipped::  #skipped $raw_trailname because GRAPHICSCONFIG is not set\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because GRAPHICSCONFIG is not set\n");
        return (1);
     }
  }

  if ($directives{atlas_user}) {
      if($atlas_password1 eq "") {
          print "Atlas user '$atlas_user_name1' not found in Thycotic \n";
          print_fail("skipped::  #skipped because Atlas user $atlas_user_name1 not found in Thycotic\n");
          print_skip_msg("skipped::  #skipped $raw_trailname because Atlas user $atlas_user_name1 not found in Thycotic \n");
          $skip_msg = "skipped:  #skipped $raw_trailname because Atlas user $atlas_user_name1 not found in Thycotic\n";
          return (-1);
	  }
      
      if ($is_atlas_user_multi_session && $atlas_password2 eq "" ) {
          print "Atlas user '$atlas_user_name2' not found for multi session in Thycotic \n";
          print_fail("skipped::  #skipped because Atlas user $atlas_user_name2 not found for multi session  in Thycotic\n");
          print_skip_msg("skipped::  #skipped $raw_trailname because Atlas user $atlas_user_name2 not found for multi session in Thycotic \n");
          $skip_msg = "skipped:  #skipped $raw_trailname because Atlas user $atlas_user_name2 not found for multi session in Thycotic";
          return (-1);         
      }
  }
  
   if ($directives{saas_test}) {
    if (defined $ENV{R_SAAS_REGRESSION}) {
        if ($ENV{R_SAAS_REGRESSION} ne "true"){
           print_fail("skipped::  #skipped because R_SAAS_REGRESSION is not true\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because R_SAAS_REGRESSION is not true\n");
           return (-1);
        }
     } else {
        print_succ("skipped::  #skipped $raw_trailname because R_SAAS_REGRESSION is not true\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_SAAS_REGRESSION is not true\n");
        return (1);
     }
   }
   
   if ($directives{rsd_test}) {
       if ( $dgm_version ne '' ) {
         $clean_setenv_cmds{RSD_DGM_VERSION} = $ENV{RSD_DGM_VERSION};
         $ENV{RSD_DGM_VERSION} = $dgm_version;
       }
   }
   
   if ($directives{skip_for_cpd_run}) {
    if (defined $ENV{R_USE_CREO_PLUS} &&  $ENV{R_USE_CREO_PLUS} eq 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_USE_CREO_PLUS is true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_USE_CREO_PLUS is true \n");
        return (1);
     }
   }
   if ($directives{run_only_on_cpd}) {
        if (! defined $ENV{R_USE_CREO_PLUS} ) {
            print_succ("skipped::  #skipped $raw_trailname because R_USE_CREO_PLUS is not true \n");
            print_skip_msg("skipped::  #skipped $raw_trailname because R_USE_CREO_PLUS is not true \n");
            return (1);
        }
   }

   if ($directives{run_on_cpd}) {
        if ($run_on_cpd_cluster_type ne "" ) {

           if ($ENV{CREO_SAAS_CLUSTER} eq 'dev' && $run_on_cpd_cluster_type ne 'dev_only')  {
            print_succ("skipped::  #skipped $raw_trailname because dev_only is $run_on_cpd_cluster_type \n");
            print_skip_msg("skipped::  #skipped $raw_trailname because dev_only is $run_on_cpd_cluster_type \n");
            return (1);
           }
           if ($ENV{CREO_SAAS_CLUSTER} eq 'staging' && $run_on_cpd_cluster_type ne 'stg_only')  {
            print_succ("skipped::  #skipped $raw_trailname because stg_only is $run_on_cpd_cluster_type\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because stg_only is $run_on_cpd_cluster_type \n");
            return (1);
           }
        }
   }
   
   if ($directives{run_only_one_test}) {
    if (defined $ENV{R_SKIP_RUN_ONLY_ONE_TEST} &&  $ENV{R_SKIP_RUN_ONLY_ONE_TEST} eq 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_SKIP_RUN_ONLY_ONE_TEST is true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_SKIP_RUN_ONLY_ONE_TEST is true \n");
        return (1);
     }
   }
   
  if ( (defined $ENV{R_WNC_RELEASE}) && ($directives{wnc_flavor}) && ($ENV{R_WNC_RELEASE} ne ${tk_flavor_})) {
        print_succ("\nskipped::  #skipped because R_WNC_RELEASE is set to $ENV{R_WNC_RELEASE} but test's wnc_flavor is ${tk_flavor_} \n");
        print_skip_msg("\nskipped::  #skipped $raw_trailname because R_WNC_RELEASE is set to $ENV{R_WNC_RELEASE} but test's wnc_flavor is ${tk_flavor_}\n");
        return (1);
  }
  
  if ($directives{engnotebook_test}) {
    if (!defined $ENV{R_RUN_ENGNOTE_BOOK_TEST} || $ENV{R_RUN_ENGNOTE_BOOK_TEST} ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_ENGNOTE_BOOK_TEST is not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_ENGNOTE_BOOK_TEST not true \n");
        return (1);
     }
   }

   if ($directives{wg_generate_code}) {
    if (!defined $ENV{WG_PARENT_TASK} || $ENV{WG_PARENT_TASK } ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because WG_PARENT_TASK is not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because WG_PARENT_TASK not true \n");
        return (1);
     }
   }

   if ($directives{wg_test_generated_code}) {
    if (!defined $ENV{WG_SUBTASK} || $ENV{WG_SUBTASK} ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because WG_SUBTASK is not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because WG_SUBTASK not true \n");
        return (1);
     }
   }
 
return (0);
   
}

sub pre_directive_process {
   my ($first_trail) = @_;
   my (@array);
   
   if ($directives{gcri_test}) {
      if (defined $ENV{R_GCRI_TEST}) {
     $ENV{CRI_DLL} = $ENV{R_GCRI_TEST};
      } else {
      if (-d "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/gcri") {
     	 ## set the location to gcri for local install 
         $ENV{CRI_DLL} = "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/gcri";
         print("using $ENV{CRI_DLL}/readnewermodels.dll\n");
        } else {
          $ENV{CRI_DLL} = "$PTCSYS/obj";
          if ($CRI_DLL_version ne "") {
            my $sys=`$csh_cmd "getversiondir $CRI_DLL_version obj $PRO_MACHINE_TYPE"`;
            chomp ($sys);
            $ENV{CRI_DLL} = "$sys/obj";
         }
       }
      }
      if (! -e "$ENV{CRI_DLL}/readnewermodels.dll") {
         print_fail("skipped::  #skipped because $ENV{CRI_DLL}/readnewermodels.dll is not exist\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because $ENV{CRI_DLL}/readnewermodels.dll is not exist\n");
         return (-1);
      }
   }

   if ($directives{not_run_on_test}) {
      @array = split(/ +/, $not_run_on_mach_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
            print_succ("skipped::  #skipped because the test not run on $mach_list\n");
            print_skip_msg("\nskipped::  #skipped $raw_trailname because the test not run on $mach_list\n");
            return (1);
         }
      }
   }

   if ($directives{not_run_with_lang}) {
      @array = split(/ +/, $not_run_lang_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $altlang) {
            print_succ("skipped::  #skipped because the test not run with $not_run_lang_list\n");
            print_skip_msg("\nskipped::  #skipped $raw_trailname because the test not run with $not_run_lang_list\n");
            return (1);
         }
      }
   }

   if ($directives{run_only_with_lang}) {
      if ($run_only_lang_list !~ /$altlang/) {
         if ($altlang ne "") {
            print_succ("skipped::  #skipped because the test run only with $run_only_lang_list\n");
            print_skip_msg("\nskipped::  #skipped $raw_trailname because the test run only with $run_only_lang_list\n");
            return (1);
         } else {
            if ($run_only_lang_list !~ /english/) {
               print_succ("skipped::  #skipped because the test run only with $run_only_lang_list\n");
               print_skip_msg("\nskipped::  #skipped $raw_trailname because the test run only with $run_only_lang_list\n");
               return (1);
            }
         }
      }
   }

   if ($directives{run_only_on_test}) {
      if ($mach_list !~ /$PRO_MACHINE_TYPE\b/) {
         print_succ("skipped::  #skipped $raw_trailname because the test only run on $mach_list\n");
         print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run on $mach_list\n");
         return (1);
      }
   }
   if ($directives{graphics_test_on} && $ENV{R_GRAPHICS} eq "0") {
      @array = split(/ +/, $g_mach_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
            print_succ("skipped::  #skipped because the test is only run with graphics on $PRO_MACHINE_TYPE\n");
            print_skip_msg("\nskipped::  #skipped $raw_trailname because the test is only run with graphics on $PRO_MACHINE_TYPE\n");
            return (1);
         }
      }
   }

   if ($directives{non_graphics_test_on} && $ENV{R_GRAPHICS} ne "0") {
      @array = split(/ +/, $g_mach_list);
      for ($i=0; $i<@array; $i++) {
         if ($array[$i] eq $PRO_MACHINE_TYPE) {
            print_succ("skipped::  #skipped because the test is only run without graphics on $PRO_MACHINE_TYPE\n");
            print_skip_msg("\nskipped::  #skipped $raw_trailname because the test is only run without graphics on $PRO_MACHINE_TYPE\n");
            return (1);
         }
      }
   }

   if (defined $ENV{R_SUPERAUTO}) {
      if ($directives{plpf_test} ||
         $directives{generic_uif_test} || $directives{generic_ui_test} ||
         $directives{java_async_test} || $directives{java_sync_test} ||
         $directives{pt_async_pic_test} ) {

         print_succ("skipped::  #skipped because R_SUPERAUTO is set\n");
         print_skip_msg("skipped::  #skipped because R_SUPERAUTO is set\n");
         return (1);
      }
   }
   if ($directives{chinese_test} && $altlang ne "chinese_tw") {
      print_succ("skipped::  #skipped because the test only run in Chinese\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Chinese\n");
      return (1);
   }
   if ($directives{korean_test} && $altlang ne "korean") {
      print_succ("skipped::  #skipped because the test only run in Korean\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Korean\n");
      return (1);
   }
   if ($directives{latin_lang_test} && !$latin_lang) {
      print_succ("skipped::  #skipped because the test only run in Latin language\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Latin language\n");
      return (1);
   }

   if ($directives{english_test} && $altlang ne "") {
      print_succ("skipped::  #skipped $raw_trailname because the test only run in English\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in English\n");
      return (1);
   }

   if ($directives{graphics_test}) {
      if ($ENV{R_GRAPHICS} eq "0") {
         print_succ("skipped::  #skipped because the test only run as graphics\n");
         print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run as graphics\n");
         return (1);
      } else {
         if ("$graphics_test_modes" ne "") {
            @array = split(/ +/, $graphics_test_modes);
            my ($match_graphics) = 0;
            for ($i=0; $i<@array; $i++) {
               if ($array[$i] eq $ENV{R_GRAPHICS}) {
                  $match_graphics = 1;
                  last;
               }
            }
            if (! $match_graphics) {
               print_succ("skipped::  #skipped because the test only run with $graphics_test_modes graphics mode\n");
               print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run with $graphics_test_modes graphics mode\n");
               return (1);
            }
         }
      }
   }
   if ($directives{none_graphics_test} && $ENV{R_GRAPHICS} ne "0") {
      print_succ("skipped::  #skipped because the test only run as non graphics\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run as non graphics\n");
      return (1);
   }
   if ($directives{check_ram_test} && $ram_size > 0 && $ram_size < 1000) {
      print_fail("skipped::  #skipped because the RAM size is $ram_size and the test on run on > 1GB RAM machine\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the RAM size is $ram_size and thetest on run on > 1GB RAM machine\n");
      return (-1);
   }
   if ($directives{japanese_test} && $altlang ne "japanese") {
      print_succ("skipped::  #skipped because the test only run in Japanese\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because the test only run in Japanese\n");
      return (1);
   }
   if ($directives{distapps_dsapi}) {
      if (! (defined $ENV{R_LOCAL_DS_C_CLNT} || defined $ENV{R_LOCAL_DS_CLNT_TESTS})) {
         if (! -e "${PTCSYS}/obj/ds_c_clnt_tests$exe_ext") {
            print_fail("skipped::  #skipped because ${PTCSYS}/obj/ds_c_clnt_tests$exe_ext does not exist\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because ${PTCSYS}/obj/ds_c_clnt_tests$exe_ext does not exist\n");
            return (-1);
         }
      }
   }

   if ($directives{distapps_dsm} || $directives{distapps_dbatchc} || $directives{distapps_dsapi}) {
      if (defined $ENV{PTCNMSPORT}) {
         $old_PTCNMSPORT = $ENV{PTCNMSPORT};
         delete $ENV{PTCNMSPORT};
      } else {
         $old_PTCNMSPORT = "";
      }
      if (defined $ENV{PTCNMS_SERVICE_DIR}) {
         $old_PTCNMS_SERVICE_DIR = $ENV{PTCNMS_SERVICE_DIR};
         delete $ENV{PTCNMS_SERVICE_DIR};
      } else {
         $old_PTCNMS_SERVICE_DIR = "";
      }
      if (defined $ENV{PTCNMS_SERVICE_LIST}) {
         $old_PTCNMS_SERVICE_LIST = $ENV{PTCNMS_SERVICE_LIST};
         delete $ENV{PTCNMS_SERVICE_LIST};
      } else {
         $old_PTCNMS_SERVICE_LIST = "";
      }
   }
   if ($directives{distapps_dsm} || $directives{distapps_dsapi}) {
      $stat = system("$csh_cmd \"dsq_start_nmsd -force\"");
      if ($stat) {
         print_fail("skipped::  #skipped because status bad from dsq_start_nmsd\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because status bad from dsq_start_nmsd\n");
         return (-1);
      }
   }
   if ($directives{anim_test}) {
      ## This R_RUN_MECH_TEST check was put in for Integ testing purpose
      if ($ENV{R_RUN_MECH_TEST} ne "true") {
         print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not set to true\n");
         &fail_skip($i, 0);
         return (-1);
      }
      if (! defined $ENV{ANIMATION_HOME}) {
         print_fail("skipped::  #skipped because ANIMATION_HOME is not set\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because ANIMATION_HOME is not set\n");
     &fail_skip($i, 0);
         return (-1);
      } elsif (! -d "$ENV{ANIMATION_HOME}") {
         print_fail("skipped::  #skipped because ANIMATION_HOME does not exist\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because ANIMATION_HOME does not exist\n");
     &fail_skip($i, 0);
         return (-1);
      }
   }
   if ($directives{mdx_test}) {
      ## This R_RUN_MECH_TEST check was put in for Integ testing purpose
      if ($ENV{R_RUN_MECH_TEST} ne "true") {
         print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not set to true\n");
         &fail_skip($i, 0);
         return (-1);
      }
      if (! defined $ENV{MECHANISM_HOME} && $r_using_local_install == 0) {
         print_fail("skipped::  #skipped because MECHANISM_HOME is not set\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because MECHANISM_HOME is not set\n");
     &fail_skip($i, 0);
         return (-1);
      } elsif (! -d "$ENV{MECHANISM_HOME}" && $r_using_local_install == 0) {
         print_fail("skipped::  #skipped because MECHANISM_HOME is not exist\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because MECHANISM_HOME does not exist\n");
     &fail_skip($i, 0);
         return (-1);
      }
   }

   if ($directives{jr_test}) {
      $ENV{PRO_JUNIOR_ACTIVE} = "true";
      print_succfail("Running a proe/junior test by setting PRO_JUNIOR_ACTIVE true\n");
   }
   if ($directives{local_home_test}) {
      $save_home = $ENV{HOME};
      $home = "$tmpdir";
      $ENV{HOME} = "$tmpdir";
      print_succfail("Running a local home test by setting home to $home\n");
   }
   if ($directives{run_if_set}) {
      @array = split(/ +/, $env_list);
      for ($i=0; $i<@array; $i++) {
     next if ($array[$i] eq "");
         if ((("$array[$i]" eq "MECH_HOME") || 
          ("$array[$i]" eq "MECHANISM_HOME") || 
          ("$array[$i]" eq "ANIMATION_HOME")) && 
          ($ENV{R_RUN_MECH_TEST} ne "true")) {
                   print_fail("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
                   print_skip_msg("skipped::  #skipped because R_RUN_MECH_TEST is not true\n");
                   &fail_skip($i, 0);
                   return (-1);
         }
         ## animation home and mechanism home to be done only for local install.
         if (! exists $ENV{$array[$i]} && 
              ((("$array[$i]" ne "ANIMATION_HOME") && ("$array[$i]" ne "MECHANISM_HOME")) || $r_using_local_install == 0)) {
               print_succ("skipped::  #skipped because $array[$i] is not set\n");
               print_skip_msg("skipped::  #skipped because $array[$i] is not set\n");
           return (1);
         }
      }
   }

   if($directives{xp_not_supported}){
             $OS_Check=`$PTC_TOOLS/perl510/$PRO_MACHINE_TYPE/bin/perl $ENV{'PTC_TOOLS'}/bin/win_os.pl`;
             $OS_Check=lc $OS_Check;
             chomp($OS_Check);
			 print("\nOS_CHECK : $OS_Check\n");
             if($OS_Check eq "windows xp"){
                    print "\n Not Supported on xp \n";
                    print_skip_msg("skipped::  #skipped because Not Supported on xp \n");
                     return (1);
              }
    }

   if ($directives{plpf_test}) {
      if (! -e "$ENV{R_FLEXGENERIC}") {
     print_fail("skipped::  #skipped because $ENV{R_FLEXGENERIC} doesn't exist\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because $ENV{R_FLEXGENERIC} not exist\n");
     return (-1);
      }
      $ENV{"PRO_LICENSE_RES"}="$PTCSRC/text/licensing/license_ship.res";
      if (exists $ENV{R_PLPF_LICENSE}) {
         if (defined $ENV{P_VERSION} && $ENV{P_VERSION} < 240) {
            $ENV{"LM_LICENSE_FILE"}=$ENV{R_PLPF_LICENSE};
         } else {
            $ENV{PTC_D_LICENSE_FILE}=$ENV{R_PLPF_LICENSE};
         }
      } else {
         if (defined $ENV{P_VERSION} && $ENV{P_VERSION} < 240) {
            $ENV{LM_LICENSE_FILE} = $auto_license_file;
         } else {
            $ENV{PTC_D_LICENSE_FILE}=$auto_license_file;
         }
      }
   }

   if ($directives{shared_workspace} && $first_trail ) {
     if ($collab_atlas eq 'true') {
        if ($ENV{IS_COLLAB_PLAYWRIGHT_TEST} !~ /yes/i) {
	       $old_shared_workspace_PATH = $ENV{PATH};
           $old_PATH = $ENV{PATH};
	   	   $ENV{PATH}="$PTC_TOOLS\\gdx_util\\nodejs\\;$PTC_TOOLS\\gdx_util\\npm;$ENV{PATH}";
           print ("PATH after adding nodejs and npm:\n $ENV{PATH} \n ");
        }
	 
	     $old_r_use_agent = $ENV{R_USE_AGENT};
	     $old_is_automation_test = $ENV{IS_AUTOMATION_TEST};
	     $old_is_hybrid_test = $ENV{IS_HYBRID_TEST};
	     $old_collab_test = $ENV{COLLAB_TEST};
	     $old_ptc_zb_cef_disable_zoom = $ENV{PTC_ZB_CEF_DISABLE_ZOOM};
		 $old_cef_debug_port = $ENV{CEF_DEBUG_PORT};
	 
		 $ENV{R_USE_AGENT} = "yes";
	     $ENV{IS_AUTOMATION_TEST} = "yes";
	     $ENV{IS_HYBRID_TEST} = "true";
         $ENV{COLLAB_TEST} = "$ENV{PTC_TOOLS}/COLLAB/gitRepo";
	     $ENV{PTC_ZB_CEF_DISABLE_ZOOM} = "true";
         print "PTC_ZB_CEF_DISABLE_ZOOM is set to $ENV{PTC_ZB_CEF_DISABLE_ZOOM}\n";
         $first_cef_debug_port = find_free_network_port(9000,9499);
         $second_cef_debug_port = find_free_network_port(9500,9999)  if (not defined $ENV{R_SHARED_CREO_HOME});        
         
         $ENV{PHA_COLLAB_USER} = $atlas_user_name1;
         $ENV{PHA_COLLAB_PWD} = $atlas_password1;
         $ENV{CEF_DEBUG_PORT} = $first_cef_debug_port ; 
         $ENV{ZB_DEBUG_PORT} = $ENV{CEF_DEBUG_PORT}; 

         if ( (! defined $ENV{COLLABSVC_URL}) && (not defined $ENV{R_USE_CREO_PLUS}) && (not defined $ENV{R_SAAS_REGRESSION}) ) {
            $ENV{COLLABSVC_URL} = "https://creo.staging-portal.ptc.com/collabsvc/api/v1/cs/";
         }
  
	 }
   }
   
   if ($directives{mech_test}) {
      if (! -e $ENV{PTC_D_LICENSE_FILE}) {
     $ENV{PTC_D_LICENSE_FILE} = $auto_license_file;
      }
      $ENV{"LM_LICENSE_FILE"} = $LM_LICENSE_FILE_backup;
   }
   
  if ( not defined $ENV{R_USE_CREO_PLUS} ) {
   if ($directives{run_with_license}) {
      if ((! -e $ENV{PTC_D_LICENSE_FILE}) || (defined $ENV{PIM_INSTALLED_VERSION})) {
         $license_info =~ s/^\s+//;
         $license_info =~ s/\s+$//;
         ($feature_name_var, @fval) = split(/ +/, $license_info);
         $feature_name = join (" ", @fval);
         $ENV{"PRO_LICENSE_RES"}="$PTCSRC/text/licensing/license_ship.res" if (not defined $ENV{PIM_INSTALLED_VERSION});
         if (defined $ENV{P_VERSION} && $ENV{P_VERSION} < 240) {
            if (defined $ENV{"LM_LICENSE_FILE"}) {
                $ENV{"LM_LICENSE_FILE"}="${auto_license_file}:$ENV{LM_LICENSE_FILE}";
            } else {
                $ENV{"LM_LICENSE_FILE"}=$auto_license_file;
            }
         } else {
            $ENV{PTC_D_LICENSE_FILE} = $auto_license_file if (! -e $ENV{PTC_D_LICENSE_FILE});
         }

         $ENV{"$feature_name_var"} = $feature_name;      

         if ($array[2] eq "OKTOFAIL") {
            $oktofail = 1;
         } else {
            $oktofail = 0;
         }
      } else {
         $oktofail = 0;
      }
      print "Setting PTC_D_LICENSE_FILE to $ENV{PTC_D_LICENSE_FILE}\n";
      print "        PRO_LICENSE_RES to $ENV{PRO_LICENSE_RES}\n";
      print "        $feature_name_var to $ENV{$feature_name_var}\n";
      print "        LM_LICENSE_FILE is set to $ENV{LM_LICENSE_FILE}\n";
   } else {
     if ($r_using_local_install == 1 || ($ENV{R_RUN_PYAUTOGUI_TEST} eq 'true')) {
   	   $ENV{CREOPMA_FEATURE_NAME} = $ENV{R_DEFAULT_LICENSE};
   	   print "CREOPMA_FEATURE_NAME to $ENV{CREOPMA_FEATURE_NAME}\n";
   	   
   	   $ENV{CREODMA_FEATURE_NAME} = "CREODMA_BASIC_INHOUSE(14 128 222 223 224 253 294 333 334 335)";
   	   $ENV{CREOOPTMOD_FEATURE_NAME} = "CREOPMA_BASIC_INHOUSE (6 14 89 128 139 140 141 164 211 212 214 222 223 224 247 253 291 292 293 294 327 359 10126)";
   	   $ENV{CREOSHELL_FEATURE_NAME} = "CREOSHELL_INHOUSE";
   	   $ENV{CREOSIM_FEATURE_NAME} = "CREOSIM_INHOUSE";
       $ENV{CREOLAY_FEATURE_NAME} = "CREOLAY_INHOUSE (291)";
            $ENV{PTC_D_LICENSE_FILE} = $auto_license_file if (! -e $ENV{PTC_D_LICENSE_FILE});
     }
   }
 }  
 if (defined $ENV{R_USE_CREO_PLUS} && $directives{run_with_license}) {
    $license_info =~ s/^\s+//;
    $license_info =~ s/\s+$//;
    
    ($l2r_feature_name_var, @fval) = split(/ +/, $license_info);
    $l2r_feature_name_val = join (" ",@fval);
    $l2r_feature_name_val =~ s/,/ /g;
    $l2r_feature_name_val_user = $fval[0] ;
    $l2r_feature_name_val_user =~ s/(\(.*\))// ;

    $username_format = 'cplusops1+cpdl2r_FEATURE-INFO@gmail.com';
    $l2r_username =  $username_format;
    $l2r_username =~ s/(_FEATURE-INFO@)/_${l2r_feature_name_val_user}@/;
    $l2r_username = lc($l2r_username);
    $l2r_password = get_secret($l2r_username);

    $ENV{$l2r_feature_name_var} = $l2r_feature_name_val;
    print "setting:$l2r_feature_name_var=$ENV{$l2r_feature_name_var}\n";
 }

#   if ($directives{run_with_license} || $directives{plpf_test}) {
#      `$csh_cmd "${TOOLDIR}check_license_server.csh`;
#      $serv_stat = $? >> 8;
#      if ($serv_stat) {
#         print_fail("skipped::  #skipped because license server down\n");
#         print_skip_msg("skipped::  #skipped $raw_trailname because license server down\n");
#         return (-1);
#      }
#   }

   if ($directives{cadds5_topology_test}) {
      if ($cv_env_version) {
         if ($ENV{CV_ENV_HOME}) {
            $old_CV_ENV_HOME = $ENV{CV_ENV_HOME}
         }
         $ENV{CV_ENV_HOME} = "$PTCSRC/auxobjs/$PRO_MACHINE_TYPE/$cv_env_version";
      }
      if ($OS_TYPE eq "UNIX") {
         $tmp_space=`$csh_cmd "${TOOLDIR}checkspace /var/tmp -f"`;
         if ($tmp_space < 20000) {
        print_fail("skipped::  #skipped because the diskspace on /var/tmp less than 20Mg\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because the diskspace on /var/tmp less than 20Mg\n");
        return (-1);
         }
      }
      if ( "$tmpdir" =~ /.[A-Z]./ ) {
         print_fail("skipped::  #skipped because there are capital letters in the path to the run directory\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because there are capital letters in the path to the run directory\n");
         return (-1);
      }

      if ($OS_TYPE eq "NT" && ! defined($PTC_CYGWIN) && ! defined($PTC_MKS)) {
         `$csh_cmd "${TOOLDIR}auto_cleanup_cadds5_nt"`;
         `$csh_cmd "${TOOLDIR}auto_cleanup_o_db"`;
      } else {
         `$csh_cmd "${TOOLDIR}auto_cleanup_cadds5"`;
         `$csh_cmd "${TOOLDIR}auto_cleanup_odb"`;
      }
      $run_stat = `$csh_cmd "${TOOLDIR}get_pid ODB"`;
      chop($run_stat);
      if ("$run_stat" ne "") {
         print_fail("skipped::  #skipped because there are ODB processes running\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because there are ODB processes running\n");
         return (-1);
      }

# force to run correct nmsq when running with localinstall
      if (-d "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/nms") {
         `$csh_cmd "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/nms/nmsq -ping -quiet"`;
         $run_stat = $?;
      } else {
         `$csh_cmd "$PTCSYS/obj/nmsq -ping -quiet"`;
         $run_stat = $?;
      }

      if ($run_stat) {
         print_fail("skipped::  #skipped because name service is not started\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because name service is not started\n");
         return (-1);
      }
   }

   if ($directives{backward_trail}) {
      my ($backward_version) = $backward_cmd;
      $backward_version =~ s/pro//g;
      my ($sysdirname)=`$csh_cmd "getversiondir $backward_version obj $PRO_MACHINE_TYPE"`;
      chomp ($sysdirname);
      if (! -e "$sysdirname/obj/xtop$ENV{EXE_EXT}") {
     print_fail("skipped::  #skipped because xtop for $backward_version doesn't exist\n");
     print_skip_msg("skipped::  #skipped $raw_trailname because xtop for $backward_version doesn't exist\n");
     return (-1);
      } else {
     $backward_cmd="${TOOLDIR}$backward_cmd";
      }
   }

   if ($directives{proevconf_test}) {
      $run_stat = `$csh_cmd "${TOOLDIR}get_pid tsd"`;
      chop($run_stat);
      if ("$run_stat" ne "") {
         print_succfail("WARNING::  there are tsd processes running\n");
      }
   }

   if ($directives{pt_asynchronous_tests}) {

# force to run correct nmsq when running with localinstall
      if (-d "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/nms") {
         `$csh_cmd "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/nms/nmsq -ping -quiet"`;
         $run_stat = $?;
      } else {
         `$csh_cmd "$PTCSYS/obj/nmsq -ping -quiet"`;
         $run_stat = $?;
      }

      if ($run_stat) {
         print_fail("skipped::  #skipped because name service is not started\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because name service is not started\n");
         return (-1);
      }
   }

   if ($directives{alt_c5_converter}) {
      if (exists $ENV{CADDS5_LINK_PATH}) {
         $save_CADDS5_LINK_PATH = $ENV{CADDS5_LINK_PATH};
         `cp $ENV{CADDS5_LINK_PATH}/$alt_c5_converter_exe "$tmpdir/pro_cadds5"`;
      } else {
         $save_CADDS5_LINK_PATH = "";
         `cp $PTCSYS/obj/$alt_c5_converter_exe "$tmpdir/pro_cadds5"`;
      }
      $ENV{"CADDS5_LINK_PATH"} = "$tmpdir";
      &init_alt_c5_converter_env;
   }
   if ($directives{check_build}) {
      my (@exe_list) = split(/ +/, $checkbuild_exes);
      foreach $exe_name (@exe_list) {
         if (! -e "${PTCSYS}/obj/$exe_name$exe_ext") {
            print_fail("skipped::  #skipped because ${PTCSYS}/obj/$exe_name$exe_ext is missing\n");
            print_skip_msg("skipped::  #skipped $raw_trailname because ${PTCSYS}/obj/$exe_name$exe_ext is missing\n");
            return (-1);
         }
      }
   }
   if ($directives{review_test}) {
      $tmp_runmode=$ENV{R_RUNMODE};
      $ENV{R_RUNMODE}="9329";
      print_succfail("Running a review test in 9329 runmode\n");
   }
   if ($directives{viewonly}) {
      $tmp_runmode=$ENV{R_RUNMODE};
      $ENV{R_RUNMODE}="9229";
      print_succfail("Running a viewonly test in 9229 runmode\n");
   }
   if ($directives{generic_uif_test} && $ENV{LANG} ne "C") {
      print_succ("skipped::  #skipped because could not run uif tests in $ENV{LANG}\n");
      print_skip_msg("skipped::  #skipped because could not run uif tests in $ENV{LANG}\n");
      return (1);
   }

   if ($directives{open_access_test}) {
      if ($OS_TYPE eq "UNIX") {
         if ($PRO_MACHINE_TYPE eq "sun_solaris_x64") {
        $ENV{LD_LIBRARY_PATH} = "$ENV{LD_LIBRARY_PATH}:$PTCSRC/auxobjs/sun_solaris_x64/OPEN_ACCESS/lib/sunos_510_x86_64/opt";
         }
         else {
        $ENV{LD_LIBRARY_PATH} = "$ENV{LD_LIBRARY_PATH}:$PTCSRC/auxobjs/sun4_solaris_64/OPEN_ACCESS/lib/sunos_58_64/opt";
         }
      } else {
     $ENV{PATH} = "$ENV{PATH};$PTCSRC/auxobjs/i486_nt/OPEN_ACCESS/bin/win32/opt";
      }
   } 

   if ($directives{check_display}) {
      return (-1) if (test_display());
   }
   if ($directives{distapps_dbatchc}) {
      if ($dsm_machine eq "") {
         delete $ENV{"LIMIT_DSM"} if (exists $ENV{LIMIT_DSM});
      } else {
         $ENV{"LIMIT_DSM"} = $dsm_machine;
      }
      $ENV{"DBATCHC_LOG_ALL"} = 1;
      if (defined $ENV{PROE_START}) {
         $PROE_START_old = $ENV{PROE_START};
      } else {
         $PROE_START_old = "";
      }
      $old_PATH = $ENV{PATH};
      $ENV{PATH} = "$PRO_DIRECTORY/bin;$PRO_DIRECTORY/$PRO_MACHINE_TYPE/lib;$PATH";
      $ENV{PROE_START}=$local_xtop;
   }
   
   
   
   if ($directives{creo_ui_resource_editor_test} || $directives{otk_cpp_async_test} || $directives{pfcvb_test}) {
      $old_PATH = $ENV{PATH};
      $ENV{PATH} = "$PRO_DIRECTORY/$PRO_MACHINE_TYPE/lib;$PATH";
   }
   
  if ($directives{gd_webapp_test}) { 
     if (not defined $ENV{GDX_PRODUCTION_TEST}) {
       print_succ("skipped::  #skipped $raw_trailname because GDX_PRODUCTION_TEST is not set\n");
       print_skip_msg("skipped::  #skipped $raw_trailname because GDX_PRODUCTION_TEST is not set\n");
        return (1);
     }

    apply_setenv();
    if ($ENV{GDX_PRODUCTION_TEST} ne "") {
       if ( $ENV{'R_SAVE_GDXLOG'} eq 'true' ) {
	      add_to_saveas('protractor_test.log');
          add_to_saveas('gens.log.1');
          add_to_saveas('gens.log');
          add_to_saveas('reports');
       }
     $clean_setenv_cmds{'R_USE_AGENT'} = $ENV{R_USE_AGENT};
	 $clean_setenv_cmds{'IS_AUTOMATION_TEST'} = $ENV{IS_AUTOMATION_TEST};
	 $clean_setenv_cmds{'IS_HYBRID_TEST'} = $ENV{IS_HYBRID_TEST};
	 $clean_setenv_cmds{'NODE_TLS_REJECT_UNAUTHORIZED'} = $ENV{NODE_TLS_REJECT_UNAUTHORIZED};
	 $clean_setenv_cmds{'PTC_ZB_CEF_DISABLE_ZOOM'} = $ENV{PTC_ZB_CEF_DISABLE_ZOOM};
	 $clean_setenv_cmds{'PTC_TRAIL_DELAY'} = $ENV{PTC_TRAIL_DELAY};
	 
	$ENV{R_USE_AGENT} = "yes";
	$ENV{IS_AUTOMATION_TEST} = "yes";
	$ENV{IS_HYBRID_TEST} = "true";
	$ENV{NODE_TLS_REJECT_UNAUTHORIZED} = "0";
	$ENV{PTC_ZB_CEF_DISABLE_ZOOM} = "t";
	$ENV{PTC_TRAIL_DELAY} = "2700";
	
     if ($ENV{GDX_ENABLE_LOGGING} eq 'true') {
         add_to_saveas('ptclog');
         $clean_setenv_cmds{'PTC_LOG_ACTIVATE'} = $ENV{PTC_LOG_ACTIVATE};
         $ENV{PTC_LOG_ACTIVATE} = "t";
 
         if ($ENV{PTC_LOG_CONFIG} eq '') {
            $clean_setenv_cmds{'PTC_LOG_CONFIG'} = $ENV{PTC_LOG_CONFIG};
            $ENV{PTC_LOG_CONFIG} = "$ENV{PTC_TOOLS}/Gdx_Pro_TestRunner/Logging/logging.cfg";
         }

         if ($ENV{PTC_LOG_DIR} eq '') {
            $clean_setenv_cmds{'PTC_LOG_DIR'} = $ENV{PTC_LOG_DIR};
            $ENV{PTC_LOG_DIR} = "${rundir}/${raw_trailname}_ptclog";
         }
         mkpath($ENV{PTC_LOG_DIR}, 0777);
    }

     my $rport = find_free_network_port(9000,9999);
     #$clean_setenv_cmds{'CEF_DEBUG_PORT'} = $ENV{CEF_DEBUG_PORT} ;
     $ENV{CEF_DEBUG_PORT} = $rport ;
     $ENV{ZB_DEBUG_PORT} = $ENV{CEF_DEBUG_PORT};
      
    if (not defined $ENV{GD_STACKNAME}) {
        $ENV{GD_STACKNAME} = "staging";
		} 
		
	if (not defined $ENV{GD_PRO_RUNNER}) {
        $ENV{GD_PRO_RUNNER} = "$ENV{PTC_TOOLS}/Gdx_Pro_TestRunner/Testrunner.jar";
		if (($ENV{IS_GDX_PLAYWRIGHT_TEST} =~ /yes/i)) {
           $ENV{GD_PRO_RUNNER} = "$ENV{PTC_TOOLS}/gdx_util/playwright/gdxPlaywrightRunner.jar";
        }
    }
		
	if ($ENV{GD_PRO_RUNNER}) {
		  $ENV{GD_PRO_RUNNER} = $ENV{GD_PRO_RUNNER};
		} 
		
	if (not defined $ENV{GDX_PRO_TEST}) {
        $ENV{GDX_PRO_TEST} = "$ENV{PTC_TOOLS}/gdx_util/github";
    }
		
	if ($ENV{GD_STACKNAME} ne "") {	        		
	    if ($ENV{GD_STACKNAME} eq "dev") {
		   $ENV{R_GD_WEBAPP_URL} = "https://dev-gdx-gdx.dev.onshape.com/gdxapp/generate-webapp/";
		   print ("\n R_GD_WEBAPP_URL for $ENV{GD_STACKNAME} stack is $ENV{R_GD_WEBAPP_URL} \n ");
		}
	    if ($ENV{GD_STACKNAME} eq "staging") {
		   $ENV{R_GD_WEBAPP_URL} = "https://creo-gdx-automation-staging.staging-gdx.creo.ptc.com/gdxapp/generate-webapp/";
		   print ("\n R_GD_WEBAPP_URL for $ENV{GD_STACKNAME} stack is $ENV{R_GD_WEBAPP_URL} \n ");
		}
        
        if (($ENV{IS_GDX_PLAYWRIGHT_TEST} !~ /yes/i)) {		
           $old_PATH = $ENV{PATH};
	   	   $ENV{PATH}="$PTC_TOOLS\\gdx_util\\nodejs\\;$PTC_TOOLS\\gdx_util\\npm;$ENV{PATH}";
		   print ("PATH after adding nodejs and npm:\n $ENV{PATH} \n ");
        }

        my $R_GD_WEBAPP_URL = $ENV{R_GD_WEBAPP_URL};
        chomp($R_GD_WEBAPP_URL);
		my $output = "generative_web_app_url $R_GD_WEBAPP_URL";
		my $output1 = "trail_substitution GDX_PRO_TEST $ENV{GDX_PRO_TEST}";
		my $output2 = "trail_substitution GD_PRO_RUNNER $ENV{GD_PRO_RUNNER}";
						 
		open(CONFIG_PT, ">>$tmpdir/config.pro");
		chomp($output);
		chomp($output1);
		chomp($output2);
		print CONFIG_PT "$output\n";
		print CONFIG_PT "$output1\n" if ($ENV{IS_GDX_PLAYWRIGHT_TEST} !~ /yes/i);
		print CONFIG_PT "$output2\n";
			
		close CONFIG_PT;
		}
    } 
 }

   if ($directives{wildfire_test}) {
      if ($first_trail) {
         $non_fastreg = 1; # this variable can be set to 0 in fastreg_get_windchill() below
         if (exists $ENV{R_SKIP_WILDFIRE_TEST}) {
            print_succ("skipped::  #skipped because R_SKIP_WILDFIRE_TEST is set\n");
            print_skip_msg("skipped::  #skipped because R_SKIP_WILDFIRE_TEST is set\n");
            return (1);
         }
         return (-1) if (test_display());
         $default_graphics = $fastreg_test_flags{default_graphics};

         if ($directives{ptwt_test}) {
           &apply_setenv;
         }
         if ($fastreg_test_flags{server} || $directives{wnc_flavor} || ($ENV{R_FIND_WNC_BUILD} eq "true")) {
		 my $response;
		 if (defined $ENV{R_USE_LOCAL_SERVER}) {
            if ($ENV{R_WNC_RELEASE} ne '') {
               $wnc_release_bak = $ENV{R_WNC_RELEASE};
               $ENV{R_WNC_RELEASE} =~ s/_edge$//i;
            }
			$response = Wispauto::return_wncurl();
			$non_fastreg = 0;
            if ($wnc_release_bak ne '') {
               $ENV{R_WNC_RELEASE} = ${wnc_release_bak};
               undef ${wnc_release_bak};
            }
			print_succ("Using WISP Cloned local server:: $windchill_url because R_USE_LOCAL_SERVER is set. $response\n");	
			&kill_old_processs;
		 }
		 else {
			$response = fastreg_get_windchill();
		 }
		 
            if ( $response =~ /^entry not found/) {
               print_fail("skipped::  #skipped because $response\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $response\n");
                return (-1);
            }

            if ( $response eq "Failed to get Windchill server instance.") {
               print_fail("skipped::  #skipped because $response\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $response\n");
                return (-1) if (! $directives{ptwt_test} );
            }
	        if ( $response eq "IE settings are not done.") {
               print_fail("skipped::  #skipped because $response\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $response\n");
                return (-1) if (! $directives{ptwt_test} );
            }
			
			if ($response ne '') {
			    print_fail("skipped::  #skipped because $response\n");
                print_skip_msg("skipped::  #skipped $raw_trailname because $response\n");
                return (-1);
			 }
			 
            if (! $non_fastreg ) {
			
			if (-e "$tmpdir/config.pro" ) {
			
			      my $output = "trail_substitution FASTREG_URL $windchill_url";
				  chomp $output;
			      open(CONFIG_PT, ">>$tmpdir/config.pro") or die "Unable to open file:$!\n";
				  print CONFIG_PT "\n$output\n";
				  close CONFIG_PT;
				  open(CONFIG_PT, '<', "$tmpdir/config.pro") or die "Unable to open file:$!\n";
				  while(<CONFIG_PT>) 
				  { 
                   print $_; 
				  } 
                   close CONFIG_PT;
				  }
			   
			#Checks if this is a D-Batch - Windchill Interaction test and replaces the wc_server in dxc file with windchill_url
			if ($directives{dbatch_int_test}){
				print "\nReplacing wc_server with $windchill_url\n";
				my @dxc_files = <*.dxc>;
				foreach my $dxc_file (@dxc_files) {
				open(FILE, "<$dxc_file");
				my @lines = <FILE>;
				close(FILE);
				my @newlines;
				foreach(@lines) {
				   $_ =~ s/wc_server/$windchill_url/g;
				   push(@newlines,$_);
				}
				open(FILE, ">$dxc_file");
				print FILE @newlines;
				close(FILE);
				}
			} #DXC file processing for interaction ends here.

           if (-e "$tmpdir/config.dbatch") {
          open(CONFIG_PT,"| tee -a \"$tmpdir/config.dbatch\"");
          print CONFIG_PT "\ntrail_substitution FASTREG_URL $windchill_url\n";
          close(CONFIG_PT);
		  
           }

           if ( -f "$tmpdir/wgmclient.ini" ) {
				#Merge custom ini file 
			   if ($ENV{WWGM_CUSTOM_INI_FILE}) {
					my $custominicontent = do { local(@ARGV, $/) = $ENV{WWGM_CUSTOM_INI_FILE}; <> };
					my $inicontent = do { local(@ARGV, $/) = "$tmpdir/wgmclient.ini"; <> };
					$updateinicontent = $custominicontent."\n".$inicontent;
					open(my $fh, '>', "$tmpdir/wgmclient.ini");
					print $fh $updateinicontent;
					close $fh;
			   }
			   open(my $fh1, '>>', "$tmpdir/wgmclient.ini");
			   print_succ("Updating wgmclient.ini from " . "$tmpdir/wgmclient.ini\n");
              if (Fastreg::isValid($windchill_url)) {
				   print $fh1 "\n# The line below is added at runtime auto.pl.\n";
				   print $fh1 "uwgm.ui.trail.substitution=FASTREG_URL " . $windchill_url . "\n";
              }
		   close $fh1;
			 $ENV{"T_ALTER_DOM_DUMP"} = Fastreg::getAutoJscriptDir();
			 #For WWGM Tests : 'PTC_WGM_ROOT' should be common throughout the tests & defined on local system. 
			 if (!$directives{wwgmint_test}){
				$ENV{"PTC_WGM_ROOT"} = $ENV{"PTC_WF_ROOT"};
			 }
			 #Below required for WFS supported WWGM CAD tools.
			 $ENV{"PTC_WFS_ROOT"} = "$tmpdir";
			 $ENV{"PTC_WF_ROOT"} = "$tmpdir/WF_ROOT_DIR";
			 $ENV{"PTC_WLD_ROOT"} = "$tmpdir";
			 #Added below for WWGM Logging.
			 $ENV{"PTC_WGM_STARTUP_DIR"} = "$tmpdir";
			 $ENV{"PTC_LOG_DIR"} = "$tmpdir";
			 $ENV{"VC_LOG_DIR"} = "$tmpdir";
			 			 
             if (! -d $ENV{"PTC_WF_ROOT"}) {
                mkdir ("$ENV{PTC_WF_ROOT}", 0777);
             }
           }
               $ENV{"PTWT_FASTREG_URL"}=$windchill_url;
			   if ($directives{wwgmint_test}){
				$ENV{"WWGMTK_REG_SERVER_URL"}=$windchill_url;
			   }
            }
         }
      }

      if ($fastreg_test_flags{server}) {
         set_dm_user_passwd if (! $non_fastreg);
      }
      if ($first_trail) {
     if (defined $ENV{MOZILLA_FIVE_HOME}) {
        $set_mozilla_env_ok=1;
        if (set_mozilla_env()) {
           $set_mozilla_env_ok=0;
           print_succfail("Warning: set mozilla failed\n");
        }
     }
     `$rm_cmd -rf "$rundir/MOZILLA_PROFILE"` if (-e "$rundir/MOZILLA_PROFILE");
     mkdir ("$rundir/MOZILLA_PROFILE", 0777);
     if ($OS_TYPE eq "UNIX") {
         $ENV{"PTC_MOZILLA_PROFILE"} = "$rundir/MOZILLA_PROFILE";
     } else {
             $win_rundir = $rundir;
             $win_rundir =~ s#/#\\#g;
         $ENV{"PTC_MOZILLA_PROFILE"} = "$win_rundir\\MOZILLA_PROFILE";
     }
         `$rm_cmd -rf "$rundir/WF_ROOT_DIR"` if (-e "$rundir/WF_ROOT_DIR");
         mkdir ("$rundir/WF_ROOT_DIR", 0777);
   #      $ENV{"PTC_NO_PVX_AUTOINSTALL"} = "t";
      }
      if ($fastreg_test_flags{clean_cache}) {
         `$rm_cmd -r "$ENV{PTC_WF_ROOT}/.cache"` if (-e "$ENV{PTC_WF_ROOT}/.cache");
         `$rm_cmd "$ENV{PTC_WF_ROOT}/.wfwsi"` if (-e "$ENV{PTC_WF_ROOT}/.wfwsi");
         `$rm_cmd -r "$ENV{PTC_WF_ROOT}/.cache2"` if (-e "$ENV{PTC_WF_ROOT}/.cache2");
         `$rm_cmd -r "$ENV{PTC_WF_ROOT}/.cache2008"` if (-e "$ENV{PTC_WF_ROOT}/.cache2008");
         `$rm_cmd "$ENV{PTC_WF_ROOT}/.wfwsi2"` if (-e "$ENV{PTC_WF_ROOT}/.wfwsi2");
      }
   }

    #For running WWGM PWS specific tests.
   if ($directives{wwgmpws_test}) {
		#Below required for WFS supported WWGM CAD tools.
		$ENV{"PTC_WFS_ROOT"} = "$tmpdir";
		$ENV{"PTC_WF_ROOT"} = "$tmpdir/WF_ROOT_DIR";
		$ENV{"PTC_WLD_ROOT"} = "$tmpdir";
		#Added below for WWGM Logging.
		$ENV{"PTC_WGM_STARTUP_DIR"} = "$tmpdir";
		$ENV{"PTC_LOG_DIR"} = "$tmpdir";
		$ENV{"VC_LOG_DIR"} = "$tmpdir";
		#End of WWGM Logging Env.
		
		#Merge custom ini file 
		if ($ENV{WWGM_CUSTOM_INI_FILE}) {
			my $custominicontent = do { local(@ARGV, $/) = $ENV{WWGM_CUSTOM_INI_FILE}; <> };
			my $inicontent = do { local(@ARGV, $/) = "$tmpdir/wgmclient.ini"; <> };
			$updateinicontent = $custominicontent."\n".$inicontent;
			open(my $fh, '>', "$tmpdir/wgmclient.ini");
			print $fh $updateinicontent;
			close $fh;
		}
   }
   #Setting WWGM Startup directory for CCAPI  
   if ($directives{uwgmcc_test}) {
      $ENV{"PTC_WGM_STARTUP_DIR"} = "$tmpdir";
   }
   if ($directives{intralink_interaction}) {
      $ENV{"PDM_LDB_PATH"} = cwd();
      $PTC_WF_ROOT_save = $ENV{PTC_WF_ROOT};
      $ENV{PTC_WF_ROOT} = cwd();
   }
   if ($directives{prokernel_test}) {
      if (defined $ENV{PTCNMSPORT}) {
         $save_PTCNMSPORT = $ENV{PTCNMSPORT};
         delete $ENV{"PTCNMSPORT"};
      } else {
         $save_PTCNMSPORT = "";
      }
   }
   if ($directives{proevconf_test}) {
      if (defined $ENV{PTCNMSPORT}) {
         $save_PTCNMSPORT = $ENV{PTCNMSPORT};
         delete ($ENV{"PTCNMSPORT"});
      } else {
         $save_PTCNMSPORT = "";
      }
#      `$csh_cmd "${TOOLDIR}check_csd"`;
#      $csd_stat = $?;
      $csd_stat = 1;
      if ($csd_stat) {
         print_fail("skipped::  #skipped because csd server is not running\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because csd server is not running\n");
         return (-1);
      }
   }

   if ($directives{ptcsetup_test}) {
      $ENV{"CONTINUE_FROM_OOS"} = "FALSE";
      $ENV{"PTCSETUPLOG"} = "$tmpdir/ptcsetup.log";
      $ENV{"PS_ALT_ROOTPATH"} = "$tmpdir";
      $ENV{"DPS_DEBUG"} = 10;
   }

   if ($directives{setenv_to_cwd}) {
      @array = split(/ +/, $setenv_to_cwd);
      for ($i=0; $i<@array; $i++) {
          $ENV{$array[$i]} = cwd();
          print_succfail("Running: setenv $array[$i] $ENV{$array[$i]}\n");
      }
   }

   if ($directives{ddl_test}) {
      $ddl_version = get_ddl_version();
      $ENV{"DDL_VERSION"} = $ddl_version;
      $ENV{"PVIEW_HOME"} = "$PTCSRC/apps/ddl_test/$ddl_version";
      $ENV{"PVIEW_PROE2PV_TEST"} = 1;
      $ENV{"PVIEW_PROEPLUGIN_TEST"} = 1;
      if (exists $ENV{R_PDEV_REGRES_BIN}) {
     `$csh_cmd "${TOOLDIR}prodevdat_setup -T -P apps/ddl_test/text proe2pv.dll"`;
      } else {
     `$csh_cmd "${TOOLDIR}prodevdat_setup -T -P apps/ddl_test/text ../../auxobjs/$PRO_MACHINE_TYPE/ddl_test/$ddl_version/proe2pv.dll"`
      }
   }

   if ($directives{ug_test} || $directives{ug_dbatch_test}) {
      # Skip Unigraphics regression tests if Unigraphics interface executable doesnot exist.
      if ($ugs_version eq 'ugsnx9') {
         $ugExecName = "UgToProNX9";
      } elsif ($ugs_version eq 'ugsnx85') {
         $ugExecName = "UgToProNX85";
      } elsif ($ugs_version eq 'ugsnx8') {
         $ugExecName = "UgToProNX8";
      } elsif ($ugs_version eq 'ugsnx7') {
         $ugExecName = "UgToProNX7";
      } elsif ($ugs_version eq 'ugsnx6') {
         $ugExecName = "UgToProNX6";
      } elsif ($ugs_version eq 'ugsnx5') {
         $ugExecName = "UgToProNX5";
      } elsif ($ugs_version eq 'ugsnx4') {
         $ugExecName = "UgToProNX4";
      } elsif ($ugs_version eq 'ugsnx3') {
         $ugExecName = "UgToProNX3";
      } else {
         $ugExecName = "UgToPro";
      }
      $ugToProPath = "$PTCSYS/obj";
      if (($ugs_version eq "ugs180" || $PRO_MACHINE_TYPE eq "sgi_elf4") && ($PRO_MACHINE_TYPE ne "i486_nt")) {
         $ugExecName = "UgToPro32";
      }
      if ($directives{mech_test} || $directives{mech_test_long}) {
         if (defined $ENV{P_VERSION} && $ENV{P_VERSION} < 300) {
            $ugToProPath = "$ENV{PTCSRC}/mech/$ENV{PRO_MACHINE_TYPE}/ug";
         } else {
            $ugToProPath = "$ENV{PTCSRC}/mech/$ENV{PRO_MACHINE_TYPE}/bin";
         }
         $ugExecName = "ug2mnf";
      } 
      if (defined $ENV{UG_TO_PRO_PATH}) {
         $ugToProPath = $ENV{UG_TO_PRO_PATH};
      }

      if ( ! -e "$ugToProPath/$ugExecName$exe_ext") {
         print_fail("skipped::  #skipped because $ugToProPath/$ugExecName$exe_ext doesn't exist\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because $ugToProPath/$ugExecName$exe_ext doesn't exist\n");
         return (-1);
      }

      if ($OS_TYPE eq "UNIX") {
         $ugs_root_dir="$PTC_TOOLS/apps";
      } else {
         $ugs_root_dir="z:\\apps";
      }

      # It appears that UG cannot cope with '/' as path separator in the environment variables
      # on Windows. So, changed the path separator on NT. Also, UGII_ROOT_DIR should point
      # to $UGII_BASE_DIR\ugii on windows.
      if ($ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
         $ENV{UGS_LICENSE_SERVER} = "28000\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
         $ENV{UGS_LICENSE_BUNDLE} = "NXPTNR100";
      } else {
         $ENV{UGII_LICENSE_FILE} = "27005\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
         $ENV{UGII_FLEX_BUNDLE} = "NXPTNR100";
      }

      if ($ugs_version eq "ugsnx9") {
         $ENV{SPLM_LICENSE_SERVER} = "28000\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
         $ENV{SPLM_LICENSE_BUNDLE} = "NXPTNR100";
         $ENV{UGII_LICENSE_FILE} = "28000\@ANDCSV-W08FLXLM01P.ptcnet.ptc.com";
         $ENV{UGII_FLEX_BUNDLE} = "NXPTNR100";
         $ENV{UGII_LICENSE_BUNDLE} = "NXPTNR100";
      }

      if ($ugs_version eq "ugs180" || $ugs_version eq "ugs190" ||
              $ugs_version eq "ugsnx2" || $ugs_version eq "ugsnx3" ||
              $ugs_version eq "ugsnx4" || $ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" ||
              $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" ||
              $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
         if ($PRO_MACHINE_TYPE eq "sun4_solaris_64") {
            if ($ugs_version eq "ugs180" && defined $ENV{R_UGS_180_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_180_INSTALL};
            } elsif ($ugs_version eq "ugs190" && defined $ENV{R_UGS_190_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_190_INSTALL};
            } elsif ($ugs_version eq "ugsnx2" && defined $ENV{R_UGS_NX2_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX2_INSTALL};
            } elsif ($ugs_version eq "ugsnx3" && defined $ENV{R_UGS_NX3_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX3_INSTALL};
            } elsif ($ugs_version eq "ugsnx4" && defined $ENV{R_UGS_NX4_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX4_INSTALL};
            } elsif ($ugs_version eq "ugsnx5" && defined $ENV{R_UGS_NX5_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX5_INSTALL};
        } elsif ($ugs_version eq "ugsnx6" && defined $ENV{R_UGS_NX6_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX6_INSTALL};
        } elsif ($ugs_version eq "ugsnx7" && defined $ENV{R_UGS_NX7_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX7_INSTALL};
        } elsif ($ugs_version eq "ugsnx8" && defined $ENV{R_UGS_NX8_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX8_INSTALL};
        } elsif ($ugs_version eq "ugsnx85" && defined $ENV{R_UGS_NX85_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX85_INSTALL};
        } elsif ($ugs_version eq "ugsnx9" && defined $ENV{R_UGS_NX9_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX9_INSTALL};
            } else { 
               if ($ugs_version eq ugs180) {
                  $ENV{UGII_BASE_DIR} = "$ugs_root_dir/$ugs_version/sun4_solaris";
               } else {
                  $ENV{UGII_BASE_DIR} = "$ugs_root_dir/$ugs_version/$PRO_MACHINE_TYPE";
               }
            }

            if ($ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
               $ENV{UGII_ROOT_DIR} = "$ENV{UGII_BASE_DIR}/ugii";
            } else {
               $ENV{UGII_ROOT_DIR} = "$ENV{UGII_BASE_DIR}/bin";
            }
            $ENV{UGII_CHARACTER_FONT_DIR} = "$ENV{UGII_BASE_DIR}/ugii/ugfonts";
            $ENV{UGII_CHARACTER_FONT_DEFAULT} = "blockfont";
            $ENV{UGII_ENV_FILE} = "$ENV{UGII_BASE_DIR}/ugii/.ugii_env_default";
            $ENV{LD_LIBRARY_PATH} = "$ENV{UGII_BASE_DIR}/ugii:${LD_LIBRARY_PATH}";
            $ENV{UGII_TMP_DIR} = "$tmpdir";
            $ENV{UGII_UGSOLIDS_TMP} = "$tmpdir";
         }

         if ($PRO_MACHINE_TYPE eq "i486_nt" || $PRO_MACHINE_TYPE eq "x86e_win64") {
            if ($ugs_version eq "ugsnx2" || $ugs_version eq "ugsnx3" ||
                    $ugs_version eq "ugsnx4" || $ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" ||
                    $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" ||
                    $ugs_version eq "ugsnx9") {
           $old_PATH = $ENV{PATH};
               $ENV{PATH} = "$ugs_root_dir\\$ugs_version\\$ENV{PRO_MACHINE_TYPE}\\UGII;$ENV{PATH}";
            }

            if ($ugs_version eq "ugs180" && defined $ENV{R_UGS_180_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_180_INSTALL};
            } elsif ($ugs_version eq "ugs190" && defined $ENV{R_UGS_190_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_190_INSTALL};
            } elsif ($ugs_version eq "ugsnx2" && defined $ENV{R_UGS_NX2_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX2_INSTALL};
            } elsif ($ugs_version eq "ugsnx3" && defined $ENV{R_UGS_NX3_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX3_INSTALL};
            } elsif ($ugs_version eq "ugsnx4" && defined $ENV{R_UGS_NX4_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX4_INSTALL};
            } elsif ($ugs_version eq "ugsnx5" && defined $ENV{R_UGS_NX5_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX5_INSTALL};
        } elsif ($ugs_version eq "ugsnx6" && defined $ENV{R_UGS_NX6_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX6_INSTALL};
        } elsif ($ugs_version eq "ugsnx7" && defined $ENV{R_UGS_NX7_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX7_INSTALL};
        } elsif ($ugs_version eq "ugsnx8" && defined $ENV{R_UGS_NX8_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX8_INSTALL};
        } elsif ($ugs_version eq "ugsnx85" && defined $ENV{R_UGS_NX85_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX85_INSTALL};
        } elsif ($ugs_version eq "ugsnx9" && defined $ENV{R_UGS_NX9_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX9_INSTALL};
            } else { 
               $ENV{UGII_BASE_DIR} = "$ugs_root_dir\\$ugs_version\\$PRO_MACHINE_TYPE";
            }

            $ENV{UGII_ROOT_DIR} = "$ENV{UGII_BASE_DIR}\\ugii";
        # Convert scratch dir path slashes for UG on Windows
        my $convtmp = "$tmpdir";
        $convtmp =~ s/\//\\/;
        $ENV{UGII_TMP_DIR} = "$convtmp";
        $ENV{UGII_UGSOLIDS_TMP} = "$convtmp";
         }

         if ($PRO_MACHINE_TYPE eq "hpux_pa64") {
            if ($ugs_version eq "ugs180" && defined $ENV{R_UGS_180_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_180_INSTALL};
            } elsif ($ugs_version eq "ugs190" && defined $ENV{R_UGS_190_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_190_INSTALL};
            } elsif ($ugs_version eq "ugsnx2" && defined $ENV{R_UGS_NX2_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX2_INSTALL};
            } elsif ($ugs_version eq "ugsnx3" && defined $ENV{R_UGS_NX3_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX3_INSTALL};
            } elsif ($ugs_version eq "ugsnx4" && defined $ENV{R_UGS_NX4_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX4_INSTALL};
            } elsif ($ugs_version eq "ugsnx6" && defined $ENV{R_UGS_NX6_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX6_INSTALL};
            } elsif ($ugs_version eq "ugsnx7" && defined $ENV{R_UGS_NX7_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX7_INSTALL};
            } elsif ($ugs_version eq "ugsnx8" && defined $ENV{R_UGS_NX8_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX8_INSTALL};
        } elsif ($ugs_version eq "ugsnx85" && defined $ENV{R_UGS_NX85_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX85_INSTALL};
        } elsif ($ugs_version eq "ugsnx9" && defined $ENV{R_UGS_NX9_INSTALL}) {
               $ENV{UGII_BASE_DIR} = $ENV{R_UGS_NX9_INSTALL};
            } else { 
               if ($ugs_version eq "ugs180") {
                  $ENV{UGII_BASE_DIR} = "$ugs_root_dir/$ugs_version/hpux11_pa32";
               } else {
                  $ENV{UGII_BASE_DIR} = "$ugs_root_dir/$ugs_version/$PRO_MACHINE_TYPE";
               }
            }

            if ($ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
               $ENV{UGII_ROOT_DIR} = "$ENV{UGII_BASE_DIR}/ugii";
            } else {
               $ENV{UGII_ROOT_DIR} = "$ENV{UGII_BASE_DIR}/bin";
            }

            $ENV{UGII_CHARACTER_FONT_DIR} = "$ENV{UGII_BASE_DIR}/ugii/ugfonts";
            $ENV{UGII_CHARACTER_FONT_DEFAULT} = "blockfont";
            $ENV{UGII_ENV_FILE} = "$ENV{UGII_BASE_DIR}/ugii/.ugii_env_default";
            $ENV{LD_LIBRARY_PATH} = "$ENV{UGII_BASE_DIR}/ugii:/usr/lib/X11R5:${LD_LIBRARY_PATH}";
            $ENV{UGII_TMP_DIR} = "$tmpdir";
            $ENV{UGII_UGSOLIDS_TMP} = "$tmpdir";
         }
      } else {
         print_fail("skipped::  #skipped because auto does support UG interface version $ugs_version with directive ug_test, please file a Integ Helpdesk case to have auto.pl updated.\n");
         print_skip_msg("skipped::  #skipped because auto does support UG interface version $ugs_version with directive ug_test, please file a Integ Helpdesk case to have auto.pl updated.\n");
         return (-1);
      }

      ## Create ugs_config.pro on the fly
      open(UG_CONF,">>$tmpdir/ugs_config.pro");
      print UG_CONF ("intf3d_ug_install_dir $ENV{UGII_BASE_DIR}\n");
      if ($ugs_version eq "ugsnx3") {
         print UG_CONF ("intf_ug_version nx3\n");
      } 
      if ($ugs_version eq "ugsnx4") {
         print UG_CONF ("intf_ug_version nx4\n");
      } 
      if ($ugs_version eq "ugsnx5") {
         print UG_CONF ("intf_ug_version nx5\n");
      }
      if ($ugs_version eq "ugsnx6") {
         print UG_CONF ("intf_ug_version nx6\n");
      }
      if ($ugs_version eq "ugsnx7") {
         print UG_CONF ("intf_ug_version nx7\n");
      }
      if ($ugs_version eq "ugsnx8") {
         print UG_CONF ("intf_ug_version nx8\n");
      }
      if ($ugs_version eq "ugsnx85") {
         print UG_CONF ("intf_ug_version nx8.5\n");
      }
      if ($ugs_version eq "ugsnx9") {
         print UG_CONF ("intf_ug_version nx9\n");
      }

      close(UG_CONF);

      if ($directives{ug_dbatch_test}) {
            `cat ugs_config.pro >> config.pro`;
      }

      print "\nUGII_ROOT_DIR is set to $ENV{UGII_ROOT_DIR}\n\n";
      if ($ugs_version eq "ugsnx5" || $ugs_version eq "ugsnx6" || $ugs_version eq "ugsnx7" || $ugs_version eq "ugsnx8" || $ugs_version eq "ugsnx85" || $ugs_version eq "ugsnx9") {
         print "\nUGS_LICENSE_SERVER is set to $ENV{UGS_LICENSE_SERVER}\n\n";
      } else {
         print "\nUGII_LICENSE_FILE is set to $ENV{UGII_LICENSE_FILE}\n\n";
      }

   }
   
   if ($directives{gd_test}) {   
	  $clean_setenv_cmds{'CREO_TRUESOLID_API_LOG'} = $ENV{$CREO_TRUESOLID_API_LOG} ;
	  $clean_setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'} = $ENV{$CREO_TRUESOLID_API_LOG_DIR};
	  $clean_setenv_cmds{'R_TIMEOUT'} = $ENV{$R_TIMEOUT};
	  $clean_setenv_cmds{'PTC_TRAIL_DELAY'} = $ENV{$PTC_TRAIL_DELAY};
      
      $setenv_cmds{'CREO_TRUESOLID_API_LOG'} = 'true' if (not defined $ENV{CREO_TRUESOLID_API_LOG});
	  if (defined $ENV{CREO_TRUESOLID_API_LOG_DIR}) {
	    $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'} = $ENV{CREO_TRUESOLID_API_LOG_DIR};
	  } else {
	     $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'} = cwd();
	  }
	  $setenv_cmds{'R_TIMEOUT'} = 60;
	  $setenv_cmds{'PTC_TRAIL_DELAY'} = 3600;
   
    if ( $ENV{'R_SAVE_APILOG'} eq 'true' ) {
        if (not defined $ENV{R_SAVE_AS}) {
            $ENV{R_SAVE_AS} = 'apilog';
        } else {
            $ENV{R_SAVE_AS} =~ s/,$//;
            if ($ENV{R_SAVE_AS} =~ /,/ || $ENV{R_SAVE_AS} ne "") {
                $ENV{R_SAVE_AS} .= ',apilog' if ($ENV{R_SAVE_AS} !~ /(apilog)/);
            } else {
                $ENV{R_SAVE_AS} = 'apilog';
            }
        }
    }
    
	  $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'}  =~ tr/\\/\//;
	  $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'}  = `cygpath -m $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'}` if (defined($PTC_CYGWIN));
	  chomp($setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'});
	  `mkdir -p $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'}` if (! -d $setenv_cmds{'CREO_TRUESOLID_API_LOG_DIR'});
	  
      my $is_prefered_orig_merge;
      if (not defined $ENV{'R_MERGE_PREFER_ORIG'}) {
          $is_prefered_orig_merge = 'no';
          $ENV{'R_MERGE_PREFER_ORIG'} = 'true';
      }

     open (CONFIG_PT,">gd_config.pro");
     print CONFIG_PT "\ngenerative_number_cores 3\n";
     print CONFIG_PT "qlay_max_threads 3\n";
     print CONFIG_PT "gdr_segm_max_threads 3\n\n";
     close(CONFIG_PT);
      
      merge_config("gd_config.pro");
      unlink("gd_config.pro");
      undef $ENV{'R_MERGE_PREFER_ORIG'} if ($is_prefered_orig_merge eq 'no'); 
   }
   
   if ($directives{aim_test}) {
      my $is_prefered_orig_merge;
      if (not defined $ENV{'R_MERGE_PREFER_ORIG'}) {
          $is_prefered_orig_merge = 'no';
          $ENV{'R_MERGE_PREFER_ORIG'} = 'true';
      }
      
      open (CONFIG_PT,"config.pro");
      my (@config_list) = <CONFIG_PT>;
      close(CONFIG_PT);
      chomp(@config_list);

      foreach $directory ('creo_ansys_run_folder','creo_ansys_cache_folder') {
          my $aimdirectory;
          open (CONFIG_PT,">>aim_config.pro");
          @matched = grep /^($directory)/, @config_list;
          if (! scalar(@matched)) {
            if ($directory eq 'creo_ansys_run_folder') {
                $aimdirectory = "a_run";
            } elsif ($directory eq 'creo_ansys_cache_folder') {
                $aimdirectory = "a_cache";
            } 
            $aimdirpath = cwd(). "/" . $aimdirectory;
            mkdir($aimdirectory, 0777) if (! -e $aimdirectory);
            print CONFIG_PT "$directory $aimdirpath\n";
          }
          close(CONFIG_PT);
      }

      merge_config("aim_config.pro");
      unlink("aim_config.pro");
      undef $ENV{'R_MERGE_PREFER_ORIG'} if ($is_prefered_orig_merge eq 'no');
   }
   
   if ($directives{vulkan} && $directives{graphics_test}) {
      $save_user_graphics_mode = $ENV{'R_GRAPHICS'} if ($ENV{'R_GRAPHICS'} ne '');
      $ENV{R_GRAPHICS} = 11;

      print "To run vulkan test, R_GRAPHICS is set to $ENV{R_GRAPHICS}\n";
   }
   
   if ($directives{pglview_test}) {
      if ($ENV{'R_GRAPHICS'} ne '' && $ENV{'R_GRAPHICS'} ne '0') {
         $save_user_graphics_mode = $ENV{'R_GRAPHICS'};
         $ENV{R_GRAPHICS} = 11;

         print "To run pglview_test test, R_GRAPHICS is set to $ENV{R_GRAPHICS}\n";
      }
   }
   
   if ($directives{saas_test_on_demand} && $ENV{R_SAAS_REGRESSION_ONDEMAND} ne "true") {
      print_succ("skipped::  #skipped because R_SAAS_REGRESSION_ONDEMAND is not set to true\n");
      print_skip_msg("\nskipped::  #skipped $raw_trailname because R_SAAS_REGRESSION_ONDEMAND is not set to true\n");
      return (1);
   }
   
   if ($directives{graphics_process}) {
      my $is_prefered_orig_merge;
      if (not defined $ENV{'R_MERGE_PREFER_ORIG'}) {
          $is_prefered_orig_merge = 'no';
          $ENV{'R_MERGE_PREFER_ORIG'} = 'true';
      }
      
      open (CONFIG_PT,">graphprocess_config.pro");
      print CONFIG_PT "\nadvanced_rendering_mode $graphics_process_type\n\n";
      close(CONFIG_PT);
      
      merge_config("graphprocess_config.pro");
      unlink("graphprocess_config.pro");
      undef $ENV{'R_MERGE_PREFER_ORIG'} if ($is_prefered_orig_merge eq 'no'); 
      
      $directives{tk_flavor};
   }
   
   if ($directives{java_flavor}) {
      my $jdkver = (split(/jdk/,$tk_flavor_)) [1];
      $clean_setenv_cmds{'JAVA'.$jdkver .'HOME'} = $ENV{'JAVA'.$jdkver .'HOME'};
      $setenv_cmds{'JAVA'.$jdkver .'HOME'} = $jdkloc;
      
      $save_user_pro_java_command = $ENV{'PRO_JAVA_COMMAND'} if ($ENV{'PRO_JAVA_COMMAND'} ne '');
      $clean_setenv_cmds{'PRO_JAVA_COMMAND'} = $ENV{'PRO_JAVA_COMMAND'}; 
      $setenv_cmds{'PRO_JAVA_COMMAND'} = $jdkloc."/bin/java";
   }
   
   if ($directives{saas_test}) {
       if ( $ENV{'R_SAAS_REGRESSION'} eq 'true' ) {
          add_to_saveas('log');
          add_to_saveas('stderr');
          add_to_saveas('stdout');
          add_to_saveas('trl');
          add_to_saveas('PlaywrightReports');
       }
   }

   if ($ENV{R_USE_CREO_PLUS} eq "true" && (not defined $ENV{R_DISABLE_PTC_LOGGING})) {
        if (! $keep_agent_home_folder) {
            $ENV{PTC_LOG_DIR} = "${rundir}/${uniquename}_ptclog";
            #$ENV{R_SAVE_AS} = "${uniquename}_ptclog";
            mkpath($ENV{PTC_LOG_DIR}, 0777) if (! -d "$ENV{PTC_LOG_DIR}");
        }
		
        if ( (not defined $ENV{PTC_LOG_CONFIG}) && -d "$ENV{PTC_TOOLS}/external/saas/saas-cpd-log-config") {
                `cp $ENV{PTC_TOOLS}/external/saas/saas-cpd-log-config/*.cfg $ENV{PTC_LOG_DIR}` ;
        }
   }
   
   if ($tk_flavor_ ne '') {
      if ($tk_flavor_ =~ /edge$/i) {
         open (CONFIG_PT,">edge_browser_config.pro");
         print CONFIG_PT "\nwindows_browser_type edge_browser\n";
         close(CONFIG_PT);
         merge_config("edge_browser_config.pro");
         print("Note:windows_browser_type edge_browser is added to config.pro\n");
         unlink("edge_browser_config.pro");    
      }
   }
   &apply_setenv;

   # set PTC_REGISTRY_REGTEST
   if ($first_trail) {
     
     if (not defined $ENV{PTC_REGISTRY_REGTEST}) {
       # trail name can be more than 32 chars, but that is fine as both creo and clear_registry script truncate it to 32 chars.
       # appending PTCNMSPORT to ensure we get different registry when we run same test twice(simultaneously) on same machine
       $ENV{PTC_REGISTRY_REGTEST} = "${raw_trailname}_$ENV{PTCNMSPORT}";
       $set_registry_regtest = 1;
     }

   }

   if ($directives{if_exist} && $ENV{R_ENABLE_IF_EXIST} eq "true") {
      @array = split(/ +/, $if_exist_list);
      if ($array[0] eq "" && $array[1] eq "") {
         print_fail("skipped::  #skipped because no keywords specified for #if_exist directive\n");
         print_skip_msg("skipped::  #skipped $raw_trailname because no keywords specified for #if_exist directive\n");
         return (-1);
      }
      foreach $if_exist_target (@array) {
         next if ($if_exist_target eq "" || $autoexist_db{$if_exist_target}{'1'}[0] eq "NA");
         if (! defined $autoexist_db{$if_exist_target}) {
            print_fail("skipped::  #skipped because no $if_exist_target for $PRO_MACHINE_TYPE is defined in $autoexist_file\n"); 
            print_skip_msg("skipped::  #skipped $raw_trailname because no $if_exist_target for $PRO_MACHINE_TYPE is defined in $autoexist_file\n");
            return (-1);
         }

         foreach $count (keys %{$autoexist_db{$if_exist_target}}) {
            $target = $autoexist_db{$if_exist_target}{$count}[0];
            $alt_target = $autoexist_db{$if_exist_target}{$count}[1];
            if ($alt_target eq '' && ! -e "$PTCSYS/$target") {
               print_fail("skipped::  #skipped because $PTCSYS/$target doesn't exist\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $PTCSYS/$target doesn't exist\n");
               if (defined $ENV{R_WAIT_FOR_BINARY}) {
                 sleep_for_a_while();
               }
               return (-1);
            }
            if ($alt_target ne '' && ! -e "$PTCSYS/$target" && ! -e "$alt_target") {
               print_fail("skipped::  #skipped because $PTCSYS/$target or $alt_target doesn't exist\n");
               print_skip_msg("skipped::  #skipped $raw_trailname because $PTCSYS/$target or $alt_target doesn't exist\n");
               return (-1);
            }
         }
         if (-e "$PTCSYS/$target") {
            print "\n  $PTCSYS/$target exists, continuing ..\n\n";
         }
         if (-e "$alt_target") {
            print "\n  $alt_target exists, continuing ..\n\n";
         }
      }
   }

   if ($directives{merge_config}) {
	 merge_config($merge_config_file);
   }

   if ($directives{config_file}) {
     `cat $config_file >> "$tmpdir/config.pro"`
   }
   
   if (defined $ENV{R_CP_TO_SCRATCH}) {
      $ENV{R_CP_TO_SCRATCH} =~ s/\\/\//g;
      $ENV{R_CP_TO_SCRATCH} = `cygpath -m $ENV{R_CP_TO_SCRATCH}`;
      chomp($ENV{R_CP_TO_SCRATCH});
      my (@cpfile);
      @cpfile = split(/ /,$ENV{R_CP_TO_SCRATCH});
      foreach $f (@cpfile) {
         if (-d $f) {
            print_succfail("Copying additional files from $f to scratch dir\n");
            `cp $f/* "$tmpdir"`;
         } else {
            print_succfail("Copying additional file to scratch dir, $f\n");
            `cp $f "$tmpdir"`;
         }
      }
   }
   
   if ($directives{num_cmd}) {
      my $stat=run_commands();
      if ($stat) {
     if ($stat == 99) {
        return (1);
     } else {
            return (-1);
     }
      }
   }

   if ($directives{shared_workspace} && $first_trail ) {
     if ($collab_atlas ne 'true') {
        print ("\n configure and run local collab service before running Creo\n");
        if (configure_run_collab_svc() == -1 ) {
           return (-1);
        }
     }
   }
 
   $prefix_host_name;
   $prefix_session_name;
   if ($directives{shared_workspace}) {
     my $cur_time;    
	 $cur_time=localtime(time());
	 @time_tokens = split(/[:,\s\/]+/, $cur_time);
	 $str_time = "";
	 
     foreach my $time_token (@time_tokens) {
	 	$str_time = "$str_time\_$time_token";
	 }
	 
     $prefix_host_name=`hostname`;		
	 chomp ($prefix_host_name);	 
	 $prefix_random_number = int(rand(1000000000));	
	 $prefix_session_name = "$prefix_host_name\_$prefix_random_number$str_time";
     
     if (defined $ENV{COLLAB_SESSION_NAME_PREFIX} && $ENV{COLLAB_SESSION_NAME_PREFIX} ne "") {
        $prefix_session_name = $ENV{COLLAB_SESSION_NAME_PREFIX};
     }
     
     $ENV{COLLAB_SESSION_NAME_PREFIX} = $prefix_session_name;
     print " COLLAB_SESSION_NAME_PREFIX is set to $ENV{COLLAB_SESSION_NAME_PREFIX}\n";

    if ( ($ENV{R_USE_CREO_PLUS} eq 'true') && -d "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin") {
      if ($directives{run_with_license} || $ENV{LANG} ne 'C' || $ENV{R_SAAS_PROFILE_NAME} ne '' || ("$ENV{R_UPDATE_PSF_ENV}" ne '') ) {
        $l2r_username = lc($l2r_username);
        $old_psf_file = $psf_file;
        $psf_file = create_psf_file($psf_file,$ENV{$l2r_feature_name_var},$ENV{LANG},$ENV{R_SAAS_PROFILE_NAME},"$ENV{R_UPDATE_PSF_ENV}");
        $psf_filename = basename($psf_file);
        `mv $psf_file $psf_file_location`;
        $psf_file = "$psf_file_location\\$psf_filename";
        $LOCALPROE_old = $ENV{LOCALPROE};
        $ENV{LOCALPROE} = "$ENV{PROE_START} $psf_file ";
      }
      save_configure_creosaas_login($l2r_username,$l2r_password) if ($directives{run_with_license});
    }
    
   }
   
  if ($collab_atlas eq 'true' || $directives{atlas_user} || ($directives{gd_webapp_test})) {
    
     if (($ENV{IS_COLLAB_PLAYWRIGHT_TEST} =~ /yes/i) || ($ENV{IS_GDX_PLAYWRIGHT_TEST} =~ /yes/i)) {
        $ctmpdir =  `cygpath -m $old_temp`;
        chomp($ctmpdir);
        if (! -d "$ctmpdir") {
           print("old_temp[$ctmpdir] is missing\n");
           print_fail("skipped::  #skipped because old_temp[$old_temp] is missing\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because old_temp[$old_temp] is missing\n");
           $skip_msg = "because because old_temp[$old_temp] is missing\n";
           return (-1);
        }
        add_to_saveas('playwright_test.log');
        add_to_saveas('playwright-report');
        add_to_saveas('test-results');
     }

     if ( ($ENV{IS_COLLAB_PLAYWRIGHT_TEST} =~ /yes/i) ) {
        print ("IS_COLLAB_PLAYWRIGHT_TEST is set to $ENV{IS_COLLAB_PLAYWRIGHT_TEST}\n");
        if ($ENV{COLLAB_TEST_PLAYWRIGHT_REPO} eq '') {
          $ENV{COLLAB_TEST_PLAYWRIGHT_REPO} = "$ctmpdir/creo-saas-automation-repo";
        }
        
        if (not defined $ENV{PTC_WEB_DRIVER_JAVA_EXE}) {
           $clean_setenv_cmds{'PTC_WEB_DRIVER_JAVA_EXE'} = $ENV{$PTC_WEB_DRIVER_JAVA_EXE};
           $ENV{PTC_WEB_DRIVER_JAVA_EXE} = "$ENV{PRO_JAVA_COMMAND}";
        }

        if (! $is_collab_test_repo_downloaded) {
          $delete_creo_saas_automation_repo  = 1;
        }
        $ENV{'COLLAB_TEST'} = $ENV{COLLAB_TEST_PLAYWRIGHT_REPO};
        mkpath("$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}",0777) if (! -d "$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}");
    
        open(FHL,">$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}/repo-in-use.lock.$$");
        print(FHL "$$");
        close(FHL);
        
       print "COLLAB_TEST_PLAYWRIGHT_REPO=$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}\n";
       if (! $is_collab_test_repo_downloaded) {
          $E2E_AUTOMATION_TOKEN = get_secret('e2e_testrun_token'); 
          $downloadscript = "$ENV{PTC_TOOLS}/bin/downloadplaywrightdata";
          
          print ("Please wait ... downloading playwright data at $ENV{COLLAB_TEST_PLAYWRIGHT_REPO}\n");
          $ENV{TEST_PLAYWRIGHT_REPO} = "$ENV{COLLAB_TEST_PLAYWRIGHT_REPO}";          
          my $cmd_output = `$csh_cmd "$downloadscript --known_download collab_playwright_data --destination $ctmpdir --download_token $E2E_AUTOMATION_TOKEN "`;
          $backquote_result = $?;
          undef $ENV{TEST_PLAYWRIGHT_REPO};
          if ($backquote_result) {
           print_fail("skipped::  #skipped because downloadplaywrightdata failed\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because downloadplaywrightdata failed\n");
           $skip_msg = "because downloadplaywrightdata failed, \n\n ${cmd_output}\n";
           return (-1);        
         }
         print ("Playwright download finish ${cmd_output}\n");         
         $is_collab_test_repo_downloaded = 1;
       }
     }

     if ( ($ENV{IS_GDX_PLAYWRIGHT_TEST} =~ /yes/i) ) {
        print ("IS_GDX_PLAYWRIGHT_TEST is set to $ENV{IS_GDX_PLAYWRIGHT_TEST}\n");
        if ($ENV{GDX_TEST_PLAYWRIGHT_REPO} eq '') {
          $ENV{GDX_TEST_PLAYWRIGHT_REPO} = "$ctmpdir/creo-saas-automation-repo-gdx";
        }

        if (not defined $ENV{PTC_WEB_DRIVER_JAVA_EXE}) {
           $clean_setenv_cmds{'PTC_WEB_DRIVER_JAVA_EXE'} = $ENV{$PTC_WEB_DRIVER_JAVA_EXE};
           $ENV{PTC_WEB_DRIVER_JAVA_EXE} = "$ENV{PRO_JAVA_COMMAND}";
        }

        if (! $is_gdx_test_repo_downloaded) {
          $delete_creo_saas_automation_repo_gdx  = 1;
        }
        $ENV{'GDX_PRO_TEST'} = $ENV{GDX_TEST_PLAYWRIGHT_REPO};
        mkpath("$ENV{GDX_TEST_PLAYWRIGHT_REPO}",0777) if (! -d "$ENV{GDX_TEST_PLAYWRIGHT_REPO}");

        open(CONFIG_PT, ">>$tmpdir/config.pro");
        my $output1 = "trail_substitution GDX_PRO_TEST $ENV{GDX_PRO_TEST}";
        print CONFIG_PT "$output1\n";
        close(CONFIG_PT);
        
        open(FHL,">$ENV{GDX_TEST_PLAYWRIGHT_REPO}/repo-in-use.lock.$$");
        print(FHL "$$");
        close(FHL);
        
       print "GDX_TEST_PLAYWRIGHT_REPO=$ENV{GDX_TEST_PLAYWRIGHT_REPO}\n";
       if (! $is_gdx_test_repo_downloaded) {           
          $E2E_AUTOMATION_TOKEN = get_secret('e2e_testrun_token'); 
          $downloadscript = "$ENV{PTC_TOOLS}/bin/downloadplaywrightdata";
          
          print ("Please wait ... downloading gdx playwright data at $ENV{GDX_TEST_PLAYWRIGHT_REPO}\n");
          $ENV{TEST_PLAYWRIGHT_REPO} = "$ENV{GDX_TEST_PLAYWRIGHT_REPO}";          
          my $cmd_output = `$csh_cmd "$downloadscript --known_download gdx_playwright_data --destination $ctmpdir --download_token $E2E_AUTOMATION_TOKEN "`;
          $backquote_result = $?;
          undef $ENV{TEST_PLAYWRIGHT_REPO};  
          if ($backquote_result) {
           print_fail("skipped::  #skipped because downloadplaywrightdata failed\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because downloadplaywrightdata failed\n");
           $skip_msg = "because downloadplaywrightdata failed, \n\n ${cmd_output}\n";
           return (-1);        
         }
         print ("Playwright download finish ${cmd_output}\n");         
         $is_gdx_test_repo_downloaded = 1;
       }
     }
     
   }

   if ($directives{saas_test} && $directives{creoplus_e2e_test}) { 
     if ($ENV{R_SAAS_REGRESSION_E2E} ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_SAAS_REGRESSION_E2E is not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_SAAS_REGRESSION_E2E is not true \n");
        return (1);
     }
  
     $clean_setenv_cmds{'E2E_CONFIG_TYPE'} = 'customE2E' if (not defined $ENV{E2E_CONFIG_TYPE});
     $clean_setenv_cmds{'CREO_SAAS_TEST_PLAYWRIGHT_REPO'} = "$cur_dir/creo-saas-automation-repo" if (not defined $ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO});
     $clean_setenv_cmds{'PLAYWRIGHT_TEST_RUNDIR'} = $ENV{PLAYWRIGHT_TEST_RUNDIR} if (not defined $ENV{PLAYWRIGHT_TEST_RUNDIR});
     
     $ENV{'E2E_CONFIG_TYPE'} = 'customE2E' if (not defined $ENV{E2E_CONFIG_TYPE});
     if (not defined $ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO}) { 
        $ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO} = "$cur_dir/creo-saas-automation-repo";
        $delete_creo_saas_automation_repo  = 1;
     }
     $ctmpdir =  `cygpath -m $tmpdir`;
     chomp($ctmpdir);
     $ENV{PLAYWRIGHT_TEST_RUNDIR} = "$ctmpdir/PlaywrightReports" if (not defined $ENV{PLAYWRIGHT_TEST_RUNDIR});

     print "CREO_SAAS_TEST_PLAYWRIGHT_REPO=$ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO}\n";
     print "PLAYWRIGHT_TEST_RUNDIR=$ENV{PLAYWRIGHT_TEST_RUNDIR}\n";
     if (! $is_e2e_downloaded) {
        print "\nRunning $ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/creoplus-e2e/e2e-scripts/download-extract-repo/DownloadAndExtractRepository.py -d $ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO}  -t <E2E_AUTOMATION_TOKEN> \n";
      
        `csh -fc "$ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/creoplus-e2e/e2e-scripts/download-extract-repo/DownloadAndExtractRepository.py -d $ENV{CREO_SAAS_TEST_PLAYWRIGHT_REPO} -t $E2E_AUTOMATION_TOKEN "`;
        $backquote_result = $?;
        if ($backquote_result) {
           print_fail("skipped::  #skipped because DownloadAndExtractRepository.py failed\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because DownloadAndExtractRepository.py failed\n");
           $skip_msg = "because DownloadAndExtractRepository.py failed\n";
           return (-1);        
        }
             
        $is_e2e_downloaded = 1;
     }

     if ($e2e_test_tsname ne "") {
        use_cpd_user() if ( $directives{cpd_user} );
         
        print "\nRunning $ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/creoplus-e2e/e2e-scripts/playwright-test-runner/CreoPlusPlaywrightTestrunner.py -t $e2e_test_tsname \n";
      
        `csh -fc "$ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/creoplus-e2e/e2e-scripts/playwright-test-runner/CreoPlusPlaywrightTestrunner.py -t $e2e_test_tsname "`;
        $backquote_result = $?;

        if ($backquote_result) {
           print "\n skipped $raw_trailname because CreoPlusPlaywrightTestrunner.py failed with satus = $backquote_result\n";
           print_fail("skipped::  #skipped because CreoPlusPlaywrightTestrunner.py failed\n");
           print_skip_msg("skipped::  #skipped $raw_trailname because CreoPlusPlaywrightTestrunner.py failed\n");
           $skip_msg = "because CreoPlusPlaywrightTestrunner.py (Note:verify chrome browser is installed on test machines) failed with satus = $backquote_result\n";
           return (-1);
         }
      }
   }
   
   if ($directives{pyautogui_test}) { 
     if ($ENV{R_RUN_PYAUTOGUI_TEST} ne 'true') {
        print_succ("skipped::  #skipped $raw_trailname because R_RUN_PYAUTOGUI_TEST is not true \n");
        print_skip_msg("skipped::  #skipped $raw_trailname because R_RUN_PYAUTOGUI_TEST is not true \n");
        return (1);
     }
   }
   
   return (0);
}

sub init_alt_c5_converter_env {
    $ENV{"XTCSRC"} = $PTCSRC if (! exists $ENV{XTCSRC});
    if (exists $ENV{CV_ENV_HOME}) {
       $old_CV_ENV_HOME = $ENV{CV_ENV_HOME};
       $ENV{CV_ENV_HOME} = "$ENV{XTCSRC}/auxobjs/$PRO_MACHINE_TYPE/$alt_c5_converter_path";
    } else {
       $old_CV_ENV_HOME = "";
       $ENV{"CV_ENV_HOME"} = "$ENV{XTCSRC}/auxobjs/$PRO_MACHINE_TYPE/$alt_c5_converter_path";
    }
}

sub unset_mozilla_env {
    if ($PRO_MACHINE_TYPE eq "sun4_solaris" || $PRO_MACHINE_TYPE eq "sun4_solaris_64") {
       $ENV{LD_LIBRARY_PATH} = $old_LD_LIBRARY_PATH;
    }
    if ($PRO_MACHINE_TYPE eq "hpux11_pa32" || $PRO_MACHINE_TYPE eq "hpux_pa64") {
       $ENV{SHLIB_PATH} = $old_SHLIB_PATH;
    }
    if ($PRO_MACHINE_TYPE eq "sgi_mips4" || $PRO_MACHINE_TYPE eq "sgi_elf4") {
       $ENV{LD_LIBRARYN32_PATH} = $old_LD_LIBRARYN32_PATH;
    }
    if ($PRO_MACHINE_TYPE eq "ibm_rs6000") {
       $ENV{LIBPATH} = $old_LIBPATH;
    }
}

sub set_mozilla_env {
    if ($PRO_MACHINE_TYPE eq "sun4_solaris" || $PRO_MACHINE_TYPE eq "sun4_solaris_64") {
       $ENV{LD_LIBRARY_PATH} = "${LD_LIBRARY_PATH}:$ENV{MOZILLA_FIVE_HOME}";
    }
    if ($PRO_MACHINE_TYPE eq "hpux11_pa32" || $PRO_MACHINE_TYPE eq "hpux_pa64") {
       $old_SHLIB_PATH = ${SHLIB_PATH};
       $ENV{SHLIB_PATH} = "${SHLIB_PATH}:$ENV{MOZILLA_FIVE_HOME}";
    }
    if ($PRO_MACHINE_TYPE eq "sgi_mips4" || $PRO_MACHINE_TYPE eq "sgi_elf4") {
       $old_LD_LIBRARYN32_PATH=$ENV{LD_LIBRARYN32_PATH};
       $ENV{LD_LIBRARYN32_PATH}="$ENV{LD_LIBRARYN32_PATH}:$ENV{MOZILLA_FIVE_HOME}";
    }
    if ($PRO_MACHINE_TYPE eq "ibm_rs6000") {
       $old_LIBPATH=$ENV{LIBPATH};
       $ENV{LIBPATH}="$ENV{LIBPATH}:$ENV{MOZILLA_FIVE_HOME}";
    }
    `$ENV{MOZILLA_FIVE_HOME}/ptc_gecko_server` if ($OS_TYPE eq "UNIX");
    return (0);
}

sub test_display {
   if ($OS_TYPE eq "UNIX" && $ENV{R_GRAPHICS} eq "0") {
      `test_display`;
      $status = $? >> 8;
      if ($status) {
     my $old_display = $ENV{DISPLAY};
     if (defined $ENV{R_DISPLAY}) {
        $ENV{DISPLAY} = $ENV{R_DISPLAY};
     } else {
        if ($PRO_MACHINE_TYPE =~ /^hpux/) {
        $ENV{DISPLAY} = "skyhawk.ptc.com:0";
    } else {
            $ENV{DISPLAY} = "oforce.ptc.com:0";
    }
     }
     `test_display`;
     $status = $? >> 8;
     if ($status) {
        $ENV{DISPLAY} = $old_display;
        print_fail("Can't run the test because can't display\n");
        print_skip_msg("skipped::  #skipped $raw_trailname because can't display\n");
        return (1);
     }
      }
   }
   return (0);
}

sub print_succfail {
   my ($msg) = @_;

   print_succ( $msg );
   print_fail( $msg );
}

sub print_succ {
   my ($msg) = @_;

   open (SUCC_PT, ">>:raw","$succ");
   print SUCC_PT $msg;
   close(SUCC_PT);
}

sub print_bitmap {
   my ($msg) = @_;

   open (BIT_PT, ">>:raw","$bitmapfile");
   print BIT_PT $msg;
   close(BIT_PT);
}

sub print_fail {
   my ($msg) = @_;

   open (FAIL_PT, ">>:raw","$fail");
   print FAIL_PT $msg;
   close(FAIL_PT);
}

sub print_skip_msg {
   my ($msg) = @_;

   open (SKIP_PT, ">>:raw","$skip_log");
   print SKIP_PT $msg;
   close(SKIP_PT);
}

sub print_notexists {
   my ($msg) = @_;

   open (NOTEXISTS, ">>:raw","$notexists");
   print NOTEXISTS $msg;
   close(NOTEXISTS);
}

sub rm_dbgfile_for_non_langtest {
   my (@dbgfile_list);
   if ($altlang ne "" && ! $directives{langtest} && ! $directives{japanese_test} && ! $directives{chinese_test} && ! $directives{korean_test}) {
      print "Removing all dbgfile.dat for tests which run in a foreign language\n";
      @dbgfile_list = glob("$tmpdir/dbgfile.dat*");
      chomp(@dbgfile_list);
      foreach $f (@dbgfile_list) {
      print "Removing $f\n";
      `$rm_cmd -f "$f"`;
      }
 
      if (-d "$cur_dir/${collab_other_pid}_otheruser") {
         print "Removing all dbgfile.dat for tests which run in a foreign language of other_user\n";
         @dbgfile_list = glob("$cur_dir/${collab_other_pid}_otheruser/dbgfile.dat*");
         chomp(@dbgfile_list);
         foreach $f (@dbgfile_list) {
           print "Removing $f\n";
          `$rm_cmd -f "$f"`;
         }
      }

   }
}

sub find_printf {
   my ($raw_trailname) = @_;

   if ($R_FIND_PRINTF != 0 && $ENV{R_RUNMODE} == 0 && $ENV{R_GRAPHICS} != 0
               && ! -z $raw_trailname.msg ) {
      $fail_no++;
      $result="FAILURE";
      print_fail("see $raw_trailname.msg for extraneous printf messages\n");
   }
}

sub run_gprof {
   my ($trail_name) = @_;

   if (defined $ENV{R_SUPERAUTO} ) {
      return (0) if ($result ne "SUCCESS");
      print "\nPROCESSING: profile data for $trail_name ....\n";
      @mon_out = `find "$tmpdir" -name mon.out -print`;
      chop (@mon_out);
      if ($mon_out[0] eq "") {
         print "\nThe mon.out is missing, no profile data\n";
         return (0);
      }
      my $out_file="$rundir/${trail_name}.sat";
      `prof -g -m $mon_out[0] $local_xtop > $out_file`;
      open (OUTFILE, $out_file);
      @out_list =<OUTFILE>;
      chop(@out_list);
      close(OUTFILE);
      my $out_functions="$rundir/${trail_name}.func";
      open (OUTFILE, ">:raw","$out_functions");
      foreach $line (@out_list) {
         @array = split(/[\t ]+/, $line);
         $first_char=substr($line, 0, 1);
         if ($first_char eq " " || $first_char eq "[") {
            if ($array[5] =~ /^_/ || $array[5] =~ /^[A-Za-z]/) {
               print OUTFILE ("$array[5] \n");
            } elsif ($array[6] =~ /^_/ || $array[6] =~ /^[A-Za-z]/) {
               print OUTFILE ("$array[6] \n");
            } elsif ($array[7] =~ /^_/ || $array[7] =~ /^[A-Za-z]/) {
               print OUTFILE ("$array[7] \n");
            }
         }
      }
      close(OUTFILE);
      `sort -u $out_functions > $out_file`;
      `$rm_cmd -rf $out_functions mon.out`;
   } else {
      print `$csh_cmd "run_gprof $local_xtop $trail_name ../mon.total"`;
   }
}

sub reset_envs {

  
   foreach $to_set_env ( keys %clean_setenv_cmds ) {
      if (defined $clean_setenv_cmds{$to_set_env}) {
         $ENV{$to_set_env} = $clean_setenv_cmds{$to_set_env};
         print("Cleanup: setenv $to_set_env $clean_setenv_cmds{$to_set_env}\n");
      } else {
         delete ($ENV{$to_set_env});
         print("Cleanup: unsetenv $to_set_env\n");
      }
   }

   if ($directives{alt_c5_converter}) {
      &restore_alt_c5_converter_env;
   }
   if ($directives{mech_test}) {
      delete $ENV{PTC_D_LICENSE_FILE} if (! -e $ENV{PTC_D_LICENSE_FILE});
      delete $ENV{LM_LICENSE_FILE};
      $trail_path = $pro_trail_path;
      $obj_path = $pro_obj_path;
   }
   if ($directives{run_with_license} || $directives{plpf_test}) {
      delete $ENV{PRO_LICENSE_RES} if (not defined $ENV{PIM_INSTALLED_VERSION}) ;
      delete $ENV{LM_LICENSE_FILE};
      delete $ENV{PTC_D_LICENSE_FILE} if (! -e $ENV{PTC_D_LICENSE_FILE});
   }

   if ($directives{run_with_license}) {
      delete $ENV{PROE_FEATURE_NAME};
      delete $ENV{CREOPMA_FEATURE_NAME};
      delete $ENV{CREODMA_FEATURE_NAME};
      delete $ENV{CREOSIM_FEATURE_NAME};
      delete $ENV{CREOLAY_FEATURE_NAME};
      delete $ENV{CREOSHELL_FEATURE_NAME};
   }
   
   if (defined $ENV{$l2r_feature_name_var}) {
     undef $ENV{$l2r_feature_name_var};  
   }

   if ($directives{weblink_test}) {
      delete ($ENV{"R_WEBLINK"});
      $netscape_exec = "";
   }
   $ENV{PRO_JUNIOR_ACTIVE}="false" if ($directives{jr_test});

   if ($directives{local_home_test}) {
      $ENV{HOME}=$save_home;
      $home=$save_home;
   }

   if ($directives{review_test} || $directives{viewonly}) {
      $ENV{R_RUNMODE}=$tmp_runmode;
   }

   if ($directives{rembatch_test}) {
      if (exists $ENV{TMPDIR}) {
         $old_tmpdir=$TMPDIR;
         $ENV{TMPDIR} = "$cur_dir/scratch_tmp";
      }
      else {
         $old_tmpdir=0;
         $ENV{"TMPDIR"} = "$cur_dir/scratch_tmp";
      }
      if ( $OS_TYPE eq "NT") {
         $ENV{TEMP} = "$cur_dir/scratch_tmp";
         $ENV{TEMP} =~ s/\//\\/g;
         $ENV{TMP} = "$cur_dir/scratch_tmp";
         $ENV{TMP} =~ s/\//\\/g;
      }
   }

   if ($directives{java_test} || $directives{otk_java_test}) {
      $ENV{CLASSPATH} = $CLASSPATH_JAVADEFAULT;
      if ($ENV{PRO_MACHINE_TYPE} ne "sgi_elf4" &&
           ( $java_version eq '1' || $java_version eq '2' || $java_version eq '3') ) {
         delete $ENV{PRO_JAVA_COMMAND} if (exists $ENV{PRO_JAVA_COMMAND});
      }
   }

}

sub create_new_file {
   my ($raw_trailname) = @_;

   `echo "junkfile" > $raw_trailname.new`;
   `mv -f protable_trl.txt.1 $raw_trailname.new` if (-e "protable_trl.txt.1");
   `mv -f proguide_trl.txt.1 $raw_trailname.new` if (-e "proguide_trl.txt.1");
   `mv -f proevconf_trl.txt.1 $raw_trailname.new` if (-e "proevconf_trl.txt.1");
   if ($directives{batch_trail_test}) {
      `cat trail.txt.* > $raw_trailname.new`;
   } else {
      `mv -f trail.txt.1 $raw_trailname.new` if (-e "trail.txt.1");
   }
   `mv -f fly_trl.txt.1 $raw_trailname.new` if (-e "fly_trl.txt.1");
   `mv -f profly_trl.txt.1 $raw_trailname.new` if (-e "profly_trl.txt.1");
   `mv -f db_client_trl.txt.1 $raw_trailname.new` if (-e "db_client_trl.txt.1");
   `mv -f dsq_trl.txt.1 $raw_trailname.new` if (-e "dsq_trl.txt.1");
   if ( -e "pwl_trl.htm.1") {
      `mv -f pwl_trl.htm.1 $raw_trailname.new`;
   }
   if ( -e "uwgm_client_trl.txt.1" ) {
      `mv -f uwgm_client_trl.txt.1 $raw_trailname.new`;
   }
   `mv -f guide_trl.txt.1 $raw_trailname.new` if ( -e "guide_trl.txt.1" );
}

sub check_dbgfile {
   my ($raw_trailname, $dbgfile_dirs) = @_;
   my (@array, $precompdir, $compdir, @file_list, @qcb_list, @dir_array);
   my $raw_trail_output_name="$raw_trailname$tk_flavor_name";
   

   return (0) if ($altlang ne "" && ! $directives{langtest} && ! $directives{japanese_test} && ! $directives{chinese_test} && ! $directives{korean_test});
   $skip_qcr = 1 if ($result eq "FAILURE");
   if ($result ne "FAILURE" || $memuse_error || $directives{qcr_script}) {
      print_fail("ERROR:  qcr file comparison has errors, saving files and forcing failure\n");
      if ($OS_TYPE eq "NT") {
         open(FILE_FP, ">>std.out");
      } else {
         open(FILE_FP, ">>$raw_trailname.msg");
      }
      print FILE_FP "ERROR:  qcr file comparison has errors, saving files and forcing failure\n";
      close(FILE_FP);
   }
   $result="FAILURE";
   $fail_no++;
   $qcr_fail = 1;
   @array = split(/\//,$trailfile);
   @array = reverse(@array);
   if ($directives{mech_test} || defined $ENV{R_NO_MSG_NEW}) {
      $result="FAILURE";
      $fail_no++;
      return(0);
   }
   if (defined $ENV{R_OLD_QCR_DIR} && $ENV{R_OLD_QCR_DIR} eq "true") {
      $raw_trail_output_name="$array[1]$tk_flavor_name";
      $precompdir="$rundir/$raw_trail_output_name";
   } else {
	  $precompdir="$rundir/$raw_trail_output_name";
   }
#   if ($directives{dlltest}) {
#      $precompdir="$rundir/${raw_trailname}_dll";
#   }
#   if ($directives{interface_retrieval}) {
#      $precompdir="$rundir/$raw_trailname";
#   }
   mkdir("$precompdir", 0777) if (! -d "$precompdir");
   if ($altlang eq "") {
      $compdir="$precompdir/usascii";
   } else {
      $compdir="$precompdir/$altlang";
   }
   print_fail("files are in $compdir\n");
   mkdir("$compdir", 0777) if (! -d "$compdir");
   opendir(TMPDIR, "$tmpdir");
   @file_list = readdir(TMPDIR);
   closedir(TMPDIR);
   @qcb_list = grep(/\.qcb\./, @file_list);
   foreach $f (@qcb_list) {
      `cp "$tmpdir/$f" "$compdir"`;
   }
   @dir_array = split(/ +/, $dbgfile_dirs);
   foreach $dir (@dir_array) {
      `cp $dir/dbgfile.dat "$compdir"`;
      open(FILE_FP, "$dir/dbgfile.dat");
      @array = <FILE_FP>;
      close(FILE_FP);
      @file_list = grep(/File_1:/, @array);
      chop(@file_list);
      chdir ("$dir");
	 my @notfoundqcrlist;
      foreach $f (@file_list) {
         @array=split(/[\t ]+/,$f);

        my @garray = <${array[2]}*>; #file glob case insensitivity
		my $systemqcr;
        foreach $systemqcr (@garray) {
		   `cp $systemqcr "$compdir"` ;
        }
         
		 if (! -e $array[2]) {
			   push(@notfoundqcrlist,$array[2]);
         }
         `cp $array[4] "$compdir"`;
      }
	  if (scalar(@notfoundqcrlist) > 0) {
	     open(fh_stdout, ">>std.out");
         print fh_stdout "MISSING_QCR_FILE_WARNING: Following qcr files mentioned in dbgfile.dat are not found. Please verify the trail file.\n";
		 print_fail("MISSING_QCR_FILE_WARNING:$raw_trailname: qcr files mentioned in dbgfile.dat are not found. Please check message file and verify the trail file.\n");
		 foreach my $qcr (@notfoundqcrlist) {
		    print fh_stdout "missing_qcr_file:$qcr\n";
		  }
		  close(fh_stdout);
	  }
      if (! defined $ENV{R_OLD_QCR_DIR} || $ENV{R_OLD_QCR_DIR} ne "true") {
         `$rm_cmd -f $dir/dbgfile.dat`;
      }
   }
   chdir_safe ("$tmpdir");
   $result="FAILURE";
   $fail_no++;
}

sub check_bitmap_file {
   my ($raw_trailname) = @_;
   my (@array, $precompdir, @file_list);
   my $image_diff;
   
   $result="FAILURE";
   $fail_no++;
   $qcr_fail = 1;
   @array = split(/\//,$trailfile);
   @array = reverse(@array);

   $precompdir="$rundir/$raw_trailname$tk_flavor_name";
 #  if ($directives{dlltest}) {
  #    $precompdir="$rundir/${raw_trailname}_dll";
  # }
   mkdir("$precompdir", 0777) if (! -d "$precompdir");
   `cp bitmap_fail.dat "$precompdir"`;
   `cp config.pro "$precompdir"` if (-e "config.pro");
   open(FILE_FP, "bitmap_fail.dat");
   @array = <FILE_FP>;
   close(FILE_FP);
   @file_list = grep(/File_1:/, @array);
   chop(@file_list);
   foreach $f (@file_list) {
      @array=split(/[\t ]+/,$f);
      `cp ${array[2]}* "$precompdir"`;
      `cp $array[4] "$precompdir"`;
      $image_diff=(split /\./,${array[4]})[0]."_diff.png";
	  `cp $image_diff "$precompdir"` if (-e $image_diff);
   }
   $fail_no++;
}

sub check_memsize {
    my $raw_trailname = $_[0];
    my $value = $_[1];
    my $threshold = $_[2];
    my ($memory_msg, $memsize, @array, $other, $devia);

    my $max = $value + ($value * $threshold) / 100;
    my $min = $value - ($value * $threshold) / 100;
    my $precompdir="$rundir/$raw_trailname$tk_flavor_name";

    if ($OS_TYPE eq "NT") {
       $memory_msg = `grep "Peak system size:" std.out`;
    } else {
       $memory_msg = `grep "Peak system size:" $raw_trailname.msg`;
    }
    chomp ($memory_msg);
    if ("$memory_msg" eq "") {
       print_succ("WARNING: can't get Peak system size for $raw_trailname\n");
       return;
    }
    @array = split(/Size:/, $memory_msg);
    ($memsize, $other) = split(/;/, $array[1]);
    if ($memsize > $max) {
       $memuse_error = 1;
       $result="FAILURE";
       mkdir("$precompdir", 0777) if (! -d "$precompdir");
       $devia = ($memsize - $value) * 100 / $value;
       open (MEMUSE, ">>$precompdir/memuse.dat");
       print MEMUSE "The memsize: $memsize is larger than baseline size: $value\n";
       print MEMUSE "(the threshold is $threshold %, current deviation is $devia %)\n\n";
       close (MEMUSE);
    }
    if ($memsize < $min) {
       $memuse_error = 1;
       $result="FAILURE";
       mkdir("$precompdir", 0777) if (! -d "$precompdir");
       $devia = ($value - $memsize) * 100 / $value;
       open (MEMUSE, ">>$precompdir/memuse.dat");
       print MEMUSE "The memsize: $memsize is less than baseline size: $value\n";
       print MEMUSE "(the threshold is $threshold %, current deviation is -$devia %)\n\n";
       close (MEMUSE);
    }
}

sub check_maxmemsize {
    my $raw_trailname = $_[0];
    my $value = $_[1];
    my $threshold = $_[2];
    my ($memory_msg, $memsize, @array, $other);

    my $max = $value + ($value * $threshold) / 100;
    my $min = $value - ($value * $threshold) / 100;
    my $precompdir="$rundir/$raw_trailname$tk_flavor_name";

    if ($OS_TYPE eq "NT") {
       $memory_msg = `grep "Peak system size:" std.out`;
    } else {
       $memory_msg = `grep "Peak system size:" $raw_trailname$tk_flavor_name.msg`;
    }
    chomp ($memory_msg);
    if ("$memory_msg" eq "") {
       print_succ("WARNING: can't get Peak system size for $raw_trailname\n");
       return;
    }
    @array = split(/Peak system size:/, $memory_msg);
    ($memsize, $other) = split(/\./, $array[1]);
    if ($memsize > $max) {
       $memuse_error = 1;
       $result="FAILURE";
       mkdir("$precompdir", 0777) if (! -d "$precompdir");
       open (MEMUSE, ">>$precompdir/memuse.dat");
       print MEMUSE "The maxmemsize: $memsize is larger than baseline size: $value\n";
       print MEMUSE "(the threshold is $threshold %)\n\n";
       close (MEMUSE);
    }
    if ($memsize < $min) {
       $memuse_error = 1;
       $result="FAILURE";
       mkdir("$precompdir", 0777) if (! -d "$precompdir");
       open (MEMUSE, ">>$precompdir/memuse.dat");
       print MEMUSE "The maxmemsize: $memsize is less than baseline size: $value\n";
       print MEMUSE "(the threshold is $threshold %)\n\n";
       close (MEMUSE);
    }
}

sub check_memuse {
    my ($raw_trailname) = @_;
    my ($value, $threshold);
    my ($test_name) = "${raw_trailname}.txt";
    my ($test_name_max) = "${test_name}_max";
    my $precompdir="$rundir/$raw_trailname$tk_flavor_name";

    `$rm_cmd -f "$precompdir/memuse.dat"` if (-e "$precompdir/memuse.dat");
    if (defined $memuse_db{$test_name}) {
       ($value, $threshold) = split(/ /, $memuse_db{$test_name});
       check_memsize ($raw_trailname, $value, $threshold);
    }
    if (defined $memuse_db{$test_name_max}) {
       ($value, $threshold) = split(/ /, $memuse_db{$test_name_max});
       check_maxmemsize ($raw_trailname, $value, $threshold);
    }
}

sub check_bitmaps {
   my ($raw_trailname) = @_;
   my ($bitmap_stat, @array);

   @array = split(/\//,$trailfile);
   @array = reverse(@array);
   $infile = $raw_trailname . ".new";
   open (IN,"<$infile");
   @Lines = <IN> ;
   chomp(@Lines);
   $status = 0;
   $total_images = 0;
   $fail_images = 0;
   %imghash = ();
   $ct = @Lines;
   close(IN);

    for($i=0;$i<$ct;$i++){
      chomp($Lines[$i]);
      $line = $Lines[$i];
	  if ($line =~ /^[^!#]*\.([iI][mM][gG]|[pP][nN][gG])$/) {
         $total_images++;
         $imghash{$line} = $total_images;
      }
   }

   my $btrailfile = $trailfile;
   $btrailfile =~ s/[\/]([^\/]+\.txt)$//;
   $btrailfile = "$btrailfile$tk_flavor_name/".$1;
   
   my ($is_img) = 0;
   for($i=0;$i<$ct;$i++) {
      chomp($Lines[$i]);
      $line = $Lines[$i];
      if ($line =~ /areas are different/ || $line =~ /Bitmaps are of unequal size/ || $line =~ /Bitmaps are not identical/ || ($line =~ /Trail file out of sequence/ && $is_img)){
         $k =$i+1;
         $prev = search_back($k);

         $btrailfile =~ s/(\.txt|\.bac)$/$tk_flavor_name.txt/ if ($directives{tk_flavor} && $btrailfile !~ /($tk_flavor_name\.txt)$/);
         if ($prev eq '' || $prev == '0' ) {
            #special case			 
            print_bitmap("BITMAP_FAIL ; TEST $btrailfile  ; check_${raw_trailname}_dot_new_file.png ; image 1/1 \n");
         } else {
           print_bitmap("BITMAP_FAIL ; TEST $btrailfile  ; $Lines[$prev] ; image $imghash{$Lines[$prev]}/$total_images \n");
         }
         
         $ct++;
         $status = 1;
      } else {
         if ($line =~ /\.(img|png)/) {
            $is_img = 1;
         } else {
            $is_img = 0;
         }
      }
   }
}

sub search_back {
   open (TIN,"<$infile");
   @Lin = <TIN>;
   close(TIN);
   $flg = 0;
   $found_line = $_[0];
   for($j=$_[0];$j>0;$j--) {
      if ($Lin[$j] =~ /.*\.([iI][mM][gG]|[pP][nN][gG])\b/ && ($Lin[$j] !~ /^[!~#]/) && $flg == 0) {
         return($j);
         $flg =1;
      }
   }
}

sub exclude_ext {
   my ($ext_name) = @_;

   return (1) if ($ext_name =~ /^asm$|^cdm$|^dgm$|^drm$|^lay$|^mfg$|^prt$|^rep$|^sec$|^vda$/);
   return (0);
}

sub gettraceback {
   my ($raw_trailname) = @_;
   my (@core_list, $coredir, $core_ndx);
   my $raw_trail_output_name="$raw_trailname$tk_flavor_name";

   $coredir="$rundir/${raw_trail_output_name}_savecore";

   @timeout_list=<timeout_traceback*.log*>;
   if ($#timeout_list >= 0) {
        mkdir("$coredir", 0777) if (! -d $coredir);
        foreach $timeout_tracefile (@timeout_list) {
            `mv -f $timeout_tracefile "$coredir"`;
            print_fail("traceback for timed-out process created,\n");
            print_fail("saving to $coredir/$timeout_tracefile\n");
        }
   }
   
   if ($OS_TYPE eq "NT") {
     if ($ENV{R_USE_CREO_PLUS} eq "true" && -d $ENV{PTC_LOG_DIR}) {
          $ctmpdir =  `cygpath -m $tmpdir`;
          chomp($ctmpdir);
        `$csh_cmd "cp -r $ENV{PTC_LOG_DIR}/* $ctmpdir/" `;
		`$csh_cmd "cp -r $ENV{PTC_LOG_DIR} $ctmpdir/" `;
     }
      @core_list=<traceback*.log*>;
      if ($core_list[0] ne "") {
          #copy first traceback as traceback.log
          mkdir("$coredir", 0777) if (! -d "$coredir");
          `cp $core_list[0] "$coredir/traceback.log"`; #copy with previous name for backward compatability
          print_fail("traceback for core file created,\n");
          print_fail("saving to $coredir/traceback.log\n");

		  #copy all traceback files, keeping their names
          if ($#core_list >= 0) {
              foreach $tracefile (@core_list) {
                  `mv -f $tracefile "$coredir"`; #keep original name for extra info
                  print_fail("traceback for core file created,\n");
                  print_fail("saving to $coredir/$tracefile\n");
              }
          }
      }
      if ( -e "$coredir" && exists $ENV{R_ENABLE_PROCESS_DUMPS} ) {
         print `$csh_cmd \"tasklist /M ucore68.dll >>  $coredir/tasklist_using_ucore68.log \"`;
         print `$csh_cmd \"tasklist /v >>  $coredir/tasklist_verbose.log \"`;
         if ( -e "${PTC_TOOLS}/apps/SysInternals/pslist.exe" ) {
            print `$csh_cmd \"${PTC_TOOLS}/apps/SysInternals/pslist.exe -accepteula >>  $coredir/pslist_w_elapsedtime.log \"`;
         }
         if ( -e "${PTC_TOOLS}/apps/SysInternals/Listdlls.exe" ) {
            print `$csh_cmd \"${PTC_TOOLS}/apps/SysInternals/Listdlls.exe -accepteula genlwsc.exe >>  $coredir/genlwsc_dlls.log \"`;
            print `$csh_cmd \"${PTC_TOOLS}/apps/SysInternals/Listdlls.exe -accepteula zbcefr.exe >>  $coredir/zbcefr_dlls.log \"`;
            print `$csh_cmd \"${PTC_TOOLS}/apps/SysInternals/Listdlls.exe -accepteula creoagent.exe >>  $coredir/creoagent_dlls.log \"`;
         }
     }
   } else {
      $core_ndx = 0;
	  
	  #first copy all existing traceback files
	  @core_list=<traceback*.log*>;
	  chomp(@core_list);
      if ($core_list[0] ne "") {
          mkdir("$coredir", 0777) if (! -d "$coredir");
          foreach $tracefile (@core_list) {
             `cp $tracefile "$coredir"`; #copy with original name for extra info
             `mv -f $tracefile "$coredir/traceback.log.$core_ndx"`; #keep previous name for backward compatability
              print_fail("traceback for core file created,\n");
              print_fail("saving to $coredir/$tracefile\n");
			  $core_ndx++;
          }
      }
	  
      @core_list=`find "$tmpdir" -name "core*" -print`;
      chop(@core_list);
      
      if ($is_otheruser_xtop_only_fail) {
         @core_list=`find "$cur_dir/${collab_other_pid}_otheruser" -name "core*" -print`;
         chop(@core_list);
      }
      
      foreach $corefile (@core_list) {
		 my $curr_exe_name = "core";
         my (@core_names) = split(/\./, $corefile);
     @core_names = reverse(@core_names);
     next if ($core_names[0] =~ /^asm|^prt|^mfg/);
         next if ("$core_names[0]" !~ /core$/ && "$core_names[1]" !~ /core$/);
         if (! -z $corefile) {
            mkdir("$coredir", 0777) if (! -d $coredir);
		if ("$core_names[1]" =~ /core$/) { #form is core.exe_name
			$curr_exe_name = "$core_names[0]";
		}
        if ($PRO_MACHINE_TYPE =~ /^sun/
                && length($local_xtop) < 70) {
           `${TOOLDIR}gettraceback - $corefile`;
        } elsif ($PRO_MACHINE_TYPE =~ /^sun/
                && length($local_xtop) >= 70) {
           my $this_exe = `pmap $corefile | awk 'NR==3 { print $4; }'`;
           `${TOOLDIR}gettraceback $this_exe $corefile`;
            } elsif ($directives{pt_async_test}) {
               $curr_exe_name = "pt_async_test";
               if ( exists $ENV{R_PDEV_REGRES_BIN} ) {
                  $pt_async_exe = get_pdev_exe ("pt_async");
                  `${TOOLDIR}gettraceback $pt_async_exe $corefile`;
               } else {
                  `${TOOLDIR}gettraceback $PTCSYS/obj/pt_async $corefile`;
               }
            } elsif ($directives{pd_async_test}) {
               $curr_exe_name = "pd_async";
               if ( exists $ENV{R_PDEV_REGRES_BIN} ) {
                  $pd_async_exe = get_pdev_exe ("pd_async");
                 `${TOOLDIR}gettraceback $pd_async_exe $corefile`;
               } else {
                 `${TOOLDIR}gettraceback $PTCSYS/obj/pd_async $corefile`;
               }
            } elsif ($directives{fly_test}) {
               $curr_exe_name = "profly";
               `${TOOLDIR}gettraceback $profly_exec $corefile`;
            } elsif ($directives{pt_async_pic_test}) {
               $curr_exe_name = "pt_async_pic";
               if ( exists $ENV{R_PDEV_REGRES_BIN} ) {
                  $pt_async_pic_exe = get_pdev_exe ("pt_async_pic");
                  `${TOOLDIR}gettraceback $pt_async_pic_exe $corefile`;
               } else {
                  `${TOOLDIR}gettraceback $PTCSYS/obj/pt_async_pic $corefile`;
               }
            } elsif ($directives{pt_simple_async_test}) {
               $curr_exe_name = "pt_simple_async";
               if ( exists $ENV{R_PDEV_REGRES_BIN} ) {
                  $pt_simple_async_exe = get_pdev_exe ("pt_simple_async");
                  `${TOOLDIR}gettraceback $pt_simple_async_exe $corefile`;
               } else {
                  `${TOOLDIR}gettraceback $PTCSYS/obj/pt_simple_async $corefile`;
               }
            } else {
                  $curr_exe_name = "xtop";
                  `${TOOLDIR}gettraceback $local_xtop $corefile`;
            }
            `rm_bad_traceback traceback.log`;
            if (-e "traceback.log") {
               `cp traceback.log $coredir/traceback.log.$curr_exe_name`; #keep name from which traceback was created
               `mv traceback.log $coredir/traceback.log.$core_ndx`; #keep original name for compatability
               print_fail("traceback for core file created,\n");
               print_fail("saving to $coredir/traceback.log.$core_ndx\n");
               $core_ndx++;
            }
         }
      }
   }
}

sub save_all_core {
   my ($raw_trailname) = @_;
   my (@core_list, $coredir, $core_ndx);
   my $raw_trail_output_name="$raw_trailname$tk_flavor_name";

   $core_ndx=0;
   @core_list=`find "$tmpdir" -name "core*" -print`;
   chop(@core_list);
   $coredir="$rundir/${raw_trail_output_name}_savecore";
   foreach $corefile (@core_list) {
      if (! -z $corefile) {
         mkdir("$coredir", 0777) if (! -d $coredir);
         if (! -e "$coredir/$corefile") {
            `mv -f $corefile $coredir`;
            print_fail("saving $corefile to $coredir\n");
         } else {
            `mv -f $corefile $coredir/core.$core_ndx`;
            print_fail("saving $corefile to $coredir/core.$core_ndx\n");
            $core_ndx++;
         }
      }
   }
}

sub exit_on_core {
   my (@core_list);

   @core_list=`find "$tmpdir" -name core -print`;
   foreach $corefile (@core_list) {
      if (! -z $corefile) {
         print_fail("CORE dumped, exiting.\n");
         print_fail("core_list:\n");
         foreach $ccccc ($core_list) {
            `ls -l $ccccc |& tee -a \"$fail\"`
         }
         exit(0);
      }
   }
}

sub get_perf_results {
   my ($raw_trailname) = @_;
   my ($perflog) = "$rundir/$raw_trailname.perf";

   if (! -e $perflog) {
      my ($trail_vers, $proe_vers);
      if (open INTRL, "$raw_trailname.txt") {
        my $line = <INTRL>;
        if ($line =~ /!trail file version No. (\d+)/) {
          $trail_vers = $1;
        }
        $line = <INTRL>;
        if ($line =~ /Version (\S+)/) {
          $proe_vers = $1;
        }
        close(INTRL);
      }
      open(PERFLOG, ">$perflog");
      print PERFLOG "\n\nPERFORMANCE TESTING\n";
      print PERFLOG "Date:         $date\n";
      print PERFLOG "Host:         $mach_name\n";
      print PERFLOG "Machtype:     $PRO_MACHINE_TYPE\n";
      print PERFLOG "Graphics:     $ENV{R_GRAPHICS}\n";
      print PERFLOG "Trail Ver:    $trail_vers\n";
      print PERFLOG "Trail Build:  $proe_vers\n\n";
      close(PERFLOG);
   }
   if ($raw_trailname eq "startup_perf") {
      if (defined $ENV{PIM_INSTALLED_VERSION}) {
         $version = $ENV{PIM_INSTALLED_VERSION};
      }

      open(PERFLOG, ">>$perflog");
      print PERFLOG "-------------------------------------------------------------------\n";
      print PERFLOG "STARTUP_PERFVersion $version\n";
      print PERFLOG "-------------------------------------------------------------------\n";
      print PERFLOG "STARTUP          $perf_runtime\n";
      print PERFLOG "-------------------------------------------------------------------\n";
      print PERFLOG "TOTAL            $perf_runtime\n";
      close(PERFLOG);
   } elsif ($directives{mech_test_long} eq 0) {
      if ($directives{shared_workspace}) {
	     `csh -fc "egrep -v '^\\!Creo  TM' \"$rundir/${collab_other_pid}_otheruser/trail.txt.1\"  >> $raw_trailname.new "`;
      }
      
      # Simulate engine tests do not run xtop, statistics are extracted from logs by diff_mech.pl.
      `$csh_cmd "${TOOLDIR}$PRO_MACHINE_TYPE/perf_results $raw_trailname.new $perflog"`;
   }
   open(PERFLOG, ">>$perflog");
   if ($result eq "SUCCESS") {
      print PERFLOG "RUN_TIME           $perf_runtime\n";
   } elsif ($qcr_fail) {
      print PERFLOG "RUN_TIME_QCR_FAIL           $perf_runtime\n";
   } else {
      print PERFLOG "RUN_TIME_FAIL      $perf_runtime\n";
   }
   print PERFLOG "****************************************************\n";
   print PERFLOG "****************************************************\n";
   close(PERFLOG);
   
   perf_check_for_iteration($perflog) if ($ENV{R_PERF_OPTIMIZE_ITERATIONS} eq 'true' && ($num_perf_test != 0 && ($num_perf_test != ($num_perf_test_count-1)) ) );
      
   if (exists $ENV{R_PERF_RESULT_COPIER}) {
     `$csh_cmd "$ENV{R_PERF_RESULT_COPIER} $perflog"`;
   }

}

sub perf_check_for_iteration {
    my ($perflog) = $_[0];
    my $perf_check_cmd = "$ENV{PTC_APPS}/python311/$PRO_MACHINE_TYPE/bin/python -u $ENV{PTC_TOOLS}/bin/check_for_iteration.py -p $perflog";
    print "Running  $perf_check_cmd\n"; 
    system("csh -fc \" $perf_check_cmd \" ");
    my $do_run_next_iteration = $?;
    
    if (! $do_run_next_iteration) {
       my $perf_skip_msg = "\n\n\ncheck_for_iteration:$do_run_next_iteration:SKIPPED_ITERATION\n\n\n";
       print "$perf_skip_msg";
	   open(PERFLOG, ">>$perflog");
	   print PERFLOG "$perf_skip_msg";
	   close(PERFLOG);
       $num_perf_test = 0;
    } else {
       my $perf_skip_msg = "\n\n\ncheck_for_iteration:$do_run_next_iteration:NOT_SKIPING_ITERATION\n\n\n";
       print "$perf_skip_msg";
    }
}

sub get_runtime {
   my ($start, $stop) = @_;
   my ($startsec, $stopsec, $runsec, $runtime);

   $startsec = &cnv_hms_sec($start);
   $stopsec = &cnv_hms_sec($stop);
   $runsec = $stopsec - $startsec;
   $runsec += 86400 if ($runsec < 0);
   $runtime=&cnv_sec_hms($runsec);
   return ($runtime);
}

sub mv_msg_files {
   my ($raw_trailname, $relDir) = @_;
   my $raw_trail_output_name = "$raw_trailname$tk_flavor_name";
   my $targetDir = "$rundir";
   if ($relDir) {
      $targetDir = "$rundir/$relDir";
   }
   
   if (! defined $ENV{R_NO_MSG_NEW}) {
      if ($OS_TYPE eq "NT") {
         `cp "$tmpdir"/std.out "$targetDir"/$raw_trail_output_name.msg`;
         `cat "$tmpdir"/$raw_trailname.msg >> "$targetDir"/$raw_trail_output_name.msg`;
         if ( -e "$tmpdir/std.err" && ! ($directives{retr_test} || $directives{gcri_retr_test})) {
            `cat "$tmpdir"/std.err >> "$targetDir"/$raw_trail_output_name.msg`;
         }
      } else {
         `mv -f $tmpdir/$raw_trailname.msg "$targetDir"/$raw_trail_output_name.new`;
         if (-e "$tmpdir/_rld_args.log") {
            `echo "" >> $targetDir/$raw_trail_output_name.msg`;
            `cat $tmpdir/_rld_args.log >> $targetDir/$raw_trail_output_name.msg`;
         }
      }

      `mv -f "$tmpdir"/$raw_trailname.new "$targetDir"/$raw_trail_output_name.new`;
      if (-e "$tmpdir/ps_trl.txt.1") {
         `mv -f "$tmpdir"/ps_trl.txt.1 "$targetDir"/$raw_trail_output_name.new`;
         `mv -f "$tmpdir"/ptcsetup.log "$targetDir"/$raw_trail_output_name.msg`;
      }
   } elsif ($OS_TYPE eq "NT") {
      `cat "$tmpdir"/std.out >> "$tmpdir"/$raw_trailname.msg`;
       if ( -e "$tmpdir/std.err") {
          `cat "$tmpdir"/std.err >> "$tmpdir"/$raw_trailname.msg`;
       }
   }
}

sub write_mtracer_data {
   my ($raw_trailname) = @_;
   my $raw_trail_output_name="$raw_trailname$tk_flavor_name";
   if ($R_UPD_TRAIL_DIR && defined $ENV{MTRACER_TEST_MODE}) {
	    my $reg_dir = "$R_UPD_TRAIL_DIR/$raw_trail_output_name";
      mkdir("$reg_dir", 0777) if (! -d "$reg_dir");

      if ($ENV{MTRACER_TEST_MODE} eq "REG_TEST") {
       my $trunc_raw_trailname=substr("$raw_trailname", 0, 31);
      `cp $tmpdir/$raw_trailname.tmz.1 $reg_dir`;
      `cp $tmpdir/$trunc_raw_trailname.tmz.1 $reg_dir`;
      `cp $tmpdir/$raw_trailname.mtd.1 $reg_dir`;
      `cp $tmpdir/$raw_trailname.new $reg_dir/$raw_trailname.new.1`;
      }
      else {
       if ($ENV{MTRACER_TEST_MODE} eq "UPD_TEST") {
      `cp $tmpdir/$raw_trailname.tmz.1 $reg_dir/$raw_trailname.tmz.2`;
      `cp $tmpdir/$trunc_raw_trailname.tmz.1 $reg_dir/$trunc_raw_trailname.tmz.2`;
      `cp $tmpdir/$raw_trailname.mtd.1 $reg_dir/$raw_trailname.mtd.2`;
      `cp $tmpdir/$raw_trailname.new $reg_dir/$raw_trailname.new.2`;
      `cp $tmpdir/$raw_trailname.hst.1 $reg_dir`;
      `cp $tmpdir/$raw_trailname.map.1 $reg_dir`;
      }
     }
   }
}

sub write_succ_result {
   my ($raw_trailname,$start,$stop,$runtime,$run_str) = @_;
   my ($memory_msg, $outline_msg, @array);
   my $raw_trail_output_name = "$raw_trailname$tk_flavor_name";

   if ($R_SUCC_TRAIL_DIR) {
      if ($OS_TYPE eq "NT") {
         `cp "$tmpdir"/std.out "$R_SUCC_TRAIL_DIR"/$raw_trail_output_name.msg`;
         `cat "$tmpdir"/$raw_trailname.msg >> "$R_SUCC_TRAIL_DIR"/$raw_trail_output_name.msg`;
         if ( -e "$tmpdir/std.err" && ! ($directives{retr_test} || $directives{gcri_retr_test})) {
         `cat "$tmpdir"/std.err >> "$R_SUCC_TRAIL_DIR"/$raw_trail_output_name.msg`;
         }
      } else {
         `cp $tmpdir/$raw_trailname.msg $R_SUCC_TRAIL_DIR`;
      }

      `cp $tmpdir/$raw_trailname.new $R_SUCC_TRAIL_DIR`;
      `cp $tmpdir/pd_develop.log $R_SUCC_TRAIL_DIR/$raw_trail_output_name.tklog` if (-e "$tmpdir/pd_develop.log");
      `cp $tmpdir/pt_toolkit.log $R_SUCC_TRAIL_DIR/$raw_trail_output_name.tklog` if (-e "$tmpdir/pt_toolkit.log");
      `cp $tmpdir/pt_test_initialize.log $R_SUCC_TRAIL_DIR/$raw_trail_output_name.tklog` if (-e "$tmpdir/pt_test_initialize.log");
      my (@file_list) = `ls`;
      chop(@file_list);
      foreach $file (@file_list) {
         if ($file =~ /^PT[0-9a-zA-Z]*\.log$/) {
            `cat $file >> $R_SUCC_TRAIL_DIR/$raw_trail_output_name.tklog`;
         }
      }
      if (defined $ENV{R_SUCC_SAVE_ALL}) {
         mkdir("$R_SUCC_TRAIL_DIR/$raw_trail_output_name", 0777) if (! -d "$R_SUCC_TRAIL_DIR/$raw_trail_output_name");
         `$cp_cmd $tmpdir/* $R_SUCC_TRAIL_DIR/$raw_trail_output_name`;
      }
   }
   &write_mtracer_data($raw_trailname);
   @run_str_values = split(' ',$run_str);
   open(SUCC_LOG,">>:raw","$succ");
   if ($run_str_values[0] =~ m/xtop/)
   {
      print SUCC_LOG "\nRUN INFO:  MACH=$mach_name $version EXE=$run_str_values[0]\n";
      print SUCC_LOG "RUN INFO:  UID=$spgid RUNDIR=$rundir\n";   
   }
   
   my $tmp_trailfile = $trailfile;   
   $trailfile =~ s/(\.txt)$/$tk_flavor_name.txt/ if ($directives{tk_flavor});
   $trailfile =~ s/(\.bac)$/$tk_flavor_name.bac/ if ($directives{tk_flavor});
   print SUCC_LOG "\n$trailfile\n";
   $trailfile = $tmp_trailfile;
   print SUCC_LOG "$result Start:  $start  Stop:  $stop  Run:  $runtime\n";
   if ($OS_TYPE eq "NT") {
      print SUCC_LOG `grep "Peak system size:" std.out` if (-e "std.out");
      print SUCC_LOG `grep "STRICT_PLAYBACK:" std.out` if (-e "std.out");
   } else {
      print SUCC_LOG `grep "Peak system size:" $raw_trailname.msg`;
      print SUCC_LOG `grep "STRICT_PLAYBACK:" $raw_trailname.msg`;
   }

   if ($report_memory eq "true" ) {
      open(NEWFILE, "$tmpdir/$raw_trailname.new");
      @array = <NEWFILE>;
      chop(@array);
      @array = reverse(@array);
      $memory_msg = $array[1];
      $memory_msg = $array[2] if ("$memory_msg" !~ /Peak system size/);
      close(NEWFILE);
      print SUCC_LOG "$memory_msg\n";
   }
   
   if (defined $ENV{CREO_MEM_USAGE_STATS} and lc($ENV{CREO_MEM_USAGE_STATS}) eq "true") {
        if ($OS_TYPE eq "NT") {
            print SUCC_LOG `grep "Peak Virtual Memory" std.out | tail -1` if (-e "std.out");
            print SUCC_LOG `grep "CPU Time" std.out | tail -1` if (-e "std.out");
            print SUCC_LOG `grep "Clock Time" std.out | tail -1` if (-e "std.out");
            print SUCC_LOG `grep -A1 "dumpGPUInfoAndUsage:" std.out` if (-e "std.out");
        } 
        else {
            print SUCC_LOG `grep "Peak Virtual Memory" $raw_trailname.msg | tail -1`;
            print SUCC_LOG `grep "CPU Time" $raw_trailname.msg | tail -1`;
            print SUCC_LOG `grep "Clock Time" $raw_trailname.msg | tail -1`;
            print SUCC_LOG `grep -A1 "dumpGPUInfoAndUsage:" $raw_trailname.msg`;
        }
   }
   
   if (defined $ENV{R_ADD_TIMER} and $ENV{R_ADD_TIMER} eq "true") {
	  $timer_msg = "";
	  open(NEWFILE, "$tmpdir/$raw_trailname.new");
      @array = <NEWFILE>;
      chomp(@array);
      @array = reverse(@array);
	  foreach $new_line (@array) {
		if ("$new_line" =~ /Total elapsed time:/) {
			$timer_msg = $new_line;
			last;
		}
	  }
	  close(NEWFILE);
	  print SUCC_LOG "$timer_msg\n\n" if ($timer_msg ne "");
   }

   if (!$directives{perf_test} && $ENV{R_KEEP_FAILURE_RESULT} ne "true") {
      `$rm_cmd -f "$rundir/$raw_trail_output_name.msg"` if (-e "$rundir/$raw_trail_output_name.msg");
      `$rm_cmd -f "$rundir/$raw_trail_output_name.new"` if (-e "$rundir/$raw_trail_output_name.new");
      `$rm_cmd -f "$rundir/$raw_trail_output_name.tklog"` if (-e "$rundir/$raw_trail_output_name.tklog");
      `$rm_cmd -rf "$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name"` if ( -d "$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name");
   }

   if ($spgid eq "spg" && $directives{logtesttime}) {
      $outline_msg="$version $mach_type $mach_name $date $raw_trail_output_name.txt $runtime";
      `echo $outline_msg >> $timefile`;
   }
   close(SUCC_LOG);
   
   if (exists $ENV{R_KEEP_SUCCESS_DATA}) {
      `$rm_cmd -rf "$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name"` if (-e "$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name");
      `$rm_cmd -rf "$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name"` if (-e "$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name");
      
      $ctmpdir =  `cygpath -m $tmpdir`;
      chomp($ctmpdir);
      mkpath ("$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name", 0777);
      `$cp_cmd $ctmpdir/* $rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name`;
      if ($directives{wildfire_test}) {
         `$cp_cmd $rundir/WF_ROOT_DIR $rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}/WF_ROOT_DIR`;
         chmod(0777, "$rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}/WF_ROOT_DIR");
         `$rm_cmd -f $rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}/WF_ROOT_DIR/.cache/0-IMMITATION/*/*/*/*.UGC`;
         `$rm_cmd -rf $rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}/WF_ROOT_DIR/.cache/0-IMMITATION/*/DB`;
         if (defined $windchill_url) {
            push @dirsToCopyServerLogs, "$rundir/KEEP_SUCCESS_DATA/${raw_trail_output_name}";
         }

        if (defined $ENV{R_FIND_WNC_BUILD}) {
         print_succ("PTWT_FASTREG_URL:$ENV{PTWT_FASTREG_URL}\n");
         print_succ("windchill_url:$windchill_url\n");
         print_succ("WNC_POOL_NAME:$ENV{WNC_POOL_NAME}\n");
         print_succ("WNC_BUILD_STREAM:$ENV{WNC_BUILD_STREAM}\n");
         print_succ("WNC_BUILD:$ENV{WNC_BUILD}\n");
         print_succ("JAVA_HOME:$ENV{JAVA_HOME}\n");
         print_succ("WNC_PRESERVE_LOG_BASEPORT:$ENV{'WNC_PRESERVE_LOG_BASEPORT'}\n");
         print_succ("WNC_CURRENT_GIT_BRANCH:$ENV{'WNC_CURRENT_GIT_BRANCH'}\n");

          mkpath ("$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name/installstartuplogs", 0777); 
          open(FH,">$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name/installstartuplogs/wcserverinfo.txt");
          print FH "trail_name:$raw_trail_output_name\n";
          print FH "WNC_POOL_NAME:$ENV{WNC_POOL_NAME}\n";
          print FH "WNC_BUILD_STREAM:$ENV{WNC_BUILD_STREAM}\n";
          print FH "WNC_BUILD:$ENV{WNC_BUILD}\n";
          print FH "JAVA_HOME:$ENV{JAVA_HOME}\n";
          print FH "INSTALL_DIR:$ENV{WNC_PRESERVE_LOG_BASEPORT}\n";
          print FH "windchill_url:$ENV{windchill_url}\n";
          print FH "PTWT_FASTREG_URL:$ENV{'PTWT_FASTREG_URL'}\n";
          print FH "WNC_CURRENT_GIT_BRANCH:$ENV{'WNC_CURRENT_GIT_BRANCH'}\n";
          close(FH);
                   
          `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}/Windchill/logs/*.log $rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name/installstartuplogs`;
          `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}/Windchill/wisp_status.properties $rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name/installstartuplogs`;
          `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}.logs/*.log $rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name/installstartuplogs`;
          `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}.logs/*.properties $rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name/installstartuplogs`; 
        }
      }
   }
   
   if (defined $ENV{R_KEEP_SUCC_MSGS}){
	   mkdir("$rundir/succ_msgs", 0777) if (! -e "$rundir/succ_msgs");
       mv_msg_files($raw_trailname, "succ_msgs");
   }
}

sub write_fail_result {
   my ($raw_trailname,$start,$stop,$runtime,$run_stat,$run_str) = @_;
   my ($last_line_number);
   my (@msg_file, @array, $i, $j, $n);
   my $raw_trail_output_name = "$raw_trailname$tk_flavor_name";

   if (! $ENV{R_EXIT_ON_CORE} && ! exists $ENV{R_SAVE_ALL_CORE}
        && ! $ENV{R_GETTB_CORE} ) {
      `$rm_cmd -f "$tmpdir"/core` if (-e "$tmpdir/core");
   }
   &write_mtracer_data($raw_trailname);
   
   if ($shared_workspace_trail ne '' && $is_otheruser_xtop_only_fail) {
      # `$cp_cmd $tmpdir/trail.txt.1 $tmpdir/trail.txt.1.secondxtop`;
       `$cp_cmd $tmpdir/std.out $tmpdir/std.out.secondxtop`;
       `$cp_cmd $tmpdir/std.err $tmpdir/std.err.secondxtop`;
       `$cp_cmd $tmpdir/$raw_trailname.new $tmpdir/$raw_trailname.new.secondxtop`;
       
       `$cp_cmd $cur_dir/${collab_other_pid}_otheruser/trail.txt.1 $tmpdir/`;
       `$cp_cmd $cur_dir/${collab_other_pid}_otheruser/trail.txt.1 $tmpdir/$raw_trailname.new`;
       
       my $smsg = "Note: This failure due to xtop launched using script collab_other while second xtop passed. \n Please check ${shared_workspace_trail}_otheruser folder for more information";
       open(NEW_FH,">>:raw","$tmpdir/$raw_trailname.new");
       print NEW_FH "\n";
       print NEW_FH $smsg;
       print NEW_FH "\n";
       close(NEW_FH);
       
       `$cp_cmd $cur_dir/${collab_other_pid}_otheruser/std.out $tmpdir/`;
       `$cp_cmd $cur_dir/${collab_other_pid}_otheruser/std.err $tmpdir/`;
   }
   
   mv_msg_files($raw_trailname);

   `mv -f "$tmpdir"/pd_develop.log "$rundir"/$raw_trailname.tklog` if (-e "$tmpdir/pd_develop.log");
   `mv -f "$tmpdir"/pt_toolkit.log "$rundir"/$raw_trailname.tklog` if (-e "$tmpdir/pt_toolkit.log");
   `mv -f "$tmpdir"/pt_test_initialize.log "$rundir"/$raw_trailname.tklog` if (-e "$tmpdir/pt_test_initialize.log");
   `mv -f $tmpdir/pt_feattree.log $rundir/$raw_trailname.tklog` if (-e "$tmpdir/pt_feattree.log");
   my (@file_list) = `ls`;
   chop(@file_list);
   foreach $file (@file_list) {
      if ($file =~ /^PT[0-9a-zA-Z]*\.log$/) {
         `cat $file >> "$rundir"/$raw_trailname.tklog`;
      }
   }
   if ($directives{distapps_dsapi}) {
      `cat "$tmpdir"/dsq.log > "$rundir"/$raw_trailname.dslog`;
      foreach $file (@file_list) {
     if ($file =~ /^DS[_0-9a-zA-Z]*\.log$/) {
        `cat $file >> "$rundir"/$raw_trailname.dslog`;
     }
     if ($file =~ /^ds[_0-9a-zA-Z]*\.log$/ && $file ne "dsq.log") {
        `cat $file >> "$rundir"/$raw_trailname.dslog`;
     }
      }
   }
   
   if ($directives{uwgm_test}) {
      my $precompdir="$rundir/$raw_trail_output_name";  
      foreach $file (@file_list) {
      if ($file =~ /\.xml$|\.log/) {
         mkdir("$precompdir", 0777) if (! -d "$precompdir");
         `cp $file "$precompdir"`;
      }
      }
   }   

   $last_line_number = get_fail_line_num("$rundir/$raw_trail_output_name.msg");
   @run_str_values = split(' ',$run_str);
   open(FAIL_LOG,">>:raw","$fail");
   if ($run_str_values[0] =~ m/xtop/)
   {
      print FAIL_LOG "\nRUN INFO:  MACH=$mach_name $version EXE=$run_str_values[0]\n";
      print FAIL_LOG "RUN INFO:  UID=$spgid RUNDIR=$rundir\n";
   }
   my $tmp_trailfile = $trailfile;
   $trailfile =~ s/(\.txt)$/$tk_flavor_name.txt/ if ($directives{tk_flavor});
   $trailfile =~ s/(\.bac)$/$tk_flavor_name.bac/ if ($directives{tk_flavor});
   print FAIL_LOG "\n$last_line_number#$trailfile\n";
   $trailfile = $tmp_trailfile;
   print FAIL_LOG "$result    Start:  $start Stop:  $stop  Run:  $runtime\n";
   print_fail("Return Status:  $run_stat\n");
   if (defined $ENV{R_ADD_TIMER} and $ENV{R_ADD_TIMER} eq "true") {
	  $timer_msg = "";
	  if (-e "$rundir/$raw_trail_output_name.new") {
		  open(NEW_FILE,"$rundir/$raw_trail_output_name.new");
		  @new_file = <NEW_FILE>;
		  close(NEW_FILE);
		  chomp(@new_file);
		  @new_file = reverse(@new_file);
		  foreach $new_line (@new_file) {
			if ("$new_line" =~ /Total elapsed time:/) {
				$timer_msg = $new_line;
				last;
			}
		 }
		  print FAIL_LOG "$timer_msg\n" if ($timer_msg ne "");
	  }
   }
   open(MSG_PT,"$rundir/$raw_trail_output_name.msg");
   @msg_file = <MSG_PT>;
   close(MSG_PT);
   chop(@msg_file);
   @msg_file = reverse(@msg_file);
   $n = @msg_file;
   $j = 0;
   for ($i=0; $i<3; $i++) {
       while ($msg_file[$j] !~ /\#/ || $msg_file[$j] !~ /::/) {
       last if ( $j >= $n);
       $j++;
       }
       last if ( $j >= $n);
       $array[$i] = $msg_file[$j];
       $j++;
   }
   print FAIL_LOG "\n";
   for ($i=0; $i<3; $i++) {
       if ($array[2-$i]) {
          print FAIL_LOG "$array[2-$i]\n";
       } else {
      print FAIL_LOG "\n";
       }
   }
   if (defined $ENV{PTC_D_LICENSE_FILE}) {
      print FAIL_LOG "PTC_D_LICENSE_FILE is set to $ENV{PTC_D_LICENSE_FILE}\n";
   }
   if (defined $ENV{LM_LICENSE_FILE}) {
      print FAIL_LOG "LM_LICENSE_FILE is set to $ENV{LM_LICENSE_FILE}\n";
   }

   close (FAIL_LOG);

   if ($directives{wildfire_test} && (${windchill_url} ne '' || $ENV{WNC_BUILD_STREAM} ne '') ) {
         print_fail("PTWT_FASTREG_URL:$ENV{PTWT_FASTREG_URL}\n");
         print_fail("windchill_url:$windchill_url\n");
         print_fail("WNC_POOL_NAME:$ENV{WNC_POOL_NAME}\n");
         print_fail("WNC_BUILD_STREAM:$ENV{WNC_BUILD_STREAM}\n");
         print_fail("WNC_BUILD:$ENV{WNC_BUILD}\n");
         print_fail("JAVA_HOME:$ENV{JAVA_HOME}\n");
         print_fail("WNC_PRESERVE_LOG_BASEPORT:$ENV{'WNC_PRESERVE_LOG_BASEPORT'}\n");
         print_fail("WNC_CURRENT_GIT_BRANCH:$ENV{'WNC_CURRENT_GIT_BRANCH'}\n");
            
         mkpath ("$rundir/$raw_trail_output_name/installstartuplogs", 0777);
         open(FH,">$rundir/$raw_trail_output_name/installstartuplogs/wcserverinfo.txt");
         print FH "trail_name:$raw_trail_output_name\n";
         print FH "WNC_POOL_NAME:$ENV{WNC_POOL_NAME}\n";
         print FH "WNC_BUILD_STREAM:$ENV{WNC_BUILD_STREAM}\n";
         print FH "WNC_BUILD:$ENV{WNC_BUILD}\n";
         print FH "JAVA_HOME:$ENV{JAVA_HOME}\n";
         print FH "INSTALL_DIR:$ENV{WNC_PRESERVE_LOG_BASEPORT}\n";
         print FH "windchill_url:$ENV{windchill_url}\n";
         print FH "PTWT_FASTREG_URL:$ENV{'PTWT_FASTREG_URL'}\n";
         print FH "WNC_CURRENT_GIT_BRANCH:$ENV{'WNC_CURRENT_GIT_BRANCH'}\n";
         close(FH);
         
         if ($ENV{WNC_R_ENABLE_WISP_MULTITHREAD} eq 'true' || defined $ENV{R_FIND_WNC_BUILD}) {      
         `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}/Windchill/logs/*.log $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}/Windchill/wisp_status.properties $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}.logs/*.log $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $ENV{'WNC_PRESERVE_LOG_BASEPORT'}.logs/*.properties $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $cur_dir/*.current $rundir/$raw_trail_output_name/installstartuplogs`;
         } else {       
         `$cp_cmd $ENV{'WNC_INSTALL_DIR'}/Windchill/logs/*.log $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $ENV{'WNC_INSTALL_DIR'}/Windchill/wisp_status.properties $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $ENV{'WNC_LOG_DIR'}/*.log $rundir/$raw_trail_output_name/installstartuplogs`;
         `$cp_cmd $ENV{'WNC_LOG_DIR'}/*.properties $rundir/$raw_trail_output_name/installstartuplogs`;
        `$cp_cmd $cur_dir/*.current $rundir/$raw_trail_output_name/installstartuplogs`;
         }
    }
        
   if (exists $ENV{R_KEEP_FAILURE_DATA} && $ENV{R_KEEP_FAILURE_DATA} eq 'true') {
      if ($dcad_server eq "") { # for non-dauto runs
         `$rm_cmd -rf "$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name"` if (-e "$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name");
         `$rm_cmd -rf "$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name"` if (-e "$rundir/KEEP_SUCCESS_DATA/$raw_trail_output_name");
      }
      $ctmpdir =  `cygpath -m $tmpdir`;
      chomp($ctmpdir);
      mkpath ("$rundir/KEEP_FAILURE_DATA/$raw_trail_output_name", 0777);
      `$cp_cmd $ctmpdir/* $rundir/KEEP_FAILURE_DATA/$raw_trail_output_name`;
      if ($directives{wildfire_test}) {
         `$cp_cmd $rundir/WF_ROOT_DIR $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR`;
         chmod(0777, "$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR");
         `$rm_cmd -f $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR/.cache/0-IMMITATION/*/*/*/*.UGC`;
         `$rm_cmd -rf $rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}/WF_ROOT_DIR/.cache/0-IMMITATION/*/DB`;
         if (defined $windchill_url) {
            push @dirsToCopyServerLogs, "$rundir/KEEP_FAILURE_DATA/${raw_trail_output_name}";
         }
      }
   }
   
   if ($directives{backward_retr} && $is_backward_retr) {
      `mv "$rundir"/$raw_trail_output_name.msg "$rundir"/BACKWARD_RETR_$raw_trail_output_name.msg`;
   }
   if ($directives{legacy_encoding_test}) {
      if ($num_legacy_test == 0) {
         open(MSG, ">>$rundir/$raw_trail_output_name.msg");
     print MSG "The test ran with R_PDEV_REGRES_LEGACY set to true\n";
         close (MSG);
      } else {
     $num_legacy_test = 0;
      }
   }
}

sub create_hector_file{
	if($ENV{'UWGM_HECTOR_RESULTS'} eq "true" || $ENV{'CREOQA_HECTOR_RESULTS'} eq "true") {
		my ($raw_trailname, $runtime, $run_stat) = @_;
	}
	
	if($ENV{'UWGMQA_HECTOR_RESULTS'} eq "true"){
		my ($raw_trailname, $runtime, $run_stat, $cadname) = @_;
	}
	
	my $myFile = getcwd;
	$myFile = substr($myFile, 0, index($myFile, "scratch"));
	$myFile =  $myFile."trail_data.tmp";
	 
	open(my $fh, '>>', $myFile);
	foreach my $row (@_) {
		print $fh $row.",";
	}
	print $fh "\n";
	close($fh);
}

sub get_fail_line_num {
   my ($file_name) = @_;
   my (@msg_file, @array,$last_line_number, $rest_line, $i, $n);

   open (FILE_PT, $file_name);
   @msg_file = <FILE_PT>;
   close(FILE_PT);
   chop(@msg_file);
   @msg_file = reverse(@msg_file);
   $i = 0;
   $n = @msg_file;
   while ("$msg_file[$i]" !~ /^\d+::/ && $i < $n) { $i++; }
   ($last_line_number, $rest_line) = split(/::/, $msg_file[$i]);
   @array = split(/ /, $last_line_number);
   $last_line_number = "fails" if ($array[1] ne "" || $last_line_number eq "");

   return ($last_line_number);
}

sub pre_run_weblink_test {
   my ($trail_name) = @_;
   my (@array);

   # Create a message file path and set this as an environment
   # variable so that Pro/weblink can retrieve the path and redirect
   # Pro/Engineer output to that location

   @array = split(/\./, $trail_name);
   $ENV{R_MSGFILE} = "$tmpdir/$array[0].msg";

   $ENV{R_WEBLINK} = "true";
   $ENV{R_WEBMODELER} = "true" if ($OS_TYPE eq "NT");
   if ( $R_NETSCAPE) {
      $netscape_exec="$R_NETSCAPE";
   } else {
      $netscape_exec="netscape";
   }
   print_succfail("Running weblink test by setting R_WEBLINK true\n");
   print "Creating $tmpdir/config.pwl for WebLink...\n";
   open(CONFIG, ">$tmpdir/config.pwl");
   print CONFIG "Pro/ENGINEER $local_xtop\n";
   print CONFIG "TrailRecord yes\n";
   close(CONFIG);
   print `cat $tmpdir/config.pwl`;
   `cp $tmpdir/config.pwl $HOME` if ($OS_TYPE eq "NT");
}

sub pre_run_wf_js_test_test {
   # starting with P20, CLASSPATH does not include jlink jars at the startup of auto
   if (defined $ENV{P_VERSION} && $ENV{P_VERSION} >= 310) {
       my $jar_name;
       # starting with P30 we use otk.jar everywhere
       if ($ENV{P_VERSION} >= 320) {
         $jar_name = "otk";
       } else {
         $jar_name = "pfc";
       }
       my $JOTKCLASSPATH = ""; 
       if( $OS_TYPE eq "UNIX" ) {
         if ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
           $PROJ_PATH = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/xplatform/jar/nodebug";
           if (-d $PROJ_PATH) {
             $JOTKCLASSPATH = ":.:$PROJ_PATH/${jar_name}.jar:$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PROJ_PATH/jlinktests.jar:$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PROJ_PATH/otkjavatests.jar:$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PROJ_PATH/otkjavaexamples.jar:$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           } else {
             $JOTKCLASSPATH = ":.:$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           }
         } else {
          $JOTKCLASSPATH = ":.:$PTCSRC/text/java/${jar_name}.jar";
          $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
          $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	  $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
	 }
       } elsif($OS_TYPE eq "NT") {
         if (defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
           $PROJ_PATH = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/xplatform/jar/nodebug";
           if (-d $PROJ_PATH) {
             $JOTKCLASSPATH = ";.;$PROJ_PATH/${jar_name}.jar;$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PROJ_PATH/jlinktests.jar;$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PROJ_PATH/otkjavatests.jar;$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH};$PROJ_PATH/otkjavaexamples.jar;$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           } else {
             $JOTKCLASSPATH = ";.;$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           }
         } else {
           $JOTKCLASSPATH = ";.;$PTCSRC/text/java/${jar_name}.jar";
           $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
           $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	   $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
         }
       }

       $ENV{CLASSPATH}=$CLASSPATH_JAVADEFAULT.$JOTKCLASSPATH;
   }

   warn "CLASSPATH: $ENV{CLASSPATH}\n";
   
   if ($ENV{R_DELAY_PRO_COMM_MSG_LAUNCH}) {
       $orig_R_DELAY_PRO_COMM_MSG_LAUNCH = $ENV{R_DELAY_PRO_COMM_MSG_LAUNCH};
       delete $ENV{R_DELAY_PRO_COMM_MSG_LAUNCH};
   }
}

sub pre_run_java_test {
   if (defined $ENV{P_VERSION} && $ENV{P_VERSION} >= 310) {
     my $jar_name;
     if ($directives{java_test} || $directives{otk_java_test}) {
       $ENV{JLINKCLASSPATH} = "";
         $jar_name = "pfc";
       if ($directives{otk_java_test}) {
         $jar_name = "otk";
       }
       # starting with P30 we use otk.jar everywhere
       if ($ENV{P_VERSION} >= 320) {
         $jar_name = "otk";
       }

       my $JOTKCLASSPATH = ""; 
       if( $OS_TYPE eq "UNIX" ) {
         if ( defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
           $PROJ_PATH = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/xplatform/jar/nodebug";
           if (-d $PROJ_PATH) {
             $JOTKCLASSPATH = ":.:$PROJ_PATH/${jar_name}.jar:$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PROJ_PATH/jlinktests.jar:$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PROJ_PATH/otkjavatests.jar:$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PROJ_PATH/otkjavaexamples.jar:$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           } else {
             $JOTKCLASSPATH = ":.:$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           }
         } else {
          $JOTKCLASSPATH = ":.:$PTCSRC/text/java/${jar_name}.jar";
          $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
          $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	  $JOTKCLASSPATH = "${JOTKCLASSPATH}:$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
	 }
       } elsif($OS_TYPE eq "NT") {
         if (defined $ENV{P_PROJECT_PATH} && defined $ENV{P_CURR_PROJ} ) {
           $PROJ_PATH = "$ENV{P_PROJECT_PATH}/$ENV{P_CURR_PROJ}/xplatform/jar/nodebug";
           if (-d $PROJ_PATH) {
             $JOTKCLASSPATH = ";.;$PROJ_PATH/${jar_name}.jar;$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PROJ_PATH/jlinktests.jar;$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PROJ_PATH/otkjavatests.jar;$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH};$PROJ_PATH/otkjavaexamples.jar;$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           } else {
             $JOTKCLASSPATH = ";.;$PTCSRC/text/java/${jar_name}.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
             $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	     $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
           }
         } else {
           $JOTKCLASSPATH = ";.;$PTCSRC/text/java/${jar_name}.jar";
           $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/jlinktests.jar";
           $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavatests.jar";
	   $JOTKCLASSPATH = "${JOTKCLASSPATH};$PTCSRC/xplatform/jar/nodebug/otkjavaexamples.jar";
         }
       }

       if ($java_version eq "1") {
          $ENV{"PRO_JAVA_COMMAND"}="$PATH_JAVA11/$JAVA11_COMMAND";
          $ENV{CLASSPATH}=$CLASSPATH_JAVA11.$JOTKCLASSPATH;
       } elsif ($java_version eq "2") {
          $ENV{"PRO_JAVA_COMMAND"}="$PATH_JAVA12/java";
          $ENV{CLASSPATH}=$CLASSPATH_JAVA12.$JOTKCLASSPATH;
       } elsif ($java_version eq "3") {
          $ENV{"PRO_JAVA_COMMAND"}="$PATH_JAVA13/java";
          $ENV{CLASSPATH}=$CLASSPATH_JAVA13.$JOTKCLASSPATH;
       } elsif ($java_version eq "D") {
          $ENV{CLASSPATH}=$CLASSPATH_JAVADEFAULT.$JOTKCLASSPATH;
       }
     }
   } else {
      if ($directives{java_test}) {
         if ($java_version eq "1") {
            $ENV{"PRO_JAVA_COMMAND"}="$PATH_JAVA11/$JAVA11_COMMAND";
            $ENV{CLASSPATH}=$CLASSPATH_JAVA11;
         } elsif ($java_version eq "2") {
            $ENV{"PRO_JAVA_COMMAND"}="$PATH_JAVA12/java";
            $ENV{CLASSPATH}=$CLASSPATH_JAVA12;
         } elsif ($java_version eq "3") {
            $ENV{"PRO_JAVA_COMMAND"}="$PATH_JAVA13/java";
            $ENV{CLASSPATH}=$CLASSPATH_JAVA13;
         } elsif ($java_version eq "D") {
            $ENV{CLASSPATH}=$CLASSPATH_JAVADEFAULT;
         }
      }
   }
   warn "CLASSPATH: $ENV{CLASSPATH}\n";
}


sub date_mdy {
  my ($cur_time, @array);

  $cur_time=localtime(time());
  @array=split(/ +/,$cur_time);
  return("$array[1]-$array[2]-$array[4]");
}

sub date_hms {
  my ($cur_time, @array);

  $cur_time=localtime(time());
  @array=split(/ +/,$cur_time);
  return($array[3]);
}

sub date_hmsmd {
  my ($cur_time, @array);

  $cur_time=localtime(time());
  @array=split(/ +/,$cur_time);
  $array[1] =~ tr/a-z/A-Z/;
  return("$array[3] $array[2]-$array[1]-$array[4]");
}

sub cnv_sec_hms {
   my ($secs) = @_;
   my ($h, $m, $s);
   use integer;

   $h = $secs / 3600;
   $secs = $secs - ($h * 3600);
   $m = $secs / 60;
   $secs = $secs - ($m * 60);
   $s = $secs;

   $h="0$h" if ($h < 10);
   $m="0$m" if ($m < 10);
   $s="0$s" if ($s < 10);

   no integer;
   return ("$h:$m:$s");
}

sub cnv_hms_sec {
   my ($inp_hms) = @_;
   my (@array, $time_sec);

   @array = split(/:/,$inp_hms);
   $time_sec = $array[0] * 3600 + $array[1] * 60 + $array[2];
   return ($time_sec);
}

sub get_unique_tmp_dir {
   my ($n) = 0;

   if (! -e $tmpdir) {
      mkdir ("$tmpdir", 0777);
   } else {
      $tmpdir = "$cur_dir/scratch";
      `$rm_cmd -rf "$tmpdir"`;
      if (! -e $tmpdir) {
     mkdir ("$tmpdir", 0777);
      } else {
         while (-e "$cur_dir/scratch$n") { 
        `$rm_cmd -rf "$cur_dir/scratch$n"`;
        last if (! -e "$cur_dir/scratch$n");
        $n++; 
     }
         $tmpdir = "$cur_dir/scratch$n";
         mkdir ("$tmpdir", 0777);
      }
   }
}

sub remove_crash_from_trail {
   my ($file_name) = @_;
   my (@filelist);

   open (TRAIL, $file_name);
   @filelist = grep(!/#CRASH/, <TRAIL>);
   close(TRAIL);
   open (TRAILNOCRASH, ">$file_name");
   print TRAILNOCRASH @filelist;
   close(TRAILNOCRASH);
}

sub create_retr_trail {
   my ($file_name, $retr_string) = @_;

   open (TRAIL, "$tmpdir/$file_name");
   my @filelist = <TRAIL>;


   close(TRAIL);
   foreach $f ( @filelist ) {
      $f =~ s/__fullname__/$retr_obj/g;
      $f =~ s/__trlnum__/1251/g;
   }
   open (TRAILRETR, ">$tmpdir/$retr_string");
   print TRAILRETR @filelist;
   close(TRAILRETR);
}

sub LoadDepIgnore {
    my ($ignorefile);
    @ignore_dependencies = ();
    @xtoplibs = ();

    ## For use with R_IF_EXIST_CHECK

    if (defined $ENV{R_IF_EXIST_CHECK}) {
      if ($ENV{PRO_MACHINE_TYPE} =~ /sun/) {
         #
         # Process xtop libraries into global array
         #
         my @t = `ldd $ENV{PTCSYS}/obj/xtop | grep spg/system_1`;
         foreach $tl (@t) {
              $tl =~ s/\s+//g;
              my ($lib,undef) = split(/=/, $tl);
              push @xtoplibs, $lib;
         }
         push @xtoplibs, 'xtop';
      } else {
         die "\nERROR: R_IF_EXIST_CHECK not supported on $ENV{PRO_MACHINE_TYPE} (LoadDepIgnore)\n\n";
      }

      if (defined $ENV{R_ALT_IGNORE_DEP_FILE}) {
        $ignorefile = "$ENV{R_ALT_IGNORE_DEP_FILE}";
      } else {
        $ignorefile = "$ENV{PTCSRC}/test/known_dependencies_to_ignore.txt";
      }
      if (-e "$ignorefile") {
        print "NOTE: R_IF_EXIST_CHECK is set, processing $ignorefile ..\n";
        open(IGNOREDEP, "$ignorefile") or die "ERROR: can't open $ignorefile (LoadDepIgnore), $!\n";
        while (<IGNOREDEP>) {
                chomp($_);
                push @ignore_dependencies, $_ if ($_ !~ /#/ && $_ !~ /^$/);
        }
        close(IGNOREDEP);
      }
    }
}

sub ProcessTruss {
   my $trailname = $_[0];
   my $trussfile = "${trailname}.truss";
   my $depfile = "${trailname}.depend";
   my $foundline = 0;                  ## Number of lines in .depend file
   my @keywordsfound = ();             ## Keywords needed for auto.txt entry
   my %keylist = ();                   ## autoexist.txt keywords already found
   my @trussfound = ();                ## truss targets already found
   my $dontexist = 0;                  ## Number of dependencies that are not in autoexist.txt
   my $mechfound = 0;                  ## Number of times mech targets are found
 
   if (-e "$tmpdir/$trussfile") {
     print "** Processing R_IF_EXIST_CHECK data for ${trailname} ..\n";
     open(TFILE, "$tmpdir/$trussfile") or "WARNING: can't open $tmpdir/${trussfile}, (ProcessTruss) $!\n";
     print "NOTE: $depfile already exists, appending ..\n" if (-e "$tmpdir/$depfile");
     open(DEPENDFILE, ">>$tmpdir/$depfile") or "WARNING: can't write $tmpdir/${depfile}, (ProcessTruss) $!\n";
     if (defined $ENV{R_ALT_AUTOEXIST}) {
        $existfile = $ENV{R_ALT_AUTOEXIST};
     } else {
        $existfile = "$ENV{PTCSRC}/test/autoexist.txt";
     }
     if (! -e "$existfile") {
        print "\nNOTE: $existfile DOES NOT EXIST. Can't compare dependencies with system.\n";
        print "      Recording ALL dependencies, if found, in $depfile\n";
     }

     ## Read each line of .truss file and use only lines that contain
     ## $PTCSYS/obj or $PTCSYS/lib in the string

     READTRUSS: while (<TFILE>) {
                 if ((/\/spg\/system_1\/$ENV{PRO_MACHINE_TYPE}/ or /\/spg\/system_1\/mech\//) and
                    (/open\(/ or /execve\(/ or /exec\(/)) {
                        my (undef,$depend) = split(/\"/, $_);
                        chomp($depend);
                        $depend =~ s/\/\//\//g; ## Remove double slashes
                        $depend =~ s/\\/\//g;   ## Convert backslash to forwardslash
                        if ($depend =~ /\/system_1\/mech\//) {
                            ## Found Mech target
                            if ($mechfound == 0) {
                                   ## Only enter this line in .depend once
                                   ## even if multiple mech dependency found
                                   print DEPENDFILE "#run_if_set MECH_HOME\n";
                                   $mechfound++;
                                   $foundline++;
                                   next READTRUSS;
                            }
                        } elsif ($depend =~ /\/lib\// or
                                 $depend =~ /\/obj\// or
                 $depend =~ /\/obj32\// or
                                 $depend =~ /JTOpenToolkit\//) {

                            foreach $lib (@xtoplibs) {
                                 ## Ignore xtop related libraries
                                 next READTRUSS if ($depend =~ /${lib}$/);
                            }
                            my (undef,$existpath) = split(/\/$ENV{PRO_MACHINE_TYPE}\//, $depend);

                            ## If dependency has already been checked, move on ..
                ## escape plus character in filename if found 
                my $existpatheval = $existpath;
                $existpatheval =~ s/\+/\\+/g;
                            my $tfound = grep /^${existpatheval}$/, @trussfound;
                            next READTRUSS if ($tfound != 0);
                            push @trussfound, $existpath;
                            ##
                            if (-f "$depend") {
                                  ##
                                  ## Compare .truss file target with autoexist.txt targets.
                                  ## If any targets don't exist in autoexist.txt,
                                  ## put in .depend file for Integration followup
                                  ## otherwise save the if_exist keyword to be entered later
                                  ## into .depend file
                                  ##
                                  if (-e "$existfile") {
                                     my $foundkeyword = 0;
                                     my $ignorenum = grep /^${existpatheval}$/, @ignore_dependencies;
                                     if ($ignorenum != 0) {
                                         ## Don't check this depend, ignore
                                         $foundkeyword = 1;
                                     } else {
                                       CHECKEXIST: foreach $existtarget (sort keys %autoexist_db) {
                                         my @dbtargets = ();
                                         foreach $count (keys %{$autoexist_db{$existtarget}}) {
                                            push @dbtargets, $autoexist_db{$existtarget}{$count}[0];
                                         }
                                         foreach $dt (@dbtargets) {
                                           if ($existpath eq $dt) {
                                              # print "\n   keyword found: $existtarget $existpath";
                                              unless($keylist{$existtarget}++) {
                                                push @keywordsfound, $existtarget;
                                              }
                                              $foundkeyword++;
                                              last CHECKEXIST;
                                           }
                                         }
                                       }
                                     }
                                     if ($foundkeyword == 0) {
                                        print "\n   WARNING: autoexist.txt keyword for $existpath is NOT defined.";
                                        print DEPENDFILE "$depend\n";
                                        $dontexist++;
                                        $foundline++;
                                     }
                                  } else {
                                     print DEPENDFILE "$depend\n";
                                  }
                            }
                        }
                   }
      } # end of READTRUSS
      close(TFILE);

      if ($dontexist != 0) {
        my $ex = 'y';
        $ex = 'ies' if ($dontexist > 1);
        my $nodepmsg = "\nWARNING: $dontexist dependenc$ex is NOT defined in $PTCSRC/test/autoexist.txt listed above.\n   Please file Integration helpdesk case to have a autoexist.txt keyword(s) created\n   Please file Integration helpdesk case to have a autoexist.txt keyword(s) created\n   for the trail dependenc$ex found.\n   Once the Integ helpdesk case is resolved,\n   please submit the new #if_exist directive keyword(s)\n   listed in the helpdesk case with the auto.txt entry for this test.\n";
        print "$nodepmsg";
        print DEPENDFILE "$nodepmsg";
      }

      ## Process all the defined keywords gathered
      ## and add them to .depend file

      my $foundkeynum = @keywordsfound;
      if ($foundkeynum != 0) {
        my $keywords;
        if ($foundkeynum == 1) {
                $keywords = $keywordsfound[0];
        } else {
                $keywords = join(' ', @keywordsfound);
        }
        print DEPENDFILE "#if_exist $keywords\n";
        $foundline++;
      }
      close(DEPENDFILE);

    }
    if ($foundline != 0) {
        print "\n   NOTE: trail dependencies were found. Located in ${trailname}.depend\n";
        return 1;
    } else {
        print "\n   No dependencies found for $trailname\n";
        return 0;
    }

}

sub checkSpace {
    my $path = shift;
	my $diskspace;
    if (! defined $ENV{PTC_CYGWIN} && ! defined $ENV{PTC_MKS}) {
	    chomp($diskspace = `$csh_cmd "${TOOLDIR}checkspace $path -f"`);
    } else {
	    #for cygwin, we avoid using csh script
	    open FILE, "${TOOLDIR}i486_nt/windiskspace.exe $path |";
	    chomp($diskspace = <FILE>); 
	    close(FILE);
    }
	return $diskspace;
}

# Following is activation of global mode performance tool:

sub perf_dir () {"PERF_TOOL_RESULTS"} # define

sub perf_tool_start {
    my $test_name = @_[0];
    $test_name = substr($test_name, 0, index($test_name, '.txt'));
    # Set Global Mode ON:
    $ENV{'PERF_TEST_MODE'} = 'GLOBAL';
    $ENV{'PERF_OUT_NAME'} = $test_name;
    $ENV{'PERF_OPERATION'} = $test_name;
    $ENV{'PERF_DEF_GROUP'} = 'auto';
    
    # Create results folder if it wasn't created already
    if (! -d '../'.perf_dir) {
		mkdir '../'.perf_dir;
		chdir '../'.perf_dir;
		`$csh_cmd $PTC_TOOLS/bin/perf_get_aux_html`;
		chdir '../scratch';
    }
}

sub perf_tool_stop {
    my $test_name = @_[0];
    $test_name = substr($test_name, 0, index($test_name, '.txt'));
    # Set Global Mode OFF:
    delete $ENV{'PERF_TEST_MODE'};
    delete $ENV{'PERF_OUT_NAME'};
    delete $ENV{'PERF_OPERATION'};
    delete $ENV{'PERF_DEF_GROUP'};
    
    # Copy generated xml to the results folder
    if (-e $test_name.'.xml') {
		copy ($test_name.'.xml' , '../'.perf_dir.'/'.$test_name.'.xml');
    } else {
		print_succfail("Failed to generate performance report for $test_name.");
    }
}

sub get_fail_info {
   my ($msg_file) = @_;
   my $fail_info = `$csh_cmd "$PTC_TOOLS/bin/get_failure_info $msg_file"`;
   my @failinfo = split(/\s/,$fail_info);
   my $flineno = $failinfo[0];
   my $ftype = lc($failinfo[1]);
   
   return($flineno,$ftype);
}

sub checkIfPortFree($) {
   my $port_no = $_[0];
   my $netstat=`netstat -an | findstr $port_no`; 
   if ($netstat=~/LISTEN/){
   	 return false;
    } else {
     return true;
   }
}

#minimum and maximum port number
sub find_free_network_port($$) {
    my $min_port_no = $_[0] ;
    my $max_port_no = $_[1];
    my $range_no = $max_port_no - $min_port_no;
    my $random_PORT;
	while(1) {
        $random_PORT = int(rand($range_no)) + $min_port_no;
        my $isPortFree = checkIfPortFree($random_PORT);   
        if ($isPortFree eq "true" ) {
	      #print("Found free port: $random_PORT,assigning env CEF_DEBUG_PORT=$random_PORT\n");
		  #$ENV{CEF_DEBUG_PORT} = $random_PORT;
    	  last;
		} else {
		   print( "Port $random_PORT is already in use, re-initiallizing port. \n");
		}        
	}
  return($random_PORT);
}

sub is_gpu_supported {
	my $gpu_status = 0;
     print "Validating Graphics Card using $ENV{PTCSYS}/obj/PTCHardwareCheck.exe -logfile=hw_check.log\n";
	  if (! -d $ENV{TEMP}) {
		  mkdir ("$ENV{TEMP}", 0777);
	  }
	  
	  if (! -d $ENV{TMP}) {
         mkdir ("$ENV{TMP}", 0777);
	  }
	
	  system("$csh_cmd \"$ENV{PTCSYS}/obj/PTCHardwareCheck.exe -logfile=hw_check.log\"");
	  $hw_check_stat = ($? >> 8);
      if ( $hw_check_stat || ! -e 'hw_check.log') {
        #HW_check failed
         print("$ENV{PTCSYS}/obj/PTCHardwareCheck.exe -logfile=hw_check.log failed with error code $hw_check_stat\n");
            $gpu_status = 1;
      }

      print `$csh_cmd \"cat hw_check.log \"`;
      $render_check_stat = `$csh_cmd \"cat hw_check.log | grep -i 'Check for Render Studio' | sort -u \"`;
      unlink('hw_check.log');
      chomp($render_check_stat);
	  $render_check_stat =~ s/\n|\r//g;
      $render_check_stat =~ s/-//g;
      
	  if ($render_check_stat =~ /FAIL/ ) {
         #HW_check success, but graphics card not suitable for graphics_process test
          print("$ENV{PTCSYS}/obj/PTCHardwareCheck.exe -logfile=hw_check.log return $render_check_stat \n");
          $gpu_status = 1;
      } elsif ($render_check_stat eq "") {
          #HW_Check success, but missing status of Render Studio
         print("$ENV{PTCSYS}/obj/PTCHardwareCheck.exe -logfile=hw_check.log missing Render Studio status \n");
         $gpu_status = 1;
      }
	 
	 `$rm_cmd -rf "$ENV{TMP}"` if (-d "$ENV{TMP}");
	 `$rm_cmd -rf "$ENV{TEMP}"` if (-d "$ENV{TEMP}");
  return ($gpu_status);	 
	  
}

sub add_to_saveas {
   my ($sfile_list) = @_;
   foreach my $fn ($sfile_list) {
      if (not defined $ENV{R_SAVE_AS}) {
         $ENV{R_SAVE_AS} = $fn;
      } else {
         $ENV{R_SAVE_AS} =~ s/,$//;
         if ($ENV{R_SAVE_AS} =~ /,/ || $ENV{R_SAVE_AS} ne "") {
            $ENV{R_SAVE_AS} .= ','.$fn if ($ENV{R_SAVE_AS} !~ /($fn)/);
         } else {
            $ENV{R_SAVE_AS} = $fn;
         }
      }
    }
}

sub is_appverifier_installed {
   my $installed = 0;
   my $appverifier_path = `$csh_cmd "which appverif.exe" `;
   
   if (! $?) {
      print  "\n Application Verifier installed\n\n";
      $installed = 1;        
   } else {
      print  "\n Application Verifier not installed\n\n";
   }

   return $installed;
}

sub remove_appverifier_setting {
    my $is_installed = is_appverifier_installed();
    if ($is_installed) {
        print  "\n Application Verifier setting removed \n";
        `$csh_cmd ' appverif.exe -disable \\* -for \\* ' ` ;
        $query_output = `$csh_cmd ' appverif.exe -query \\* -for \\* ' `;
        print "==========================\n";
        print "CurrentAppverifierSettings\n";
        print "$query_output\n";
        print "==========================\n";
    }
}

sub configure_appverifier_setting {
    my $is_installed = is_appverifier_installed();
    my $file_application_list;
    if ($ENV{R_USE_CREO_PLUS} eq "true" || $ENV{R_SAAS_REGRESSION} eq "true") {
      $file_application_list = "$ENV{PTC_TOOLS}/bin/appverifier_apps_saas.txt";
    }
    
    $file_application_list = "$ENV{R_LOCAL_APPVER_LIST}"  if ($ENV{R_LOCAL_APPVER_LIST} ne "");
    if ($file_application_list ne "") {
       if (! -e $file_application_list) {
          print "ERROR: Appverifier file_application_list $file_application_list missing\n";
       }           
    }
    
    if ($is_installed) {
        if (-e $file_application_list) {
          open (FILE, "$file_application_list");
          my @filelist = <FILE>;
          close(FILE);
          chomp(@filelist);
          foreach $f ( @filelist ) {
            print  "\n Application Verifier setting configured for $f \n\n";
            `$csh_cmd " appverif.exe -enable heaps -for $f -with NoLock=true " `;  
           }
        } else {
           print  "\n Application Verifier setting configured for xtop.exe \n\n";
           `$csh_cmd ' appverif.exe -enable heaps -for xtop.exe -with NoLock=true ' `;            
        }
        
        $query_output = `$csh_cmd ' appverif.exe -query \\* -for \\* ' `;
        print "==========================\n";
        print "CurrentAppverifierSettings\n";
        print "$query_output\n";
        print "==========================\n";
    }
}

sub list_current_dir {
  my $stmpdir =  `cygpath -m "$tmpdir" `;
  chomp($stmpdir);

   @current_dir_content = ` find $cur_dir -print `;
   chomp(@current_dir_content);
   add_to_saveas("${raw_trailname}rundir_filelist.log");
   open(FHR,">>$stmpdir/${raw_trailname}rundir_filelist.log");
   foreach $f (@current_dir_content) {
      #print "$f\n";
      print FHR "$f\n";
      
   }
   close(FHR);
   
}

sub list_current_process {
  my $stmpdir =  `cygpath -m "$tmpdir" `;
  chomp($stmpdir);
   
   add_to_saveas("${raw_trailname}tasklist_verbose.log");
   add_to_saveas("${raw_trailname}pslist_w_elapsedtime.log");
   
   print `$csh_cmd \"tasklist /v >>  $stmpdir/${raw_trailname}tasklist_verbose.log \"`;
   if ( -e "${PTC_TOOLS}/apps/SysInternals/pslist.exe" ) {
      print `$csh_cmd \"${PTC_TOOLS}/apps/SysInternals/pslist.exe -accepteula >>  $stmpdir/${raw_trailname}pslist_w_elapsedtime.log \"`;
   }
    
}

sub log_current_diskspace_ram {
  my $stmpdir =  `cygpath -m "$tmpdir" `;
  chomp($stmpdir);

   add_to_saveas("${raw_trailname}memory_diskspace.log");
   
    print `$csh_cmd \"free -h >>  $stmpdir/${raw_trailname}memory_diskspace.log \"`;
    print `$csh_cmd \"df -h >>  $stmpdir/${raw_trailname}memory_diskspace.log \"`;
    print `$csh_cmd \"uptime >>  $stmpdir/${raw_trailname}memory_diskspace.log \"`;   
    
}

sub basic_check_for_dauto_run {
   
   my $check_status = 0;
   
   if (-f "$rundir/succ.log") {
      `$csh_cmd "grep 'PARAMETER/ENVIRONMENT' $rundir/succ.log"`;
      if ($?) {
         print  "\nPARAMETER/ENVIRONMENT summary is missing in $rundir/succ.log\n\n";
         #exit(1);
        $check_status = 1;       
      }
   } else {
         print "File $rundir/succ.log is missing before starting test\n";
         #exit(1);          
   }
      
   if (-f "$rundir/fail.log") {
      `$csh_cmd "grep 'PARAMETER/ENVIRONMENT' $rundir/fail.log"`;
      if ($?) {
         print  "\nPARAMETER/ENVIRONMENT summary is missing in $rundir/fail.log\n\n";
         #exit(1);
         $check_status = 1;         
      }
   } else {
      print "File $rundir/fail.log is missing before starting test\n";
      #exit(1);
      $check_status = 1;
   }
   
   if (! -f "$rundir/auto.pl") {
      print "File $rundir/auto.pl is missing before starting test\n";
      #exit(1);
      $check_status = 1;
   }
  
  if ($check_for_success_status) {
	  print "check_for_success_status set to one for $raw_trailname$tk_flavor_name\n";
	 # $check_status = 1;
  }
  return($check_status);
}

sub kill_process_by_pid {
	my $process_pid = $_[0];
	$cur_cmd = "timeout 10s pskill -t $process_pid";
	print "Killing process with id $process_pid\n";
    `$csh_cmd "$cur_cmd"`; 
}

sub unique_string {
   my $cur_time;    
  $cur_time=localtime(time());
  @time_tokens = split(/[:,\s\/]+/, $cur_time);
  $str_time = "";
  foreach my $time_token (@time_tokens) {
	 	   $str_time = "$str_time_$time_token";
  }
	     
  $prefix_random_number = int(rand(1000000000));	
  $uniquename = "$prefix_random_number$str_time";
  return ($uniquename);
}

sub creoplus_refresh_APIKEY {
 
     undef $ENV{CREO_SAAS_APIKEY};
     undef $ENV{CREO_SAAS_AUTHORIZATION};
     if ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} eq 'true') {
        print "\n\nRunning: $ENV{PTC_TOOLS}/external/saas/saas_auth.csh api_key.out.$$ auth.out.$$ --force \n\n";
        system(" csh -fc  \" timeout -s SIGINT 2m $ENV{PTC_TOOLS}/external/saas/saas_auth.csh api_key.out.$$ auth.out.$$ --force \" ");
     } else {
        print "\n\nRunning: $ENV{PTC_TOOLS}/external/saas/saas_auth.csh api_key.out.$$ --force \n\n";
        system(" csh -fc \" $ENV{PTC_TOOLS}/external/saas/saas_auth.csh api_key.out.$$ --force \" ");
     }

     if (-f "api_key.out.$$" && -s "api_key.out.$$") {
        $new_apikey = `cat api_key.out.$$`;
        chomp($new_apikey);
        $ENV{CREO_SAAS_APIKEY} = $new_apikey;
        `rm api_key.out.$$`;
     } else {
        print ("\n\nFile api_key.out.$$ is missing\n\n"); 
     }
     
     if ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} eq 'true') {
        if (-f "auth.out.$$" && -s "auth.out.$$") {
           $authout = `cat auth.out.$$ `;
           chomp($authout);
           $ENV{CREO_SAAS_AUTHORIZATION} = $authout; 
           `rm auth.out.$$`;        
        } else {
          print ("\n\nFile auth.out.$$ is missing\n\n");   
        }
     }  
}

sub create_ptc_service_trl {
    
     my $local_username = $_[0];
     my $local_password = $_[1];
     $ENV{local_password} = $_[1]; 
     my $prefix_random_number = int(rand(1000000000));
     #my $local_ptc_ui_service_run_trl = "local_ptc_ui_service_run_$$_$prefix_random_number.txt";
	 my $local_ptc_ui_service_run_trl = "ui_trl_$$_$prefix_random_number.txt";
     my $new_local_ptc_ui_service_run_trl = "new_ui_trl_$$_$prefix_random_number.txt";
     my $saas_script = "$ENV{PTC_TOOLS}/external/saas/saas-ptcagent-regtest.csh";
     
     if (defined $ENV{LOCAL_SAAS_PTCAGENT_REGTEST}) {
        $saas_script = $ENV{LOCAL_SAAS_PTCAGENT_REGTEST};
     }
    
    $trl_cmd = "$saas_script create_browser_trail" . " -u $local_username" . " -p local_password" . " -o $local_ptc_ui_service_run_trl";
    $trl_cmd .= " --new-output $new_local_ptc_ui_service_run_trl";
    
    `csh -fc  " $trl_cmd " `;
    mkdir ("$cur_dir/scratch_tmp", 0777) if (! -e "$cur_dir/scratch_tmp");
    
   `mv $local_ptc_ui_service_run_trl "$cur_dir/scratch_tmp" `;
    my $service_trail_path = "$cur_dir/scratch_tmp/$local_ptc_ui_service_run_trl";
    
    `mv $new_local_ptc_ui_service_run_trl "$cur_dir/scratch_tmp" `;
    my $new_service_trail_path = "$cur_dir/scratch_tmp/$new_local_ptc_ui_service_run_trl";
    
    $service_trail_path =~ s/\//\\/g;
    $new_service_trail_path =~ s/\//\\/g;
    undef $ENV{local_password};
    undef $ENV{local_username};

    return($service_trail_path, $new_service_trail_path);   
}

sub update_creosaas_env {
    # this is to support machines having different LOCALAPPDATA
    
    my %ENV_TMP = %ENV;
    
    my $LOCALAPPDATA_tmp = $ENV{LOCALAPPDATA};
    $LOCALAPPDATAdrive = (split("",$ENV{LOCALAPPDATA}))[0];
    print "$LOCALAPPDATAdrive\n";
    
    my $current_user = ` $csh_cmd "whoami" `;
    chomp($current_user);    
    
    foreach $envname (keys(%ENV_TMP) ) {
       next if ($envname eq 'LOCALAPPDATA');
       next if ($envname eq 'PATH');
       next if ($envname eq 'APPDATA');
       
       if ($ENV_TMP{$envname} =~ /AppData/i) {
           print "Modifying $envname\n";
           $new_value = $ENV_TMP{$envname};
           $new_value =~ s/^([a-zA-Z]:)/$LOCALAPPDATAdrive:/i;
           
           $new_value =~ m/^$LOCALAPPDATAdrive:\/Users\/(_?[a-z]*_?)\//i;
           $env_user = $1;
           if ($current_user ne $env_user) {
              $szregex = "$LOCALAPPDATAdrive:\/Users\/$env_user";
              $szreplace_with = "$LOCALAPPDATAdrive:\/Users\/$current_user";
              $new_value =~ s/^($szregex)/$szreplace_with/i;              
           }
		   print "old:$envname->$ENV{$envname}\n";
		   $ENV{$envname} = $new_value;
		   print "new:$envname->$ENV{$envname}\n";
       }
    }
}

sub create_message_file {
   my $message = "$_[0]";
   my $raw_trail_name = "${raw_trailname}${tk_flavor_extension}${tk_flavor_}";
   open(MSG, ">>$rundir/$raw_trail_name.msg");
   print MSG "$message\n";
   close (MSG);
		   
   open(MSG, ">>$tmpdir/$raw_trailname.msg");
   print MSG "$message \n";
   close (MSG);
}

sub save_extra_logs {
    my $raw_trail_name ="$raw_trailname$tk_flavor_name";
    my $trailfiledir = "$rundir/$raw_trail_name";
    mkdir("$trailfiledir", 0777) if (! -d "$trailfiledir");
    #`cp "$tmpdir/$raw_trailname.txt" "$trailfiledir"`;

    if (-f "$rundir/proj.std.err") {
      `cp "$rundir/proj.std.err" "$trailfiledir/console.auto.err.log"`;
    }
      
    if (-f "$rundir/proj.std.out") {
      `cp "$rundir/proj.std.out" "$trailfiledir/console.auto.log"`;
    }

    if (-f "$rundir/env.log") {
      `cp "$rundir/env.log" "$trailfiledir"`;
    }  
}

sub save_configure_creosaas_login {
    
  my $new_username = $_[0];
  my $new_password = $_[1];   
  $old_CREO_SAAS_TEST_ALT_USERNAME = "$ENV{CREO_SAAS_TEST_ALT_USERNAME}";
  $old_CREO_SAAS_TEST_ALT_PASSWORD = "$ENV{CREO_SAAS_TEST_ALT_PASSWORD}";       
  $ENV{CREO_SAAS_TEST_ALT_USERNAME} = $new_username;
  $ENV{CREO_SAAS_TEST_ALT_PASSWORD} = $new_password;
  
  $old_CREO_SAAS_USERNAME = "$ENV{CREO_SAAS_USERNAME}";
  $old_CREO_SAAS_PASSWORD = "$ENV{CREO_SAAS_PASSWORD}";                    
  $ENV{CREO_SAAS_USERNAME} = $new_username;
  $ENV{CREO_SAAS_PASSWORD} = $new_password;
   
   if ( ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} ne 'true') || (not defined $ENV{CREO_SAAS_TEST_SCRIPT_AUTH}) ) {
         ($service_trail_path, $new_service_trail_path) = create_ptc_service_trl($new_username, $new_password);
         $old_PTC_UI_SERVICE_RUN_TRAIL = "$ENV{PTC_UI_SERVICE_RUN_TRAIL}";
         $ENV{PTC_UI_SERVICE_RUN_TRAIL} = $service_trail_path;
           
         $old_ZBROWSER_TRAIL_FILE = "$ENV{ZBROWSER_TRAIL_FILE}";
         $ENV{ZBROWSER_TRAIL_FILE} = $new_service_trail_path;    
    }    
}

sub create_psf_file {
 my $lpsf_file = $_[0];
 $lpsf_file =~ s/\\/\//g;
 my $license_name = $_[1];
 my $lang_value = $_[2];
 my $nondefault_profile = $_[3];
 my $psf_with_current_env = "$_[4]";
 my $prefix_random_number = int(rand(1000000000));
 my $local_l2r_psf_file_out = "local_l2r_$$_$prefix_random_number.psf";
 my $saas_script = "$ENV{PTC_TOOLS}/external/saas/saas-ptcagent-regtest.csh";

 if (defined $ENV{LOCAL_SAAS_PTCAGENT_REGTEST}) {
   $saas_script = $ENV{LOCAL_SAAS_PTCAGENT_REGTEST};
 }
  
  $trl_cmd = "$saas_script create_psf" . " -i \'$lpsf_file\' " . " -o \'$local_l2r_psf_file_out\' ";
  $trl_cmd .= " --license \'$license_name\' " if ($license_name ne '');
  $trl_cmd .= " --lang \'$lang_value\' " if ($lang_value ne '');
  $trl_cmd .= " --profile \'$nondefault_profile\' " if ($nondefault_profile ne '');
  $trl_cmd .= " --envs \'$psf_with_current_env\'" if ($psf_with_current_env ne '');
 
 print "\nRunning:$trl_cmd\n";
 
 `csh -fc  " $trl_cmd " `;
  
  my $local_l2r_psf_file_path = `cygpath -aw \"$local_l2r_psf_file_out\"`;
  chomp($local_l2r_psf_file_path);
   
  return($local_l2r_psf_file_path);
}

sub use_cpd_user {
  
  if ($directives{atlas_user}) {
     print "will be using #atlas_user user, ignoring #cpd_user \n";
     $directives{cpd_user} = 0;
     return ;
  }
        
  if ($directives{run_with_license}) {
     print "will be using #run_with_license l2R user, ignoring #cpd_user\n";
     $directives{cpd_user} = 0;
     return ;
  }
  
  $cpd_password = get_secret($cpd_username); 
  save_configure_creosaas_login($cpd_username,$cpd_password);    
}

sub check_for_success {
  my $raw_trail_name = "$raw_trailname$tk_flavor_name"; 
  
  if ( $directives{mech_test_long} 
       || $directives{pt_asynchronous_tests}
     ) {
    $fmsg = "$raw_trail_name,skipped for check_for_success\n";
    print_succ( $fmsg );
    return;    
  }
  
  $check_for_success_status = 0;
  $ctmpdir =  `cygpath -m $tmpdir`;
  chomp($ctmpdir);
       
  if (! -e "$ctmpdir/std.out") {
	$fmsg = "ERROR:FALSE_SUCCESS:$raw_trailname$tk_flavor_name,std.out missing";
	print "$fmsg\n";
	$result = "FAILURE";
	$check_for_success_status = 1;
	create_message_file("$fmsg");
  }
  
  if (! -e "$ctmpdir/trail.txt.1") {
	$fmsg = "ERROR:FALSE_SUCCESS:$raw_trailname$tk_flavor_name,trail.txt.1 missing\n";
	print "$fmsg\n";
	$result = "FAILURE";
	$check_for_success_status = 1;
	create_message_file("$fmsg");
  } else {
	my $trail_exit = `$csh_cmd \" grep 'End of Trail File' $ctmpdir/trail.txt.1 \" `;
	chomp($trail_exit);
	
	if ($trail_exit !~ /(End of Trail File)/) {
		$result = "FAILURE";
		$check_for_success_status = 1;
	    $fmsg = "ERROR:FALSE_SUCCESS:$raw_trailname$tk_flavor_name, End of Trail File line missing in trail.txt.1";
		print "$fmsg\n";
	    create_message_file("$fmsg");
    }  
  }
}

sub get_binary_version {
   my $file = $_[0];
   $file =~ s|/|\\|g;
   
   return "NOT_APPLICABLE" if ($ENV{OS_TYPE} ne "NT");

   if (! -e "$file") {
      print "get_binary_version:$file not found\n";
      return "FILE_NOT_FOUND";
   }
   
   my $afile = "$file";
   $afile =~ s|^\\|\\\\\\|;
   my $sigcheck_cmd = " $ENV{PTC_TOOLS}/apps/SysInternals/sigcheck.exe -nobanner -accepteula -n ";
   $sigcheck_cmd .= " \'$afile\' ";

   my $sigcheckcmd_status = system("$csh_cmd \"$sigcheck_cmd\" > $cur_dir/sigcheck$$.out");
   my $fversion = ` $csh_cmd "cat $cur_dir/sigcheck$$.out" `;
   chomp($fversion);
   unlink("$cur_dir/sigcheck$$.out");
   
   $sigcheckcmd_status = ($sigcheckcmd_status >> 8);
   if ($sigcheckcmd_status != 1) {
       print ("For following sigcheck_cmd:\n $sigcheck_cmd \n");
       print ("ERROR: sigcheckcmd_status = $sigcheckcmd_status\n");
       print ("ERROR: sigcheckcmd file version = $fversion\n");
   }
   
  return ($fversion)
}

sub configure_run_collab_svc {
     	 use URI;
	     require LWP::UserAgent;
	     use JSON;
     	 my $ua = LWP::UserAgent->new;
	     $ua->timeout(20);	 
	     my $host = $ENV{COLLABSVC_HOST};
	     my $port = $ENV{COLLABSVC_PORT};
	     my $sessname = $raw_trailname;
	     my $json = JSON->new->allow_nonref;	
		 $keep_creo_collab_svc_exe = "true";	 
		 if (defined $host) {
			 $port = "8009" if (! defined $port);
		 } 	 
		 else {
		     $host = "localhost";	 	 
		     ($srvPID, $port) = run_local_collab_svc();
			 if ($port == '-1') {
				print "Error: $port invalid port number from run_local_collab_svc\n";
			    print_fail("skipped::  #skipped because run_local_collab_svc return port $port\n");
				print_skip_msg("skipped::  #skipped $raw_trailname because run_local_collab_svc return port $port\n");
                $skip_msg = "because  run_local_collab_svc return port $port which is invalid\n";
                mkpath("$tmpdir/collabsvc_exe_log",0777) ;
                if (defined $ENV{R_SAVE_COLLABSVC_LOG}) {
                  `$cp_cmd $cur_dir/scratch_tmp/* "$tmpdir/collabsvc_exe_log/" `;
                   add_to_saveas("collabsvc_exe_log");
                   $result = "FAILURE";
                   run_for_save_as_data();
                }
				kill_process_by_pid($srvPID) if ($srvPID ne '');              
	            return (-1);
			 }
		 }  

	 	   $collabsvc_url_set = "true";
	       my $collabsvc_url = "http://${host}:$port/api/v1/cs";
		   $ENV{COLLABSVC_URL} = $collabsvc_url;
	 
		 if (! defined $ENV{dataDir}) {
	     $sessname = "collab session for me" if (! defined $sessname);		 
	     my $request_data = '{"name": "'.$sessname.'", "description": "Creo collab session"}';	 
	     my $url = "http://${host}:$port/api/v1/cs/sessions";
	     my $response = $ua->post($url, 
	                              "Content-Type", "application/json",
	                              # new server
	                              "X-PTC-Collaboration-AppId", "auto",
	                              "X-PTC-Collaboration-UserName", $ENV{USERNAME},
								  "X-PTC-Company-Id", "auto",
	                              # old server
	                              "X-CGM-Collaboration-appid", "auto",
	                              "X-CGM-Collaboration-userid", $ENV{USERNAME},
	                              "Content", $request_data);
	     if (not $response->is_success) {
	         print_fail("skipped::  #skipped because request to collab service failed ${host}:$port\n");
	         print_skip_msg("skipped::  #skipped $raw_trailname because request to collab service failed ${host}:$port\n");
             $skip_msg = "because  request to collab service failed ${host}:$port\n";
			 kill_process_by_pid($srvPID) if ($srvPID ne '');
	         return (-1);
	     }
	     my $session_json = $response->decoded_content;
	     my $sessinfo = $json->decode($session_json);
	     my $contrib_link = $sessinfo->{contributor_access_link};
	     if (! defined $contrib_link) {
	       my $sid = $sessinfo->{id};
	       $ENV{PHA_COLLAB_URL} = "$url/$sid";
	     } else {
	       $response = $ua->get($contrib_link);
	       my $pha = $response->decoded_content;
	       my @lines = split /\n/, $pha;
	       my @one = grep /^display_url/, @lines;
	       my (undef, $display_url) = split /=/, $one[0];
	       $ENV{PHA_COLLAB_URL} = $display_url;
	       @one = grep /^collabsvc_access_token/, @lines;
	       if (scalar @one == 1) {
	         my (undef, $token) = split /=/, $one[0];
	         $ENV{PHA_COLLAB_TOKEN} = $token
	       }
	       }    
		 }
		 else {
			print ("dataDir is to $ENV{dataDir} \n ");
	     }  
}

sub get_secret {
   my $username = $_[0];
   my $password = '';
   my $curl_data = "";
   my $token_collab_creds = "";
   
   if (lc($ENV{CREO_SAAS_CLUSTER}) eq 'production' || lc($ENV{CREO_SAAS_CLUSTER}) eq 'prod') {
      if ($ENV{TOKEN_PROD_COLLAB_CREDS} ne '') {
         my $header = "-H User-Token:$ENV{TOKEN_PROD_COLLAB_CREDS}";
      $curl_data = `$csh_cmd "curl -s --ssl-no-revoke --cacert $ENV{PTC_TOOLS}/cacerts/ptcrootca_ptcissuingca.pem -X POST ${header} https://token.ptcnet.ptc.com/secret/get_atlas_collab_creds_prod"`;
      } else {
         print ("\n\nERROR:TOKEN_PROD_COLLAB_CREDS not set\n");   
      }
   } else {
     $curl_opt = "-s --ssl-no-revoke --cacert $ENV{PTC_TOOLS}/cacerts/ptcrootca_ptcissuingca.pem";
     if ($ENV{R_SKIP_FUTURE_MODE} eq "true") {
         $curl_opt = "-sk"
     }
     $curl_data = `$csh_cmd "curl $curl_opt -X POST https://token.ptcnet.ptc.com/secret/get_atlas_collab_creds" `;   
   }
   
   if ($curl_data ne '') {
      my $decoded_data = decode_json($curl_data);
      my @data = @{ $decoded_data };
      
      foreach my $d ( @data ) {
             if ( $d->{'username'} eq $username) {
                 $password = $d->{'password'};
         }   
	  }
   }
   return ("$password");
}

sub upload_config_to_server {
    my $ctmpdir =  `cygpath -m $tmpdir`;
    chomp($ctmpdir);
    $mach_name = `hostname`;
    chomp($mach_name);
    my $current_uid = `$csh_cmd uuidgen`;
    chomp($current_uid);
    $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID} = "${mach_name}_${current_uid}";
    print("For(upload) CREO_SAAS_CONFIGS_AUTO_PREFIX_ID = $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID}\n");
    
    my $lprofile = $ENV{CREO_SAAS_TEST_ALT_PROFILE_NAME};
    $lprofile = $ENV{R_SAAS_PROFILE_NAME} if ($ENV{R_SAAS_PROFILE_NAME} ne '');
    
    my $config_cmd = "$ENV{PTC_TOOLS}/external/saas/saas-ptcagent-regtest.csh configs_manage --src ${ctmpdir} --user $ENV{CREO_SAAS_USERNAME} --profile $lprofile";
    
    my $user_tmp = "$ENV{CREO_SAAS_USERNAME}";
    my $passwd_tmp = "$ENV{CREO_SAAS_PASSWORD}";
    $ENV{CREO_SAAS_USERNAME} = "$ENV{CREO_SAAS_ADMIN_USERNAME}";
    $ENV{CREO_SAAS_PASSWORD} = "$ENV{CREO_SAAS_ADMIN_PASSWORD}";
    
    print ("Running $config_cmd\n");
    my $system_stat =  system("csh -fc \"$config_cmd\"  ");
    check_system_status($system_stat, " csh -fc \"$config_cmd\" ");
    undef $ENV{ULC_STORAGE_ALT_DIR} if (defined $ENV{ULC_STORAGE_ALT_DIR});
    $ENV{CREO_SAAS_USERNAME} = "$user_tmp";
    $ENV{CREO_SAAS_PASSWORD} = "$passwd_tmp";
    if (-f "${ctmpdir}/saas-ptcagent-regtest.log") {
        `mv ${ctmpdir}/saas-ptcagent-regtest.log $ENV{PTC_LOG_DIR}/saas-ptcagent-regtest-upload_config.log`;
    }
}

sub delete_config_from_server {
    my $ctmpdir =  `cygpath -m $tmpdir`;
    chomp($ctmpdir);
    my $lprofile = $ENV{CREO_SAAS_TEST_ALT_PROFILE_NAME};
    $lprofile = $ENV{R_SAAS_PROFILE_NAME} if ($ENV{R_SAAS_PROFILE_NAME} ne '');
    
    my $config_cmd = "$ENV{PTC_TOOLS}/external/saas/saas-ptcagent-regtest.csh configs_manage --delete --user $ENV{CREO_SAAS_USERNAME} --profile $lprofile";
    
    my $user_tmp = "$ENV{CREO_SAAS_USERNAME}";
    my $passwd_tmp = "$ENV{CREO_SAAS_PASSWORD}";
    $ENV{CREO_SAAS_USERNAME} = "$ENV{CREO_SAAS_ADMIN_USERNAME}";
    $ENV{CREO_SAAS_PASSWORD} = "$ENV{CREO_SAAS_ADMIN_PASSWORD}";
     
    print ("Running $config_cmd\n");
    print("For(delete) CREO_SAAS_CONFIGS_AUTO_PREFIX_ID = $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID}\n");   
    my $system_stat =  system("csh -fc \"$config_cmd\"  ");
    check_system_status($system_stat, " csh -fc \"$config_cmd\" ");
    undef $ENV{ULC_STORAGE_ALT_DIR} if (defined $ENV{ULC_STORAGE_ALT_DIR});
    $ENV{CREO_SAAS_USERNAME} = "$user_tmp";
    $ENV{CREO_SAAS_PASSWORD} = "$passwd_tmp";
    if (-f "${ctmpdir}saas-ptcagent-regtest.log") {
        `mv ${ctmpdir}/saas-ptcagent-regtest.log $ENV{PTC_LOG_DIR}/saas-ptcagent-regtest-delete_config.log`;
    }    
}

sub set_random_numbered_saas_username {
  print "finding random username for CREO_SAAS_USERNAME = $ENV{CREO_SAAS_USERNAME} \n";
  my $curr_user = $ENV{CREO_SAAS_USERNAME} ;
  my ($min, $max) = 1;
  $min = $ENV{R_RANDOM_START_NUM_SAAS_USER} if ($ENV{R_RANDOM_START_NUM_SAAS_USER} != '');
  $max = $ENV{R_RANDOM_END_NUM_SAAS_USER} if ($ENV{R_RANDOM_END_NUM_SAAS_USER} != '');
  my $usr_cnt = $min + int(rand($max - $min + 1));
  my $seq = sprintf("%03d", $usr_cnt);
  
  $curr_user =~ s/(\.auto\@gmail.com)$/\.auto\.$seq\@gmail.com/;
  return($curr_user);
} 

sub run_collab_other {
   if ($directives{shared_workspace} && $shared_workspace_trail_size > 0) {
     if (defined $ENV{R_SHARED_CREO_HOME}) {
        $ENV{CEF_DEBUG_PORT} = $first_cef_debug_port;
     } else {
        $ENV{CEF_DEBUG_PORT} = $second_cef_debug_port; 
     }
     $ENV{ZB_DEBUG_PORT} = $ENV{CEF_DEBUG_PORT};
     #print " CEF_DEBUG_PORT is set to $ENV{CEF_DEBUG_PORT} for other_user session \n";       
     
     if ($ENV{CREO_SAAS_TEST_ALT_SECOND_USERNAME} ne '') {
         $ENV{PHA_COLLAB_USER} = $ENV{CREO_SAAS_TEST_ALT_SECONDARY_USERNAME}; 
     } else {
        $ENV{PHA_COLLAB_USER} = $atlas_user_name2;        
     }
     
     if ($ENV{CREO_SAAS_TEST_ALT_SECOND_PASSWORD} ne '') {
        $ENV{PHA_COLLAB_PWD} = $ENV{CREO_SAAS_TEST_ALT_SECONDARY_PASSWORD};         
     } else {
        $ENV{PHA_COLLAB_PWD} = $atlas_password2;      
     }

     #print "   other_user(s2) With PHA_COLLAB_USER is set to $ENV{PHA_COLLAB_USER}\n";
     
     if ($ENV{PHA_COLLAB_PWD} ne "") {
                #print " And PHA_COLLAB_PWD for other_user is set \n"    
     }
     
	 if ($collab_atlas eq 'false') {
		 $ENV{R_COLLAB_WAIT_SECS} = 0;
	 }
     if ($ENV{ENABLE_MULTI_CLIENT_SYNC} eq "true") {
        print "\nRunning $ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/integ_tools/cu_multiclient_trail_sync.py -s -pf multiclient_trail_port.txt & ";
        system("csh -fc \"$ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/integ_tools/cu_multiclient_trail_sync.py -s -pf multiclient_trail_port.txt & \"");
        print "\nRunning $ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/integ_tools/cu_multiclient_trail_sync.py -w -pf multiclient_trail_port.txt ";
        system("csh -fc \"$ENV{PTC_TOOLS}/python37/$PRO_MACHINE_TYPE/python $ENV{PTC_TOOLS}/integ_tools/cu_multiclient_trail_sync.py -w -pf multiclient_trail_port.txt \"");
       
        open(MCT_PORT, 'multiclient_trail_port.txt');
        $ENV{TC_MULTI_CLIENT_SYNC} = <MCT_PORT>;
        close(MCT_PORT);
        print "\nThe multiclient port is $ENV{TC_MULTI_CLIENT_SYNC}\n";
        unlink('multiclient_trail_port.txt');
     }
 
     if ( ($ENV{R_USE_CREO_PLUS} eq "true" || $ENV{R_SAAS_REGRESSION} eq "true")  && $directives{atlas_user}) {
        print ("\n\n multi-user test, refresh key/trail for other_user for atlas_user_name2 (s2) = $ENV{PHA_COLLAB_USER}\n\n");
        

        if ( ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} ne 'true') || (not defined $ENV{CREO_SAAS_TEST_SCRIPT_AUTH}) ) {
           ($service_trail_path, $new_service_trail_path) = create_ptc_service_trl($ENV{PHA_COLLAB_USER}, $ENV{PHA_COLLAB_PWD});
           $old_PTC_UI_SERVICE_RUN_TRAIL = "$ENV{PTC_UI_SERVICE_RUN_TRAIL}";
           $ENV{PTC_UI_SERVICE_RUN_TRAIL} = $service_trail_path;
           
           $old_ZBROWSER_TRAIL_FILE = "$ENV{ZBROWSER_TRAIL_FILE}";
           $ENV{ZBROWSER_TRAIL_FILE} = $new_service_trail_path;
           }

        $old_CREO_SAAS_TEST_ALT_USERNAME = "$ENV{CREO_SAAS_TEST_ALT_USERNAME}";
        $old_CREO_SAAS_TEST_ALT_PASSWORD = "$ENV{CREO_SAAS_TEST_ALT_PASSWORD}";       
        $ENV{CREO_SAAS_TEST_ALT_USERNAME} = $ENV{PHA_COLLAB_USER};
        $ENV{CREO_SAAS_TEST_ALT_PASSWORD} = $ENV{PHA_COLLAB_PWD};

        $old_CREO_SAAS_USERNAME = "$ENV{CREO_SAAS_USERNAME}";
        $old_CREO_SAAS_PASSWORD = "$ENV{CREO_SAAS_PASSWORD}";                    
        $ENV{CREO_SAAS_USERNAME} = $ENV{PHA_COLLAB_USER};
        $ENV{CREO_SAAS_PASSWORD} = $ENV{PHA_COLLAB_PWD};
        
        if (lc($ENV{CLUSTER_TYPE}) eq 'test' || $ENV{CREO_SAAS_TEST_SCRIPT_AUTH} eq "true") {
         creoplus_refresh_APIKEY();
        }
     }
     
     if ($ENV{R_USE_SAAS_CONFIG_SERVICE} eq 'true') {
        upload_config_to_server();
        print "CREO_SAAS_CONFIGS_AUTO_PREFIX_ID(other user)=$ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID}\n" ;
        $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID_OTHER_USER} = $ENV{CREO_SAAS_CONFIGS_AUTO_PREFIX_ID};
     }
	 
      if ($ENV{R_USE_LOCAL_COLLAB_OTHER} ne "") {
        $collab_other_pid = "";
        $local_collab_other = CygPath($ENV{R_USE_LOCAL_COLLAB_OTHER});
        print "\nRunning other_user trail: \n\n$local_collab_other $shared_workspace_trail  $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} \n\n"; 
        $system_stat = system("csh -fc \"$local_collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} \'$ENV{PHA_COLLAB_PWD}\' $ENV{CEF_DEBUG_PORT}\"");       

        if ($ENV{PHA_COLLAB_PWD} ne "") {
           check_system_status($system_stat, " csh -fc \"$local_collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} <PHA_COLLAB_PWD> $ENV{CEF_DEBUG_PORT}\" ");
        } else {
           check_system_status($system_stat, " csh -fc \"$local_collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} $ENV{CEF_DEBUG_PORT}\" "); 
        }
        $collab_other_pid = `cat $cur_dir/.${shared_workspace_trail}_collab_other.pid`;
        chomp($collab_other_pid);
     } else {
        $collab_other_pid = "";
        print "\nRunning other_user trail: \n\n$ENV{PTC_TOOLS}/bin/collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER}  $ENV{CEF_DEBUG_PORT} \n\n"; 
        $system_stat = system("csh -fc \"$ENV{PTC_TOOLS}/bin/collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} \'$ENV{PHA_COLLAB_PWD}\' $ENV{CEF_DEBUG_PORT}\"");

        if ($ENV{PHA_COLLAB_PWD} ne "") {
           check_system_status($system_stat, " csh -fc \"$ENV{PTC_TOOLS}/bin/collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} <PHA_COLLAB_PWD> $ENV{CEF_DEBUG_PORT}\" ");
        } else {
           check_system_status($system_stat, " csh -fc \"$ENV{PTC_TOOLS}/bin/collab_other $shared_workspace_trail $prefix_session_name $atlas_user_name1 $ENV{PHA_COLLAB_USER} $ENV{CEF_DEBUG_PORT}\" "); 
        } 
        $collab_other_pid = `cat $cur_dir/.${shared_workspace_trail}_collab_other.pid`;
        chomp($collab_other_pid);        
     }
     
     if (defined $ENV{'R_SHARED_CREO_HOME'}) {
        
        $clean_setenv_cmds{'CREO_AGENT_HOME'} = $ENV{CREO_AGENT_HOME};   
        $clean_setenv_cmds{'PTC_WF_ROOT'} = $ENV{PTC_WF_ROOT};        
        
        $ENV{CREO_AGENT_HOME} = "$cur_dir/CREO_HOME_${collab_other_pid}_otheruser";
        $ENV{PTC_WF_ROOT} = "$cur_dir/WF_ROOT_DIR_${collab_other_pid}_otheruser/wfroot";
        print ("Note: CREO_AGENT_HOME is set to $ENV{CREO_AGENT_HOME} because R_SHARED_CREO_HOME is set\n");
        print ("Note: PTC_WF_ROOT is set to $ENV{PTC_WF_ROOT} because R_SHARED_CREO_HOME is set\n");
     }

     if ( ($ENV{R_USE_CREO_PLUS} eq 'true') && -d "$ENV{LOCAL_INSTALL_PATH_NT}\\$ENV{'CREO_SAAS_BUILDNUM'}\\Parametric\\bin") {
       $ENV{LOCALPROE} = "$local_xtop_default";
       print "reseting LOCALPROE to $ENV{LOCALPROE} \n";
     }
     
     $ENV{PHA_COLLAB_USER} = $atlas_user_name1;
     $ENV{PHA_COLLAB_PWD} = $atlas_password1;
          
     #$clean_setenv_cmds{'CEF_DEBUG_PORT'} = $ENV{CEF_DEBUG_PORT};
     $ENV{CEF_DEBUG_PORT} = $first_cef_debug_port;
     $ENV{ZB_DEBUG_PORT} = $ENV{CEF_DEBUG_PORT};
     print " PHA_COLLAB_USER (s1) is set to $ENV{PHA_COLLAB_USER}\n";
     print " CEF_DEBUG_PORT (s1) is set to $ENV{CEF_DEBUG_PORT}\n";
     print " CREO_AGENT_HOME (s1) is set to $ENV{CREO_AGENT_HOME}\n";
     print " PTC_WF_ROOT (s1) is set to $ENV{PTC_WF_ROOT}\n";
     if ($ENV{PHA_COLLAB_PWD} ne "") {
             #print " and PHA_COLLAB_PWD (s1) is set \n"    
     }
     
     if ( ($ENV{R_USE_CREO_PLUS} eq "true" || $ENV{R_SAAS_REGRESSION} eq "true") && $directives{atlas_user} ) {
        print ("\n\n multi-user test, refresh key/trail for atlas_user_name1(s1) = $ENV{PHA_COLLAB_USER}\n\n");
        if ( ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} ne 'true') || (not defined $ENV{CREO_SAAS_TEST_SCRIPT_AUTH}) ) {
           ($service_trail_path, $new_service_trail_path) = create_ptc_service_trl($ENV{PHA_COLLAB_USER}, $ENV{PHA_COLLAB_PWD});
           
           $ENV{PTC_UI_SERVICE_RUN_TRAIL} = $service_trail_path;
           $ENV{ZBROWSER_TRAIL_FILE} = $new_service_trail_path;
        }
        
        $ENV{CREO_SAAS_TEST_ALT_USERNAME} = $ENV{PHA_COLLAB_USER};
        $ENV{CREO_SAAS_TEST_ALT_PASSWORD} = $ENV{PHA_COLLAB_PWD};
                   
        $ENV{CREO_SAAS_USERNAME} = $ENV{PHA_COLLAB_USER};
        $ENV{CREO_SAAS_PASSWORD} = $ENV{PHA_COLLAB_PWD};
     }
   }
   
   if ( ($ENV{R_USE_CREO_PLUS} eq "true" || $ENV{R_SAAS_REGRESSION} eq "true") && $directives{atlas_user} && (! $is_atlas_user_multi_session && $shared_workspace_trail eq '')) {
        print ("\n\n single-user test, refresh key/trail for atlas_user_name1(s1) = $ENV{PHA_COLLAB_USER}\n\n");
        if ( ($ENV{CREO_SAAS_TEST_SCRIPT_AUTH} ne 'true') || (not defined $ENV{CREO_SAAS_TEST_SCRIPT_AUTH}) ) {
           ($service_trail_path, $new_service_trail_path) = create_ptc_service_trl($ENV{PHA_COLLAB_USER}, $ENV{PHA_COLLAB_PWD});
           $old_PTC_UI_SERVICE_RUN_TRAIL = "$ENV{PTC_UI_SERVICE_RUN_TRAIL}";
           $ENV{PTC_UI_SERVICE_RUN_TRAIL} = $service_trail_path;
           
           $old_ZBROWSER_TRAIL_FILE = "$ENV{ZBROWSER_TRAIL_FILE}";
           $ENV{ZBROWSER_TRAIL_FILE} = $new_service_trail_path;
        }

        $old_CREO_SAAS_TEST_ALT_USERNAME = "$ENV{CREO_SAAS_TEST_ALT_USERNAME}";
        $old_CREO_SAAS_TEST_ALT_PASSWORD = "$ENV{CREO_SAAS_TEST_ALT_PASSWORD}";       
        $ENV{CREO_SAAS_TEST_ALT_USERNAME} = $ENV{PHA_COLLAB_USER};
        $ENV{CREO_SAAS_TEST_ALT_PASSWORD} = $ENV{PHA_COLLAB_PWD};

        $old_CREO_SAAS_USERNAME = "$ENV{CREO_SAAS_USERNAME}";
        $old_CREO_SAAS_PASSWORD = "$ENV{CREO_SAAS_PASSWORD}";                    
        $ENV{CREO_SAAS_USERNAME} = $ENV{PHA_COLLAB_USER};
        $ENV{CREO_SAAS_PASSWORD} = $ENV{PHA_COLLAB_PWD}; 
   }
}

##############################################################################
# REVISION HISTORY
#
# 09/02/97 Jean Created.
# 09/09/97 Jean fixed bug for weblink test
# 09/11/97 Jean fixed bug for running cmd on NT
# 09/15/97 Jean support relative path
# 09/18/97 Jean Added rec_copy_trail
# 09/25/97 Jean Fixed bug for running local_home_test
# 09/25/97 Jean Fixed a bug for checking cutoff time.
# 09/30/97 Jean fixed bug for qcr and R_ALT_QCR_DIR test
# 09/30/97 Jean run command from current directory if there is one.
# 09/30/97 Jean remove /tmp_mnt from xtop path
# 10/01/97 Jean fixed bug for ptr_async test
# 10/06/97 Jean do not dump core when no need, not use tail
# 10/10/97 Jean do chmod before copy R_ALT_*
# 10/14/97 Jean made cmd output display
# 10/16/97 Jean added #setenv and #unsetenv stuff
# 10/22/97 Jean don't remove #CRASH from weblink trail file
# 10/23/97 Jean use chmod +w on nec_mips
# 10/27/97 Jean unbuffer output
# 11/05/97 Jean fixed Win95 problem
# 11/10/97 Jean fixed the bug in date_mdy
# 11/12/97 Jean fixed win95 problem
# 11/17/97 Jean fixed weblink test for NT
# 11/17/97 Jean change tmpdir to NT path for NT.
# 11/19/97 Jean fixed skipped message
# 12/01/97 Jean do not put trail file names in succ.log and fail.log
# 12/03/97 Jean remove auto_misc when auto stop
# 12/05/97 Jean print out info for copying R_ALT_TRAIL_DIR
# 12/14/97  aap Copy .bif files to auto_misc too!
# 12/16/97 Jean put "skipped::  #skipped" into fail.log to make regstat happy
# 12/18/97 Jean fixed bug in copy_pd_demo_trail
# 12/19/97 Jean fixed fail_skip bug
# 12/23/97 Jean fail_skip also check .htm
# 01/09/98 Jean fixed a bug in handling #k
# 01/09/98 Jean copy *.cfg to lang dir
# 02/12/98 Jean remove the ending spaces from the lines in auto.txt
# 02/17/98 Jean fixed bug from previous changes
# 02/18/98 Jean fixed a NT bug.
# 02/23/98 Jean copy misc for find version.
# 02/25/98 Jean added chmod for copying altlang qcr
# 02/25/98 Jean added R_PROFLY
# 03/20/98 MTP  Added spanish, fixed other langs.
# 04/16/98 Jean added CV_ENV_HOME
# 04/27/98 Jean fixed a typo
# 05/12/98 MTP  Added korean.
# 05/14/98 Jean fixed bug for save all core.
# 05/27/98 Jean copy .new as well when $R_SUCC_TRAIL_DIR.
# 05/27/98 Jean set PROFLY_DIRECTORY to $PTCSRC/pronav if it is not defined.
# 06/17/98 Jean copy $R_ALT_TRAIL_DIR/trailfile.txt for #r test
# 06/17/98 Jean Added R_NICE.
# 06/17/98 Jean copy object files one by one.
# 06/23/98 Jean better fix for copying object files problem
# 06/25/98 Jean fixed bug for counting test number
# 06/29/98 Jean add "\n" into config.pro
# 06/30/98 Jean removed the first line by Serge Lublinsky's request
# 07/09/98 Jean added profly_trl.txt for I01 profly
# 07/13/98 Jean added checking status for copying object fixes
# 07/16/98 Jean fixed copy_misc.
# 07/24/98 Jean add "variant_drawing_items_sizes yes" to config.pro when < 941
# 08/10/98 Jean removed proguide.
# 09/10/98 Jean catch the info. from perror to .msg
# 09/28/98 Jean added pt_async_pic_test
# 10/01/98 Jean check exists $R_SAVE_ALL_CORE
# 10/08/98 Jean added java_test stuff
# 10/20/98 Jean mark dll test fail if prodevdat_setup exists none-zero status
# 10/21/98 Jean setup java env in auto script
# 10/22/98 Jean added graphics_test
# 10/29/98 MTP  Updated korean locales.
# 11/18/98 Jean put rename pwl_trl.htm.1 to correct place.
# 01/20/99 Jean fixed bug for copy class.
# 03/03/99 Jean remove TMPDIR after get traceback.
# 03/09/99 Jean added java_async_test.
# 03/22/99 Jean put cmd process in directive process
# 04/08/99 Jean put qcr fail result into trailname_dll dir.
# 04/15/99 Jean added zero_run_mode_test stuff
# 04/19/99 Jean remove extra space from auto.txt
# 04/21/99 Jean added none_graphics_test
# 04/27/99 Jean use www4
# 04/30/99 bwatson added R_MSGFILE for weblink test
# 06/15/99 Jean exit 1 if there are test fail
# 07/08/99 Jean added cadds5_topology_test stuff
# 07/09/99 Jean changed run_str for java_async_test
# 07/21/99 KY   added chinese_tw and chinese_cn
# 08/10/99 Jean check capital letters in rundir for cadds5_topology_test
# 08/23/99 Jean added PTC_ILLIB stuff by request from Surit Prakash
# 08/26/99 Jean skip the run_only test first.
# 09/14/99 Jean added PURECOVOPTIONS stuff, requested by seshadri
# 10/08/99 Jean added check_build stuff
# 10/11/99 Jean give warning when exist ~/config.win.
# 11/16/99 Jean added pt_simple_async_test stuff.
# 12/01/99 Jean added /usr/openwin/lib to LD_LIBRARY_PATH
# 12/08/99 Jean added ${altlang}_nt stuff
# 12/06/99 Maya added PTC_ADVAPPSLIB.
# 01/11/00 Jean removed "store_display" from config.pro requested by Andy Wolf
# 02/16/00 Jean added run_if_set stuff.
# 03/15/00 Jean added R_PURECOVOPTIONS stuff requested by Sesh
# 04/06/00 Sesh more R_PURECOVOPTIONS fixes
# 04/13/00 Sesh more R_PURECOVOPTIONS fixes
# 04/17/00 Jean added OpenGL libraries in SHLIB_PATH (requested by watras)
# 04/19/00 Eshwar added java_sync_test stuff
# 05/25/00 Jean added alt_c5_converter stuff
# 06/16/00 Jean added R_PDEV_REGRES_BIN stuff and fix gettraceback
# 08/28/00 Jean added more alt_c5_converter fixes
# 09/11/00 Jean fix LD_LIBRARY_PATH for alt_c5_converter test
# 09/19/00 Jean save pd_develop.log or pt_toolkit.log to .tklog file
# 10/12/00 Jean more R_PDEV_REGRES_BIN fixes
# 10/18/00 Jean fixed typo
# 10/20/00 Jean check all dbgfile.dat files
# 11/08/00 Jean fixed another typo
# 11/13/00 Jean Copy .cfg only if it exist
# 11/14/00 Jean Copy pt_toolkit.log to $R_SUCC_TRAIL_DIR
# 11/28/00 Jean Append default config.pro before the one from trail dir
# 12/05/00 Jean Make run_if_set test success if not set.
# 12/06/00 Jean Added fbuilder_test
# 12/08/00 Jean changed www4 to netscape
# 12/13/00 Jean added skip.log stuff.
# 12/15/00 Jean Added probatch_test stuff.
# 12/20/00 Jean Added disk check for CADDS5 tests
# 01/02/01 Jean Fixed problem for generating empty config.pro.
# 01/03/01 Jean Added saving pt_test_initialize.log and PT*.log stuff.
# 01/05/01 Jean Remove P_VERSION
# 01/09/01 DB   Added distributed functionality
# 01/12/01 Jean made not_run_on_test match exact PRO_MACHINE_TYPE
# 01/17/01 Jean when MECH_HOME is set and no graphics, set DISPLAY
# 01/29/01 Jean check $TEMP for NT.
# 01/30/01 Jean Use ${TOOLDIR}pro_batch.
# 01/31/01 Jean added run_with_license stuff.
# 02/02/01 Jean more fixes for check display.
# 02/13/01 Jean Added xtop_add_args stuff
# 02/15/01 Jean Added plpf test stuff.
# 02/20/01 sberkeley Added mech_test stuff
# 02/22/01 Jean Added R_KEEP_FAILURE_DATA stuff
# 02/28/01 Jean fixed LM_LICENSE_FILE for plpf test
# 02/28/01 Jean Added R_PLPF_LICENSE
# 03/02/01 Jean use $MECH_HOME/.. for mech_test if no $trail_path/test....
# 03/06/01 Jean fixed demo_test.
# 03/07/01 Jean changed display to kuril
# 03/07/01 Jean fixed EXE_EXT and CSH_EXT
# 03/13/01 Jean fixed pd_demo_test
# 03/15/01 skazakov added PTC_ADVAPPSLIB for LD_LIBRARY_PATH (c5_converter)
# 03/16/01 Jean NT plpf test
# 03/21/01 Jean Added OPER_SYS to succ.log and fail.log
# 03/22/01 Jean Added production_test stuff.
# 03/26/01 Jean Added error message for $TEMP is not set
# 03/30/01 Tom  Changed name of --counts-file in PURECOVOPTIONS.
# 04/02/01 Jean Convert demo dir.
# 04/04/01 Jean fixed rec_copy_trail.
# 04/05/01 Jean Added double quotes for tmpdir to handle space in path.
# 04/10/01 Jean Added more double quotes
# 04/20/01 Jean Removed double quotes for copy auto_misc
# 05/02/01 Jean Added skip copy_mech failed tests
# 05/02/01 AEY  Removed setting for shared libraries' paths for alt_c5_converter
# 05/03/01 Jean Copy qcr files one by one if >= 255 files
# 05/09/01 Jean Reset trail_path and obj_path when skip copy_mech failed tests
# 05/21/01 Jean Added pt_asynchronous_tests stuff.
# 05/24/01 Jean Added -1 to fix NT chmod qcr
# 05/24/01 Jean reset trail_path after fail_skip.
# 06/20/01 Jean Added generic_ui_test stuff and use $PROE_START for async test
# 07/10/01 Jean Added R_POST_PROCESSING stuff.
# 07/13/01 Jean skip pt_asynchronous_tests if name service is not started.
# 07/19/01 Jean save pt_feattree.log
# 07/20/01 Jean Added the skip reason into the skip.log
# 07/22/01 vpu  Added batch_mode_test stuff
# 07/23/01 Jean probatch test fix for NT.
# 07/25/01 Jean use $PTCSYS/obj/nmsq
# 08/21/01 Jean More skip info.
# 09/06/01 Jean Added R_LOCAL_XTOP
# 09/10/01 Jean Fixes for geting copy_mech status on i486_win95.
# 09/14/01 Jean Updated license server.
# 09/18/01 Jean adeed .ptc.com for LM_LICENSE_FILE
# 09/18/01 Jean Fixed mech_copy fail result setting.
# 09/21/01 Jean skip mech_test and plpf tests if R_SUPERAUTO is set.
# 10/01/01 Jean Added wildfire_test stuff.
# 10/01/01 hgao R_SUPERAUTO fixes.
# 10/02/01 Jean more wildfire_test fixes.
# 10/05/01 Jean removed MECH_HOME check for mech_test.
# 10/08/01 Jean skip more test for R_SUPERAUTO is set.
# 10/10/01 Jean more wildfire_test fixes.
# 10/11/01 Jean more wildfire_test fixes.
# 10/15/01 Jean Added PROTOOL_DEBUG setting.
# 10/22/01 Jean Added LD_LIBRARYN32_PATH and LIBPATH setting for MOZILLA
# 10/23/01 Jean don't unset MOZILLA env if set failed.
# 10/24/01 Jean process predirective before running copy_mech.
# 10/25/01 Jean run with graphics mode 7 for wildfire_test.
# 10/29/01 Jean Added message for switch graphics mode for WildFire Test.
# 10/31/01 Jean Added R_SKIP_WILDFIRE_TEST stuff.
# 10/31/01 Scott Added R_TRAIL_PATH (used in java_sync_test script)
# 11/27/01 Jean Added Warning for switch to $MECH_HOME/..
# 12/10/01 Jean Added default_graphics stuff.
# 12/11/01 Jean Removed Warning for switch to $MECH_HOME/..
# 12/12/01 Ksenia Prokofjeva write run cdm result into succ fail log.
# 12/17/01 Jean Added running move_cursor for graphics and R_PERF test.
# 12/20/01 Jean Added showing MECHANISM_HOME and ANIMATION_HOME info.
# 12/31/01 Jean print out command.
# 01/10/02 Jean Added R_EMAIL
# 01/14/02 Jean Added PTC_MOZILLA_PROFILE stuff.
# 01/16/02 Jean Added anim_test and mdx_test stuff.
# 01/17/02 Jean Made fixes for CADDS5 stuff.
# 01/18/02 Jean More CADDS5 test fixes.
# 01/21/02 Jean Added R_NO_MSG_NEW.
# 01/30/02 Jean changed static to goodbye
# 02/06/02 Jean Added PTC_NO_PVX_AUTOINSTALL stuff.
# 02/14/02 Jean Removed test_display when MECH_HOME set.
# 02/28/02 Jean Use R_PDEV_REGRES_BIN for finding pt_tests_async_exec
# 02/28/02 Jean Added Profile superauto stuff.
# 03/18/02 Jean fixed reset_envs.
# 03/18/02 MBE  Clean up setenv, unsetenv afterwards
# 03/15/02 Jean Added check c5_converter_versions.
# 03/20/02 MTP  Added support for retrievals
# 04/05/02 Jean Change gprof to prof
# 04/08/02 Jean Added the "can't display" message into the skip.log.
# 04/09/02 Jean Find mon.out in subdir.
# 04/15/02 Jean Remove .sat file for dauto.
# 04/16/02 Jean Added skip messages for failed dlltest cmd.
# 04/23/02 Jean Added skip messages for succ skips.
# 04/25/02 Jean cleanup ODB processes when exit.
# 04/29/02 Jean Removed putting retain_display_memory in config.pro
# 04/26/02 Jean Added wf_js_test test stuff.
# 04/30/02 Jean Added test name after skipped.
# 05/01/02 Jean Set PTC_WF_ROOT for all tests.
# 05/07/02 Jean Set raw_trailname before run pre_directive_process.
# 05/07/02 Jean Remove dbgfile.dat after each test.
# 05/08/02 Jean Fixed R_KEEP_FAILURE_DATA
# 05/09/02 Jean set $dcad_stop=1 if get empty test.
# 05/13/02 Jean Changed path for purecov
# 05/13/02 Jean Append new dbgfile.dat to the existing one.
# 05/14/02 Jean put R_CP_TO_SCRATCH copy info to succ and fail log.
# 05/15/02 Jean Added ddl_test stuff.
# 05/16/02 Jean Added XLINK changes.
# 05/21/02 Jean More ddl_test stuff.
# 05/28/02 Jean More skip msg fix.
# 05/29/02 Jean More skip msg fix.
# 05/30/02 Jean wildfire_test switch to Graphics Mode only on NT
# 06/03/02 Jean Undo the dbgfile.dat changes.
# 06/06/02 Jean Undo the dbgfile.dat changes again.
# 06/12/02 Jean Save gecko_traceback.log.
# 06/13/02 Jean Added proevconf_test stuff.
# 06/13/02 Jean Added wildfire_pdm stuff.
# 06/17/02 Jean Skip perf_test.
# 06/18/02 Jean Check for PT*.log
# 06/19/02 Jean Added check_csd
# 06/26/02 Jean Added distapps_dsm and setenv_to_cwd stuff.
# 06/27/02 Jean Merged with perform.pl.
# 07/10/02 Jean More distapps test fixes.
# 07/11/02 Jean Check disk space for dauto.
# 07/11/02 Jean Pass copy_mech rel_trail_path and obj_path
# 07/12/02 Jean Added R_ALT_RETR_DIR.
# 07/17/02 RHB  Added bitmap related code.
# 07/18/02 Jean More for R_EMAIL
# 07/22/02 RHB  Removed die etc.
# 07/22/02 Jean Check disk space for dauto only when $ENV{LANG}=C.
# 07/22/02 Jean not set $mech_obj_path to $mech_trail_path.
# 07/24/02 Jean perf_test fixes.
# 07/24/02 Jean Check disk space for cadds5 only when $ENV{LANG}=C.
# 07/25/02 Jean removed Check disk space only when $ENV{LANG}=C.
# 07/29/02 Jean Added foreign_merge_errors.log stuff.
# 07/31/02 Jean Fixes for checking directives
# 08/01/02 Jean added $ui_graphics for proevconf tests
# 08/02/02 Jean added pro_symbol_dir for retr_test
# 08/06/02 Jean more proevconf tests fixes.
# 08/08/02 Jean added xsl to exclude_file list.
# 08/08/02 Jean handle perf_test objects same as others.
# 08/08/02 Jean more xlink fixes.
# 08/12/02 Jean another xlink fixes.
# 08/22/02 JSP  Make #run_only_on pattern match machine type exactly.
# 08/22/02 ABC  Change dsq_start_batchc to dsq_start_dbatchc.
# 08/26/02 pjagtap Added code so as to allow jlink tests run on multiple jdk versions.
# 09/03/02 Jean Removed variant_drawing_item_sizes, rename to ptcvconf etc.
# 09/03/02 Jean added override_store_back etc. for retr config.
# 09/03/02 Jean skip cmd line for trail.
# 09/04/02 Jean made the succ_skip and fail_skip in the same format.
# 09/05/02 Jean Fixed copy cmd for WF_ROOT_DIR.
# 09/09/02 Jean Print out SIM_STDS_PATH for mech_test.
# 09/16/02 Jean Fixed more double quotes for win2k
# 09/25/02 Jean More double quotes for win2k
# 09/26/02 Jean Added ptcsetup_test.
# 09/26/02 Jean Added html and js to exclude_file list.
# 09/27/02 Jean Use relative path for local xtop to make win2k happy.
# 10/01/02 Jean run dsq_stop_nmsd and move -nographics to end.
# 10/07/02 Jean changed to back slash for $my_local_xtop
# 10/09/02 Jean support automatic traceback on Sun.
# 10/09/02 ECW  Fix so japanese_test will trigger QCR copy
# 10/14/02 Jean skip the rest part for qcr failure if it has failed.
# 10/14/02 Jean disable the screensaver for i486_linux
# 10/18/02 Jean use run_cmd.pl and run_nt_cmd.pl to kill hanging tests
# 10/23/02 Jean added R_RENAME_HOME_CONFIG stuff.
# 10/24/02 Jean fixed checkspace for cadds5
# 10/28/02 Jean if not $wf_get, not get $wf_releass. Check $DCAD_TEMP dir.
# 11/06/02 Jean do not use run_cmd on hp8k.
# 11/11/02 Jean not use run_cmd on hpux11_pa32, removed PTC_NO_PVX_AUTOINSTALL
# 11/12/02 Jean not use run_cmd when not run from dauto.
# 11/14/02 Jean changed back about run_cmd.
# 11/18/02 Jean Use PTC_PARTLIBROOT for retr test.
# 11/18/02 Jean Added intralink_interaction stuff.
# 11/20/02 Jean Fixed copy_qcr to 150
# 11/22/02 Jean define VC_CS_HOST to rirons03d if it is not defined.
# 11/25/02 Jean use system for run_commands().
# 11/27/02 Jean Added PTCNMSPORT etc. settings.
# 11/27/02 Jean Added R_DISPLAY.
# 11/26/02 pjagtap updated init_others(). Added a check for ONLY_JDK_VERSION
# 12/03/02 JCN  proevconf_test changed.
# 12/03/02 Jean Added chinese_test and korean_test
# 12/03/02 aap  Added R_PERF_RESULT_COPIER.
# 12/06/02 Jean use system for run_commands() only for dsq_start_nmsd.
# 12/06/02 JCN  Cleanup interrupted proevconf_test.
# 12/09/02 Jean Do not allow to run when there are $HOME/.no_autopl.
# 12/09/02 Jean Use the line in .msg with '::' as well
# 12/10/02 pjagtap Added CLASSPATH setting for i486_linux
# 12/10/02 Jean Added DBATCHC_LOG_ALL setting
# 12/11/02 Jean Added PRO_LANG and handle db_client_trl.txt.1 etc.
# 12/10/02 Jean added interface_retrieval and multi_file stuff
# 12/12/02 Jean check dbgfile fixes for diff_mech.
# 12/16/02 Jean more distapps tests related fixes.
# 12/17/02 Jean do not filter out __1c functions for superauto
# 12/16/02 Alex Cleanup diff_mech return status.
# 12/19/02 Jean fixes for proevconf_test
# 01/02/03 Jean Added start/stop date and kill_xmx256m.
# 01/13/03 Jean Fixes for ddl_test.
# 01/13/03 Jean Use GetTrlUtil.pm.
# 01/21/03 Jean added graphics_test_on stuff.
# 02/04/03 Jean Set directive separate.
# 02/06/03 Jean unset $PTCNMSPORT for proevconf_test.
# 02/13/03 Jean search for core.* when gettraceback
# 02/17/03 RHB  fixed bitmap_test bugs.
# 02/17/03 Jean search for core* when gettraceback.
# 02/19/03 Jean Added PTC_WT_SERVER stuff.
# 02/21/03 Jean comment out copy /net/foot/disk1/version/index.html for now.
# 02/26/03 Jean Added pdmlink stuff.
# 02/26/03 Jean Fixes for distapps_dbatchc tests.
# 02/28/03 RHB Added newline before force_base_size
# 02/28/03 Jean Exit if running 7 graphics and not set display to local host.
# 03/03/03 Jean Added auto_cleanup_cadds5
# 03/12/03 Jean Added setenv_hold, OKTOFAIL and many other fixes.
# 03/17/03 Jean Fixes for NT OKTOFAIL.
# 03/18/03 Jean Removed the logic for VC_CS_HOST
# 03/18/03 Jean User hostname -s for i486_linux
# 03/19/03 Jean Fixes for qcr_script, PTC_WT_SERVER, run command etc.
# 03/26/03 Jean Added is_groove_import_vcard stuff.
# 03/26/03 Jean Added latin_lang_test stuff.
# 03/31/03 Jean Set PRO_MECH_COMMAND etc.
# 04/07/03 Jean Make the chinese_test only run for traditional chinese.
# 04/09/03 Jean xlink test changes.
# 04/09/03 Jean Fixed NT bug for check_dbgfile and set PVIEW_PROEPLUGIN_TEST
# 04/11/03 Jean OOS.qcr fix, PTC_WF_ROOT setting etc.
# 04/15/03 Jean release wildfire PDM server when ctrl-c.
# 04/23/03 Jean Fixes for probatch_test.
# 04/30/03 Jean more wildfire_test fixes.
# 05/01/03 Jean Allow set display to :0.0 or :0.
# 05/05/03 Jean wildfire_test wildfire_pdm related fixes.
# 05/05/03 Jean Added batch_trail_test stuff.
# 05/05/03 Jean Added R_EXCLUDE_INTF stuff.
# 05/07/03 Jean check_display for all mech_test and run_if_set MECH_HOME.
# 05/14/03 Jean more is_groove_import_vcard stuff.
# 05/19/03 Jean more is_groove_import_vcard fixes
# 05/21/03 Jean removed pdmlink code, fixes for batch_trail_test.
# 05/27/03 Jean more fixes for batch_trail_test.
# 05/29/03 Jean Fixed get_fail_line_num.
# 06/05/03 ALS  Modified to run Pre and Post Scripts for directive #wf_js_test
# 06/16/03 Jean Added pt_retrieval_tests stuff.
# 06/18/03 Jean Removed copy files from auto_misc dir in get_version.
# 06/26/03 Jean Fixed bug in succ_skip and fail_skip.
# 07/27/03 NCK  Ported for cygwin. Source unix style scripts for cygwin on NT
# 07/21/03 Jean Added backward_trail and backward_retr stuff.
# 07/22/03 Jean Don't report crash and oos as qcr.
# 07/24/03 Jean Changed pt_retrieval to pt_retrieve.
# 07/29/03 Jean fixes for batch_trail_test.
# 07/23/03 JCN  Revamped JDK/Java/CLASSPATH handling for J-Link (proj 13013682)
# 07/31/03 Jean Use move_cursor from /tools.
# 08/26/03 Jean Added ug_test stuff.
# 08/28/03 Jean Added uninstall_pvx_silent stuff.
# 09/02/03 Jean Made cmd associate with the related trail.
# 09/08/03 JCN  Added distapps_dsapi directive.
# 09/09/03 Jean Fixed ugs_root_dir for NT.
# 09/09/03 Jean skip proevconf_test if there are tsd process running.
# 09/10/03 Jean Added R_EXCLUDE_RETR stuff.
# 09/10/03 Jean More proevconf_test fixes.
# 09/15/03 Jean R_NO_BATCH_TRAIL related fixes.
# 09/16/03 ECW  CLONE related fixes
# 09/17/03 Jean Changed the order of the license servers
# 09/17/03 Jean Don't run uninstall_pvx_silent on win95
# 09/23/03 Jean Delete LICENSE_FILE env by default.
# 09/24/03 Jean Comment out the previous change.
# 09/25/03 Jean run csd_cleanup after each conference test.
# 09/29/03 Uday NT fixes for UG interface testing.
# 09/29/03 Jean Sleep 5 minutes after xtop back.
# 09/30/03 Jean Do not set dsm_machine for distapps_dsapi test.
# 09/30/03 Jean Make test as skip for conference tests when server overload.
# 10/01/03 Jean make all mech_test as run_with_license tests.
# 10/02/03 Jean Use PTC_D_LICENSE_FILE instead.
# 10/03/03 Jean proevconf_test related fixes.
# 10/06/03 Jean Still use LM_LICENSE_FILE for now.
# 10/06/03 Jean Added check_license_server
# 10/06/03 Jean delete PRO_LICENSE_RES and PROE_FEATURE_NAME also.
# 10/08/03 Jean more clean_cache stuff.
# 10/08/03 Jean more proevconf_test related fixes.
# 10/13/03 CYL/AK use VERBOSE=NO for wf_get
# 10/21/03 Jean added copy jre plugin trace.
# 10/21/03 Jean devide 256 if $run_stat >= 256
# 10/22/03 Jean don't use PROE_START for async_test, added them to superauto.
# 10/23/03 Jean fixed typo.
# 10/24/03 Jean added prokernel_test
# 10/27/03 Jean added not_run_with_lang
# 10/30/03 Jean added server_problem etc.
# 10/30/03 Jean more prokernel_test
# 10/30/03 Jean added R_GRANITE_TESTS_BIN
# 11/03/03 utekade added more checks for Unigraphics regression tests
# 11/06/03 Jean run dsq_start_nmsd after unset PTCNMSPORT.
# 11/12/03 Jean skip the distapps_dsapi test if ds_c_clnt_tests not exist
# 11/13/03 Jean do not create msg file if run command failed.
# 11/18/03 DPB  fixed formatting for skip reporting case when no trail found
# 11/19/03 Jean Fixes for R_KEEP_FAILURE_DATA
# 11/19/03 Jean/Shturm Ignore run_with_license if used local license file
# 11/25/03 Jean fixes for setting license server.
# 12/01/03 Jean more fixes for setting license server.
# 12/03/03 Jean changed the syntax for the check_build.
# 12/04/03 Jean force to run correct nmsq when running with localinstall
# 12/11/03 shirsch Added PTWT_FASTREG_URL
# 01/07/04 Jean added FastregSetup stuff.
# 01/16/04 Jean Added mech_test_long stuff.
# 01/29/04 Jean do not append std.err for retr_test.
# 01/29/04 JCN  No special Java handling for SGI
# 02/04/04 Jean Added R_RUN_MECH_TEST.
# 02/05/04 Jean make it fail_skip when R_RUN_MECH_TEST.. not true
# 02/12/04 Jean more skip mech_test_long stuff.
# 02/20/04 Jean Added hpux11_pa32 and sun4_solaris_64 for setting shared lib
# 02/23/04 Jean gettraceback only for failed test.
# 02/24/04 Jean copy qcr result to trail_name dir and other fixes.
# 03/01/04 Jean Added R_PRE_TEST_SCRIPT and R_POST_TEST_SCRIPT
# 03/03/04 Jean Expand the environment variables for setenv.
# 03/09/04 Jean Added pt_wt_asynchronous_tests stuff.
# 03/12/04 Jean Fixed write_succ_result for NT.
# 03/19/04 Jean Added new license servers, fixed test_num for succ_skip.
# 03/28/04 JSP  Change all AX_TOOLDIR refs to TOOLDIR
# 04/01/04 Jean Added ug_dbatch_test
# 04/12/04 Jean Do not run dsq_start_nmsd for distapps_dbatchc test.
# 04/19/04 DPB  added R_PERF_SKIP_COPIER and modified get_perf_results subroutine
# 04/23/04 Jean Added _RLD_ARGS stuff.
# 05/04/04 Jean Added startup_perf stuff.
# 05/05/04 Jean Added directive_hold stuff.
# 05/10/04 Jean Move setenv to last, 3264 change for asynchronous test
# 05/19/04 Jean Remove dbgfile.dat to let associated test pass if it is.
# 05/24/04 Jean Move R_PERF_SKIP_COPIER into loop
# 05/25/04 Jean Added run_only_on_test to directive_hold.
# 06/01/04 Jean Added init_local_build_env
# 06/16/04 Jean reset $wildfire_test_vars.
# 06/22/04 Jean Added uitoolkit_app_test stuff.
# 06/24/04 Jean Use set_dm_user_passwd to find WF_USERNAME and WF_PASSWD.
# 07/06/04 suapte fixes in parse_txt_for_bitmap
# 07/06/04 Jean Added mech_motion_test stuff.
# 07/07/04 Jean Fixes for get_fail_line_num.
# 07/14/04 Jean Added R_MERGE_CONFIG stuff.
# 07/15/04 Jean Run set_dm_user_passwd for each trail.
# 07/22/04 Jean Allow the graphics_test to have graphics mode arguments.
# 07/30/04 Jean Added checking ptcscom stuff.
# 08/24/04 Jean Added non_graphics_test_on stuff and fixed run_with_license
# 09/02/04 Chris Output memory usage info in succ.log
# 09/02/04 Jean Added permissions for *_WF_ROOT_DIR dir.
# 09/09/04 Jean Added disable screen for NT.
# 09/10/04 Jean Turn on graphics for wildfire non-server tests on NT.
# 09/13/04 Jean Fixed a bug for R_MERGE_CONFIG
# 09/17/04 Jean Made bitmap failure identify fixes.
# 10/20/04 Jean comment out check ptcmisc
# 10/21/04 Jean Added setting R_AUTO_RUNNING to true
# 10/28/04 Jean Changed UG license port number to 27005.
# 11/01/04 Jean Added random wildfire test stuff.
# 11/04/04 DPB  Added new_ug_test directive
# 11/05/04 Jean remove ptcmisc check and check PTC_PROLIBS instead.
# 11/18/04 JSP  Call prokernel_exe via /tools/bin script instead of $PTCSYS/obj directly
# 12/03/04 JSP  Call prokernel_exe via /tools/bin script using $TOOLDIR
# 12/03/04 Jean Fixed bug for TMP_DIR_DEBUG case.
# 12/09/04 Jean Added setenv_to_cwd_and stuff.
# 12/13/04 Jean Fixed bug for putting memory message into succ.log.
# 12/14/04 Jean Run gettraceback for mech_test.
# 12/21/04 Jean Print out the diskspace in case fail.
# 01/05/05 DPB  added R_SAVE_AS
# 01/05/05 Jean More print out for checkspace
# 01/06/05 DPB  prepended existing LM_LICENSE_FILE to auto LM_LICENSE_FILE
# 01/06/05 Jean added R_NO_MECH_DATA
# 01/07/05 Jean only use goodbye.ptc.com as license server.
# 01/07/05 Jean added memuse stuff.
# 01/10/05 Jean use LM_LICENSE_FILE only for P_VERSION < 240
# 01/10/05 Jean changed license server again.
# 01/12/05 DPB  Added fail skip case for run_if_set MECH_HOME.
# 01/12/05 Jean added delete PTC_D_LICENSE_FILE.
# 01/12/05 Jean added dump env to env.log
# 01/13/05 DPB  better fix for run_if_set also added to mdx_test and anim_test R_RUN_MECH_TEST
# 01/13/05 Jean added print out PTC_D_LICENSE_FILE.
# 01/14/05 Jean not need for RUN_PROKERNEL_TEST to run Granite
# 01/18/05 Jean avoid to print junk to fail.log
# 01/19/05 Jean Changed license server again
# 01/20/05 Jean print out PTC_D_LICENSE_FILE etc. for fail test only
# 01/24/05 Jean more fix for PTC_D_LICENSE_FILE print out
# 01/27/05 Jean added SKIP_PROKERNEL_TEST
# 01/28/05 Jean made SKIP_PROKERNEL_TEST ship and fail.
# 02/02/05 Jean Changed license server again
# 02/07/05 Jean Fixed bug for R_REGRES_BIN stuff.
# 02/07/05 Jean set R_REGRES_BIN if it not set and P_CURR_PROJ etc. set.
# 02/09/05 Jean handle the 3rd column in auto_env_vars.txt
# 02/10/05 Jean added R_OLD_QCR_DIR
# 02/14/05 Jean Added R_SUCC_SAVE_ALL
# 02/15/05 Jean Changed license server again
# 02/18/05 Jean Added R_ALT_TRAIL_PATH, and changed license server again
# 02/22/05 DPB  moved R_SAVE_AS to post_run_process routine
# 02/23/05 Jean put R_SAVE_AS data to testname dir, run #mech_test for superauto
# 02/24/05 Jean put R_SAVE_AS data back to testname_saveas.
# 03/02/05 Jean check {R_REGRES_BIN}32 as well.
# 03/02/05 Jean Show deviation for memuse.
# 03/08/05 Jean Added R_REGRES_BIN to LD_LIBRARY_PATH for unix and PATH for NT.
# 03/14/05 Jean set back to old display if test_display failed again.
# 03/23/05 Jean Added R_ALT_MEMUSE.
# 03/24/05 Jean Fixed grep Peak system size from std.out for NT, copy .crc.
# 03/28/05 Jean Fixed typo for add R_REGRES_BIN to LD_LIBRARY_PATH
# 03/30/05 Jean Added some single quotes for xtop.
# 04/05/05 Jean Fixed bug for R_ALT_MEMUSE
# 04/05/05 Jean do not put setenv infor into succ/fail log.
# 04/11/05 Jean undid the single quotes for xtop change.
# 04/20/05 JSP  Move R_GRANITE_TESTS_BIN into /tools/bin/granite*.csh scripts
# 04/27/05 Jean use getversiondir to get PTC_D_LICENSE_FILE
# 04/29/05 Jean chop off '\n' from 'getversiondir' string.
# 05/02/05 Jean set PROE_START to local_xtop.
# 05/03/05 Jean Allow multipl setenv_to_cwd for a test
# 05/04/05 akonshin added use FindBin;use lib "$FindBin::Bin". As result all modules will be looking in start directory first.
# 05/04/05 akonshin module FastregSetup.pm is removed
# 05/04/05 akonshin new module Fastreg.pm do all fastreg related tasks: initializing, parsing directive, get/release Windchill.
# 05/04/05 Jean Do not set PROE_START to local_xtop
# 05/04/05 Jean Added check_ram_test
# 05/05/05 Jean set PROE_START to local_xtop only for distapps_dbatchc
# 05/12/05 Jean run with batch trail only if R_BATCH_TRAIL is set to true
# 05/12/05 Jean made a fix to save_all_core to save all core* files
# 05/26/05 Jean be able to handle multiple core files on sun for traceback
# 06/07/05 Jean Set perf_test to wildfire_test
# 06/20/05 Jean Added RUN_TIME_FAIL for perf test
# 07/06/05 Jean Do not remove error information for perf_test
# 07/14/05 Jean Change to relative path only when there are spaces
# 07/22/05 Jean wildfire reg tests by default in Non Graphics mode on Windows.
# 08/17/05 DPB  added P_VERSION to log headers
# 08/18/05 pleb Added script_test
# 08/23/05 Jean skip and succ for check_ram_test on < 1GB RAM machine
# 08/24/05 Jean Do not run qcr_script for lang tests.
# 08/26/05 Jean When ANIMATION_HOME and MECHANISM_HOME not exist fail/skip
# 08/29/05 npant Added env variables to run UGNX2 tests for Mechanica.
# 08/30/05 Jean handle run_only_on and run_only_on for multiple trail.
# 08/31/05 Jean fixed record memuse info to succ.log for k03
# 08/31/05 Jean fixed a bug from handle run_only_on etc.
# 09/02/05 Jean undo some handle run_only_on and run_only_on for multiple trail
# 09/06/05 npant Added check for PATH for UGNX2.
# 09/12/05 pleb Added separate handler for script_test (ignore other run_str)
# 09/15/05 JCN  Added x86e_win64 handling for 32/64 Pro/TK tests
# 09/15/05 Jean Fixes for zero_run_mode_test and added NT to check_ram_test
# 09/21/05 Jean fixed LD_LIBRARY_PATH setting for UGNX2 (set back after run).
# 09/21/05 pleb Added uwgm_test
# 09/22/05 npant Block config.pro messages for Mechanica UG tests.
# 09/23/05 Jean Made english_test, none_graphics_test, check_ram_test as
#       trail related.
# 09/26/05 Jean append R_REGRES_BIN to R_PDEV_REGRES_BIN if it is set.
# 09/26/05 Jean process succ_skip directive first, no rec_copy_trail for retr
# 09/28/05 Jean fail and skip retr test when copy_object fail.
# 09/29/05 Jean Change display machine to oforce
# 09/30/05 npant Added UG NX 3.0.
# 10/04/05 Jean Save trailname.dslog for distapps_dsapi when test fail
# 10/14/05 Jean Allow multiple directive_hold for a trail and more dslog fix.
# 10/21/05 Jean Added check_bitmap_file for bitmap test if bitmap_fail.dat
# 11/02/05 Jean Added R_NOVERSION stuff.
# 07/26/05 Jean Added release_last for the wildfire_test.
# 11/17/05 Jean run all perf_test as run_with_license.
# 11/28/05 Jean Print out run_with_license information
# 11/29/05 Jean undid the run all perf_test as run_with_license change
# 12/06/05 Jean added if_exist stuff.
# 12/08/05 DPB  skip if #run_if_set MECHANISM_HOME and ANIMATION_HOME
#               (for initial build)
# 12/08/05 Jean More fixes for if_exist stuff.
# 12/09/05 Jean Added R_ENABLE_IF_EXIST
# 12/14/05 AGARG Added run granite java test stuff.
# 12/15/05 Jean replace fgrep with grep
# 12/21/05 Jean Do not put qcr fail result into trailname_dll dir any more.
# 12/30/05 Jean Added print for PRE_RUN_SCRIPT
# 01/04/06 Jean fail skip plpf test if the flexgeneric doesn't exist.
# 01/11/06 Jean Set raw_trailname before pre_directive_process for mech_test
# 01/13/06 Jean Added qcr error infor into .msg file for qcr_script test
# 01/24/06 Jean Added flex_lic_chk stuff and pre_directive_process_skip.
# 01/26/06 Jean Fixed a typo for R_RUN_MECH_TEST_LONG stuff
# 02/01/06 Jean Added no_future_mode stuff.
# 02/01/06 DPB  added skip message for R_PERF_SKIP_COPIER
# 02/10/06 Jean Added R_SKIP_TOOLKIT and R_SKIP_JAVA stuff
# 02/13/06 Jean Make fix for getting traceback for other executables.
# 02/20/06 Jean use run_cmd only if OS_TYPE is UNIX.
# 02/20/06 Jean Added R_HWINFO stuff.
# 02/21/06 Jean Fixes for succ_skip and fail_skip.
# 02/21/06 Jean Fixes for the pre_directive_process_skip.
# 02/27/06 Jean Made enhancements for backward_trail test
# 03/01/06 DPB  Modified skip messages
# 03/06/06 Jean Added gcri_test stuff and support multiple retrieval test
# 03/07/06 Jean Added mech related environement variables print out
# 03/10/06 Jean exclude file with core.proe_ext when gettraceback
# 03/16/06 Jean Append STRICT_PLAYBACK message to succ.log
# 03/21/06 Jean Skip the test if copy_objects fail.
# 03/22/06 Jean More gcri_test related fixes.
# 03/23/06 Jean Do not skip the test if copy_objects fail for now.
# 04/03/06 Jean Allow version argument for gcri_test
# 04/03/06 Jean Made backward_trail work the new way even if R_BACKWARD is set
# 04/05/06 Jean let sun debugger find correct executable for the core file
# 04/07/06 Jean Fixed copy_images
# 04/11/06 Jean Added no_graphics_mode_on
# 04/13/06 Jean More fixes for the bitmap test
# 04/21/06 Jean Do not append the hwinfo.log to .msg file.
# 04/25/06 Jean Use regedit_win64 for win64
# 05/01/06 Jean UG test changes by Dave
# 05/02/06 Jean bitmap path changes by Dave
# 05/09/06 Jean Do not reset MOZILLA_FIVE_HOME
# 05/19/06 Jean Added -g to put static functions into superauto database
# 05/23/06 Jean reset $setenv_to_cwd
# 05/26/06 Jean set DISPLAY to skyhawk for hp
# 05/27/06 DPB  don't make res_path to for spg or spgreg
# 06/01/06 Jean let sun debugger find executable only when xtop path < 70 
# 06/07/06 AMIT Changed %PARTS location of Granite objects 
# 06/06/06 Jean Added mathcad_test stuff.
# 06/14/06 DPB  Ignore if_exist targets that are marked NA in autoexist.txt
# 06/14/06 Jean Use separate list for no_graphics_mode_on
# 06/15/06 Jean More ignore if_exist targets that are marked NA
# 06/19/06 Jean Added missing skip reason into skip.log
# 06/21/06 Jean Added no_mathcad_test, made autoexist_db multi-words
# 06/22/06 Jean Made if_exist become trail related.
# 06/22/06 Jean Added warning when csd server is not running at start.
# 06/29/06 Jean Changed bitmap log file to bitmap.log 
# 07/18/06 DPB  changed res_path again to better suit
#               migration of bitmap images under PTCSRC
# 07/18/06 Jean Added post_cmd directive
# 07/18/06 DPB  set bitdb_path to $PTCSRC by default
#               and override bitdb_path with R_BITMAPDB_PATH 
# 07/19/06 Jean  Made enhancement for post_cmd directive
# 07/27/06 pdeshmuk Added pfcvb_test
# 08/01/06 Jean  Fixed a typo.
# 08/25/06 Jean  Skip empty env for run_if_set
# 08/28/06 Jean  Added improper integration fail type.
# 08/30/06 DPB   get memory info when MEMUSAGE_ON_EXIT is set
# 08/31/06 Jean  Added missing qcr check.
# 09/05/06 Jean  Added copy pfcvb_tests.pdb
# 09/06/06 Jean  Added MEMUSE print out for this kind of failure.
# 09/12/06 Jean  Support UG NX4 and check $TEMP write access.
# 09/13/06 Jean  Added setting PFCLS_START_DIR.
# 09/18/06 Jean  Made unsetenv directive as trail related.
# 09/18/06 Jean  Handle retr test the same when copy object failed.
# 09/18/06 Jean  Do not overwrite the LD_LIBRARY_PATH for ug_test
# 09/22/06 Jean  Added print R_ALT_SIM_STDS_PATH information.
# 09/29/06 Jean  Set R_MEMUSE for the memuse test
# 10/02/06 Jean  Do not run prokernel_test for superauto
# 10/03/06 DPB   added R_NEW_BITIMAGE_PATH
# 10/03/06 Jean  reset fastreg_test_flags
# 10/04/06 Jean  do not call set_mozilla_env if MOZILLA_FIVE_HOME is not set
#                removed -v for ptc_gecko_server.
# 10/04/06 Jean  Set TEMP to scratch_tmp for NT
# 10/06/06 Jean  set zero_run_mode_test to wildfire_test.
# 10/17/06 Jean  Added pro_illustrate_test stuff and fixes for perf_test.
# 10/18/06 Jean  Unset IS_PRO_ILLUSTRATE after pro_illustrate_test done
# 10/19/06 Jean  Added open_access_test stuff
# 10/25/06 Jean  Added more usage information
# 10/25/06 Jean  Run regsvr32 instead of regedit to avoid popup for vista.
# 10/26/06 Jean  Use Win32::Registry to check MathCad install.
# 10/27/06 Jean  Do not run wf_js_postrun after each wf_js_test.
# 10/27/06 Jean  Added L10N stuff.
# 10/30/06 Jean  Use 'set_altlang' from GetTrlUtil.pm
# 10/30/06 Maya  Changes for UWGM client regression tests
# 10/31/06 Jean  Fixed typo for res_path
# 11/02/06 Jean  Switch to Graphics Mode for L10N_test when altlang
# 11/06/06 Jean  Undid the switch to Graphics Mode for L10N_test change
# 11/07/06 Jean  Added warning for exist config.win.* in home dir.
# 11/07/06 Jean  Added R_FIX_TRAIL_SCRIPT etc.
# 11/08/06 Jean  Redo the config.win fix.
# 11/13/06 Maya  uwgmclient.ini -> wgmclient.ini
# 11/13/06 Jean  Added R_NO_UNINSTALL_PVX, save .xml and .log for uwgm_test
# 11/20/06 Jean  Support new run_with_license format, added not_run_test stuff
# 11/21/06 Jean  Support R_RUNMODE for backward_retr.
# 11/27/06 Jean  If R_GETTB_CORE is defined, gettraceback.
# 12/07/06 Jean  Fixed a bug on gettraceback when in dir with dot
# 12/08/06 Jean  Added print_other_envs stuff.
# 12/11/06 Jean  Create env.log first.
# 12/12/06 Jean  More print_other_envs fixes.
# 12/12/06 Jean  Comment out print_other_envs for now.
# 12/21/06 Jean  Comment out / remove check_csd
# 01/02/07 Jean  Turn on print_other_envs and obsolete PRO_DOCS, R_USEKEY etc.
# 01/09/07 Jean  Fixes for i486_nt UG NX test path setting.
# 01/17/07 Jean  Added dotnet_test stuff.
# 01/18/07 DPB   removed bitmap spg/spgreg specific code
# 01/18/07 Jean  Removed dotnet_test stuff.
# 01/22/07 Jean  allow the cmd command skip/pass test when return 99.
# 01 30/07 Jean  Added setting UGII_FLEX_BUNDLE
# 01/30/07 Jean  Made ug_test as flex_lic_chk, skip fail if run_if_set not set
# 02/06/07 Jean  Added mathcad_version stuff.
# 02/09/07 Jean  Remove the empty core to avoid confusing.
# 02/12/07 Jean  Set UGII_FLEX_BUNDLE for all UG test.
# 02/13/07 Jean  Fix for run_with_license, made devia negtive when decrease
# 02/14/07 Jean  Temp fix for sun long path gettraceback
# 02/15/07 Jean  Added memuse_os stuff, so only check memuse on matched OS
# 02/19/07 Jean  Removed pro_illustrate_test directive
# 03/01/07 Jean  Exit if not under home in cygwin.
# 03/05/07 Jean  Put fixit back.
# 03/08/07 Jean  Create scratch_tmp early.
# 03/09/07 Jean  Support x86e_win64 for pfcvb reg tests
# 03/21/07 Jean  pre-register current xtop when running performance tests.
# 03/23/07 Jean  chmod to full permission before remove tmpdir.
# 03/26/07 Jean  registering, not unregistering (regsvr32)
# 03/26/07 Jean  Added R_BITMAP_LOCAL_IMAGE stuff.
# 03/29/07 Jean  Added R_TEST_SPR temp fix.
# 04/06/07 Jean  R_BITMAP_LOCAL_IMAGE related fixes.
# 04/10/07 pleb  Updated set_dm_user_passwd
# 04/17/07 DPB   Added R_IF_EXIST_CHECK functionality case# 13838
# 04/18/07 DPB   Made message for undefined #if_exist keywords more clear
# 04/19/07 Jean  Made fix for copy to R_SUCC_TRAIL_DIR
# 04/23/07 Jean  Added R_INTEG_WAIT stuff.
# 04/25/07 AC    Changed the call of regsvr32 to ptcregsvr and added pvx_install
# 04/30/07 Jean  Added LOCALPROE
# 04/30/07 Jean  Added EDAcompare_test and fix a bug for check mathcad install
# 05/07/07 Jean  Added R_NO_WRAP. unset LOCALPROE for backward_trail.
# 05/08/07 Jean  Added kill_mathcad directive.
# 05/09/07 JCN   java_async_test uses "trailname".csh locally.
# 05/18/07 Jean  Do not run mech_test for superauto, sleep 1 before rm tmpdir
# 05/23/07 Jean  Delete existing tmpdir to avoid lots of scratch$n.
# 05/24/07 Jean  Set UGII_UGSOLIDS_TMP.
# 05/31/07 Jean  Removed kill_mathcad directive.
# 06/01/07 Jean  Run L10N in graphics mode 7 only, added not_run_with_graphics
# 06/04/07 DPB   added another ugs_config.pro option for #ug_test
# 06/05/07 DPB   Added kill UgToPro processes on postrun for #ug_test
# 06/13/07 Jean  Filter out core.prt, core.asm and core.mfg.
# 06/13/07 Jean  More R_BITMAP_LOCAL_IMAGE related fixes.
# 06/15/07 Jean  Set GR_ANNOT_FULL
# 06/18/07 Jean  Added R_KEEP_FAILURE_RESULT.
# 06/21/07 Jean  Added keep directive
# 06/22/07 Jean  More keep directive related fixes
# 07/06/07 Jean  Added PROWT_JS_DLL stuff.
# 07/09/07 Jean  Added PTC_ILLIB etc. to LD_LIBRARY_PATH for sun_solaris_x64
# 07/11/07 Jean  Allow to have argument for check_ram_test
# 07/12/07 DPB   changed to consistant fail.log output in run_commands routine
# 07/13/07 Jean  keep directive related dauto fixes
# 07/13/07 Jean  keep directive fix again.
# 07/16/07 Jean  Added R_PFCLSCOM_DIR stuff.
# 07/18/07 Jean  Added drm_test directive
# 07/20/07 Jean  Added ipc_test directive
# 07/23/07 Jean  More keep directive fixes.
# 07/24/07 Jean  Run uwgm_test without run_nt_cmd on windows.
# 07/25/07 Jean  Another keep directive fix.
# 07/25/07 Jean  Added legacy_encoding_test directive.
# 07/26/07 Jean  Added R_IGNORE_XTOP stuff.
# 07/27/07 Jean  More legacy_encoding_test fixes.
# 08/21/07 Jean  Fixes for multi object fail skip.
# 08/21/07 Jean  Allow to have argument for drm_test.
# 08/22/07 Jean  More R_IGNORE_XTOP stuff.
# 08/23/07 Jean  Changed the logic of no_mathcad_test for NT (case 14609)
# 08/27/07 aap   Modified get_perf_results.
# 08/28/07 Jean  Set R_FIO_SERVER for drm_test.
# 09/06/07 rct   Fix gettraceback() for Sun
# 09/11/07 Jean  Set R_FIO_SERVER to different value.
# 10/01/07 DPB   Added granite support to R_IF_EXIST_CHECK
#                and fix bug in R_SAVE_TRUSS
# 10/09/07 ssanyal Changed R_FIO_SERVER URL from https to http (Case# 14777)
# 10/15/07 ssanyal Changed R_FIO_SERVER URL (Case# 15016)
# 10/24/07 vsomwans drm tests set environemt variables 14608
# 10/26/07 MTP   do not set SHLIB_PATH for hpux_pa64
# 10/31/07 vsomwans Removed unnecessary '}' for drm test
# 11/08/07 dbarnes run drm_test if R_RUN_DRM_TESTS is set to true
# 11/13/07 austin added ugsnx5 support for the #ug_test directive
# 11/19/07 ssanyal/vsomwans Fix bug with #drm_test, delete drm cache (#15015)
#                 run obsolete_test if R_RUN_OBSOLETE_TEST is true (#15173)
# 12/11/07 ssanyal/vsomwans Fix bug with legacy encoding test for dauto (#15085)
# 12/12/07 vsomwans Resubmitted the fix for 3dic tests on sun_solaris_x64 14979
# 12/12/07 Chris  Initial support for basic PV ECAD reg tests
# 01/02/08 ssanyal Added support for force_drm (Case# 15231)
# 01/08/08 dbarnes change mathcad_test to use modified mathcad_register
# 01/16/08 vsomwans/ssanyal Fix for backward trail (#15064)
# 01/18/08 ssanyal Kill CatiaToPro if catia_v5_test fails (#15360)
# 02/29/08 ssanyal Skip/fail drm tests if /dev/urandom is not found on hp (#15272)
# 04/01/08 dbarnes ignore plus char fix for R_IF_EXIST_CHECK (#16107)
# 04/02/08 ssanyal Remove check for $HOME in Cygwin environment
# 04/07/08 Hanna Adapt to RSD - new directive rsd_test and let auto recognise .bac as test trail files.
# 04/16/08 vsomwans run IE settings for wf_js* tests (#14769)
# 04/17/08 ssanyal Kill JtToPro, PvToPro if jt_test, pv_test fails (#16125)
# 05/09/08 vsomwans Remove .cmp files for backward trail (#16237)
# 05/19/08 dbarnes force set DRM_DISABLE_OFFLINE per kprokofjeva request
# 06/09/08 vsomwans/ssanyal Fix for backward trail (#15984)
# 06/11/08 vsomwans/ssanyal Further fixes for backward trail 
# 07/08/08 ssanyal Modified cadds5_topology_test, removed alt_c5_converter (#16624)
# 07/10/08 vsomwans Reset num_cmd directive for perf tests
# 07/14/08 ssanyal Added support for #solidworks_test (#16326)
# 07/15/08 sjahagir Use i486_nt perl for x86e_win64
# 07/15/08 svn Added support for ARTS interaction tests
# 08/07/08 ssanyal Asaf's changes for bitmap tests (#16886)
# 08/18/08 ssanyal Bug fix for review_test skip condition (#16932)
# 10/03/08 ssanyal Changed UGS_LICENSE_BUNDLE for ugsnx5 (#17207)
# 10/16/08 ssanyal Added directive #add_to_config (#17179)
#                  Support mozilla on windows (#17095)
# 12/20/08 snikolay Hide unnecessary debug info. Setting env FASTREG_DEBUG adds it to fail log
# 01/08/09 sjahagir Fixed  clean_cache (#17713)
# 01/09/09 AEY Set R_BY_BACKWARD_CMD for backward tests.
# 02/03/09 sjahagir Fixed license file error on chinese 64bit windows (#17331,#17481,#17482). 
# 02/24/09 ssanyal  Changed drm server (#18096)
# 03/19/09 sjahagir Unset R_BY_BACKWARD_CMD (#16019). 
# 03/31/09 ssanyal  Changes for purecoverage
# 04/01/09 sperry   Change UGII_FLEX_BUNDLE due to license change
# 04/22/09 ssanyal  Changes for purecoverage
# 04/22/09 sjahagir Unset $PRO_RES_DIRECTORY in backward trail (#18316)
# 05/29/09 ssanyal  Copy bitmap images for interface_retrieval tests (#18491)
# 06/17/09 vmahajan Changes for perl510
# 07/16/09 sjahagir Commented set $LANG to $PRO_LANG. Moved it to GetTrlUtil.pm (#18932) 
# 08/03/09 ssanyal  Changed run_nt_cmd.pl to run_nt_job.pl (#18265, #18296)
# 08/05/09 ssanyal  Delete WF_ROOT_DIR after every test (#18657)
# 08/13/09 ssanyal  Copy *.rbn files to scratch directory (#18840)
# 08/20/09 ssanyal  Added pvecadcompare_perform_test, pvvalidate_perform_test (#19027)
# 09/10/09 ssanyal  Added inventor_test (#18293)
# 09/28/09 SJB      Reduce clutter in Mechanica output.
# 11/05/09 ewa      Processed cbp files.
# 11/25/09 sjahagir Added $java_version for java_async_test (#19405) 
# 12/14/09 sjahagir Added not_run_with_xtop_md directive (#19402) 
# 01/07/10 ssanyal  Added lda_test (#18995)
# 01/22/10 snikolay Adding support for UWGM interaction tests (merging changes from Yutaka).
# 02/02/10 sjahagir Overhauled mathcad version check, added support for mathcad prime (#19582)
# 02/12/10 sjahagir Added support for ugnx6 test (#19391)
# 02/13/10 snikolay Modified the logic copying of folder WF_ROOT_DIR after failures (wildfire tests)
# 03/04/10 ssanyal  Copy .png and .sdf files (#19854)
# 03/10/10 ssanyal  Fixed #setenv bug in set_directive
# 03/17/10 snikolay Addressing issue with collecting Windchill server side logs in dautoc
# 03/18/10 SJB      Fix ugsnx6 support.
# 04/01/10 ssanyal  Added /accepteula to pskill to silently accept EULA
# 04/12/10 ssanyal  Fixes for #inventor_test (#19875)
# 05/21/10 sjahagir Added support for mathcad 15  (#20134)
# 05/25/10 ssanyal  Changed R_LOCAL_DS_CLNT_TESTS to R_LOCAL_DS_C_CLNT (#20196)
#                   Register Solidworks on Windows 7 (#20125)
# 05/26/10 ssanyal  Support both R_LOCAL_DS_CLNT_TESTS, R_LOCAL_DS_C_CLNT (#20196)
# 05/26/10 sneves   Commented move_cursor functionality per request by Mkozhevnikov
# 06/02/10 gshmelev Added otk_cpp_test directive
# 07/14/10 ssanyal  Fix for solidworks_test (#20293)
# 07/22/10 ssanyal  Fix for #L10N directive (#20341)
# 07/29/10 ssanyal  Use "if" instead of "last" to exit set_directive for L10N test
#                   Unset PTCNMSPORT for prokernel_test (#18285)
# 08/04/10 ssanyal  Fixes for not_run_on directive (#20265)
# 08/14/10 snikolay Fixes related to processing QCR failures for wildfire tests
# 09/27/10 ssanyal  Fixes for cadds5_topology_test (#20575)
# 09/29/10 ssanyal  Fixes for legacy_encoding_test (#16050)
# 11/10/10 ssanyal  Fixes for cadds5_topology_test (#20626)
# 11/12/10 ssanyal  Copy *.rbn, *_db.chg files to scratch directory (#20700)
# 01/13/11 sjahagir Added support for ugsnx7 (#20816)
# 01/30/11 gshmelev changed cmd for otk_cpp_tests (removed qcr arg)
# 02/09/11 gshmelev Added substitution for OTK shortcuts
# 02/10/11 seer     Added check for R_REGRES_BIN 32 path existance before checking each exe
# 02/14/11 sjahagir Added R_SKIP_FUTURE_MODE for future test (#21061)
# 02/21/11 gshmelev Added PTKOBJ
# 03/10/11 sjahagir Added check for weblink test (#20883) 
# 03/28/11 ssanyal  Fix for SPR 2055445, changed copy path for pfcvb_tests.exe 
# 04/06/11 seer     Report failure when skipping test when no substitution found
# 04/11/11 MRC      Add CREOPMA_FEATURE_NAME handling
# 04/18/11 BI       Added OTK_TEST_DIR for R_ALT_TRAIL_PATH
# 09/22/11 ssanyal  Change UGS_LICENSE_BUNDLE (#21910)
# 10/28/11 sperry   Undid last change because of problem on license server end
# 11/14/11 ssanyal  Modified CREOPMA_FEATURE_NAME handling (#21618)
# 22/01/12 gshmelev Added otk_cpp_async_test
# 01/23/12 seer     Added creo agent support for windows
# 01/30/12 ssanyal  Switch execution to run_nt_job.pl except mech_test (#22546)
# 03/20/12 ssanyal  Support alt executable path in autoexist.txt (#22393)
# 03/21/12 SJB      Moved call to reset_envs after diff_mech.pl
# 04/10/12 ssanyal  Register pfclscom.exe only for pfcvb_test (#22610)
# 04/16/12 DB       Handled "#uwgmcc_test" directive
# 05/24/12 ssanyal  Added gcri_retr_test directive (#22669)
# 06/21/12 seer     Moved CheckSpace to exe for cygwin
# 06/27/12 DB       Skipped #uwgmcc_test tests by default
# 07/03/12 rroeder  Convert back slash in R_REGRES_BIN to forward slash (#22831)
# 08/15/12 gshmelev/aphatak added otk_java_test
# 08/03/12 nkhedkar Added creo_ui_resource_editor_test directive
# 08/27/12 gshmelev Added pre_run_wf_js_test_test  
# 10/08/12 SJB      UG NX 8.0 support (Simulate tests).
# 09/28/12 agodbole Changes for MKS support pre_run_wf_js_test_test
# 10/18/12 ssanyal  Made xtop_add_args a per-trail directive
# 10/19/12 sajay    Special handling for creo_ui_resource_editor_test
# 10/19/12 rkothari Removed skip condition for creo_ui_resource_editor_test
# 10/26/12 vivashko Added RADAR_HOME for hybrid tests supporting
# 11/15/12 drud     Fixed executable name in creo_ui_resource_editor_test
# 11/27/12 seer     fresh_creo_agent directive to set R_USE_AGENT
# 11/27/12 vivashko Fixed RADAR_HOME restoring
# 12/17/12 ssanyal  Modified interface_retrieval directive for #23452
# 01/03/13 apaygude Added gr_keep directive 
# 01/17/13 ssanyal  Minor fix for #run_with_license, trim license_info
# 01/30/13 seer     Support for R_KEEP_SUCC_MSGS
# 02/05/13 ssanyal  Don't skip mech_test for R_SUPERAUTO
# 03/04/13 seer     Prevent tests from running in home dir
#                   Fixed copy_keep_files to re-set after test is skipped when not found
# 03/06/13 Asaf     Use creoinfo -shutdown after each test (using the agent)
# 03/11/13 LEON     Added locks to prevent simultaneous msi installs. Save agent home.
#          seer     Support new traceback names. Always run creoinfo. Timeout for creoinfo. 
# 03/18/13 LEON     Added print of fresh_creo_agent directive when used.
# 04/02/13 ssanyal  Added directive #ptc_univ_ce_test (#24218)
# 04/08/13 SJB      Support perf_test for Simulate engine.
# 04/11/13 ssanyal  Fix for R_KEEP_FAILURE_DATA (#24181)
# 04/16/13 AC       Add R_SUPPRESS_PROTK_PROC_WINDOW to keep cmd window minimised for protk tests.
# 04/22/13 USK      Added support for Performance Tool.
# 04/25/13 USK      Fixed Performance Tool condition.
# 04/24/13 SJB      Fix ugToProPath for Simulate UG tests.
# 05/24/13 SBONGIR  Modified to use system files if local files set by $R_KERNEL_PARTS
#                   & $R_KERNEL_QCRS do not exist for GRANITE.
# 26/08/13 seer     keep agent home between #k tests. unset R_DELAY_PRO_COMM_MSG_LAUNCH for 
#                   wf_js tests. Added R_SAVE_FILTER for saving failure files.
# 09/30/13 ssanyal  Fix for mathcad_test
# 10/17/13 seer     copy_keep_files to be set correctly after skip
# 11/12/13 seer     fresh_creo_agent for all wildfire tests,
#                   ensure new agent home. R_KEEP_SUCC_SAVE_FILTER only for succ.
# 11/14/13 ssanyal  Moved chdir_safe from auto to GetTrlUtil (#24290)
# 12/02/13 gshmelev introduced add_jdk7_to_path
# 12/16/13 vsomwans added config_file and merge_config directives (#25052)
# 01/09/14 MVIO     removing pfcscom.dll auto registration for NT since P_VERSION 310.
# 01/13/14 apaygude added directive copy_gr_keep only for prokernel_tests.
# 01/20/14  SPAWAR  corrected cp command under directive copy_gr_keep.
# 01/28/14 AEY      Added check for UgToProNX8 executable.
# 03/13/14 vsomwans support micro-profiler
# 03/19/14 KSV      Added couple of envvars for creoagent
# 03/27/14 KSV      Changes for WC automation tests
# 04/11/14 ssanyal  Changed license server from hq-apps1 to ANDCSV-W08FLXLM01P
# 04/28/14 jas      Added creo_ui_editor support for Unix
# 05/06/14 KSV      Non-conditional shutdown of agent
# 05/05/14 DEM      Add RUN INFO to succ.log/fail.log
# 05/23/14 JDP  P-20-54   $$1  Add RUN INFO separately to succ.log for success test and fail.log for failed test.
# 05/23/14 KSV  P-20-54   $$2  Fixed copying of creoagent HOME for cases of failed tests
# 07/14/14 aphatak  P-20-56   $$3  Added otkjavaexamples.jar 
# 22/14/14 KSV  P-20-57   $$4  Better handling agent home dir for consequtive tests
# 07/25/14 gshmelev P-20-57 $$5 added #tk_flavor
# 08/18/14 ssanyal P-20-59 $$6  Exit if xtop does not return version (#25962)
# 12/15/14 vmahajan	P-20-64 $$7 Using config file for wf_js_settings, ram_size and os type 
# 01/05/15 ssanyal P-20-64 $$8  Capture profile data (superauto) for failed tests
# 01/22/15 apaygude P-20-64 $$9  Updated to pick GRANITE QCRs and Object files from local proj if available
#02/24/15 vmahajan P-30-03 $$10 Removed environment variable setting for using config file for wf_js_settings, ram_size and os type
# 03/10/15 naswar P-30-03 $$11  Added support for NX8.5 NX9, Inventor 2011,2012,2013,2014 & 2015.
# 03/01/15 gshmelev P-20-65 $$12 added ptwt_test
# 11/05/15 gshmelev P-30-08 $$13 introduced add_jdk8_to_path
# 05/12/15 sgandepalli P-30-08 $$14 To process all funclist files.
# 06/10/15 sgandepalli P-30-10 $$15 Changes for image format PNG of Bitmap tests
# 06/23/15 sgandepalli P-30-11 $$16 To copy PERF_TOOL_RESUTLS xml data in post process
# 06/29/15 ChenI P-20-66+ $$17 Fixed case of generic_ui_test to support another apps
# 07/02/15 psarnaik P-20-66+ $$18 Added support for WWGM interaction runs(JSCB/PWS Tools)
# 07/06/15 gshmelev    P-30-12 $$19 in P30 $jar_name is always otk
# 07/10/15 psarnaik P-20-66+ $$20 Updated wwgmint_test directive for NX automation support(JSCB/PWS Tools)
# 08/05/15 psarnaik P-20-67 $$21 Updated wwgmint_test directive for CAD version installation check and 'R_WWGMINT_ENABLE' environment.
# 11/08/15 magi     P-30-14 $$22 fixed issue with skip fails and #keep directive
# 30/08/15 seer     P-30-15 $$23 copy timeout traces
# 09/01/15 psarnaik P-20-67 $$24 Fixed issue of NX temp directory creation for subsequent NX test runs.
# 09/22/15 sgandepalli P-30-16 $$25 To support all windows os for solidworks_test
# 09/30/15 seer     P-30-17 $$26 Removed warnings in output when no tracebacks found
# 10/10/15 KSV      P-30-19 $$27 Fixed to properly pick up in-project built executables
# 12/03/15 aap      P-30-22 $$28 Fixed init_local_build_env.
# 01/11/16 psarnaik P-20-69 $$29 Updated for WWGM NX old macro copy.
# 01/13/16 magi     P-30-23 $$30 search for project envs in unpaked msis in addition to R_REGRES_BIN
# 02/03/16 magi     P-30-25 $$31 support new auto_env_vars.txt format.
# 02/05/16 KSV      P-30-25 $$32 Fixed #31
# 02/07/16 seer     P-30-25 $$33 Added IS_WILDFIRE_TEST env var
# 02/17/16 MRM      P-30-26 $$34 Enhanced fixit processing. Supported DSTUDY_DLL and MANIKIN_DLL environment.
# 03/01/16 nkhedkar P-30-27 $$35 Added set_otk_testlog_env_var to log otk test calls
# 03/08/16 magi 	P-30-27 $$36 fixed bug not locating directories in auto_env_vars.txt 
# 03/15/16 magi 	P-30-27 $$37 fixed bug parsing env vars from auto_env_vars 
# 03/16/16 psarnaik P-20-70 $$38 Updated WWGM Automation directives to support CAD startup commands
# 03/31/16 psarnaik P-30-29 $$39 Added support for Automation of WGM of AutoCAD Mechanical, AutoCAD Electrical
# 05/05/16 psarnaik P-20-71 $$40 Added support for WWGMTK automation specific functionality
# 05/23/16 nkapale  P-30-32 $$41 Added IGNORE_XP enviornment variable to skipp the tests on windows_xp and code to use GPI,JAVA local and system qcr automatically. 
# 05/26/16 mgokhale P-20-71 $$42 Updated to create xml of ccapi test results to upload on Hector
# 06/17/16 jas      P-30-34 $$43 Create zero size core.xtop as well as core
# 06/30/16 mgokhale P-20-72 $$44 Fixed to generate hector xml to run on cygwin shell.
# 07/01/16 aap      P-30-35 $$45 Apply #setenv before launching creoagent.
# 07/12/16 aap      P-30-35 $$46 Fix #45 for envs of part 2.
# 07/26/16 psarnaik P-20-72 $$47 Added support specific hector report format for WWGM automation.
# 07/25/16 aap      P-30-36 $$48 Adjust set_dm_user_passwd() for #setenv directives.
# 08/02/16 seer     P-30-37 $$49 Clean IS_WILDFIRE_TEST when test ends
# 08/09/16 seer     P-30-37 $$50 Fixed ##49 for #k tests
# 08/05/16 aap      P-30-38 $$51 Tweak #49 for all_wildfire.
# 08/17/16 psarnaik P-20-72 $$52 Added support for Inventor 2017/AutoCAD 2017/NX 11 for WGM Automation.
# 08/23/16 sbinawad P-30-38 $$53 Updated for CREO_UI_EDITOR
# 10/17/16 sgandepalli P-30-41 $$54 R_PERF_RUN_N_TIMES to run each perf test N times 
# 01/04/17 aap      P-30-42 $$55 Added R_KEEP_SUCCESS_DATA.
# 01/16/17 psarnaik P-30-42 $$56 Added support for SolidWorks 2017 for WGM Automation.
# 01/18/17 sgandepalli P-30-42 $$57 To handle extra whitespace for #setenv directive.
# 02/09/17 sgandepalli P-30-42 $$58 To post superauto data to solr using R_SUPERAUTO_SOLR
# 03/08/17 sgandepalli P-30-42 $$59 To always use regsvr32 of NT OS
# 03/31/17 sgandepalli P-50-04 $$60 To support 4k bitmap tests (#28397)
# 04/26/17 jurodrigues P-30-43 $$61 To support DBatch-Windchill interaction test
# 05/19/17 sgandepalli P-50-09 $$62 Help desk ID# 28586
# 05/21/17 aap         P-30-43 $$63 Fix leaked env IS_WILDFIRE_TEST in skip case.
# 06/28/17 psarnaik    P-30-44 $$64 Support WISP clone Server for interaction tests and WWGM Automation updates.
# 07/13/17 sgandepalli P-50-17 $$65 To support RMS compare for bitmap tests (#28671)
# 09/08/17 psarnaik    P-30-44 $$66 To support WWGM CAD tool version specific qcrs.
# 09/18/17 sgandepalli P-50-27 $$67 Switched superauto solr host to andcsv-solind1d
# 09/20/17 prashinde   P-20-76 $$68 Added xp_not_supported directive to skip tests on windows_xp and removed
# 03/11/17 sgandepalli P-50-34 $$69 To use perf & bitmap superauto db.
# 11/15/17 sgandepalli P-50-36 $$70 Not to use separate db for perf & bitmap.
# 12/09/17 psarnaik    P-50-41 $$71 WWGM Automation support for new cad tools.
# 02/08/18 sgandepalli P-50-48 $$72 To allow testing expected failures (#29277)
# 02/13/18 sgandepalli P-50-48 $$73 To allow testing expected failures (#29277)
# 03/14/18 sgandepalli P-30-46 $$74 Licensing changes for node license file used in Integration performance run
# 03/26/18 jurodrigues P-30-46 $$75 Called: kill_old_processs() if R_USE_LOCAL_SERVER is set
# 04/10/18 jurodrigues P-30-46 $$76 Added support for skipping unstable Creo-Windchill interaction test in pipeline. 
# 05/04/18 jurodrigues P-30-46 $$77 Called the stale process killer while reserving the server. 
# 05/06/18 MVK         P-60-06 $$78 Fix for #29420 and #29481
# 06/19/18 sgandepalli P-60-07 $$79 change for skip fail (#29587, #29500, #25217)
# 07/06/18 sgandepalli P-30-47 $$80 change for RMS bitmap fail (#29605)
# 07/11/18 psarnaik    P-50-50 $$81 Support for WWGM Automation- New CAD Support and additional enhancements for NX
# 07/15/18 psarnaik    P-50-50 $$82 Fixed issue about updating wgmclient.ini file due to buffer issue and updated ACAD2019 registries.
# 08/07/18 MVK         P-60-13 $$83 Fix typo in java path
# 08/09/18 psarnaik    P-60-14 $$84 Added support for CEDM/CEDD for cleaning of CAD tools.
# 08/21/18 sgandepalli P-50-50 $$85 To support test with directive #nist_analyzer_test (#29709) 
# 08/22/18 kshukla     P-50-50 $$86 To allow installation from cdImage
# 08/28/18 ssanyal     P-60-16 $$87 Fix compilation error
# 09/05/18 psarnaik    P-60-17 $$88 Added support for release specific QCRs for WWGM automation.
# 10/12/18 MVK         P-60-21 $$89 Fixed removal PRO_JAVA_COMMAND
# 10/24/18 jurodrigues P-60-22 $$90 Modified the logic for skipping unstable Creo-Windchill interaction test in pipeline.
# 10/25/18 sgandepalli P-60-22 $$91 To support test with directive #simlive_test (#29886)
# 11/17/18 psarnaik	   P-60-28 $$92 Added support for custom ini file option and WWGMTK NX DLL.
# 02/04/19 sgandepalli P-60-31 $$93 changes for performance run.
# 02/04/19 MVK	       P-60-31 $$94 Added some useful logs and registry cleanup(to reduce false failures)
# 02/08/19 psarnaik	   P-60-31 $$95 Added support for running WWGM test in Creo pipeline.
# 03/01/19 MVK	       P-30-50 $$96 Support running from local install(cdimage)
# 03/07/19 kshukla	   P-30-50 $$97 Added support for auto to install, run regressions and uninstall Creo concurrently.
# 03/15/19 kshukla	   P-70-01 $$98 using cp for copying the install/uninstall scripts
# 03/25/19 MVK         P-70-02  $$99 Copy everything from tmpdir when R_SUCC_SAVE_ALL is set. Fixes CHD-40.
# 04/12/19 MVK         P-70-04  $$100 Support bitmap_text (text comparison of images)
# 04/15/19 MVK         P-70-05  $$101 Updated #100 to save bitmap text qcr to dbpath
# 05/10/19 MVK         P-70-08  $$102 Added time stamps to help investigate unlock jar issue and fix bitmap_text issues
# 05/26/19 MVK         P-70-11  $$103 Updated for some local install scenarios
# 05/29/19 sgandepalli P-70-11  $$104 changes to support hdpi run
# 06/11/19 aadake      P-70-14  $$105 added "R_USE_LOCAL_HECTOR_XML_PL" ENV to use local hector_xml.pl
# 06/25/19 MVK         P-70-15  $$106 Use appropriate license for simulate and layout in local install run
# 07/07/19 MVK         P-70-16  $$107 Fix CREO_AGENT_HOME settings
# 07/10/19 apaygude    P-70-18  $$108 Added directive repeat_gr_trail
# 07/15/19 MVK         P-70-18  $$109 Call R_MERGE_CONFIG for multi trail scenario
# 07/12/19 MVK         P-70-18  $$110 Wait for missing LUN
# 07/25/19 sgandepalli P-70-19  $$111 to support run_only_on_cdimage(CHD-481)
# 07/31/19 sgandepalli P-70-20  $$112 fix for not to delete KEEP_FAILURE_DATA of dauto runs.
# 07/30/19 MVK         P-70-20  $$113 Updated 110
# 07/31/19 skandagale  P-70-20  $$114 Added support for Multiple servers with WISP
# 08/06/19 sgandepalli  P-70-20  $$115 Fix for directive
# 08/01/19 MVK         P-70-21  $$116 Wait for binary for if_exist case. Needed when sys area is being updated.
# 08/01/19 MVK         P-70-22  $$117 Fixed typo in 116
# 08/21/19 sgandepalli P-70-23 $$118 to support gd_test (ISGT-852)
# 08/27/19 sgandepalli P-70-24 $$119 to support gd_test (ISGT-852)
# 08/28/19 sgandepalli P-70-24 $$120 for local integrations runs
# 08/29/19 sgandepalli P-70-24 $$121 to support gd_test (ISGT-891) and (ISGT-890)
# 08/30/19 sperry      P-70-24 $$122 Fix small issue with #121
# 09/04/19 MVK         P-70-25 $$123 Added R_MERGE_PREFER_ORIG
# 09/13/19 sgandepalli P-70-26 $$124 to support #gmb_wip
# 10/04/19 sgandepalli P-70-29 $$125 to ignore case when copying qcr's 
# 10/06/19 sgandepalli P-70-29 $$126 to log in msg file with list of qcr's are not found. so that Dev/QA can easily fix trail.
# 10/10/19 sgandepalli P-70-29 $$127 fix for ignore case change, Which failing for specific case having PTCSRC filepath in dbgfile.dat instead local file
# 11/11/19 sgandepalli P-70-32 $$128 to support #gd_webapp_test (CHD-893). Changes for (CHD-843)
# 21/11/19 nehiwse P-70-34 $$129 Adding support for running the generative webapp hybrid tests.
# 12/03/19 sgandepalli P-70-36 $$130 to support gd_test
# 12/10/19 nehiwse P-70-37 $$131 Adding trail substitution for reading radar_jar property for GD hybrid tests
# 12/12/19 sgandepalli P-70-37 $$132 to support gd_test
# 12/16/19 sgandepalli P-70-37 $$133 to generate xml file by default. User can disable with PERF_TEST_AUTO set to NO either in auto.txt or at the time of auto run.
# 12/16/19 sgandepalli P-70-37 $$134 to support gd_test
# 12/17/19 nehiwse P-70-38 $$135 Added logging to check FASTREG_URL replaced in config.
# 12/18/19 sgandepalli P-70-38 $$136 to support gd_test
# 06/01/20 nehiwse P-70-39 $$137 updated code for trail_substitution in config.pro for FASTREG_URL
# 10/02/20 nehiwse P-70-44 $$138 updated the responce value for tests to skipped.
# 11/02/20 MVK     P-70-44 $$139 Tests were incorrectly skipped due to incompatible directives
# 30/03/20 MVK     P-72-06 $$140 Cleanup of ENV moved out later. Since apilog dir was cleared, we could not save them for a test.
# 01/04/20 MVK     P-70-44 $$141 Added the response for tests which are skipped due to ie seetings are not done.
# 30/03/20 jurodrigues P-70-44 $$142 Changed the default value CREOINT_PRODUCTION_STATUS to PRODUCTION
# 04/09/20 sgandepalli P-60-36 $$143 To run gd_test tests only on x86e_win64. And R_DONT_SAVE_API_LOG for not to save API logs.
# 05/29/20 MVK     P-80-07 $$144 Check and fail if license related ENV are explicitly set
# 06/16/2020 sgandepalli P-70-45 $$145 generate .perf for qcr failure. And change for ptwt_test
# 06/22/2020 sgandepalli P-70-45 $$146 Support for #aim_test. And change qcr perf fail and Bitmap tol, And change for R_MERGE_PREFER_ORIG
# 06/29/2020 sgandepalli P-80-09 $$147 To save Windchill install and startup logs
# 07/01/2020 sgandepalli P-80-10 $$148 To log PTWT_FASTREG_URL
# 08/20/2020 MVK         P-80-17 $$149 Partial fix of CHD1501
# 09/13/2020 sgandepalli P-80-20 $$150 change for CHD1501
# 09/24/2020 sgandepalli P-80-21 $$151 to support vulkan tests
# 09/25/2020 nehiwse P-70-46 $$152 Adding env GDX_PRO_TEST for generative webapp
# 10/16/2020 sgandepalli P-80-24 $$153 ignore commands
# 10/28/2020 apaygude    P-80-26 $$154 Updated for inventor tests
# 10/30/2020 sgandepalli P-80-26 $$155 to support graphics_process
# 11/10/2020 sgandepalli P-80-28 $$156 To support java_flavor
# 11/11/2020 sgandepalli P-80-28 $$157 to support vulkan and java flavor tests
# 11/19/2020 nehiwse P-80-29 $$158 correting the place for checking gd_webapp_url.
# 11/19/2020 sgandepalli P-80-29 $$159 R_DONOT_UNINSTALL_CREO for not un-installing Creo. And changes for graphics_process
# 11/20/2020 sgandepalli P-80-29 $$160 change for bitmap
# 11/23/2020 sgandepalli P-80-29 $$161 change for java tests
# 11/24/2020 sgandepalli P-70-47 $$162 change for bitmap graphics_process test
# 12/03/2020 sgandepalli P-80-31 $$163 change for apply_setenv
# 12/03/2020 sgandepalli P-80-31 $$164 change for log
# 12/10/2020 skandagale P-80-32 $$165 GDX test to use node and npm dependencies from PTC_TOOLS
# 08/20/2020 MVK         P-80-32 $$166 Fix PATH reset for java_flavor test
# 01/07/2021 sgandepalli P-80-35 $$167 To support pglview_test
# 01/25/2021 sgandepalli P-80-37 $$168 To support pglview_test
# 01/28/2021 skandagale P-80-38 $$169 Dev stack support for GDX test
# 02/03/2021 skumar		P-80-39 $$170 Change for RTCJ-877
# 02/04/2021 nehiwse    P-80-39 $$171 Adding ENV to skip gdx test in integration
# 02/10/2021 sgandepalli P-80-40 $$172 temporary fix for Perf run against CD Image
# 02/11/2021 sgandepalli P-80-40 $$173 change for Cd image run
# 02/15/2021 sgandepalli P-80-40 $$174 change for Cd image run
# 02/20/2021 sgandepalli P-80-40 $$175 temporary fix for Bitmap run
# 02/25/2021 sgandepalli P-80-40 $$176 change for Cd image run
# 02/26/2021 MVK P-80-40 $$177 set local_xtop to PROE_START for cdimage run
# 03/03/2021 sgandepalli P-80-40 $$178 fix for ptwt_test
# 04/20/2021 nehiwse P-70-48 $$179 Support for testing local Testrunner.jar
# 04/23/2021 nehiwse P-70-48 $$180 GDX support for multithreading
# 05/10/2021 MVK P-90-08 $$181 Skip wwgm test for cdimage runs(test having wwgmint_test directive)
# 05/14/2021 MVK P-90-09 $$182 Support otk_async_port tests for cdimage(need lib in path)
# 05/19/2021 sgandepalli P-90-09 $$183 Support gpu run
# 05/20/2021 skumar P-90-09 $$184 Added directive not_run_on_app_verifier
# 05/24/2021 MVK P-90-10 $$185 Fix PTC_REGISTRY_REGTEST value for each test
# 05/30/2021 MVK P-90-10 $$186 Avoid tee in print_succ and print_fail
# 05/31/2021 ELN P-90-11 $$187 Added collaboration support and new directive shared_workspace
# 06/01/2021 sgandepalli P-90-11 $$188  to support vulkan in nongraphics
# 06/03/2021 sgandepalli P-90-11 $$189  change for windchill run
# 06/10/2021 sgandepalli P-90-12 $$190  disable data upload by default
# 06/10/2021 sgandepalli P-90-12 $$191 to support backward_trail
# 06/11/2021 nehiwse P-80-41 $$192 Adding default env for gdx
# 06/14/2021 nehiwse P-80-41 $$193 Adding env for gdx
# 06/26/2021 MVK P-80-41 $$194 Used PTCSYS. Fixed reg count. Set lib PATH for pfcvb tests
# 07/05/2021 skumar P-80-41 $$195 Added directive coretech_kio_test
# 07/19/2021 ELN    P-90-18 $$196 Supporting run of 2 xtops for collaboration
# 07/21/2021 sgandepalli P-90-18 $$197 To supprot Creo Schematics CD image run
# 07/26/2021 sgandepalli P-90-18 $$198 change for R_SAVEAS
# 07/26/2021 ELN         P-90-19 $$199 change for #shared_workspace collab trails
# 07/28/2021 skumar P-90-19 $$200 Support for new directive ngcri_test
# 08/02/2021 sgandepalli P-90-19 $$201 change for creo schematics
# 08/02/2021 spol P-90-20 $$202 Redirect uninstall logs based on ENV R_UNINSTALL_LOGS_DIR
# 08/03/2021 sperry P-90-20 $$203 Add missing ;
# 08/04/2021 sgandepalli P-90-20 $$204 change for vulkan tests
# 08/05/2021 ELN         P-90-20 $$205 change for collaboration tests
# 08/12/2021 sgandepalli P-90-21 $$206 change to have LF style lines
# 08/13/2021 sgandepalli P-90-21 $$207 fix for dauto
# 08/15/2021 ELN         P-90-22 $$208 set path and envs for using Atlas in collab tests
# 08/18/2021 nehiwse P-80-42 $$209 Adding env for GDX
# 08/23/2021 ELN     P-90-23 $$210 Updates for shared_workspace for working with Atlas
# 08/24/2021 nehiwse P-90-23 $$211 Adding respose for wisp error.
# 09/06/2021 sgadepalli P-90-24 $$212 to save reports
# 09/23/2021 sgadepalli P-90-26 $$213 to save reports
# 09/28/2021 sgadepalli P-90-26 $$214 change for Creo Schematics CD Image run using dauto
# 10/19/2021 sgadepalli P-80-43 $$215 add check for an issue seen in dauto run
# 10/29/2021 sgandepalli P-90-31 $$216 To support wip_test
# 11/04/2021 sgur        P-90-33 $$217 Added R_UPD_TRAIL_DIR, MTRACER_TEST_MODE
# 11/14/2021 sgur        P-90-34 $$218 Added write_mtracer_data.
# 11/23/2021 skumar      P-90-35 $$219 To support atlas_user for single session
# 12/01/2021 sgandepalli P-80-43 $$220 To use tools jq
# 12/01/2021 sgandepalli P-90-36 $$221 Fix for superauto
# 12/08/2021 sgandepali P-90-37 $$222 To use tools jq
# 12/08/2021 sgandepali P-80-43 $$223 Add nodejs and protractor to path
# 12/17/2021 skumar     P-90-38 $$224 Remove jq from curl command
# 12/20/2021 satya      P-90-39 $$225 Setting WWGM Startup directory for CCAPI
# 12/23/2021 ELN        P-90-39 $$226 killing both creo agents in collab multi xtop run
# 12/27/2021 sgandepalli P-90-39 $$227 To support atlas_user
# 12/28/2021 sgandepalli P-70-51 $$228 To support old format as well
# 12/29/2021 sgandepalli P-90-40 $$229 Change for creo agent
# 01/10/2021 sgandepalli P-90-41 $$230 Change for atlas_user session info
# 01/11/2022 sgandepali P-80-44 $$231 To create .dge file for Creo Schematics
# 01/17/2022 sgandepali P-90-42 $$232 To support saas_test
# 01/14/2022 MVK        P-90-42 $$233 Update OPTM license for cdimage runs(removed 318)
# 01/18/2022 sgandepali P-80-44 $$234 To support saas_test
# 01/18/2022 lli        P-90-43 $$235 Updated saas_test support
# 01/23/2022 ELN        P-90-43 $$236 collab test that dont use atlas should not have a delay
# 01/25/2022 sgandepali P-90-43 $$237 Check/Configure/Remove AppVerifier settings
# 01/25/2022 lli        P-90-44 $$238 Added trl to saas_test saveas
# 02/14/2022 MVK        P-90-46 $$239 Added env and dll logs
# 02/09/2022 lli        P-90-47 $$240 tee R_UITOOLKIT_APP to std.out
# 03/06/2022 sgandepalli Q-10-01 $$241 To create .dge file for Creo Schematics
# 03/08/2022 MVK        Q-10-02 $$242 Updated #239 to be ENV controlled
# 09/03/2022 lli        Q-10-02 $$243 Used --keep with saas-ptcagent-regtest.csh
# 15/03/2022 sgandepalli P-90-47 $$244 save PTC logs
# 17/03/2022 sgandepalli P-90-47 $$245 extra logging, R_EXTRA_LOGGING
# 03/23/2022 sgandepalli Q-10-04 $$246 to support Creo Schematics
# 03/24/2022 sgandepalli Q-10-04 $$247 disabled prevous change
# 03/30/2022 sgandepalli Q-10-05 $$248 set license for rsd_test
# 03/31/2022 ELN         Q-10-05 $$249 removed default for COLLAB_INFLIGHT_UPLOAD_LIMIT for collaboration runs
# 05/04/2022 lli         Q-10-06 $$250 Also check CREO_SAAS_TEST_REUSE_INSTALL 
# 07/04/2022 Asaf        Q-10-06 $$251 R_DISABLE_PROCESS_DUMPS ==> R_ENABLE_PROCESS_DUMPS
# 10/04/2022 EFN         Q-10-07 $$252 Introduced ENABLE_MULTI_CLIENT_SYNC 
# 12/04/2022 ELN         Q-10-07 $$253 fails the test if collaboration second xtop fails on qcrs
# 13/04/2022 skumar		 Q-10-07 $$254 RTCJ_1350(To support support_non_simlive_mode)
# 19/04/2022 sgandepalli P-80-45 $$255 special case to handle bitmap failure
# 22/04/2022 skumar		 Q-10-08 $$256 minor fix for support_non_simlive_mode
# 25/04/2022 MVK Q-10-08 $$257 Reset is_atlas_user_multi_session
# 27/04/2022 skumar		 P-80-45 $$258 fix for support_non_simlive_mode
# 28/04/2022 sgandepalli P-80-45 $$259 to fix dauto issue
# 01/05/2022 sgandepalli P-80-45 $$260 to use local collab_other
# 09/05/2022 sgandepalli P-80-45 $$261 enable dauto fix by default
# 11/05/2022 sgandepalli P-80-45 $$262 fix for shared_workspace
# 05/12/2022 sgandepalli P-80-45 $$263 change for wip_test
# 16/05/2022 sgandepalli P-80-45 $$264 fix for shared_workspace
# 17/05/2022 sgandepalli P-70-53 $$265 minor fix for shared_workspace
# 30/05/2022 sgandepalli P-80-45 $$266 change for appverifier 
# 31/05/2022 sgandepalli P-80-45 $$267 to fix dauto issue
# 06/20/2022 sgandepalli Q-10-15 $$268 change for Creo Plus full regression run
# 06/21/2022 sgandepalli P-80-46 $$269 read saas_install_env.src
# 06/23/2022 sgandepalli Q-10-16 $$270 change for Creo Plus
# 06/24/2022 sgandepalli Q-10-16 $$271 change for Perf
# 07/15/2022 sgandepalli Q-10-19 $$272 change for Creo Plus
# 07/19/2022 sgandepalili P-80-46 $$273 change for Creo schematics
# 07/20/2022 sgandepalli P-70-54 $$274 change for Creo Plus
# 07/20/2022 sgandepalli Q-10-20 $$275 minor change for Creo Plus
# 08/09/2022 sgandepalli P-80-46 $$276 minor change for Creo Plus
# 08/10/2022 sgandepalli Q-10-22 $$277 minor change for Creo Plus
# 08/18/2022 skumar		 Q-10-23 $$278 Support for new directive skip_for_cpd_run
# 08/19/2022 sgandepalli Q-10-23 $$279 change for fresh_creo_agent tests
# 08/21/2022 lli         Q-10-24 $$280 Updated for tools/bin/saas
# 08/28/2022 MVK         Q-10-24 $$281 Fixed clean_setenv_cmds usage
# 09/12/2022 sgandepalli P-90-49 $$282 change for collab test
# 09/18/2022 lli         Q-10-28 $$283 Added R_AVOID_XTOP_APPVERIFIER
# 09/19/2022 saltamash   Q-10-28 $$284 minor fix for unwanted messages
# 09/27/2022 sgandepalli P-90-49 $$285 for collab tests run in other languages
# 09/30/2022 sgandepalli Q-10-29 $$286 change for creo_home name
# 10/08/2022 sgandepalli Q-10-30 $$287 for multitrail and creoschemtics
# 10/11/2022 sgandepalli P-80-47 $$288 for creoschemtics
# 10/12/2022 sgandepalli Q-10-31 $$289 support prevs schematics bat file
# 10/19/2022 sgandepalli Q-10-32 $$290 change for creouieditor
# 10/20/2022 sgandepalli Q-10-32 $$291 for cdimage run using node license 
# 10/20/2022 sgandepalli P-90-50 $$292 to use Creo plus test stack 
# 10/20/2022 MVK         P-70-55 $$293 SEt PTC_D_LICENSE_FILE for cdimage runs
# 11/02/2022 sgandepalli Q-10-34 $$294 change for creouieditor
# 11/03/2022 sgandepalli Q-10-34 $$295 change creo schemaitcs against local build
# 11/04/2022 spol        Q-10-34 $$296 change creo schemaitcs print version
# 11/08/2022 sgandepalli P-90-50 $$297 change for creo plus
# 11/17/2022 sgandepalli Q-10-36 $$298 change for creo plus CHD-2838
# 11/18/2022 sgandepalli Q-10-36 $$299 change for creo plus
# 11/29/2022 issingh Q-10-37 $$300 X-PTC-Company-Id change 
# 11/30/2022 sgandepalli P-90-50 $$301 unsetenv COLLAB_COMPANY_ID for Creo plus
# 12/01/2022 sgandepalli P-80-48 $$302 revert unsetting COLLAB_COMPANY_ID
# 12/01/2022 DSS         Q-10-37 $$303 Supporting DRC tests
# 12/05/2022 MVK         Q-10-37 $$304 Support R_ALT_LICENSE_FILE
# 12/06/2022 sgandepalli P-90-50 $$305 update env
# 12/06/2022 sgandepalli P-90-50 $$306 change for collab
# 12/15/2022 sgandepalli Q-10-39 $$307 trival change print stmt
# 12/20/2022 sgandepalli Q-10-39 $$308 add perfview and vsdiag
# 12/22/2022 skumar      Q-10-40 $$309 pass drc_obj to conver and compare plt files for drc test
# 12/26/2022 sgandepalli Q-10-40 $$310 change for e2e tests CHD-2789
# 02/01/2023 sgandepalli Q-10-41 $$311 change to support collab tests in SaaS promotion run 
# 06/01/2023 skumar      Q-10-42 $$312 revert $$309
# 06/01/2023 sgandepalli P-90-51 $$313 change for e2e tests, tk_flavor
# 10/01/2023 lli         Q-10-42 $$314 use -w for cu_multiclient_trail_sync
# 16/01/2023 sgandepalli Q-10-43 $$315 change for RTCJ-1538, CHD-3006
# 02/09/2023 sgandepalli P-90-51 $$316 dump CREO_SAAS enviroment, RTCJ-1566
# 02/09/2023 sgandepalli P-70-55 $$317 dump CREO_SAAS enviroment, RTCJ-1566
# 15/02/2023 sgandepalli Q-10-48 $$318 change VSDIAG, PERFVIEW
# 20/02/2023 sgandepalli Q-10-48 $$319 change for RTCJ-1575
# 22/02/2023 sgandepalli Q-10-49 $$320 fix for RTCJ-1575
# 23/02/2023 sgandepalli Q-10-49 $$321 change to save log
# 23/02/2023 sgandepalli Q-10-48 $$322 do not set COLLABSVC_URL for CPD
# 27/02/2023 sgandepalli Q-10-48 $$323 fix for PTC_LOG
# 28/02/2023 Asaf        Q-10-48 $$324 Introduce R_WRAPPER_SCRIPT
# 02/03/2023 sgandepalli Q-10-49 $$325 exclude password
# 08/03/2023 sgandepalli Q-10-49 $$326  change for collab test
# 13/03/2023 sgandepalli Q-10-48 $$327  change for run_with_license in CPD run, RTCJ-1587
# 14/03/2023 sgandepalli Q-10-49 $$328  change for PTC_LOG_DIR
# 14/03/2023 sgandepalli Q-10-49 $$329  #cpd_user directive, RTCJ-1589
# 16/03/2023 sgandepalli Q-10-49 $$330  change in l2r username format
# 20/03/2023 sgandepalli Q-10-49 $$331  change in l2r username format
# 20/03/2023 sgandepalli Q-10-49 $$332  change for e2e
# 21/03/2023 skumar      Q-10-49 $$333  Added directive "run_only_on_cpd", Additional parameter for "run_on_cpd" directive
# 22/03/2023 lli         Q-10-49 $$334  Added -telecon-flush
# 23/03/2023 sgandepalli Q-10-48 $$335  change for RTCJ-1593
# 27/03/2023 sgandepalli Q-10-48 $$336 check_for_success; use /tools/external/saas
# 27/03/2023 sgandepalli Q-10-49 $$337 logoff control center
# 06/04/2023 sgandepalli Q-11-06 $$338 change for save logs
# 11/04/2023 sgandepalli Q-10-49 $$339 space separated license options only for CPD run
# 17/04/2023 sgandepalli Q-10-49 $$340 RTCJ-1594, support collab SaaS test
# 19/04/2023 sgandepalli Q-10-49 $$341 R_DISABLE_PTC_LOGGING change
# 24/04/2023 sgandepalli Q-10-49 $$342 support CPD language
# 24/04/2023 lli         S-10-03 $$343 Use -pf for cu_multiclient_trail_sync
# 03/05/2023 skumar      Q-10-49 $$344 support new format of WIP test(including RT#)
# 03/05/2023 sgandepalli Q-11-10 $$345 support ZBROWSER_TRAIL_FILE (RTCJ-1613)
# 03/05/2023 sgandepalli Q-11-10 $$346 change for RTCJ-1610
# 08/05/2023 lli         Q-10-49 $$347 Fixed ##343 - unlink multiclient_trail_port.txt
# 30/05/2023 sgandepalli Q-10-49 $$348 don't set COLLABSVC_URL for SaaS test
# 31/05/2023 sgandepalli Q-11-14 $$349 support q11 - creo agent
# 06/05/2023 sgandepalli Q-11-14 $$350 support q11 - creo agent - R_USE_CREO_CDIMAGE
# 06/05/2023 sgandepalli Q-10-49 $$351 support Creo plus
# 06/06/2023 ELN         Q-10-49 $$352 collaboration set COLLABSVC_URL also for multi user run
# 06/12/2023 sgandepalli Q-10-49 $$353 change for creoinfo
# 22/06/2023 sgandepalli Q-11-17 $$354 change permission
# 10/07/2023 sgandepalli Q-11-19 $$355 change for ptc_logs
# 19/July/2023 sgandepalli P-90-53 $$356 fix in post_run_process
# 24/July/2023 sgandepalli Q-10-50 $$357 change for CHD-3355 
# 02/August/2023 sgandepalli Q-11-23 $$358 change for CHD-3356
# 03/August/2023 sgandepalli Q-11-23 $$359 change for CHD-3356
# 09/August/2023 sgandepalli Q-11-24 $$360 change for CHD-3336
# 12/August/2023 MVK Q-11-24 $$361 Support R_ALT_NT_JOB_PL
# 27/August/2023 sgandepalli Q-11-26 $$362 change for CHD-3336
# 08/29/23 arozbaum Q-11-27 $$363 RTCJ-1644
# 08/29/23 aap      Q-10-50 $$364 COLLAB_SESSION_NAME_PREFIX also for single-user collab tests
# 09/07/23 skumar   Q-11-28 $$365 support R_MERGE_CONFIG for creo schematics
# 14/Sept/2023 sgandepalli Q-11-29 $$366 to support --profile for CPD run
# 10/Oct/2023 sgandepalli Q-10-50 $$367 change for RTCJ-1769, support video run
# 15/Oct/2023 sgandepalli Q-11-33 $$368 to support shared workspace with #run_with_license in CPD run
# 16/Oct/2023 skumar Q-11-33 $$369 change for RTCJ-1781 and RTCJ-1618
# 17-Oct-2023 sgur   Q-11-34 $$370 Updated write_mtracer_data.
# 19-Oct-2023 sgandepalli  Q-11-34 $$371 print binary version
# 19-Oct-2023 sgandepalli  Q-10-51 $$372 check and kill known processes by directory name
# 26-Oct-2023 sgandepalli  Q-11-35 $$373 change in get_binary_version
# 10/29/23 arozbaum Q-11-36 $$374 RTCJ-1797
# 02-Oct-2023 sgandepalli Q-11-36 $$375 remove abnormal exit of auto
# 03-Oct-2023 sgandepalli Q-11-36 $$376 to use local collab cache
# 11-Nov-2023 sgandepalli Q-11-37 $$377 fix RTC windchill failure
# 14-Nov-2023 lli         Q-10-51 $$378 Remove -u from multiclient python runs
# 15-Nov-2023 ELN         Q-11-38 $$379 Skip new session creation when there is dataDir
# 17-Nov-2023 sgandepalli Q-10-51 $$380 unset collab env
# 21-Nov-2023 sgandepalli Q-10-51 $$381 change to support UNC path
# 22-Nov-2023 sgandepalli Q-10-51 $$382 unset collab env
# 27-Nov-2023 sgandepalli Q-10-51 $$383 change for collab other
# 04-Dec-2023 sgandepalli Q-10-51 $$384 change for collab fail. And for ISGT-5522
# 06-Dec-2023 sgandepalli Q-11-41 $$385 print download status
# 07-Dec-2023 sgandepalli Q-11-41 $$386 revert a change due an issue in fixqcrs
# 12-Dec-2023 sgandepalli Q-11-42 $$387 use SaaS Config service
# 19-Dec-2023 sgandepalli Q-10-51 $$388 change for SaaS Config service
# 19-Dec-2023 skumar	  Q-11-43 $$389 Add directive saas_test_on_demand
# 20-Dec-2023 skumar	  Q-11-43 $$390 fix for wip test
# 26-Dec-2023 sgandepalli Q-10-51 $$391 change for libcef
# 01-Jan-2024 MVK         Q-11-44 $$392 Corrected PATH_default for local install
# 02-Jan-2024 sgandepalli P-90-55 $$393 change for R_SAVE_AS
# 11-Jan-2024 sgandepalli Q-11-46 $$394 change for SaaS Config service
# 16-Jan-2024 sgandepalli Q-11-46 $$395 fix for config service
# 17-Jan-2024 sgandepalli Q-11-47 $$396 change for wnc_flavor
# 22-Jan-2024 sgandepalli Q-11-47 $$397 change sequence of R_CP_TO_SCRATCH
# 05-Jan-2024 sgandepalli Q-10-52 $$398 change for repo download
# 21-Feb-2024 pyajurvedi/sgandepalli Q-10-52 $$399 change for CHD-3450
# 05-Mar-2024 sgandepalli Q-10-52 $$400 to use new numbered username
# 20-Mar-2024 sgandepalli Q-12-04 $$401 added AUTO_PL_PID
# 25-Mar-2024 sgandepalli P-90-56 $$402 support RTCJ-1931 and profiler data for collab tests
# 27-Mar-2024 sgandepalli Q-12-05 $$403 change for collab test
# 02-Apr-2024 skumar      P-90-56 $$404 add peak virtual memory usages in succ log file
# 02-Apr-2024 sgandepalli P-80-51 $$405 support gdx_playwright for ISGT-6228 and CHD-3799
# 05-Apr-2024 sgandepalli Q-12-06 $$406 to support profiling for collab
# 11-Apr-2024 sgandepalli Q-12-07 $$407 rename auto log and fix collab test issue
# 12-Apr-2024 sgandepalli Q-12-07 $$408 change for config service and shared WS trail in video run
# 16-Apr-2024 skumar      Q-10-53 $$409 add only last occurence of peak virtual memory
# 12-Apr-2024 sgandepalli Q-11-52 $$410 change for collab_prod endpoint and shared creo home
# 16-May-2024 sgandepalli Q-12-12 $$411 use --envs option to create psf
# 19-May-2024 Asaf        Q-12-12 $$412 Use get_string_from_gmk_files
# 30-May-2024 sgandepalli Q-11-52 $$413 change for config service
# 06-June-2024 sgandepalli Q-12-15 $$414 fix for env print
# 18-June-2024 skumar      Q-12-17 $$415 Add GPUInfoAndUsage info in succ log file
# 24-June-2024 sgandepalli Q-12-17 $$416 change for uses_config_service
# 24-June-2024 sgandepalli Q-11-52 $$417 preserve SaaS local backend server logs
# 02-July-2024 sgandepalli Q-10-54 $$418 change for CHD-3931
# 02-July-2024 sgandepalli Q-10-54 $$419 change for CHD-3931
# 18-July-2024 sgandepalli Q-12-21 $$420 support new psf file name format
# 24-July-2024 sgandepalli Q-12-22 $$421 modify the script location
# 30-July-2024 sgandepalli Q-11-53 $$422 change print statement
# 07-Aug-2024 sgandepalli Q-12-24 $$423 change for CHD-4000, CHD-3931 & R_PERF_CURRENT_ITERATION_NUM
# 12-Aug-2024 sgandepalli Q-12-24 $$424 support WIP bitmap tests
# 12-Aug-2024 sgandepalli Q-12-26 $$425 set CREO_MEM_USAGE_STATS by default
# 22-Aug-2024 sgandepalli Q-12-26 $$426 remove CREO_MEM_USAGE_STATS to set by default
# 27-Aug-2024 sgandepalli Q-11-53 $$427 support pyautogui tests, pskill
# 03-Sep-2024 vemore      Q-12-28 $$428 Added Inventor 2023 & 2024 support for Granite Inventor test
# 04-Sep-2024 sgandepalli Q-12-28 $$429 remove BOM for config.pro
# 02-Sep-2024 aap         Q-12-28 $$430 workaround collabsvc issue CGM-2011 with env var
# 05-Sep-2024 pyajurvedi  Q-12-28 $$431 Updated IC suite folder structure
# 13-Sep-2024 sgandepalli Q-11-53 $$432 change for simlive and pyautogui tests
# 23-Sep-2024 sgandepalli Q-12-30 $$433 change for object copy
# 27-Sep-2024 sgandepalli Q-12-31 $$434 change for atlas domain name change
# 01-Oct-2024 sgandepalli Q-12-32 $$435 revert atlas domain name change
# 04-Oct-2024 sgandepalli Q-12-32 $$436 change for skip fail
# 18-Oct-2024 sgandepalli Q-11-54 $$437 remove force_browser
# 23-Oct-2024 sgandepalli Q-11-54 $$438 save collab log
# 23-Oct-2024 sgandepalli Q-12-35 $$439 modify message
# 25-Oct-2024 sgandepalli Q-12-35 $$440 change for curl
# 25-Oct-2024 sgandepalli Q-11-54 $$441 check for user not found
# 12-Nov-2024 aap         Q-12-38 $$442 revert #430, fixed in collabsvc.exe
# 13-Nov-2024 sgandepalli Q-12-38 $$443 change for collab test
# 18-Nov-2024 sgandepalli Q-12-38 $$444 change for pyautogui tests
# 18-Nov-2024 sgandepalli Q-12-38 $$445 change for curl command
# 19-Nov-2024 skumar      Q-12-39 $$446 add cpu time and clock time in succ log file
# 17-Dec-2024 sgandepalli Q-12-42 $$447 change for test stack run
# 02-Jan-2025 sgandepalli Q-12-45 $$448 change for saas test
# 03-Jan-2025 sgandepalli Q-12-45 $$449 change for saas test
# 03-Jan-2025 sgandepalli Q-12-45 $$450 to avoid running creo info for saas_test
# 03-Jan-2025 sgandepalli Q-12-45 $$451 to support ub CEF
# 07-Jan-2025 skumar      Q-12-46 $$452 Add directive engnotebook_test
# 16-Jan-2025 sgandepalli Q-12-47 $$453 change for profiler run
# 04-Feb-2025 sgandepalli Q-11-55 $$454 change for playwright data and creoinfo
# 06-Feb-2025 sgandepalli Q-12-50 $$455 change to print display size and collab isue
# 08-Feb-2025 MVK         Q-12-50 $$456 Support using inhouse build of CEF
# 10-Feb-2025 MVK         Q-12-50 $$457 print net use
# 05-Mar-2025 sgandepalli Q-12-54 $$458 change for skip message
# 06-Mar-2025 sgandepalli Q-12-54 $$459 list all file
# 24-Mar-2025 sgandepalli Q-12-55 $$460 change for collab test
# 28-Mar-2025 sgandepalli Q-13-01 $$461 added CREO_SAAS_CREO_WAIT_READY
# 16-April-2025 sgandepalli Q-13-04 $$462 change for CHD-3678
# 23-April-2025 sgandepalli Q-13-05 $$463 for future date run
# 25-April-2025 skumar      Q-13-05 $$464 change for WG_GENERATE_CODE, WG_TEST_GENERATED_CODE
# 28-April-2025 sgandepalli Q-13-05 $$465 to support UI_TRAIL_STRICT_VALIDATION
# 29-April-2025 sgandepalli P-90-58 $$466 to support edge
# 07-May-2025   skumar      Q-13-07 $$467 Updated widget directories to lowercase
# 08-May-2025 sgandepalli Q-13-07 $$468 change for collabsvc 
# 09-May-2025 sgandepalli Q-13-07 $$469 change for WG
# 13-May-2025 sgandepalli Q-13-08 $$470 make UI_TRAIL_STRICT_VALIDATION default 
# 26-May-2025 sgandepalli Q-13-09 $$471 to use openglimages for vulkan run 
# Please enter date in DD-MMM-YYYY format for consistency with previous history comments

############################################################################
