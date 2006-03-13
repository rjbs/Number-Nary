use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Number::Nary',
    AUTHOR              => 'Ricardo Signes <rjbs@cpan.org>',
    VERSION_FROM        => 'lib/Number/Nary.pm',
    ABSTRACT_FROM       => 'lib/Number/Nary.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Carp'            => 0,
        'Test::More'      => 0,
        'List::MoreUtils' => 0.09,
        'Sub::Exporter'   => 0.90,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Number-Nary-*' },
);
