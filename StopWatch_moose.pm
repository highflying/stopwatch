package StopWatch;
use Moose;
use DateTime;
use Time::HiRes qw( time );

has start_time => (
    is         => 'ro',
    isa        => 'DateTime',
    clearer    => '_clear_start_time',
    lazy_build => 1,
);

has stop_time => (
    is         => 'ro',
    isa        => 'DateTime',
    clearer    => '_clear_stop_time',
    lazy_build => 1,
);

has _start_time => (
    is        => 'rw',
    predicate => '_has_start_time',
    trigger   => sub { my $self = shift; $self->_clear__stop_time; $self->_clear_start_time; $self->_clear_stop_time; },
);

sub _build_start_time
{
    my $self = shift;
    return DateTime->from_epoch( epoch => $self->_start_time );
}

sub _build_stop_time
{
    my $self = shift;
    return DateTime->from_epoch( epoch => $self->_stop_time );
}

has _stop_time => (
    is         => 'ro',
    clearer    => '_clear__stop_time',
    predicate  => '_has_stop_time',
    lazy_build => 1,
);

sub _build__stop_time
{
    return time;
}

sub start
{
    my $self = shift;
    return $self->_start_time(time);
}

sub stop
{
    my $self = shift;
    return $self->_stop_time;
}

sub isRunning
{
    my $self = shift;
    return ( $self->_has_start_time and not $self->_has_stop_time ) ? 1 : 0;
}

sub duration
{
    my $self = shift;
    my $stop_time = $self->_has_stop_time ? $self->_stop_time : time;
    return sprintf '%.2f', $stop_time - $self->_start_time;
}

__PACKAGE__->meta->make_immutable;

1;
