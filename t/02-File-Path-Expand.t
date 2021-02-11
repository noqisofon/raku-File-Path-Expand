# -*- mode: raku; -*-
use v6;
use lib 'lib';

use Test;
use File::Path::Expand;

plan 4;

# $*HOME = 'some/to'.IO;

is expand-filename( './hoge/piyo/fuga.txt' )     , './hoge/piyo/fuga.txt'                          , 'Local path';
is expand-filename( '~/hoge/piyo/fuga.txt' )     , "$*HOME/hoge/piyo/fuga.txt".subst('\\', '/', :g), 'Home directory path';

my $expected = do if $*SPEC ~~ IO::Spec::Win32 {
    "%*ENV<HOMEDRIVE>/Users/alice/hoge/piyo/fuga.txt"
} else {
    "/home/alice/hoge/piyo/fuga.txt"
}
is expand-filename( '~alice/hoge/piyo/fuga.txt' ), $expected , 'Other home directory path';

if $*KERNEL ~~ 'unix' {
    is expand-filename( '~root/hoge/piyo/fuga.txt' ), '/root/hoge/piyo/fuga.txt', 'Root Direcotry';
} else {
    skip "Windows has root, but I don't use it much";
}

done-testing;
