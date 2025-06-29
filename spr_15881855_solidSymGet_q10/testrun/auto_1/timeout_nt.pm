# INI file parser 
package timeout_nt;  # assumes timeout_nt.pm

use lib ($0 =~/(.+)\/.+$/);
use dbgetc;
use strict;
use Win32::Process;

BEGIN {
    use Exporter   ();
    use vars       qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    
    @ISA         = qw(Exporter);
    @EXPORT      = qw(&SysTOCmd );
    %EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],

    # your exported package globals go here,
    # as well as any optionally exported functions
    @EXPORT_OK   = ();
        
}
use vars   @EXPORT,@EXPORT_OK;

#############################################################
# RECEIVES:  A String containing a system command
# RETURNS:   Nothing
# PURPOSE:   Execute System commands with a time out function 
#            on NT machines
#############################################################
sub SysTOCmd 
{

    my ($Cmd, $NoExit) = @_;

    my $time_out = $ENV{'SIM_TIMEOUT'};

    my ($Process, $PID, $AppName, $Ext);
    my ( @WinExt, $Hamilton, $Proc, $KNAME);

    $Cmd =~ s/\//\\/g;
    $Cmd =~ s/^\s+//g;     # Remove leading spaces
    $Cmd =~ s/\s{2,}/ /g; # Make sure there are only single white spaces

    ($AppName) = split(/ /,$Cmd);

    ####### Figure out the extension for the given command
    @WinExt = ( '.com', '.exe', '.bat', '.cmd' );
    foreach $Ext ( @WinExt ) 
    {
        if ( -f $AppName . $Ext )
        {
              $AppName = $AppName . $Ext;
              last;
        }
    }
    ######################################################
 
    dprint("\t$Cmd");
    
    unless ( -e $AppName ) {
        eprint("ERROR: Command not found: $AppName");
        exit(1)
    }
        
    Win32::Process::Create($Process,
                          "$AppName",
                          "$Cmd",
                           1,
                           CREATE_NEW_PROCESS_GROUP,
                          ".") || eprint "ERROR: Did not make process \"$AppName\"";
    $PID = $Process->GetProcessID();
    

    my $exitcode = 259;  # value returned until there is an exit status 
    my $Timer    = 0;

    ### Timer ##################################
    while ( $exitcode == 259  and $Timer < $time_out ) 
    {
        sleep 2;
        $Timer = $Timer + 2;
        $Process->GetExitCode($exitcode);  # Returns 259 until process exits
    }
    ############################################


    ### Kill Timed Out Processes
    if ( $exitcode == 259 ) 
    {
#       my ( $TList, @All_PIDS, $Kill_List, $Keep, $KPID, $KName);
        my $Stopped = $Process->Suspend();
        if ( $Stopped == 0 ) 
        {
            ### Kill msengine if it is running ###
            opendir(DIR, '.') or dprint("    Could not read Dir ( in timeout_nt.pm )");
            my @DirFiles = grep { /^msengine\d+$/ } readdir(DIR);
            closedir(DIR);
            my $MsePID = pop(@DirFiles);
            $MsePID =~ s/^msengine//;
            eprint("TIMED-OUT TIMED-OUT TIMED-OUT\n");
            # The following line causes regDB to report a timeout.
            eprint("This test is killed due to time out\n");
            # needed to kill pop-up window when xtop crashes
	    # this is not the right thing to do according to Microsoft
            # system("$ENV{TOOLDIR}$ENV{PRO_MACHINE_TYPE}/KILL32 CSRSS");  
            # Needed to kill the msengine process if it exists
            my $ExitCode;
            Win32::Process::KillProcess($MsePID, $ExitCode) if ( defined $MsePID ); 
            Win32::Process::KillProcess($PID, $ExitCode);
        }
        exit(1) unless ( $NoExit ) ;
    }

    ### return exit status
    if ( $exitcode ) {
        eprint("\tPREMATURE EXIT: $Cmd\tstatus => $exitcode\n ");
        exit(1) unless ( $NoExit ) ;
    } else {
        dprint("\tEXIT OK => $Cmd\tstatus => $exitcode");
    }
    return $exitcode;
}

#############################################################

END { }       # module clean-up code here (global destructor)

1; #Important
