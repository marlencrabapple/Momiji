use Object::Pad;

package Momiji::Db;
role Momiji::Db :does(Frame::Db::SQLite);

use utf8;
use v5.36;

# use DBI;
# use DBD::SQLite::Constants ':dbd_sqlite_string_mode';

use Momiji::Model::Board;

# field $dbh_old;

method init_db {
  my $config = $self->app->config;
  
  # $config->{db}{attr}->@{qw/AutoCommit RaiseError sqlite_string_mode/}
  #   = (1, 1, DBD_SQLITE_STRING_MODE_UNICODE_STRICT);

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