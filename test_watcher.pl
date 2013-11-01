#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

use App::Prove;
use File::ChangeNotify::Watcher::Default;
use List::MoreUtils qw( distinct );

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
        directories     => \@paths,
        filter          => qr/ [.] (pl|pm|t) \z /sxm,
        follow_symlinks => 1,
    );

    print STDERR "#################### Running Tests ####################\n\n";

    run_tests();

    print STDERR "\n#################### Watching for Changes ####################\n";

    while ( my @events = $watcher->wait_for_events )
    {
        sleep 1;

        push @events, $watcher->new_events;

        print STDERR "\nChanges found...\n\n";

        for my $event (@events)
        {
            print STDERR 'File changed: ', $event->path, ' (', $event->type, ")\n";
        }

        my @code_paths = distinct map { $_->path }
          grep { $_->path =~ / [.] (?:pl|pm) \z /sxm and $_->type ne 'delete' } @events;

        my $run_tests = 1;

        if (@code_paths)
        {
            print STDERR
              "\n#################### Checking Syntax ####################\n\n";

            for my $code_file (@code_paths)
            {
                my $rc = system( 'perl', '-c', $code_file );
                if ($rc)
                {
                    $run_tests = 0;
                }
            }
        }

        if ($run_tests)
        {
            print STDERR
              "\n#################### Re-Running Tests ####################\n\n";

            run_tests();
        }

        print STDERR "\n#################### Watching for Changes ####################\n";
    }
}

sub run_tests
{
    my $child_pid = fork;

    if ( $child_pid == 0 )
    {
        my $app = App::Prove->new;
        $app->process_args( '-v', 't' );
        my $rc = $app->run ? 0 : 1;

        if ($rc)
        {

            print STDERR <<FAIL;

           FFFFF   A    III L
           F      A A    I  L
           F     A   A   I  L
           FFFF A     A  I  L
           F    AAAAAAA  I  L
           F    A     A  I  L
           F    A     A III LLLLL

FAIL
        }

        exit($rc);
    }

    local $SIG{INT} = sub
    {
        kill 9, $child_pid;
        exit;
    };

    wait;

    local $SIG{INT} = 'DEFAULT';

    return;
}
