#!/usr/bin/perl

use strict;
use warnings;

use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

is_deeply(
    { list_tags(qw/file[foo].txt file2[foo].txt file3.txt file4[bar].txt/) },
    { foo => 2, bar => 1 } );

done_testing;
