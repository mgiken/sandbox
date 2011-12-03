#!/usr/bin/env perl
use strict;use FindBin;use Fileio;use WWW::Mechanize;use URI;use Web::Scraper;
our $VERSION = '0.1.1';
sub each_item(&$) {
    my $items = scraper {
        process '.hotentry.main-entries .entry-body', 'items[]' => scraper {
            process '.entry-link', url => '@href';
            process '.entry-info .tags .tag', 'tags[]' => 'TEXT';
        };
    };
    $_[0]->() for @{$items->scrape(URI->new($_[1]))->{items}};
}
my ($id, $pw) = readlines "$FindBin::Bin/user.txt";
my $mech = WWW::Mechanize->new;
$mech->get('https://techp.jp/login');
$mech->submit_form(fields => {id => $id, pw => $pw});
$mech->get('https://techp.jp/news/post?_='.time*1000);
each_item {
    $mech->submit_form(fields => {url => $_->{url}});
    $mech->submit_form(fields => {tags => join(' ', @{$_->{tags}})});
} 'http://b.hatena.ne.jp/hotentry/it';
