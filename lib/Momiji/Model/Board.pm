use Object::Pad;

package Momiji::Model::Board;
class Momiji::Model::Board :does(Momiji::Model);

use utf8;
use v5.36;
use autodie;

use Momiji::Model::Board::Post;
# use Momiji::Model::Board::File;

use Data::Dumper;

field $name :param;
field $post :reader;
field $file :reader;

ADJUSTPARAMS ($params) {
  $post = Momiji::Model::Board::Post->new(
    table => "$name\_post",
    dbh => $self->dbh || $$params{dbh}
  )
}

method init {
  $post->create_table
}

1