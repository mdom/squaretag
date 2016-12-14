#!/usr/bin/perl

use strict;
use warnings;

use FindBin '$Bin';
use Test::More;
use File::Temp 'tempdir';

require_ok("$Bin/../bin/squaretag");

my $tempdir = tempdir( CLEANUP => 1 );
chdir $tempdir;

my $fh;
open($fh,'>','file.txt');

sub test_output {
    my ( $args, $expect, $name ) = @_;
    my $got;
    open( my $fh, '>', \$got );
    my $old = select($fh);
    eval { run(@$args) };
    select($old);
    return is( $got, $expect, $name );
}

test_output [qw(add -v foo file.txt)], <<EOF;
file.txt -> file[foo].txt
EOF

test_output [qw(rename -v foo bar file[foo].txt)], <<EOF;
file[foo].txt -> file[bar].txt
EOF

test_output [qw(list file[bar].txt)], <<EOF;
bar 1
EOF

test_output [qw(search bar file[bar].txt)], <<EOF;
file[bar].txt
EOF

test_output [qw(add -v foo file[bar].txt)], <<EOF;
file[bar].txt -> file[bar,foo].txt
EOF

test_output ['remove','-v', 'foo', 'file[bar,foo].txt'], <<EOF;
file[bar,foo].txt -> file[bar].txt
EOF

test_output [qw(mv -v bar foo file[bar].txt)], <<EOF;
file[bar].txt -> file[foo].txt
EOF

test_output [qw(clear -v file[foo].txt)], <<EOF;
file[foo].txt -> file.txt
EOF

test_output [qw(untagged file.txt)], <<EOF;
file.txt
EOF

done_testing;
