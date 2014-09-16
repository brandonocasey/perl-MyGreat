package Connection;
use strict;
use warnings;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();
our $VERSION = '1.00';
require Exporter;
use AutoLoader qw(AUTOLOAD);


sub new
{
    my $class = shift;
    my $arg = shift;
    my $self = {
        ''
    };



    bless($self, $class);
    return $self;
}


1;
# __END__
# # Below is stub documentation for your module. You'd better edit it!
