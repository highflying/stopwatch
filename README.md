stopwatch
=========

Used as the basis of a Moose training session.

The idea is to take an StopWatch object that is written in the traditional
Perl OO and re-write it into a Moose object.

The StopWatch has full test coverage, so it can be used to show that each
change made doesn't break the object.

StopWatch_orig.pm is the traditional Perl OO object.
StopWatch_moose.pm is the refactored Moose object.
Run test_watcher.pl to automatically re-run the tests on each saved change.
