use Object::Pad;

package Momiji::Db;
role Momiji::Db :does(Frame::Db::SQLite);

use utf8;
use v5.36;

dmsg 'asdf' if $ENV{'FRAME_DEBUG'};

use Hash::Util 'lock_hashref_recurse';
use Momiji::Model::Board;

field $models :accessor; ADJUST { $models = {} }

method init_db {
  my $config = $self->app->config;
  
  foreach my $board ($$config{boards}->@*) {
    my $board_config = { %$config, %$board }; # This should be fine
    # delete $$board_config{boards};
    lock_hashref_recurse($board_config);

    $$models{$$board{name}} = Momiji::Model::Board->new(
      name => $$board{name},
      app => $self->app,
      config => $board_config
    );

    $$models{$$board{name}}->init
  }
}

1