package Cat;
use strict;
use base qw(Class::Accessor::Fast);
Cat->mk_accessors(qw(gender age pregnant pregnant_days gestation_period days_since_litter sexual_maturity name));

1;
