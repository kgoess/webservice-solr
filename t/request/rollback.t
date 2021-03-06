use strict;
use warnings;

use Test::More tests => 5;
use Test::Mock::LWP;

use XML::Simple;
use HTTP::Headers;

$Mock_ua->mock(
    request => sub {
        _test_req( @{ $_[ 1 ]->new_args } );
        return HTTP::Response->new;
    }
);
$Mock_response->mock( is_error => sub { return 0 } );

use_ok( 'WebService::Solr' );
my $solr = WebService::Solr->new;
isa_ok( $solr, 'WebService::Solr' );
$solr->rollback;

sub _test_req {
    is( $_[ 2 ]->path, '/solr/update', 'rollback() path' );
    is( $_[ 3 ]->header( 'Content_Type' ),
        'text/xml; charset=utf-8',
        'rollback() headers'
    );
    my $struct = XMLin( $_[ 4 ], KeepRoot => 1 );
    is_deeply( $struct, { rollback => {} }, 'rollback() xml' );
}
