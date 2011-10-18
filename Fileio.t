use strict;
use warnings;
use Test::More qw(no_plan);
use Fileio;

fileio {
    print "HOGE\n";
    print "HOGE\n";
    print "HOGE\n";
} 'test.txt' => '>';

fileio {
    while (<>) {
        is $_, "HOGE\n";
    }
} 'test.txt';

eachline {
    is $_, "HOGE\n";
} 'test.txt';

my $d = readfile 'test.txt';
is $d, "HOGE\nHOGE\nHOGE\n";

my @l = readlines 'test.txt';
print join("\n", @l), "\n";
is_deeply \@l, [qw(HOGE HOGE HOGE)];

writefile 'test.txt' => "Hello, world!\n";
is readfile('test.txt'), "Hello, world!\n";

writelines 'test.txt' => qw(foo bar baz);
is readfile('test.txt'), "foo\nbar\nbaz\n";

unlink 'test.txt';

1;
