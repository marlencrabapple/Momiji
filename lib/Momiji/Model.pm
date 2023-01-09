use Object::Pad;

package Momiji::Model;
role Momiji::Model;

use utf8;
use v5.36;
use autodie;

use Carp;
use Data::Dumper;
use Time::Moment;
use JSON::MaybeXS;
use SQL::Abstract;
use Hash::Ordered;
use Feature::Compat::Try;

field $dbh :param :reader;
field $sqla :reader;
field $columns :mutator;
field $constraints :mutator;

ADJUSTPARAMS ($params) {
  $sqla = SQL::Abstract->new;
  $dbh //= $$params{dbh};
  $columns //= Hash::Ordered->new;
  $constraints //= Hash::Ordered->new;
}

method create_table {
  my $columns = $self->columns;
  my $constraints = $self->constraints;
  my $table = $self->table;
  my @fields;

  foreach my $name ($columns->keys) {
    my $column = $columns->get($name);

    $$column{type} //= 'TEXT';

    $$column{sql_type} = 'TEXT'
      if $$column{type} eq 'JSON';

    $$column{sql_type} = 'INTEGER'
      if $$column{type} eq 'Time::Moment';

    my $field = "$name " . ($$column{sql_type} || $$column{type});
    
    $field .= ' PRIMARY KEY' if $$column{primary_key};
    $field .= ' AUTOINCREMENT' if $$column{autoincrement};
    $field .= ' NOT NULL' if $$column{not_null};

    $field .= " REFERENCES $$column{foreign_key}" if $$column{foreign_key};

    push @fields, $field
  }

  push @fields, "attr TEXT";

  foreach my $key ($constraints->keys) {
    my $val = $constraints->get($key);
    my $field;
  
    if($key eq 'primary_key') {
      $field = 'PRIMARY KEY (' . join ',', @$val . ')'
    }

    push @fields, $field
  }

  my $sql = $sqla->generate('CREATE TABLE', \$table, \@fields);
  # say Dumper($table, $columns, $constraints, \@fields, $sql);

  try {
    my $sth = $dbh->prepare($sql);
    $sth->execute
  }
  catch ($e) {
    carp $e
  }
}

1