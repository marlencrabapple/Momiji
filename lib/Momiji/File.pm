use Object::Pad;

package Momiji::File;
class Momiji::File;

use utf8;
use v5.36;

use GD;
use Path::Tiny;
use Image::ExifTool;

field $thumbnail;
field $original_filename;
# field $filename;
field $dbrow;
field $upload;
field $path;
# field $dest :param;
field $board_model :param;

ADJUSTPARAMS ($params) {
  if($$params{upload}) {
    $upload = $$params{upload};
    $path = path($$upload->path);
    $original_filename = $$upload->filename;

    $self->handle_thumbnail;
    $self->save;
  }
  elsif($$params{row}) {
    $dbrow = $$params{row}
    # $thumbnail = path($$dbrow{})
    # $path = path($$dbrow{})
  }
}

method handle_thumbnail {

}

method save {

}

1