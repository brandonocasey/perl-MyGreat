#! /usr/bin/env perl
use strict;
use warnings;
my $table_name = 'test_table';

sub up
{
    my $schema = shift;
    print "WOO 2015\n";
    # Array of hashes
#    my $table_data = DB::query("SELECT * FROM $table_name");
#    Schema->table($table_name, sub{
#        my $table = shift;
#        $table->dropColumn('status');
#        $table->string('status2');
#    });
    #
    #foreach my $data (@$table_data) {
    #    DB::query("UPDATE $table_name SET status2 = ? WHERE id = ?", $data->{status}, $data->[id]);
    #}
}

sub down
{
    my $schema = shift;
    my $table_data = DB::query("SELECT * FROM $table_name");
    Schema->table($table_name, sub{
        my $table = shift;
        $table->dropColumn('status2');
        $table->string('status');
    });

    foreach my $data (@$table_data) {
        DB::query("UPDATE $table_name SET status = ? WHERE id = ?", $data->{status2}, $data->{id});
    }
}
