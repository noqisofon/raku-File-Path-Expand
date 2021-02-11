use v6;

unit module File::Path::Expand;

sub home-of($user-name = %*ENV<USER>) {
    IO::Spec::Cygwin.catpath( %*ENV<HOMEDRIVE>, "/User/$user-name/", '' )
}

sub expand-filename(Str $a-path) is export {
    my $match = $a-path ~~ / ^^ '~' ( \w + )? '/' /;
    unless $match.Bool {
	return $a-path;
    }

    if $match[0]:exists {
	my $user-name = $match[0].chunks[0].value;

	return $match.replace-with( home-of( $user-name ) );
	
    }
    $match.replace-with( home-of )
}
