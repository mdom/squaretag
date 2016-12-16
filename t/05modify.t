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

is_deeply(
    modify( 'year=2016', '+', 'file.txt' ),
    [ [ 'file.txt' => 'file[year=2016].txt' ] ]
);

is_deeply(
    modify( 'year', '+', 'file[year=2015].txt' ),
    [ [ 'file[year=2015].txt' => 'file[year].txt' ] ]
);

is_deeply(
    modify( 'year=2016', '+', 'file[year=2015].txt' ),
    [ [ 'file[year=2015].txt' => 'file[year=2016].txt' ] ]
);

is_deeply(
    modify( 'year', '-', 'file[year=2015].txt' ),
    [ [ 'file[year=2015].txt' => 'file.txt' ] ],
    'Remove tagvalue with unvalued tag'
);

is_deeply(
    modify( 'year=2015', '-', 'file[year=2015].txt' ),
    [ [ 'file[year=2015].txt' => 'file.txt' ] ],
    'Remove tagvalue with identical valued tag'
);

is_deeply( modify( 'year=2014', '-', 'file[year=2015].txt' ), [] );
is_deeply(
    modify( 'year=2016', '+', 'file[year].txt' ),
    [ [ 'file[year].txt' => 'file[year=2016].txt' ] ]
);

is_deeply(
    modify( 'year=current', '+', 'file[year=2015].txt' ),
    [ [ 'file[year=2015].txt' => 'file[year=current].txt' ] ]
);

is_deeply(
    modify( { separator => ' ' }, 'bar', '+', 'file[foo].txt' ),
    [ [ 'file[foo].txt' => 'file[bar foo].txt' ] ]
);

is_deeply(
    modify( { separator => ' ' }, 'bar', '-', 'file[bar foo].txt' ),
    [ [ 'file[bar foo].txt' => 'file[foo].txt' ] ]
);

done_testing;
