# INI file parser 
package timeout_unix;  # assumes timeout_unix.pm

use dbgetc;
use strict;

BEGIN {
    use Exporter   ();
    use vars       qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    
    @ISA         = qw(Exporter);
    @EXPORT      = qw(&SysTOCmd);
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
#            on UNIX machines
#############################################################
sub SysTOCmd 
{

    my ($Cmd, $dontExit) = @_;
    my ($Stat, $pid);
    my $time_out = $ENV{'SIM_TIMEOUT'};

    if ($pid = fork) {
        waitpid($pid,0);
        $Stat = $?;
    } else {
        ### Timeout eval block for UNIX
        setpgrp(0,0);
        eval 
        {
            local $SIG{ALRM} = sub { die "CASE TIMED-OUT\n" };
            alarm($time_out);
            dprint("\t$Cmd");
            $Stat = system("$Cmd");
            eprint("PREMATURE EXIT: $Cmd") if ( $Stat );
            alarm(0);
        };

        #Important - race condition protection
        alarm(0);

        ### Process eval Error Message
        if ( $@ ) 
        {
            if ( $@ eq "CASE TIMED-OUT\n" )
            {
                eprint("TIMED-OUT TIMED-OUT TIMED-OUT");
                # The following line causes regDB to report a timeout.
                eprint("This test is killed due to time out\n");
                kill(9,-$$);
            } else {
                dprint("$@");
            }
        }
        exit($Stat);
    }

    if ( $dontExit or not $Stat ) {
        return $Stat;
    } else { 
        exit($Stat);
    }
}

#############################################################

END { }       # module clean-up code here (global destructor)

1; #Important
