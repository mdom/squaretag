#!/usr/bin/perl

use strict;
use warnings;

use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

is_deeply( [ clear('file[foo].txt') ]->[0],
    [ [ 'file[foo].txt' => 'file.txt' ] ] );
is_deeply(
    [ clear('file[bar,foo].txt') ]->[0],
    [ [ 'file[bar,foo].txt' => 'file.txt' ] ]
);
is_deeply( [ clear('file.txt') ]->[0], [ [ 'file.txt' => 'file.txt' ] ] );

done_testing;
