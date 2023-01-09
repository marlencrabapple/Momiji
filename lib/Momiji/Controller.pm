use Object::Pad;

package Momiji::Controller;
role Momiji::Controller :does(Frame::Controller);

use utf8;
use v5.36;
use autodie;

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

1