package Schema;
use Schema::Table;
use strict;
use warnings;

sub create
{
    my $class      = shift;
    my $table_name = shift;
    my $function   = shift;

    my $table = Schema::Table->new($table_name);
    $function($table);

    $table->save();
}

sub alter
{
    my $class      = shift;
    my $table_name = shift;
    my $function   = shift;

    my $table = Schema::Table->find($table_name);
    $function($table);

    $table->save();

}

sub delete
{
    my $class      = shift;
    my $table_name = shift;
    Schema::Table->delete($table_name);
}

1;
