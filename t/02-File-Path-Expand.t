# -*- mode: raku; -*-
use v6;
use lib 'lib';

use Test;
use File::Path::Expand;

plan 3;

# $*HOME = 'some/to'.IO;

is expand-filename( './hoge/piyo/fuga.txt' )     , './hoge/piyo/fuga.txt'                          , 'Local path';
is expand-filename( '~/hoge/piyo/fuga.txt' )     , "$*HOME/hoge/piyo/fuga.txt".subst('\\', '/', :g), 'Home directory path';
if $*SPEC ~~ IO::Spec::Win32 {
    is expand-filename( '~alice/hoge/piyo/fuga.txt' ), "C:/Users/alice/hoge/piyo/fuga.txt"                , 'Other home directory path';
} else {
    is expand-filename( '~alice/hoge/piyo/fuga.txt' ), "/home/alice/hoge/piyo/fuga.txt"                , 'Other home directory path';
}

done-testing;
