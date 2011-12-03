#!/usr/bin/env perl
use FindBin;use Fileio;use WWW::Mechanize;use URI;use Web::Scraper;
our $VERSION='0.1.2';$items=scraper{process '.hotentry.main-entries .entry-body'
,'items[]'=>scraper{process '.entry-link',url=>'@href';process
'.entry-info .tags .tag','tags[]'=>'TEXT'}};
sub each_item(&$) {$_[0]->() for @{$items->scrape(URI->new($_[1]))->{items}}}
($id,$pw)=readlines "$FindBin::Bin/user.txt";
$mech=WWW::Mechanize->new;$mech->get('https://techp.jp/login');
$mech->submit_form(fields=>{id=>$id,pw=>$pw});
$mech->get('https://techp.jp/news/post?_='.time*1000);
each_item {$mech->submit_form(fields=>{url=>$_->{url}});$mech->submit_form(
fields=>{tags=>join(' ',@{$_->{tags}})})} 'http://b.hatena.ne.jp/hotentry/it';
