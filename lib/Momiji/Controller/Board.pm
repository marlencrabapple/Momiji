use Object::Pad;

package Momiji::Controller::Board;
class Momiji::Controller::Board :does(Momiji::Controller);

use utf8;
use v5.36;
use autodie;

use Momiji::Post;
use Momiji::Thread;
use Momiji::Model::Board;

use Data::Dumper;
use List::Util 'any';

method index ($board, $page = 0) {
  my $app = $self->app;
  my $req = $app->req;

  return $self->render_404
    unless any { $board eq $$_{path} } $app->config->{boards}->@*;
  
  $self->render(template('board-index.tx', {
    default_style => 'Yotsuba B',
    static_res_base => '/s/',
    static_uri => '/s/'
  }))
}

1