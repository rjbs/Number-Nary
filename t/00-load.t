#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Number::Nary' );
}

diag( "Testing Number::Nary $Number::Nary::VERSION, Perl $], $^X" );
