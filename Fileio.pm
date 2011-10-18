package Fileio;

use strict;
use warnings;
use base qw(Exporter);

our @EXPORT = qw(fileio eachline readfile readlines writefile writelines);

sub fileio(&$;$) {
    my ($f, $n, $m) = @_;
    if ($m && $m =~ /^>/) {
        open(my $H, $m, $n) || die "cannot open $n: $!";
        my $o = select($H);
        $f->();
        select($o);
        close($H);
    } else {
        die "cannot read $n" unless -r $n;
        local @ARGV = ($n);
        $f->();
    }
}

sub eachline(&$) {
    my ($f, $n) = @_;
    local $_;
    fileio {$f->() while <>} $n;
}

sub readfile($) {
    my $buf;
    open my $fh, '<', $_[0];
    sysread $fh, $buf, -s $fh;
    close $fh;
    $buf;
}

sub readlines($) {
    split /\r?\n/, readfile $_[0]
}

sub writefile($$) {
    my ($n, $d) = @_;
    fileio {print $d} $n => '>';
}

sub writelines($@) {
    my $n = shift;
    my $v = \@_;
    fileio {print "$_\n" for @$v} $n => '>';
}

1;
