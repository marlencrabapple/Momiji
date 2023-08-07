use Object::Pad;

package Momiji::Post;
class Momiji::Post :does(Frame::Base);

use utf8;
use v5.36;
use autodie;

use Carp;
use Momiji::File;
use Text::Markdown::Hoedown;

field $board_model :param(model);
field $board;
field $post_model;
field $file_model;
field $config;
field $req;
field $dbrow :mutator;

field $postno :reader;
field $parent :reader;
field $file;

ADJUSTPARAMS ($params) {
  $board = $board_model->name;
  $post_model //= $board_model->post_model;
  $file_model //= $board_model->file_model;
  $config = $board_model->config;

  # if($$params{dbrow}) {
  #   $dbrow = $$params{dbrow};
  #   $file = Momiji::File->new($$)
  # }
  #elsif($$params{req}) {
  if($$params{req}) {
    say 'hi';
    $req = $$params{req};
    $self->validate_post;
    $self->format_post;
    $self->handle_files;
    $self->save($postno);
  }
  elsif($$params{postno}) {
    my $filerow;
    ($dbrow, $filerow) = $board_model->post($$params{postno});
    $file = Momiji::File->new($filerow);

    $postno = $$params{postno};
    $parent = $$dbrow{parent}
  }
  else {
    # die "Missing required arguments dbrow, req, or postno"
    croak "Missing request object or post no."
  }
}

# method from_db :common ($model, $row) {
#   Momiji::Post->new(board_model => $model, dbrow => $row)
# }

# method from_req :common ($model, $req) {
#   Momiji::Post->new(board_model => $model, req => $req)
# }

method field { # Grab from $dbrow?
  
}

method save ($postno) {
  $board_model->post($self)
}

method handle_files {
  my @files;

  my $max_files = $req->parameters->{parent}
    ? $$config{max_files_reply}
    : ($$config{max_files_op} // $$config{max_files_reply});

  my $i = 0;

  foreach my $key (keys $req->uploads->%*) {
    my $upload = $req->uploads->{$key};

    croak "Maximum number of files per post ($max_files) exceeded"
      unless $i < $max_files;

    my $file = Momiji::File->new(upload => $upload, board_model => $board_model);
    push @files, $file;

    dmsg $file, $upload, $key, $req->uploads
  }
  continue {
    $i++
  }
}

method validate_post {
  my $params = $req->parameters;

  dmsg $params;
  
  die "Invalid thread"
    if $$params{parent} && !$board_model->thread($$params{parent})

  
  # Check field lengths
  # Check for banned words
  # Check if pass user (Momiji Maaku) or if captcha correct

  # IP bans will be handled somewhere else
  # 

}

method format_post {

}

method res_href {
  {
    postno => $self->postno,
    $self->parent ? (parent => $self->parent) : (),
  }
}

1