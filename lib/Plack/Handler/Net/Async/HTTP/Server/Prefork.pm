package Plack::Handler::Net::Async::HTTP::Server::Prefork;

use parent Plack::Handler::Net::Async::HTTP::Server;

use v5.36;
use autodie;

use Parallel::Prefork;

sub new($class, %args) {
  $args{max_workers} //= 10;
  my $max_workers = delete $args{max_workers};
  
  my $self = $class->SUPER::new(%args);
  $$self{is_multiprocess} = 1;
  $$self{max_workers} = $max_workers;

  $$self{timeout} = $args{spawn_interval}
    ? $args{spawn_interval} * $args{max_workers}
    : 1;

  $self
}

sub run($self, $app) {
  my $pm = Parallel::Prefork->new({
    max_workers => 10,
    trap_signals => {
      TERM => 'TERM',
      HUP => 'TERM',
    }
  });

  while($pm->signal_received !~ /^TERM|USR1$/) {
    $pm->start and next;
    srand((rand() * 2 ** 30) ^ $$ ^ time); # Yes
    $self->SUPER::run($app);
    $pm->finish
  }

  while($pm->wait_all_children($$self{timeout})) {
    $pm->signal_all_children('TERM')
  }
}

1