package Momiji::Thread;

use v5.36;
use autodie;

sub new {
  my ($class, %args) = @_;

  if($args{thread_no}) {

  }

  bless {}, $class
}

sub get_thread {
  my ($dbh, $board, $thread_no) = @_;

}

sub lock {

}

sub sticky {

}

sub permasage {

}

sub delete {

}

sub move {

}

sub archive {

}

sub autotrim {

}

sub max_posts {

}

sub max_files {

}

1