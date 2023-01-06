use Object::Pad;

package Momiji::Request;
class Momiji::Request :isa(Frame::Request);

use utf8;
use v5.36;
use autodie;

ADJUST {
  say Dumper($self, $self->app->dbh);
}

1

