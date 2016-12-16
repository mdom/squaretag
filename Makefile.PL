#!/usr/bin/perl
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME       => "App::squaretag",
    VERSION    => 0.04,
    EXE_FILES  => ['bin/squaretag'],
    META_MERGE => {
        "meta-spec" => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url =>
                  'git://github.com/mdom/squaretag.git',
                web =>
                  'https://github.com/mdom/squaretag',
            },
        },
    },
);

sub MY::c_o {
    "cover:\n\tHARNESS_PERL_SWITCHES=-MDevel::Cover make test && cover";
}
