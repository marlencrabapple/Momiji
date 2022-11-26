use v5.36;
use autodie;

use lib 'lib';

use Momiji;
use Plack::Builder;
use Plack::App::File;

builder {
  enable "Plack::Middleware::Static",
    path => sub { s!^/s/!! }, root => 'static/';

  Momiji->new->to_app
}
