#------------------------------------------------------------------------
# fuzzyclock.pm
#
# Tells people what time it is, in whatever timezone the infobot is set
# to at the moment.
#
# TODO
# Make it psychic enough to figure out what timezone you're in, and have
# it tell you the right time.  (Ha ha ha)
#
# $Id: fuzzyclock.pm,v 1.18 2004/09/12 21:46:10 dagbrown Exp $
#------------------------------------------------------------------------

use strict;
package fuzzyclock;

sub fuzzytime {
    my $this=shift;
    my $time=shift;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);

    if(defined($time)) {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $time;
    } else {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    }

    my $timestring;

    my $myhour=$hour;

    if($min==0 and $sec==0) {
        $timestring="exactly";
    } else {
        $timestring=(("just about","about","about","nearly","nearly")
                [$min%5])
    }

    if($min>=33){
        $myhour++;
    }

    $timestring .= " ";

    if(($min >= 0 and $min <= 2) or ($min >= 57 and $min <= 59)) {
        $timestring .= "%s o'clock";
    } elsif($min >= 3 and $min <= 7) {
        $timestring .= "five past %s";
    } elsif($min >= 8 and $min <= 12) {
        $timestring .= "ten past %s";
    } elsif($min >= 13 and $min <= 17) {
        $timestring .= "quarter past %s";
    } elsif($min >= 18 and $min <= 22) {
        $timestring .= "twenty past %s";
    } elsif($min >= 23 and $min <= 27) {
        $timestring .= "twenty-five past %s";
    } elsif($min >= 28 and $min <= 32) {
        $timestring .= "half past %s";
    } elsif($min >= 33 and $min <= 37) {
        $timestring .= "twenty-five to %s";
    } elsif($min >= 38 and $min <= 42) {
        $timestring .= "twenty to %s";
    } elsif($min >= 43 and $min <= 47) {
        $timestring .= "quarter to %s";
    } elsif($min >= 48 and $min <= 52) {
        $timestring .= "ten to %s";
    } elsif($min >= 53 and $min <= 57) {
        $timestring .= "five to %s";
    }

    if($myhour==0 or $myhour==24) {
        $timestring=~s/ o'clock//;
        $timestring=sprintf($timestring,"midnight");
    } else {
        if($myhour >= 1 and $myhour <= 4) {
            $timestring .= " in the middle of the night";
        } elsif($myhour >= 5 and $myhour <= 11) {
            $timestring .= " in the morning";
	} elsif($myhour == 12 ) {
	    $timestring .= "noon";
        } elsif($myhour >= 13 and $myhour <= 17 ) {
            $timestring .= " in the afternoon";
        } elsif($myhour >= 18 and $myhour <= 20 ) {
            $timestring .= " in the evening";
        } elsif($myhour >= 21 and $myhour <= 23 ) {
            $timestring .= " at night";
        }
    }

    $myhour-=12 if $myhour>=12;

    my @hours=(
            "", "one", "two", "three", "four", "five", "six",
            "seven", "eight", "nine", "ten", "eleven", ""
            );

    return sprintf($timestring,$hours[$myhour]);
}

sub scan(&$$) {
    my ($callback, $message, $who) = @_;
    
    if($message =~ /(?:what time (?:is (?:it|(\d+))|do you have))|(?:fuzzy?(?:clock|time))\??/i) {
        if($1) {
            $callback->("$1 is ".fuzzytime($1).", $who.");
        } else {
            if(rand()>0.5) {
                $callback->("It's ".fuzzytime().", $who.");
            } else {
                $callback->("$who: It's ".fuzzytime()." where I am.");
            }
        }
        return "NOREPLY";
    }
    undef;
}

"fuzzyclock";

__END__
=pod

=head1 NAME

fuzzyclock.pm - let infobot tell you what time it is

=head1 PREREQUISITES

I was originally going to just make this require Ruby, but then I
figured that might be unreasonable.  So now it doesn't have any
prerequisites (apart from Perl).

=head1 PUBLIC INTERFACE

sigio, what time is it?

=head1 DESCRIPTION

This tells you what time it is, at least according to the infobot
you're asking.  (This is generally less-than-useful in an IRC
environment, because you often find people from all over the world
on an IRC channel.)

=head1 AUTHOR

Dave Brown (dagbrown@rogers.com)
