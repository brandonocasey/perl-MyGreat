#! /usr/bin/env perl
use strict;
use warnings;


my $table_name = 'test_table';

sub up {
    my $schema = shift;
#    $schema->create($table_name, sub{
#        my $table = shift;
#        $table->increments('id');
#        $table->string('status');
#        $table->timestamps();
#    });

}

sub down {
    my $schema = shift;
#    $schema->drop($table_name);
}

