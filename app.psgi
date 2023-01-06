use utf8;
use v5.36;
use autodie;

use lib 'lib';

use Momiji;
use Plack::Builder;

builder {
  enable "Plack::Middleware::Static",
    path => sub { s!^/s/!! }, root => 'static/assets/';

  Momiji->new->to_psgi
}
