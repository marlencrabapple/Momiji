use Object::Pad;

package Momiji::Post;
class Momiji::Post;

use utf8;
use v5.36;
use autodie;

use Carp;
use Momiji::File;
use Text::Markdown::Hoedown;

# field $app :param;
field $board_model :param;
field $post_model;
field $file_model;
field $dbrow;
field $req;

field $postno;
field $file;

ADJUSTPARAMS ($params) {
  $post_model //= $board_model->post_model;
  $file_model //= $board_model->file_model;

  # if($$params{dbrow}) {
  #   $dbrow = $$params{dbrow};
  #   $file = Momiji::File->new($$)
  # }
  #elsif($$params{req}) {
  if($$params{$req}) {
    $req = $$params{req};
    $self->validate_post;
    $self->format_post;
    $self->handle_files;
    $self->save
  }
  elsif($$params{postno}) {
    my $filerow;
    ($dbrow, $filerow) = $board_model->post($$params{postno});
    $file = Momiji::File->new($filerow)
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

  my $i = 0;

  foreach my $upload ($req->uploads) {
    croak "Maximum number of files per post exceeded" if $i == $board_model->max_files_post;

    my $file = Momiji::File->new($upload);
    push @files, $file;

    say Dumper($file);
  }
  continue {
    $i++
  }
}

method validate_post {

}

method format_post {

}

1