use Object::Pad;

package Momiji::Controller;
role Momiji::Controller :does(Frame::Controller);

use utf8;
use v5.36;

$Frame::Controller::template_vars->@{qw/default_style static_res_base/}
  = ('Yotsuba B', '/s/');

method boards { $self->app->models }

1