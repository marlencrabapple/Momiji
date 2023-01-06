recommends 'perl', 'v5.36';

requires 'Object::Pad', '0.77';
requires 'Future::AsyncAwait', '0.62';
requires 'Syntax::Keyword::Dynamically', '0.11';

requires 'Plack', '1.0050';
requires 'Plack::App::File';
requires 'Plack::Builder';
requires 'Plack::Middleware::Static';

requires 'DBI', '1.643';
requires 'DBD::SQLite', '1.72';
requires 'SQL::Abstract', '2.000001';

requires 'Text::Xslate', 'v3.5.9';
requires 'JSON::MaybeXS', '1.004004';
requires 'YAML::Tiny', '1.73';
requires 'Path::Tiny', '0.142';

requires 'Net::SSLeay', '1.92';
requires 'IO::Socket::SSL', '2.075';
requires 'HTTP::Tinyish', '0.18';

requires 'IO::Async', '0.802';
requires 'IO::Async::SSL', '0.23';
requires 'Net::Async::HTTP::Server', '0.13';

requires 'Starlet', '0.31';
requires 'Gazelle', '0.49';
requires 'HTTP::Parser::XS', '0.17';
requires 'Server::Starter', '0.35';
requires 'Parallel::Prefork', '0.18';

requires 'Time::Moment', '0.44';
requires 'DateTime::TimeZone', '2.57';

requires 'Image::ExifTool', '12.42';
requires 'GD', '2.76';

on develop => sub {
  recommends 'App::perlimports', '0.000049';
  recommends 'Perl::Tidy', '20221112';
  recommends 'Perl::Critic', '1.144';
  recommends 'Perl::Critic::Community', 'v1.0.3'
}

