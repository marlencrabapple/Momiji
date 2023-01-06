use Object::Pad;

package Momiji::Controller;
role Momiji::Controller :does(Frame::Controller);

use utf8;
use v5.36;
use autodie;

# use Text::Xslate;

# state $tx_default = Text::Xslate->new(
#   cache => $ENV{'PLACK_ENV'} && $ENV{'PLACK_ENV'} eq 'development' ? 0 : 1,
#   path => ['view'],
#   pre_process_handler => sub {
#     my $text = shift;
#     $text =~ s/\n+\s*/ /g;
#     $text
#   }
# );

1