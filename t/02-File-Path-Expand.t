# -*- mode: raku; -*-
use v6;
use lib 'lib';

use Test;
use File::Path::Expand;

plan 4;

{
    is expand-filename( './hoge/piyo/fuga.txt' )     , './hoge/piyo/fuga.txt'                          , 'Local path';
}

{
    my $user-name = 'alice';

    %*ENV<USER>    = $user-name;
    %*ENV<LOGNAME> = $user-name;

    $*HOME = '/wonderland/home'.IO;

    my $expected = do given $*VM.osname {
	when 'mswin32' { "%*ENV<HOMEDRIVE>/Users/%*ENV<USER>/hoge/piyo/fuga.txt" }
	when 'linux'   { "/home/%*ENV<LOGNAME>/hoge/piyo/fuga.txt" }
    };
    
    is expand-filename( '~/hoge/piyo/fuga.txt' )     , $expected, 'Home directory path';
}

{
    my $expected = do if $*SPEC ~~ IO::Spec::Win32 {
	"%*ENV<HOMEDRIVE>/Users/alice/hoge/piyo/fuga.txt"
    } else {
	"/home/alice/hoge/piyo/fuga.txt"
    }
    is expand-filename( '~alice/hoge/piyo/fuga.txt' ), $expected , 'Other home directory path';
}

if $*KERNEL ~~ 'linux' {
    is expand-filename( '~root/hoge/piyo/fuga.txt' ), '/root/hoge/piyo/fuga.txt', 'Root Direcotry';
} else {
    skip "Windows has root, but I don't use it much";
}

done-testing;
