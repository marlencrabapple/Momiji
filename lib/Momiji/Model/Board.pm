use Object::Pad;

package Momiji::Model::Board;
class Momiji::Model::Board :does(Momiji::Model);

use utf8;
use v5.36;

use Momiji::Model::Board::Post;
use Momiji::Model::Board::File;

use Data::Dumper;

field $name :param;
field $max_threads_page :param :reader;
field $config :param;
field $config_top_lvl :param;

field $post_model :reader;
field $file_model :reader;

ADJUSTPARAMS ($params) {
  $post_model = Momiji::Model::Board::Post->new(
    table => "$name\_post",
    app => $self->app
  )
}

method init {
  $post_model->create_table
}

method threads ($page = 0) {

}

method thread ($thread_no) {
  my @where = (
    { postno => $thread_no, },
    { parent => $thread_no }
  );

  my $sql = $self->sqla->select($post_model->table, '*', \@where, { -asc => 'postno' });
  my $sth = $self->dbh->prepare($sql);
  $sth->execute;

  my @posts;

  while (my $row = $sth->fetchrow_hashref) {
    push @posts, $row
  }

  # Momiji::Thread->new(board_model => $self, posts => @posts)
  \@posts
}

method post {
  $post_model->post($self, @_)
}

1