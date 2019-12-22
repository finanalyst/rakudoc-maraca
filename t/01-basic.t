use Test;

use-ok 'DocSearch';

use DocSearch;

my DocSearch $s .= new;

my $rv;
lives-ok { $rv = $s.what-has( 'say' ) }, 'type response';
ok $rv<types>.Set (<=)
    ['Independent routines', 'Mu', 'Proc::Async', 'IO::CatHandle', 'IO::Handle' ].Set,'main say types';
lives-ok { $rv = $s.doc-of( 'Proc::Async', 'say' ) }, 'doc-of lives';
like $rv<doc>, /
    '(Proc::Async) method say'
    \s*
    'method say(Proc::Async:D: $output, :$scheduler = $*SCHEDULER)'
    /, 'gives Async documentation';
is $s.what-has('xxx_absurd_method')<info>,
        'Not supported by any Type', 'Nothing is returned for rubbish';

like $s.doc-of('Not::A::Real::Type', 'say')<info>, /'No matches'/, 'No such type response';

done-testing;