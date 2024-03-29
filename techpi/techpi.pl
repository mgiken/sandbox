#!/usr/bin/env perl
use FindBin;use Encode;use Fileio;use WWW::Mechanize;use URI;
use Web::Scraper;use XML::FeedPP;our $VERSION='0.1';
$items=scraper{process '#news-items article','items[]'=>scraper{process 'h1 a',
link=>'@href',title=>'TEXT';process 'time','pubDate'=>'@datetime';process
'.tags li','category[]'=>'TEXT'}};
sub each_item(&$) {$_[0]->() for @{$items->scrape($_[1])->{items}}}
($id,$pw)=readlines "$FindBin::Bin/user.txt";
$mech=WWW::Mechanize->new;$mech->get('https://techp.jp/login');
$mech->submit_form(fields=>{id=>$id,pw=>$pw});
$mech->get('https://techp.jp/news');
$fpp=XML::FeedPP::RSS->new;$fpp->title('techp.jp/news');
$fpp->link('https://techp.jp/news');$fpp->pubDate(time);
each_item {$fpp->add_item(%$_)} $mech->content;
print encode('utf8', $fpp->to_string);
