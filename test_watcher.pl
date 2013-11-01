#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

use App::Prove;
use File::ChangeNotify::Watcher::Default;

my @paths = @ARGV;

if ( not @paths )
{
    @paths = ('.');
}

watch_for_changes(@paths);

sub watch_for_changes
{
    my (@paths) = @_;

    my $watcher = File::ChangeNotify::Watcher::Default->new(
        directories => \@paths,
        filter      => qr/ [.] (pl|pm|t) \z /sxm,
    );

    print STDERR "#################### Running Tests ####################\n\n";

    run_tests();

    print STDERR "\n#################### Watching for Changes ####################\n";

    while ( my @events = $watcher->wait_for_events )
    {
        print STDERR "\nChanges found...\n\n";

        for my $event (@events)
        {
            print STDERR 'File changed: ', $event->path, ' (', $event->type, ")\n";
        }

        print STDERR "\n#################### Re-Running Tests ####################\n\n";

        run_tests();

        print STDERR "\n#################### Watching for Changes ####################\n";
    }
}

sub run_tests
{
    if ( fork == 0 )
    {
        my $app = App::Prove->new;
        $app->process_args( '-v', 't' );
        exit( $app->run ? 0 : 1 );
    }

    wait;

    return;
}
