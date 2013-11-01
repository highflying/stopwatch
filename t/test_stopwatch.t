use Test::More;

use strict;
use warnings;
use Time::HiRes qw( sleep );

use_ok('StopWatch');

can_ok( 'StopWatch', 'new' );

isa_ok( StopWatch->new, "StopWatch" );

can_ok( 'StopWatch', 'start' );

can_ok( 'StopWatch', 'stop' );
can_ok( 'StopWatch', 'isRunning' );
can_ok( 'StopWatch', 'duration' );

note( 'Getting Stopwatch instance' );
my $stopwatch = StopWatch->new;

is( $stopwatch->isRunning, 0, 'New object not running' );

ok( $stopwatch->start, 'New object can be started' );
is( $stopwatch->isRunning, 1, 'New object now running' );
ok( $stopwatch->stop, 'StopWatch can be stopped' );
is( $stopwatch->isRunning, 0, 'StopWatch is stopped' );

note( 'Starting stopwatch' );
$stopwatch->start;

like( $stopwatch->duration, qr/^[0-9]+[.][0-9]{2}$/, 'Can get number of seconds it has been running' );

note( 'Sleeping for 0.5 seconds' );
sleep 0.5;

cmp_ok( $stopwatch->duration, '>=', 0.5, 'Been running for at least 0.5 seconds' );

note( 'Sleeping for 0.5 seconds' );
sleep 0.5;

cmp_ok( $stopwatch->duration, '>=', 1, 'Been running for at least 1 second' );

note( 'Stopping stopwatch' );
$stopwatch->stop;
note( 'Sleeping for 0.5 seconds' );
sleep 0.5;

cmp_ok( $stopwatch->duration, '<=', 2, 'Been running for less than 2 seconds' );

note( 'Restarting stopwatch' );
$stopwatch->start;

cmp_ok( $stopwatch->duration, '<', 1, 'Been running for less than 1 second' );

note( 'Stopping stopwatch' );
$stopwatch->stop;

#can_ok( $stopwatch, 'start_time' );
#isa_ok( $stopwatch->start_time, 'DateTime' );
#
#my $start_time = $stopwatch->start_time;
#
#can_ok( $stopwatch, 'stop_time' );
#isa_ok( $stopwatch->stop_time, 'DateTime' );
#
#note( 'Sleeping for 1.1 seconds' );
#sleep 1.1;
#
#note( 'Restarting stopwatch' );
#$stopwatch->start;
#
#my $new_start_time = $stopwatch->start_time;
#
#diag( "Original start time: $start_time" );
#diag( "New start time: $new_start_time" );
#
#isnt( "$start_time", "$new_start_time", 'Should have different times' );

done_testing();

