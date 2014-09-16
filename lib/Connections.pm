package List;
use strict;
use warnings;


my $connections = {};

sub shift
{
}

sub push
{
    my $class = shift;
    my $connection = shift;
    Connections::Connection->new($connection);
    push(@$connections, $connection);
}

sub pop
{
}

sub unshift
{
}

sub splice
{
}

sub get
{
}


1;
# __END__
# # Below is stub documentation for your module. You'd better edit it!
