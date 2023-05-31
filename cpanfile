requires 'perl', 'v5.36';

# Add Frame to darkpan in ./darkpan (OrePAN2 seems to work) or install
# Dist::Milla, run `milla build` and copy it to ./darkpan/D/DU/DUMMY/Frame-0.01.tar.gz
#
# requires 'Frame',
#   mirror => "file:///$ENV{CWD}/darkpan",
#   dist => 'D/DU/DUMMY/Frame-0.01.tar.gz';
# ...or one of the following once I get it working in Carmel (halfway there for the first one):
#   url => 'https://github.com/marlencrabapple/Frame/archive/refs/heads/master.zip';
#   url => 'https://github.com/marlencrabapple/Frame.git';

requires 'List::AllUtils', '0.19';
requires 'List::Util', '1.63';
requires 'List::UtilsBy', '0.12';
requires 'List::SomeUtils', '0.59';

requires 'Hash::Ordered', '0.014';

requires 'Plack', '1.0050';
requires 'Plack::App::File';
requires 'Plack::Builder';
requires 'Plack::Middleware::Static';
requires 'Plack::Middleware::Debug';

requires 'DBI', '1.643';
requires 'DBD::SQLite', '1.72';
requires 'SQL::Abstract', '2.000001';

requires 'Text::Xslate', 'v3.5.9';
requires 'YAML::Tiny', '1.73';
requires 'Path::Tiny', '0.142';

requires 'Net::SSLeay', '1.92';
requires 'IO::Socket::SSL', '2.075';
requires 'HTTP::Tinyish', '0.18';

requires 'Time::Moment', '0.44';
requires 'DateTime::TimeZone', '2.57';

requires 'Text::Markdown::Hoedown', '1.03';

requires 'Inline::C';
requires 'Image::ExifTool', '12.42';
requires 'GD', '2.76';

on develop => sub {
  recommends 'App::perlimports', '0.000049';
  recommends 'Perl::Tidy', '20221112';
  recommends 'Perl::Critic', '1.144';
  recommends 'Perl::Critic::Community', 'v1.0.3';
  requires 'Plack::Middleware::REPL', '0.01'
};

on test => sub {
  requires 'Test::More', '0.96';
}
