# EDS PLM
#
# File: change_user_pass.pl
#
#*******************************************************************************
#   Revision    History:
#   Date        Author         Comment
#   =========   ======         =================================================
#   12-Jul-03   Van Nguyen     Initial.
#   05-Dec-06   Brendan Brolly Remove create_ilog
#
#*******************************************************************************#
#       If you want Tc databases created with a different Oracle
#       username/password than infodba/infodba, use this script to change
#       it BEFORE running Oracle DBCA to create a new database.
#
#       The files it uses as templates are: create_user.sql.tpl,
#                                           delete_user.sql.tpl.
#
#       The files it creates new are: create_user.sql,
#                                     delete_user.sql.
#
#       When you run Oracle DBCA to create a Tc database, the script
#       create_user.sql is called by DBCA to create the
#       required Tc objects.
#
#       When you run tc_unpopulate_db.sql to unpopulate a Tc database,
#       the script delete_user.sql is called.
#
#
#       This script uses the Getopt::Std package, so you need a Perl5 install
#       that includes the Getopt Perl module. The Perl install of Oracle
#       should be sufficient.
#
#       This script needs 2 arguments -u and -p.
#
#       This is how this program should be called:
#       perl -w change_user_pass.pl -u=new_username -p=new_password
#
#       For help:
#       perl -w change_user_pass.pl -help
#
# ******************************************************************************

# Need this Getopt for argument processing.
use Getopt::Std;

# Initialize opt_u and opt_p, these variables will be stored with values passed
# in from the command line.
$opt_u = "";
$opt_p = "";
$opt_h = "NO";

# Get the command arguments and exit if do not find these 2 args: u and p.
getopt ('hup');

# Get rid of the "=" character if supplied.
$opt_h =~ s/=//;
$opt_u =~ s/=//;
$opt_p =~ s/=//;

if ( "$opt_h" eq "help" || "$opt_h" eq "elp" || "$opt_h" eq "" ) {
   print "\n\nSynopsis:\n";
   print "perl -w change_user_pass.pl -u=new_username -p=new_password\n\n";
   print "This script needs Perl5 with the Getopt::Std package installed.\n";
   exit;
}

if ( ! "$opt_u" ) {
   die "No -u argument spcified.";
}
if ( ! "$opt_p" ) {
   die "No -p argument spcified.";
}

# Find required files.
if ( ! -e "create_user.sql.tpl" ) {
   die "Unable to find template file: create_user.sql.tpl: $!\n";
}
if ( ! -e "delete_user.sql.tpl" ) {
   die "Unable to find template file: delete_user.sql.tpl: $!\n";
}

# Remove existing .old files.
if ( -e "create_user.sql.old" ) {
   unlink "create_user.sql.old" or die "Unable to delete file: create_user.sql.old: $!\n";
}
if ( -e "delete_user.sql.old" ) {
   unlink "delete_user.sql.old" or die "Unable to delete file: delete_user.sql.old: $!\n";
}

if ( -e "delete_user.sql" ) {
   if ( ! rename "delete_user.sql", "delete_user.sql.old" ) {
     die "Unable to rename file: delete_user.sql to delete_user.sql.old: $!\n";
   }
}
if ( -e "create_user.sql" ) {
   if ( ! rename "create_user.sql", "create_user.sql.old" ) {
     die "Unable to rename file: create_user.sql to create_user.sql.old: $!\n";
   }
}


# Process create_user.sql
open CREATE_USER_TPL, "<create_user.sql.tpl" or die "Unable to open file: create_user.sql.tpl: $!\n";
open CREATE_USER, ">create_user.sql" or die "Unable to open file: create_user.sql: $!\n";

$count = 0;
while ( $_ = <CREATE_USER_TPL> ) {
   if ( $_ =~ m/infodba/ ) {
      $count = $count + 1;
      $new_line = $_;
      $new_line =~ s/infodba/$opt_u/g;
      if ( $new_line =~ m/identified by/ ) {
         $new_line =~ s/identified by $opt_u/identified by $opt_p/;
      }
      print CREATE_USER $new_line;
   } else {
      print CREATE_USER $_;
   }
}

if ( $count == 0 ) {
  print "Warning: Did not find string \"infodba\" in file create_user.sql.tpl.\n";
} else {
  print "Created create_user.sql.\n";
}
close CREATE_USER_TPL;
close CREATE_USER;

# Process delete_user.sql
open DELETE_USER_TPL, "<delete_user.sql.tpl" or die "Unable to open file: delete_user.sql.tpl: $!\n";
open DELETE_USER, ">delete_user.sql" or die "Unable to open file: delete_user.sql: $!\n";

$count = 0;
while ( $_ = <DELETE_USER_TPL> ) {
   if ( $_ =~ m/infodba/ ) {
      $count = $count + 1;
      $new_line = $_;
      $new_line =~ s/infodba/$opt_u/g;
      print DELETE_USER $new_line;
   } else {
      print DELETE_USER $_;
   }
}
if ( $count == 0 ) {
  print "Warning: Did not find string \"infodba\" in file delete_user.sql.tpl.\n";
} else {
  print "Created delete_user.sql.\n";
}
close DELETE_USER_TPL;
close DELETE_USER;

print "Completed succesfully.\n";

exit 0;
