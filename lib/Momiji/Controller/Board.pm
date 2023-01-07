use Object::Pad;

package Momiji::Controller::Board;
class Momiji::Controller::Board :does(Momiji::Controller);

use utf8;
use v5.36;
use autodie;

use Momiji::Thread;

use Data::Dumper;

method index ($board, $page = 0) {
  $self->stash->{aaaaaaaaa} = 'bbbbbbbbbb';

  say Dumper($self);

  $self->render(template('board-index.tx', {
    default_style => 'Yotsuba B',
    static_res_base => '/s/',
    static_uri => '/s/'
  }))
}

1