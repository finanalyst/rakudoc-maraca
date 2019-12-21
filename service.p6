use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;
use DocSearch;

my DocSearch $ds .= new;

my Supplier $feedback = Supplier.new;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<RAKUDOC_HOST> ||
        die("Missing RAKUDOC_HOST in environment"),
    port => %*ENV<RAKUDOC_PORT> ||
        die("Missing RAKUDOC_PORT in environment"),
    application => routes( $feedback, $ds ),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<RAKUDOC_HOST>:%*ENV<RAKUDOC_PORT>";
react {
    whenever $feedback.Supply -> $message {
        say $message;
        $*OUT.flush
    }
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
