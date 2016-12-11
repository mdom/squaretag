#!/usr/bin/perl
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME      => "App::squaretag",
    VERSION   => 0.02,
    EXE_FILES => ['bin/squaretag'],
);

sub MY::c_o {
    "cover:\n\tHARNESS_PERL_SWITCHES=-MDevel::Cover make test && cover";
}
