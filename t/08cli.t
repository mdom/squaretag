#!/usr/bin/perl

use strict;
use warnings;

use FindBin '$Bin';
use Test::More;
use File::Temp 'tempdir';

require_ok("$Bin/../bin/squaretag");

my $tempdir = tempdir( CLEANUP => 1 );
chdir $tempdir;
$ENV{HOME} = '.';

my $fh;
open( $fh, '>', 'file.txt' );

sub capture {
    my (@args) = @_;
    my $got;
    local *STDOUT;
    open STDOUT, '>', \$got;
    local *STDERR;
    open STDERR, '>', \$got;
    eval { run(@args) };
    if ($@) {
        $got .= $@;
    }
    return $got;
}

is capture(qw(add -v foo file.txt)), <<EOF;
file.txt -> file[foo].txt
EOF

is capture(qw(rename -v foo bar file[foo].txt)), <<EOF;
file[foo].txt -> file[bar].txt
EOF

is capture(qw(list file[bar].txt)), <<EOF;
bar 1
EOF

is capture(qw(search bar file[bar].txt)), <<EOF;
file[bar].txt
EOF

is capture(qw(add -v foo file[bar].txt)), <<EOF;
file[bar].txt -> file[bar,foo].txt
EOF

is capture( 'remove', '-v', 'foo', 'file[bar,foo].txt' ), <<EOF;
file[bar,foo].txt -> file[bar].txt
EOF

is capture(qw(mv -v bar foo file[bar].txt)), <<EOF;
file[bar].txt -> file[foo].txt
EOF

is capture(qw(clear -v file[foo].txt)), <<EOF;
file[foo].txt -> file.txt
EOF

is capture(qw(untagged file.txt)), <<EOF;
file.txt
EOF

is capture(qw(add -v foo bar.txt)), <<EOF;
Skip missing file bar.txt.
EOF

BEGIN {
    *CORE::GLOBAL::exit = sub (;$) { die }
}
$0 = "$Bin/../bin/squaretag";

like capture(qw(add !foo file.txt)), qr/^Invalid tag !foo/;

open( $fh, '>', 'bar[foo].txt' );
open( $fh, '>', 'bar.txt' );

is capture(qw(add -v foo bar.txt)), <<EOF;
Skip moving bar.txt to bar[foo].txt: File already exists.
EOF

is capture(qw(search foo;bar foo.txt)), <<EOF;
Error at foo;bar
            ^
EOF

like capture(), qr/^Usage:/;

like capture('add'), qr/^Usage:/;

open( my $cfg, '>', '.squaretagrc' );

print $cfg qq{separator = " " # by space\n};
close $cfg;

is capture(qw(add -v quux bar[foo].txt)), <<EOF;
bar[foo].txt -> bar[foo quux].txt
EOF

chdir("..");

done_testing;
