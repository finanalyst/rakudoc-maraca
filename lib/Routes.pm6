use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use JSON::Fast;

class Cro::WebSocket::BodyParser::Maraca does Cro::BodyParser {
    method is-applicable($message) {
        # We presume that if this body parser has been installed, then we will
        # always be doing JSON
        True
    }

    method parse($message) {
        $message.body-blob.then: -> $blob-promise {
            my $inp = from-json $blob-promise.result.decode('utf-8');
            if $inp ~~ Str { $inp }
            else {
                ( gather for $inp.list -> %item {
                    take %item<key> => %item<value>
                } ).hash
            }
        }
    }
}

sub routes() is export {
    route {
        get -> *@path {
            static 'ui/public/', @path, :indexes<index.html index.htm>
        }

        my $chat = Supplier.new;
        get -> 'rakudoc' {
            web-socket
                    :body-parsers(Cro::WebSocket::BodyParser::Maraca),
                    :body-serializers(Cro::WebSocket::BodySerializer::JSON),
                    -> $incoming {
                        supply {
                            whenever $incoming -> $message {
                                my $json = await $message.body;
                                emit %( :searched( $json ), :found<Finding> );
                            }
                        }
                    }
        }
    }
}
