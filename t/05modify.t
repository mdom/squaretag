#!/usr/bin/perl

use strict;
use warnings;

use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

is_deeply( modify( 'foo', '+', 'file.txt' ),
    [ [ 'file.txt' => 'file[foo].txt' ] ] );

is_deeply(
    modify( 'foo+', '+', 'file.txt' ),
    [ [ 'file.txt' => 'file[foo].txt' ] ]
);

is_deeply(
    modify( 'foo', '-', 'file[foo].txt' ),
    [ [ 'file[foo].txt' => 'file.txt' ] ]
);

is_deeply(
    modify( 'foo-', '-', 'file[foo].txt' ),
    [ [ 'file[foo].txt' => 'file.txt' ] ]
);

is_deeply( modify( 'foo-', '-', 'file.txt' ), [] );

is_deeply( modify( '', '-', 'file.txt' ), [] );

is_deeply(
    modify( 'foo,,bar-', '+', 'file.txt' ),
    [ [ 'file.txt' => 'file[foo].txt' ] ]
);

done_testing;
