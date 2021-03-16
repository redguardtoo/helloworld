#!/usr/bin/perl
use strict;
use warnings;

# @see http://www.perlmonks.org/?node_id=88222
use Getopt::Std;

my %args;
getopts('h',\%args);

sub usage() {
    print <<END
Usage: program [options]
END
}

## main
if( $args{h} ) {
    usage();
    exit(1);
}

printf
print "hello world\n";