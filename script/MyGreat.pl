#! /usr/bin/env perl
package Script::MyGreat;
# TODO:
# 1. Create
# 2. Rollback
# 3. Reset
# 4. Refresh
# 5. ToVersion rather than date?
# 6. Create Database
# 7. Create Migrations Table
# 8. allow multi project migrations
# 9. Setup default connection per project
use strict;
use warnings;
use DBI;
use Data::Dumper;
use Getopt::Long qw(:config no_auto_abbrev);
use File::Basename;

my $defaults = {
    'root'    => '/opt/MyGreat/examples',
    'db_user' => 'mysql',
    'db_pass' => 'mysql',
    'db_port' => 3306,
};

my $vars = {
};


__PACKAGE__->run(@ARGV) if !caller();


sub run
{
    my $class = shift;

    my $ret = GetOptions
    (
        "root=s"    => \$vars->{root},
        "db_name=s" => \$vars->{db_name},
        "db_user=s" => \$vars->{db_user},
        "db_pass=s" => \$vars->{db_pass},
        "db_host=s" => \$vars->{db_host},
        "db_port=s" => \$vars->{db_port},
        "create=s"  => \$vars->{create},
        "rollback"  => \$vars->{rollback},
        "reset"     => \$vars->{reset},
        "refresh"   => \$vars->{refresh},
        "h|help|?"  => sub { $class->usage() },
        "list"      => \my $list,
        "project=s" => \$vars->{project},
    );
    $class->set_defaults();
    if(!$ret) {
        exit;
    }

    # We have to list after we get all of the options or else
    # we won't get an accurate list
    if($list) {
        $class->list($vars->{root});
    }

    if(!$vars->{project}) {
        die("Project is required, use --list to see all avilable projects");
    }

    if($vars->{create})
    {
        $class->create($vars->{project}, $vars->{create})
    }
    #Schema->addConnection({
    #    'name' => $vars->{project},
    #    'db'   => $vars->{db_name},
    #    'host' => $vars->{db_host},
    #    'port' => $vars->{db_port},
    #    'user' => $vars->{db_user},
    #    'pass' => $vars->{db_pass},
    #    'type' => 'mysql'
    #});

    if($vars->{rollback})
    {
        $class->rollback($vars->{project});
    }
    elsif($vars->{reset})
    {
        $class->reset($vars->{project});
    }
    elsif($vars->{refresh})
    {
        $class->rollback($vars->{project});
        $class->migrate($vars->{project});
    }
    else
    {
        $class->checkTable($vars->{project});
        $class->migrate($vars->{project});
    }
}

# make sure the database/migratrion table exists
sub checkTable
{
    my $class = shift;
    my $project = shift;
#    if(!Schema->databaseExists($project))
    #{
    #}
    # Check if database exists, ask to create
#    if(!Schema->tableExists('migrations'))
    #{
    #}
}

sub usage
{
    my $class = shift;
    my $script = basename($0);
    print STDOUT ""
    . "\n"
    . "    ./$script -project <name> --<options>\n"
    . "\n"
    . "     h|help|?     Show this help menu\n"
    . "     l|list       List the projects that can be migrated\n"
    . "     dbn|db_name  Specify a database name rather than using the default\n"
    . "     r|root       Find Migrations under this root instead of $defaults->{root}\n"
    . "     dbu|db_user  Specify a database user rather than a the default $defaults->{db_user}\n"
    . "     dbp|db_pass  Specify a database pass rather than a the default $defaults->{db_pass}\n"
    . "     p|project    Specify which project to migrate\n"
    . "     c|create     Add a new migration with this name for the specified project\n"
    . "\n";
    exit;
}

sub migrate
{
    my $class   = shift;
    my $project = shift;

    my $folder = "$vars->{root}/$project/migrations";
    my $migrations = [];
    opendir(my $DIR, "$folder") or die "Cant open $folder: $!\n";
    while (my $entry = readdir $DIR)
    {
        my $full_path = $folder. '/' . $entry;
        next if ! -f $full_path;
        (my $migration = $entry) =~ s/\.[^.]+$//;
        print "Migrating $migration\n";
        {
            require "$full_path";
            up();
            undef &up;
            undef &down;
        }

    }
}

sub rollback
{
    my $class   = shift;
    my $project = shift;

    my $folder = "$vars->{root}/$project/migrations";
    my $migrations = [];
    opendir( my $DIR, "$folder") or die "Cant open $folder: $!\n";
    while ( my $entry = readdir $DIR )
    {
        my $full_path = $folder. '/' . $entry;
        next if ! -f $full_path;
        print "Using $full_path\n";
        {
            require "$full_path";
            down();
            undef &up;
            undef &down;
        }

    }
}



sub list
{
    my $class  = shift;
    my $folder = shift;

    my $projects = [];
    opendir( my $DIR, "$folder") or die "Cant open $folder: $!\n";
    while ( my $entry = readdir $DIR )
    {
        my $full_path = $folder. '/' . $entry;
        next if ! -d $full_path;
        next if $entry eq '.' or $entry eq '..';
#        next if ! -f $full_path ."/defaults.cfg";
        next if ! -d $full_path ."/migrations";
        next if $class->isEmptyFolder($full_path ."/migrations");

        push(@$projects, $entry);
    }

    print STDOUT ""
    . "\n"
    . "    The following are located in $vars->{root}:\n";
    foreach my $project (@$projects)
    {
        print STDOUT "    * $project\n";
    }

    print STDOUT "\n";
    exit;
}


sub set_defaults
{
    my $class = shift;
    while (my ($default_key, $default_value) = each (%$defaults))
    {
        if(!defined($vars->{$default_key}))
        {
            $vars->{$default_key} = $default_value;
        }
    }
}

sub projects
{
    my $class = shift;
    my $folder = $vars->{root};

    my $projects = [];
    opendir( my $DIR, "$folder") or die "Cant open $folder: $!\n";
    while ( my $entry = readdir $DIR )
    {
        my $full_path = $folder. '/' . $entry;
        next if ! -d $full_path;
        next if $entry eq '.' or $entry eq '..';
        next if ! -f $full_path ."/defaults.cfg";
        next if ! -d $full_path ."/migrations";
        next if $class->isEmptyFolder($full_path ."/migrations");

        push(@$projects, $entry);
    }
    closedir $DIR;
    return $projects;
}

sub isEmptyFolder
{
    my $class  = shift;
    my $folder = shift;
    opendir( my $DIR, "$folder") or die "Cant open $folder: $!\n";
    while ( my $entry = readdir $DIR )
    {
        if ($entry !~ /^[.][.]?\z/)
        {
            closedir($DIR);
            return 0;
        }
     }
    closedir($DIR);
    return 1;
}
