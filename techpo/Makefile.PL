use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'techpo',
    VERSION_FROM      => 'techpo.pl',
    PREREQ_PM         => {
        'WWW::Mechanize' => 0,
        'Web::Scraper'   => 0,
    },
);
