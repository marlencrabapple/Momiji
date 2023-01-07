use Object::Pad;

package Momiji;
class Momiji :does(Frame) :does(Momiji::Db);

use utf8;
use v5.36;
use autodie;

# use Momiji::Request;

use YAML::Tiny;
use Data::Dumper;

field $config :reader;

ADJUST {
  $config = YAML::Tiny->read($ENV{MOMIJI_CONFIG_FILE} || 'config.yml')->[0];
  $self->init_db
  # $self->request_class = 'Momiji::Request';
}

method startup {
  my $r = $self->routes;
  
  $r->get('/', sub ($self) {
    $self->stash->{時} = time;
    $self->render('<pre>' . Dumper($self) . '</pre>')
  });

  $r->get('/:board', 'board#index');
  $r->get('/:board/:page', { page => qr/^[0-9]+$/ }, 'board#index')
}

1