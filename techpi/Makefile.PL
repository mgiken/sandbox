use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'techpi',
    VERSION_FROM      => 'techpi.pl',
    PREREQ_PM         => {
        'WWW::Mechanize' => 0,
        'Web::Scraper'   => 0,
        'XML::FeedPP'    => 0,
    },
);
