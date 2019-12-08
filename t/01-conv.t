use Test;

use rgb-hsl-conv;

is conv( 0,0,0 ), (0,0,0) , 'black';
is conv( 255, 255, 255  ) , (0,0,100), 'white';
is conv( 255, 0, 0 ) , ( 0, 100, 50), 'red';
is conv( 0,255,0 ), ( 120, 100, 50), 'lime';
is conv( 0,0,255 ), ( 240, 100, 50), 'blue';
is conv( 255,255,0 ), ( 60, 100, 50), 'yellow';
is conv( 0, 255, 255 ), (180, 100, 50 ), 'cyan';
is conv( 191, 191, 191 ), (0, 0, 75 ), 'silver';
is conv( 128,128,128 ), (0, 0, 50 ), 'gray';
is conv( 128,0,0 ), (0, 100, 25 ), 'maroon';
is conv( 128,128,0 ), (60, 100, 25 ), 'olive';
is conv( 0,128,0 ), (120, 100, 25 ), 'green';
is conv( 128,0,128 ), (300, 100, 25 ), 'purple';
is conv( 0,128,128 ), (180, 100, 25 ), 'teal';
is conv( 0,0,128 ), (240, 100, 25 ), 'navy';

is conv( 236, 146, 19 ), (35, 85, 50), 'maraca red';
is conv( 19,235,109), ( 145, 85, 50 ), 'maraca green';

done-testing;