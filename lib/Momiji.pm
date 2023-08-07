use Object::Pad;

package Momiji;
class Momiji :does(Frame) :does(Momiji::Db);

our $VERSION  = '0.01';

use utf8;
use v5.38;

use Data::Dumper;

ADJUST {
  $self->init_db
}

method startup {
  my $r = $self->routes;
  my $config = $self->config;
  
  $r->get('/', sub ($c) {
    $c->stash->{時} = time;
    $c->render('<pre>' . Dumper($c, $self) . '</pre>')
  });

  $r->get('/r', sub ($c) { $c->render('<pre>' . Dumper($r->tree) . Dumper($r->patterns) . '</pre>') });

  $r->get('/:asdf/:fdsa', sub ($c, $asdf, $fdsa) { $c->render($c->req->placeholders) });

  use constant IS_NUM => qr/^[0-9]+$/;

  my $board = $r->under('/board', sub ($c) {
    int rand 2 ? $c->render_403('u r teh banned') : 1
  });

  # Real world these should be auto-generated per board according to their configs
  # But if I did go this route (ha) it'd be a good idea to give traversing our routes
  # level by level another shot, rather than by depth and then starting over when
  # something doesn't match (and skipping the no-match after starting over)
  $board->get('/:board', { board => \&valid_board }, 'board#index');
  $board->get('/:board/:page', { board => \&valid_board, page => IS_NUM }, 'board#index');
  $board->get('/:board/thread/:no', { board => \&valid_board, no => IS_NUM }, 'board#view_thread');

  $board->post('/:board/post', { board => \&valid_board }, 'board#new_post');

  $r->post('/testpost', sub ($c) { $c->render($c->req) })
}

method boards { $self->models }

method valid_board ($req, $path) {
  dmsg $req, $path;
  (($req->stash->{board}) = grep { $path eq $$_{path} } $self->config->{boards}->@*)
    ? 1 : 0
}

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
