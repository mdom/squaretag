#!/usr/bin/perl

use strict;
use warnings;
use FindBin '$Bin';
use Test::More;

require_ok("$Bin/../bin/squaretag");

my @tests = (
    [ 'foo'   => [ 'foo',   '', '' ] => 'File without tag and extension' ],
    [ '[]'    => [ '[]',    '', '' ] => 'File with just []' ],
    [ '[foo]' => [ '[foo]', '', '' ] => 'File with just [foo]' ],
    [ '[foo].ext' => [ '[foo]', '', '.ext' ] => 'File with just [foo].ext' ],
    [
        'foo.txt' => [ 'foo', '', '.txt' ] =>
          'File without tag but with extension'
    ],
    [
        'foo[read].ext' => [ 'foo', 'read', '.ext' ] =>
          'File with tag and extension'
    ],
    [
        'foo[read,good].ext' => [ 'foo', 'read,good', '.ext' ] =>
          'File with tags and extension'
    ],
    [
        'foo[read,good]' => [ 'foo', 'read,good', '' ] =>
          'File with tags but no extension'
    ],
    [
        'foo[first book][read,good]' =>
          [ 'foo[first book]', 'read,good', '' ] =>
          'File with tags and squares'
    ],
    [
        'foo[first book][read,good].ext' =>
          [ 'foo[first book]', 'read,good', '.ext' ] =>
          'File with tags and squares and extension'
    ],
    [
        '/foo/bar[quux].txt' => [ '/foo/bar', 'quux', '.txt' ] =>
          'File with path'
    ],
    [
        'c:\foo\bar[quux].txt' => [ 'c:\foo\bar', 'quux', '.txt' ] =>
          'File with windows path'
    ],
);

for my $t (@tests) {
    is_deeply( [ split_file( $t->[0] ) ], $t->[1], $t->[2] );
}

done_testing;
