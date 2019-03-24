#!/usr/bin/env perl6

use DB::SQLite;;

use lib $*PROGRAM.parent.add('../lib');
use OurFuncs;
use OurSql;

my $dbf = $*PROGRAM.parent.add($DBF2).absolute;

my $f   = '../data/attendees.csv';

my $db = atabase "SQLite", :database($dbf);

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM go

    Reads data from CSV file '$f' and
    loads them into an SQLite database
    (file '$DBF').
    HERE
    exit;
}

my $dbf-updated = 0;

create-tables; # OurSql

my %keys = SetHash.new ; # check for dups
for $f.IO.lines -> $line {
    my @w = split $COMMA, $line;
    my $last  = tclc @w.shift;
    my $first = tclc @w.shift;
    # rest of data may vary
    my %a = SetHash.new;
    my %e = SetHash.new;
    my %p = SetHash.new;

    # TODO use a grammar to extract data from the input line
    for @w -> $w is copy {
        $w .= trim;
        if $w ~~ /(\d**4) (:i p)?/ {
            my $year = ~$0;
            if  $1 {
                %p{$year}++;
            }
            else {
                %a{$year}++;
            }
        }
        elsif $w ~~ /'@'/ {
            $w .= lc;
            %e{$w}++;
        }
        else {
            note "FATAL: Unexpected data word '$w'";
            die  "line: '$line'";
        }
    }

    # put in db
    # get a key for Person
    my $key = create-csv-key :$last, :$first, :e-mail(%e);
    # unique?
    if %keys{$key} {
        die "FATAL: key '$key' is NOT unique.";
    }
    else {
        %keys{$key}++;
    }

    # we have the data, insert into the four tables if not there
    # already
    my $upd = create-row :table<person>; # enter pairs of col/values
    if $upd {
        ++$dbf-updated;
        # check each child table's entry
        for %a.keys -> $year {
            create-row table<attend>;
        }
        for %e.keys -> $email {
            create-row table<email>;
        }
        for %p.keys -> $year {
            create-row table<present>;
        }
    }
}

say "Normal end.";
if $dbf.IO.f {
    if $dbf-updated {
        say "Updated data are in database file '$DBF'.";
    }
    else {
        say "No data were updated in database file '$DBF'.";
    }
}
