package Table;
use strict;
use warnings;
use DB;

my $table_schema = {};

sub new
{
    my $self = shift;
    my $table_name = shift;

}

sub find
{

}

sub string
{
    my $self = shift;
    my $name = shift;

    $table_schema->{$name} = "string";

}

sub increments
{
    my $name = shift;
    $table_schema->{$name} = "";

}

sub delete
{

}
1;
# __END__
# # Below is stub documentation for your module. You'd better edit it!
