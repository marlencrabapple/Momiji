use Object::Pad;

package Momiji::Db;
role Momiji::Db :does(Frame::Db::SQLite);

use utf8;
use v5.36;

use Hash::Util 'lock_hashref_recurse';

dmsg 'asdf' if $ENV{'FRAME_DEBUG'};

use Momiji::Model::Board;

field %models;

method init_db {
  my $config = $self->app->config;
  
  foreach my $board ($$config{boards}->@*) {
    my $board_config = { %$config, %$board };
    lock_hashref_recurse($board_config);

    $models{$$board{name}} = Momiji::Model::Board->new(
      name => $$board{name},
      app => $self->app,
      # max_threads_page => $$board{max_threads_page} // $$config{max_threads_page},
      # max_files_post => $$board{max_files_post} // $$config{max_files_post},
      # config => $board,
      config => $board_config
    );

    $models{$$board{name}}->init
  }
}

method models {
  \%models
}

1