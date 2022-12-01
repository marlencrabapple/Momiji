package Momiji;

use v5.36;
use autodie;

use Plack;
use Plack::Request;
use Data::Dumper;
use Path::Tiny;
use YAML::Tiny;
use JSON::MaybeXS;
use Text::Xslate;
use GD;

our $tx = Text::Xslate->new(
  #cache => $ENV{PLACK_ENV} eq 'development' ? 0 : 1,
  path => ['view'],
  pre_process_handler => sub {
    my $text = shift;
    $text =~ s/\n+\s*/ /g;
    $text
  }
);

sub new {
  bless {
    config => YAML::Tiny->read($ENV{MOMIJI_CONFIG_FILE} || 'config.yml')
  }, shift
}

sub to_app {
  my $self = shift;
  sub { $self->handler(shift) }
}

sub res {
  my ($body, $status, $content_type) = @_;

  $status //= 500;
  $body //= 'its not good that youre here';

  if(!$content_type && ref $body =~ /ARRAY|HASH/) {
    #die "Not a plain hash." if blessed $body;
    $body = encode_json($body);
    $content_type = 'application/json; charset=utf-8'
  }
  else {
    $content_type //= 'text/html; charset=utf-8'
  }

  my $res = Plack::Request->new_response($status);
  $res->content_type($content_type);
  $res->body($body);

  $res->finalize
}

sub res_chunked {
  ...
}

sub res_stream {
  ...
}

sub render {
  my ($self, $name, $data) = @_;

  $tx->render('', {
    static_uri => '/s/'
  })
}

sub handler {
  my ($self, $env) = @_;

  my $req = Plack::Request->new($env);

  res($tx->render('board-index.tx', {
    static_res_base => '/s/'
  }), 200)
}

1