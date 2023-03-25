use Object::Pad;

package Momiji::Db;
role Momiji::Db :does(Frame::Db::SQLite);

use utf8;
use v5.36;

use Momiji::Model::Board;

method init_db {
  my $config = $self->app->config;

  foreach my $board ($$config{boards}->@*) {
    $$board{model} = Momiji::Model::Board->new(
      name => $$board{name},
      app => $self->app,
      max_threads_page => $$board{max_threads_page} // $$config{max_threads_page},
      max_files_post => $$board{max_files_post} // $$config{max_files_post},
      config => $board,
      config_top_lvl => $config
    );

    $$board{model}->init 
  }
}

1