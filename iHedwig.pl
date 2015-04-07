#!/usr/local/scsperl/5.8.9/bin/perl

use strict;
use lib "$ENV{SCMS_HOME}/lib";
use determinePrimaryLan;
use popup;
use Tk;
my %displayRefs;

my $lan = determinePrimaryLan::getPrimaryLan();

my $numberRunning = `ps auxww | grep -v grep | grep -i java | grep -i '../config/logging.properties' | wc -l`;
print "num is $numberRunning\n";

if ( $numberRunning > 0 ) {
    print "throwing box up \n";
    my $string    = "iHedwig is already running on this node!!!";
    my $timeStamp = `date '+%T %Z'`;
    $displayRefs{sml2}{warning} = MainWindow->new();
    $displayRefs{sml2}{warning} ->configure( -title => $timeStamp, -background => 'grey' );
    $displayRefs{sml2}{warning} ->geometry('1080x120');
    $displayRefs{sml2}{main} = $displayRefs{sml2}{warning}->Frame( -background => 'grey' ) ->pack( -side => 'top', -expand => 1, -fill => 'both' );
    $displayRefs{sml2}{text} = $displayRefs{sml2}{main}->Scrolled("Text",
        -scrollbars       => 'e',
        -background       => "red",
        -foreground       => 'black',
        -insertbackground => 'lightgrey',
        -font             => "Helvetica18",
        -wrap             => 'word',
        -width            => 5,
        -height           => 5,
        -relief           => 'sunken',
        -height           => 5
    )->pack( -side => 'top', -fill => 'both', -expand => 1 );
    $displayRefs{sml2}{text}->Subwidget("yscrollbar") ->configure( -background => 'darkgrey' );
    $displayRefs{sml2}{'close'} = $displayRefs{sml2}{text}->Button(
        -text       => 'Acknowledge',
        -font       => "Helvetica12",
        -command    => sub { $displayRefs{sml2}{warning}->destroy; },
        -background => 'grey',
        -relief     => 'groove'
    )->pack( -side => 'bottom' );
    $displayRefs{sml2}{text}->insert( 'end', $string );
    &bell( $displayRefs{sml2}{main} );
}
else {
    print "YAY launched!\n";
    system("$ENV{SCMS_HOME}/ihedwig/bin/ihedwig.sh &");
}

sub bell {
    my $main = shift;
    $main->bell();
    $main->bell();
    $main->bell();
    $main->after( 5000, [ \&bell, $main ] );
}
MainLoop();
