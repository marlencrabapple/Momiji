use Object::Pad;

package Momiji::Controller::Board;
class Momiji::Controller::Board :does(Momiji::Controller);

use utf8;
use v5.36;

# use Frame::Controller; # Until we can import template sub on :does

use Momiji::Post;
use Momiji::Thread;
use Momiji::Model::Board;

use Data::Dumper;
use List::Util 'any';
use Feature::Compat::Try;
use Text::Markdown::Hoedown;

method index ($board_path, $page = 0) {
  my $app = $self->app;
  my $req = $self->req;

  # dmsg $self, $app, $req;

  # say Dumper($app->option($self->stash->{board}{name}))

  # template 'board-index.tx';
  
  $self->render(template('board-index.tx', {
    board => $self->stash->{board},
    page => $page
  }))
}

method view_thread ($board_path, $thread_no) {
  my $dbh = $self->app->dbh;
  my $board = $self->stash->{board};

  my $thread = $$board{model}->thread($thread_no);

  $self->thread
    ? $self->render(template('board-index.tx', {
        board => $self->stash->{board},
        threads => [ { posts => $thread } ]
      }))
    : $self->render_404('Request thread does not exist')
}

method new_post ($path) {
  my ($post, $status) = do {
    # Try adding return if this doesn't work
    try {
      dmsg $self->app->models->{$self->stash->{board}{name}}, $self->req, $self->app;

      (Momiji::Post->new(
        model => $self->app->models->{$self->stash->{board}{name}},
        req => $self->req,
        app => $self->app
      ), 200);
    }
    catch ($e) {
      die $e if $ENV{'PLACK_ENV'} eq 'development';
      ($e, 400)
    }
  };

  $self->req->maybe_ajax
    ? ref $post ? $self->render($post->res_href) : $self->render($post, $status)
    : ref $post ? $self->redirect("/$path/thread/" . $post->parent . '#' . $post->postno)
      : $self->render($post, $status)
}

1