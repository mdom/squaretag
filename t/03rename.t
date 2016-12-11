#!/usr/bin/perl

use strict;
use warnings;

use File::Temp 'tempdir';

use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

is_deeply(
    [ rename_tag( 'foo', 'bar', 'file[foo].txt' ) ],
    [ [ 'file[foo].txt' => 'file[bar].txt' ] ]
);
is_deeply( [ rename_tag( 'foo', 'foo',  'file[foo].txt' ) ], [] );
is_deeply( [ rename_tag( 'bar', 'quux', 'file[foo].txt' ) ], [] );

done_testing;
