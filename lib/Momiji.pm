use Object::Pad;

package Momiji;
class Momiji :does(Frame) :does(Momiji::Controller) :does(Momiji::Db);

our $VERSION  = '0.01';

use utf8;
use v5.36;
use autodie;

use YAML::Tiny;
use Data::Dumper;
use List::Util 'any';

ADJUST {
  $self->init_db
}

method startup {
  my $r = $self->routes;
  my $config = $self->config;
  
  $r->get('/', sub ($self) {
    $self->stash->{時} = time;
    $self->render('<pre>' . Dumper($self) . '</pre>')
  });

  $r->get('/r', sub ($self) { $self->render('<pre>' . Dumper($r->tree) . Dumper($r->patterns) . '</pre>') });

  $r->get('/:asdf/:fdsa', sub ($self, $asdf, $fdsa) { $self->render($self->req->placeholders) });

  sub valid_board ($self, $board) {
    ($self->stash->{board}) = grep { $board eq $$_{path} } $self->app->config->{boards}->@*;
    $self->stash->{board} ? 1 : 0
  };

  # Real world these should be auto-generated per board according to their configs
  # But if I did go this route (ha) it'd be a good idea to give traversing our routes
  # level by level another shot, rather than by depth and then starting over when
  # something doesn't match (and skipping the no-match after starting over)
  state $isnum = qr/^[0-9]+$/;

  $r->get('/:board', { board => \&valid_board }, 'board#index');
  $r->get('/:board/:page', { board => \&valid_board, page => $isnum }, 'board#index');
  $r->get('/:board/thread/:no', { board => \&valid_board, no => $isnum }, 'board#view_thread');

  $r->post('/:board/post', { board => \&valid_board }, 'board#new_post')
}

# method valid_board {
#   any { $$_{path} eq $req->placeholders->{board} } @$self->config->{boards}
# }

1
__END__

=encoding utf-8

=head1 NAME

Momiji - Blah blah blah

=head1 SYNOPSIS

  use Momiji;

=head1 DESCRIPTION

Momiji is

=head1 AUTHOR

Ian P Bradley E<lt>ian.bradley@studiocrabapple.comE<gt>

=head1 COPYRIGHT

Copyright 2023- Ian P Bradley

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
