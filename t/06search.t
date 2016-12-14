#!/usr/bin/perl

use strict;
use warnings;

use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

is_deeply( search_tags( 'foo', 'file[foo].txt' ), ['file[foo].txt'] );
is_deeply( search_tags( 'bar', 'file[foo].txt' ), [] );
is_deeply( search_tags( 'bar', 'file[foo].txt', 'test[bar].txt' ),
    ['test[bar].txt'] );

is_deeply( search_tags( '!bar', 'file[foo].txt', 'test[bar].txt' ),
    ['file[foo].txt'] );

is_deeply( search_tags( 'foo', 'file[foo].txt', 'test[bar].txt' ),
    ['file[foo].txt'] );

is_deeply( search_tags( 'bar || foo', 'file[foo].txt', 'test[bar].txt' ),
    [ 'file[foo].txt', 'test[bar].txt' ] );

done_testing;
