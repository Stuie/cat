#!/usr/bin/perl
use strict;
use warnings;
use Cat;

my $iterations = $ARGV[0];
$iterations ||= 1;
my @results;

for(my $it = 0; $it < $iterations; $it++) {
  my $season = 0;
  my $breeding = 1;

  my @seasons;
  push @seasons, 'Winter';
  push @seasons, 'Spring';
  push @seasons, 'Summer';
  push @seasons, 'Autumn';

  my @cats;
  push @cats, Cat->new({
    gender => 'Female',
    age => 0,
    pregnant => 0,
    pregnant_days => 0,
    days_since_litter => 0,
    gestation_period => int(rand(3))+64,
    sexual_maturity => int(rand(150))+150,
  });

  for(my $i = 0; $i<1826; $i++) {
    if ($i % 91 == 0) {
      if($season < 3) {
        $season++;
        $breeding = 1;
      } else {
        $season = 0;
        $breeding = 0;
      }
      #print "Season: ".$seasons[$season]." - Breeding: $breeding\n";
    }

    foreach my $cat (@cats) {
      $cat->age($cat->age()+1);
      next unless $cat->gender() eq 'Female';

      if($cat->pregnant()) {
        if($cat->pregnant_days() == $cat->gestation_period()) {
          for(my $j=0; $j<int(rand(2))+3; $j++) {
            push @cats, Cat->new({
              gender => (int(rand(100)) < 60) ? 'Female' : 'Male',
              age => 0,
              pregnant => 0,
              pregnant_days => 0,
              days_since_litter => 0,
              gestation_period => int(rand(3))+64,
              sexual_maturity => int(rand(150))+150,
            });
          }

          $cat->pregnant(0);
          $cat->pregnant_days(0);
          $cat->days_since_litter(0);
        } else {
          $cat->pregnant_days($cat->pregnant_days()+1);
        }
      } else {
        $cat->days_since_litter($cat->days_since_litter()+1);

        if($cat->age() >= $cat->sexual_maturity() && $breeding && $cat->days_since_litter() >= 30) {
          $cat->pregnant(1);
          $cat->pregnant_days(0);
        }
      }
    }

    my $s = (scalar(@cats) == 1) ? '' : 's';
    if($i == 1825) {
      print scalar(@cats)."\n";
      push @results, scalar(@cats);
    }
  }
}

my $total = 0;
foreach my $result (@results) {
  $total += $result;
}

print "Average number of cats: ".$total/$iterations."\n";
