use v6.*;

unit module RGB-HSL-CONV;

sub conv(*@trip  ) is export {
    my ($r, $g, $b) = @trip <</>> 255;
    # algorithm from https://www.rapidtables.com/convert/color/rgb-to-hsl.html
    my $cmax = max( $r, $g, $b);
    my $cmin = min( $r, $g, $b);
    my $delta = $cmax - $cmin;
    my $factor = 60 ; # the formula for hue is in degrees, and the output is wanted scaled to 100

    my $hue;
    {
        when $delta == 0 { $hue = 0 }
        when $cmax == $r { $hue = $factor * ( ( ($g - $b) / $delta ) + ( $g >= $b ?? 0 !! 6 ) ) }
        when $cmax == $g { $hue = $factor * ( ( ($b - $r) / $delta ) + 2   ) }
        when $cmax == $b { $hue = $factor * ( ( ($r - $g) / $delta ) + 4   ) }
    }

    my $lightness = ( $cmax + $cmin ) / 2;

    my $sat = 0;
    $sat = 100 * ($delta / ( 1 - abs( 2 * $lightness -1 ) )).round(0.01) if $delta != 0;
    ( $hue.round(1), $sat, 100 * $lightness.round(0.01) )
}