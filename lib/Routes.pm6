use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::BodySerializer;
use Cro::WebSocket::Message::Opcode;
use JSON::Fast;
use DocSearch;

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

class Cro::WebSocket::BodySerializer::Maraca does Cro::BodySerializer {
    method is-applicable($message, $body) {
        # We presume that if this body serializer has been installed, then we
        # will always be doing Maraca type JSON
        True
    }

    method serialize($message, $body) {
        $message.opcode = Text;
        # convert all arrays into hashes with numbered keys
        supply emit to-json( $body.&a2h ).encode('utf-8')
    }

    sub a2h( $inp ) {
        given $inp {
            when Associative { %( gather for $inp.kv { take $^a => $^b.&a2h }) }
            when Positional { %( gather for $inp.kv { take $^a + 1 => $^b.&a2h }) }
            default { $inp }
        }
    }
}

sub routes( DocSearch $ds ) is export {
    route {
        get -> *@path {
            static 'static/', @path, :indexes<index.html index.htm>
        }

        get -> 'docresponse' {
            web-socket
                    :body-parsers(Cro::WebSocket::BodyParser::Maraca),
                    :body-serializers(Cro::WebSocket::BodySerializer::Maraca),
                    -> $incoming {
                        supply {
                            whenever $incoming -> $message {
                                my $json = await $message.body;
                                if $json ~~ Str {
                                    emit %( :routine( $json ), :info( 'Sending error' ));
                                }
                                else {
                                    if $json<routine>:exists {
                                        if $json<type>:exists {
                                            my $rv = $ds.doc-of($json<type>, $json<routine>);
                                            emit( $rv )
                                        }
                                        else {
                                            my $rv = $ds.what-has($json<routine>);
                                            emit( $rv)
                                        }
                                    }
                                    else {
                                        emit %( :routine( $json ), :info( 'Sending error' ));
                                    }
                                }
                            }
                        }
                    }
        }
    }
}
