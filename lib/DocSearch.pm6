use OO::Monitors;
use P6doc;
use P6doc::Index;
use P6doc::Utils;
use Perl6::Documentable;
no precompilation;

unit monitor DocSearch;
has $!dir = '../raku-doc/doc/Type';

method what-has( Str $routine --> Hash ) is export {

    my $routine-index-path = routine-index-path();

    die "No index file found, build index first."
            unless ($routine-index-path.e && not INDEX.z );
    my @types = routine-search($routine, $routine-index-path).list;
    if @types.all ~~ Str {
        %( :$routine, :@types)
    }
    else
    {
        %( :$routine, :types(['Not supported by any Type']) )
    }
}

method doc-of( Str $type, Str $routine --> Hash ) is export {
    my IO::Path @pod-paths;
    my Perl6::Documentable @documentables;
    my Perl6::Documentable @search-results;

    @pod-paths = find-type-files($type, $!dir);

    @documentables = process-type-pod-files(@pod-paths);
    @search-results = type-search($type,
                                  :routine($routine),
                                  @documentables);
    %( :$routine, :$type, :doc( str-search-results(@search-results)) );
}