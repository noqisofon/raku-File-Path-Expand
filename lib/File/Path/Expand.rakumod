use v6;

unit module File::Path::Expand;

multi home-of() {
    my $user-name  = $*DISTRO.is-win ?? %*ENV<USER> !! %*ENV<LOGNAME>;

    home-of( $user-name )
}

multi home-of(Str:D $user-name) {
    given $*VM.osname {
        when 'mswin32' {
            my $home-drive = %*ENV<HOMEDRIVE>;

            return IO::Spec::Cygwin.catpath( $home-drive, "/Users/$user-name", '' )
        }
        when 'linux' {
            if $user-name ~~ 'root' {
                return "/$user-name";
            }
            return "/home/$user-name";
        }
    }
}

sub expand-filename(Str:D $a-path) is export {
    my $match = $a-path ~~  / ^ '~' <(\w+)> <?before '/'>? /;
    if so $match {
        my $user-name = $match.Str;

        return $a-path.subst( "~$user-name", home-of( $user-name ) );
    }
    $a-path.subst( '~', home-of )
}
