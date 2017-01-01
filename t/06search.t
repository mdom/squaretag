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

is_deeply( search_tags( 'year', 'file[year=2009].txt' ),
    ['file[year=2009].txt'] );
is_deeply( search_tags( 'year=2009', 'file[year=2009].txt' ),
    ['file[year=2009].txt'] );
is_deeply( search_tags( 'year=2008', 'file[year=2009].txt' ), [] );
is_deeply( search_tags( 'year>2008', 'file[year=2009].txt' ),
    ['file[year=2009].txt'] );
is_deeply( search_tags( 'year<2010', 'file[year=2009].txt' ),
    ['file[year=2009].txt'] );
is_deeply( search_tags( 'year>2010', 'file[year=2009].txt' ), [] );
is_deeply( search_tags( 'year>2010', 'file[foo].txt' ),       [] );
is_deeply( search_tags( 'author=mdom', 'file[author=mdom].txt' ),
    ['file[author=mdom].txt'] );
is_deeply( search_tags( '!author=mdom', 'file[author=mdom].txt' ), [] );
is_deeply( search_tags( 'author=dom',   'file[author=mdom].txt' ), [] );
is_deeply( search_tags( 'author~dom',   'file[author=mdom].txt' ),
    ['file[author=mdom].txt'] );

is_deeply(
    search_tags(
        { implicit => '^(?<author>.+?),' },
        'author=Pratchett',
        'Pratchett, Terry - Colors of Magic.epub'
    ),
    ['Pratchett, Terry - Colors of Magic.epub']
);

is_deeply(
    search_tags(
        { implicit => '^(?<author>.+?),' },
        'author=Pratchett',
        'Pratchett, Terry - Colors of Magic[read].epub'
    ),
    ['Pratchett, Terry - Colors of Magic[read].epub']
);

is_deeply(
    search_tags(
        { implicit => '^(?<author>.+?),' },
        'author=Pratchett',
        'Pratchett, Terry - Colors of Magic[author=Assimov].epub'
    ),
    []
);

is_deeply(
    search_tags(
        { implicit => '^(?<author>.+?),' },
        'author=Assimov',
        'Pratchett, Terry - Colors of Magic[author=Assimov].epub'
    ),
    ['Pratchett, Terry - Colors of Magic[author=Assimov].epub']
);

is_deeply(
    search_tags(
        { implicit => '^(?<author>.+?),' },
        'implicit()',
        'Pratchett, Terry - Colors of Magic[author=Assimov].epub'
    ),
    ['Pratchett, Terry - Colors of Magic[author=Assimov].epub']
);

is_deeply(
    search_tags(
        { implicit => '^(?<author>.+?),' },
        'implicit()',
        'Pratchett - Colors of Magic[author=Assimov].epub'
    ),
    []
);

is_deeply( search_tags( 'tagged()', 'file[author=mdom].txt' ),
    ['file[author=mdom].txt'] );

is_deeply( search_tags( '!tagged()', 'file[author=mdom].txt' ), [] );

BEGIN {
    *CORE::GLOBAL::exit = sub (;$) { }
}

sub capture {
    my $code = shift;
    my $got;
    local *STDOUT;
    open STDOUT, '>', \$got;
    local *STDERR;
    open STDERR, '>', \$got;
    eval { $code->(); };
    if ($@) {
        $got .= $@;
    }
    return $got;
}

is capture( sub { search_tags( 'author < mdom', 'file[author=mdom].txt' ) } ),
  <<EOF;
Operand mdom isn't numeric in numerical comparison.
EOF
is capture( sub { search_tags( 'author > mdom', 'file[author=mdom].txt' ) } ),
  <<EOF;
Operand mdom isn't numeric in numerical comparison.
EOF

is capture( sub { search_tags( 'author > ', 'file[author=mdom].txt' ) } ),
  <<EOF;
No operand on right side of author.
EOF

is capture( sub { search_tags( 'author > &&', 'file[author=mdom].txt' ) } ),
  <<EOF;
Operand && isn't numeric in numerical comparison.
EOF

done_testing;
