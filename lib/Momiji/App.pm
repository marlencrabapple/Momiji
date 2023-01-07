use Object::Pad;

package Momiji::App;
class Momiji::App;

use utf8;
use v5.36;
use autodie;

use Momiji;

my $app = Momiji->new;
my $psgi = $app->to_psgi;

state %dispatch = (
  new => 'new_app',
);

method cmd(@argv) {
  my $dest = $dispatch{shift @argv};
  $self->$dest(@argv)
}

method new_app($package) {
  ...
}

1