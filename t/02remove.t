#!/usr/bin/perl

use strict;
use warnings;
use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

my @tests = (
	[ 'foo[read].txt' => 'foo.txt', undef ],
	[ 'foo[read,bar].txt' => 'foo.txt', undef ],
	[ 'foo.txt' => 'foo.txt', undef ],
	[ 'foo' => 'foo', undef ],
	[ '[]' => '[]', undef ],
	[ '[foo]' => '[foo]', undef ],
);

for my $t (@tests) {
    is( remove_tags( $t->[0] ), $t->[1], $t->[2] );
}

done_testing;
