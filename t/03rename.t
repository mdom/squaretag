#!/usr/bin/perl

use strict;
use warnings;

use File::Temp 'tempdir';

use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

sub get_tags {
    my $file = shift;
    my ( $base, $tags, $suffix ) = split_file($file);
    return $tags;
}

sub touch {
    open( my $fh, '>', $_[0] ) or die "$!\n";
}

my $tempdir = tempdir( CLEANUP => 1 );

my $file = "$tempdir/file.dat";
touch($file);

modify( 'foo', '+', $file );
($file) = glob("$tempdir/*");
rename_tag( 'foo', 'bar', $file );
($file) = glob("$tempdir/*");

is( get_tags($file), 'bar' );

rename_tag( 'bar', 'bar', $file );

is( get_tags($file), 'bar' );

rename_tag( 'foo', 'quux', $file );

is( get_tags($file), 'bar' );

modify( 'foo', '+', $file );
($file) = glob("$tempdir/*");

rename_tag( 'foo', 'quux', $file );
($file) = glob("$tempdir/*");
is( get_tags($file), 'bar,quux' );

unlink $file;

done_testing;
