use v6.*;
use rgb-hsl-conv;

my $src = 'assets/palette.txt'.IO;
$src = $src.open if $src.f;

my $dest = 'ui/src/colors.ma'.IO;

my $url;
my $clrs;
my $key = '';

for $src.lines {

    when m/^ \s* '#'+ \s* 'Palette URL:' \s* $<url> = (.+) $ / { $url = ~$<url> }
    when m/^ \s* '*'+ .+ 'Primary'/ { $key = 'P' }
    when m/^ \s* '*'+ .+ 'Secondary' .+ '(1)'/ { $key = 'S1' }
    when m/^ \s* '*'+ .+ 'Secondary' .+ '(2)'/ { $key = 'S2' }
    when m/^ \s* '*'+ .+ 'Complement'/ { $key = 'C' }
    when $key ne '' and m/ 'shade' \s* $<sh>=(\d) .+ 'rgb(' \s* $<r>=(\d+) ',' \s* $<g>=(\d+) ',' \s* $<b>=(\d+) ')' /
            { $clrs ~= $key ~ '_' ~$<sh>  ~': ' ~ conv(+$<r>, +$<g>, +$<b>) ~ ",\n" }

}

$dest.spurt(
    '[' ~
        $clrs ~
        "url: \"$url\" " ~
    ']'
)