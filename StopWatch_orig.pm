package StopWatch;
use strict;
use warnings;

use Time::HiRes qw( time );

sub new
{
    my $class = shift;

    my $self = {};
    bless $self, ref($class) || $class;

    return $self;
}

sub start
{
    my $self = shift;
    $self->{start_time} = time;
    delete $self->{stop_time};
    return 1;
}

sub stop
{
    my $self = shift;
    $self->{stop_time} = time;
    return 1;
}

sub isRunning
{
    my $self = shift;
    return ( $self->{start_time} and not $self->{stop_time} ) ? 1 : 0;
}

sub duration
{
    my $self = shift;
    my $stop_time = defined $self->{stop_time} ? $self->{stop_time} : time;
    return sprintf '%.2f', $stop_time - $self->{start_time};
}

1;
