use Object::Pad;

package Momiji::Controller::Board;
class Momiji::Controller::Board :does(Momiji::Controller);

use utf8;
use v5.36;
use autodie;

use Momiji::Thread;

method index ($board, $page = 0) {
  $self->render(template('board-index.tx', {
    default_style => 'Yotsuba B',
    static_res_base => '/s/',
    static_uri => '/s/'
  }))
}

1