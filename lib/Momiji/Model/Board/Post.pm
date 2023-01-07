use Object::Pad;

package Momiji::Model::Board::Post;
class Momiji::Model::Board::Post :does(Momiji::Model);

use utf8;
use v5.36;
use autodie;

state $columns_base = Hash::Ordered->new(
  postno => {
    type => 'INTEGER',
    primary_key => 1,
    autoincrement => 1,
    not_null => 1
  },

  parent => { type => 'INTEGER' },

  # Seconds since unix epoch, expands to Time::Moment (not sure where to handle that yet)
  timestamp => { type => 'Time::Moment', not_null => 1 },
  lasthit => { type => 'Time::Moment', not_null => 1 },

  # Dunno if I actually want to store these, depends on how easily I can cache them elsewhere
  date => { not_null => 1 },

  ip => { type => 'INTEGER', not_null => 1 },
  (map { $_, {} } qw/name link subject comment comment_formatted/),
  (map { $_, { type => 'TINYINT' } } qw/sticky permasage locked tnmask location flag staff pass/),
  options => { type => 'JSON' },
  password => { not_null => 1 }
);

state $constraints = Hash::Ordered->new(
  primary_key => [qw/postno parent/]
);

field $table :param :reader;

ADJUSTPARAMS ( $params ) {
  my $columns = $self->columns = $columns_base;
  $columns->get('parent')->{foreign_key} = "$table(postno)"
}

1