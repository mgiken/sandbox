use strict;
use warnings;
use Test::More qw(no_plan);
use Fileio;

fileio {
    print "HOGE\n";
    print "HOGE\n";
    print "HOGE\n";
} 'test.txt' => '>';

print "------------------\n";

fileio {
    while (<>) {
        is $_, "HOGE\n";
    }
} 'test.txt';

print "------------------\n";

eachline {
    is $_, "HOGE\n";
} 'test.txt';

print "------------------\n";

my $d = readfile 'test.txt';
is $d, "HOGE\nHOGE\nHOGE\n";

print "------------------\n";

my @l = readlines 'test.txt';
print join("\n", @l), "\n";
is_deeply \@l, [qw(HOGE HOGE HOGE)];

print "------------------\n";

writefile 'test.txt' => "Hello, world!\n";
is readfile('test.txt'), "Hello, world!\n";

print "------------------\n";

writelines 'test.txt' => qw(foo bar baz);
is readfile('test.txt'), "foo\nbar\nbaz\n";

unlink 'test.txt';

1;
