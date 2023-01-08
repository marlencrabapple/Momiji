use Object::Pad;

package Momiji;
class Momiji :does(Frame) :does(Momiji::Db);

our $VERSION  = '0.01';

use utf8;
use v5.36;
use autodie;

use YAML::Tiny;
use Data::Dumper;

field $config :reader;
field $config_defaults :reader;

ADJUST {
  $config_defaults = YAML::Tiny->read('config-defaults.yml')->[0];
  $config = YAML::Tiny->read($ENV{MOMIJI_CONFIG_FILE} || 'config.yml')->[0];

  # Board specific configs won't be handled this way obviously
  $config = {%$config_defaults, %$config};
  say Dumper($config);
  
  $self->init_db
}

method startup {
  my $r = $self->routes;
  
  $r->get('/', sub ($self) {
    $self->stash->{時} = time;
    $self->render('<pre>' . Dumper($self) . '</pre>')
  });

  # These should be auto-generated per board according to their configs
  $r->get('/:board', 'board#index');
  $r->get('/:board/:page', { page => qr/^[0-9]+$/ }, 'board#index');
  $r->get('/:board/thread/:no', { no => qr/^[0-9]+$/ }, 'board#index');
  
  $r->post('/:board/post', 'board#post')
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
