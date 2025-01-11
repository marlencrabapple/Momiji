use Object::Pad;

package Momiji::Controller::Board;
class Momiji::Controller::Board :does(Momiji::Controller);

use utf8;
use v5.36;

use Momiji::Post;
use Momiji::Thread;

use Feature::Compat::Try;

field $board :accessor;

ADJUST {
  $board = $self->boards->{$self->stash->{board}{name}};
  $$Frame::Controller::template_vars{config} = $board->config;
  $$Frame::Controller::template_vars{board} = $board->config
}

method index ($board_path, $page = 0) {
  $self->render(template('board-index.tx', {
    page => $page
  }))
}

method view_thread ($board_path, $thread_no) {
  my $dbh = $self->app->dbh;

  my $thread = $board->thread($thread_no);

  $self->thread
    ? $self->render(template('board-index.tx', {
        threads => [ { posts => $thread } ]
      }))
    : $self->render_404('Request thread does not exist')
}

method new_post ($path) {
  my ($post, $status) = do {
    try {
      (Momiji::Post->new(
        model => $board,
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