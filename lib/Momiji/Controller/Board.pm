use Object::Pad;

package Momiji::Controller::Board;
class Momiji::Controller::Board :does(Momiji::Controller);

use utf8;
use v5.36;

use Momiji::Post;
use Momiji::Thread;
use Momiji::Model::Board;

use List::Util 'any';
use Text::Markdown::Hoedown;

method index ($board_path, $page = 0) {
  my $app = $self->app;
  my $req = $app->req;

  # say Dumper($app->option($self->stash->{board}{name}))
  
  $self->render(template('board-index.tx', {
    board => $self->stash->{board},
    page => $page
  }))
}

method view_thread ($board_path, $thread_no) {
  my $dbh = $self->app->dbh;
  my $board = $self->stash->{board};

  my $thread = $$board{model}->thread($thread_no);

  $self->render(Dumper($thread));

  # $self->render(template('board-index.tx', {
  #   board => $self->stash->{board},
  #   threads => [ { posts => $thread } ]
  # }))
}

method new_post ($board_path) {
  my $req = $self->app->req;
  my $params = $req->parameters;
  my $uploads = $req->uploads;
  my $dbh = $self->app->dbh;
  my $board = $self->stash->{board};

  if($$params{thread}) {
    my $sth = $dbh->prepare("SELECT count(postno) FROM $$board{name}\_comme");
  }

  if($uploads) {

  }

  if($req->maybe_ajax) {

  }
  else {

  }

  $self->render('<pre>' . Dumper($self->app->req) . '</pre>')
}

1