package Momiji::Template;

use v5.36;
use autodie;

use Text::Xslate;

our $default_args = {
  path => ['view'],
  pre_process_handler => sub {
    my $text = shift;
    $text =~ s/\n+\s*/ /g;
    $text
  }
};

state %profiles = ();
state %layouts = ();

sub new {
  my ($class, %args) = @_;

  %args = %$default_args unless keys %args;
  my $profile = delete $args{profile} || "tx";

  return $profiles{$profile}
    if ref $profiles{$profile} eq 'Momiji::Template';

  my $self = bless {
    tx => Text::Xslate->new(\%args)
  }, $class;

  $profiles{$profile} //= $self;

  $self
}

sub render {
  my ($self, $name, $data) = @_;


  if(ref $data eq 'ARRAY') { # Layout data
    #$$self{tx}->render ...
  }
  elsif(ref $data eq 'HASH') { # Single template data
    #$$data{static_uri};

    $$self{tx}->render($name, {
      static_uri => '/s/'
      #%$d
    })
  }
  else {
    ...
  }
}

1