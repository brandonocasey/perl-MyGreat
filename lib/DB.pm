package DB;
use strict;
use warnings;
use DBI;

my $dbh;

sub connect
{
    my $class   = shift;
    my $db_name = shift;
    my $db_host = shift;
    my $db_user = shift;
    my $db_pass = shift;
    my $db_port = shift;
}

sub query
{
    my $class = shift;
    my $query = shift;
    my $sth = $dbh->prepare($query);
    $sth->execute(@_);

    my $result = [];
    $result = $sth->fetchall_arrayref({}) if $sth->{NUM_OF_FIELDS};
    return $result;
}

1;
