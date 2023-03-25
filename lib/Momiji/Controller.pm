use Object::Pad;

package Momiji::Controller;
role Momiji::Controller :does(Frame::Controller);

use utf8;
use v5.36;

# use Text::Xslate;
# use Exporter 'import';

# our @EXPORT = qw(template);

$Frame::Controller::template_vars->@{qw/default_style static_res_base/}
  = ('Yotsuba B', '/s/');

# state $tx_default = Text::Xslate->new(
#   cache => $ENV{'PLACK_ENV'} && $ENV{'PLACK_ENV'} eq 'development' ? 0 : 1,
#   path => ['view'],
#   pre_process_handler => sub { 
#     my $text = shift;
#     $text =~ s/\n+\s*/ /g;
#     $text
#   }
# );

# $Frame::Controller::tx_default = $tx_default;

method option ($board, $opt_path) { # Maybe $board should be a $board_model since that has a ref to its board's config section
                                    # ...or I can think of something better
  my $config = $self->app->config;
  my $opt = $board ? $$config{$board} : $config;

  foreach my $key (split '.', $opt_path) {
    $opt = $$opt{$key};
    last unless ref($opt) =~ /HASH|ARRAY/
  }

  $opt ? $opt : $board ? $self->option(undef, $opt_path) : undef
}

1