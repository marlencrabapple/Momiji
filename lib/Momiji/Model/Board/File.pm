use Object::Pad;

package Momiji::Model::Board::File;
class Momiji::Model::Board::File :does(Momiji::Model);

use utf8;
use v5.36;

# CREATE TABLE "<: $board :>_file" (
#   "fileid" INTEGER PRIMARY KEY NOT NULL,
# # "linkedposts" TEXT, 
#   "path" TEXT NOT NULL,
#   "filename" TEXT NOT NULL,
#   "metadata" TEXT, --JSON string with metadata type/source as keys and data as
#                    --value (e.g one {ffprobe: ..., exiftool: ..., mediainfo: ...})
#   "status" TINYINT --Processing, etc.
# );
