use strict;
use warnings;

use Test::More tests => 9;

BEGIN { use_ok('Number::Nary'); }

{ # scale base
  my ($enc, $dec) = n_codec([qw(do ra mi fa so la ti)]);

  my $meaning = $enc->(532);

  is($meaning, "rafatido", "encodes sung-scale properly");

  my $meaningless = $dec->($meaning);

  is($meaningless, "532", "decodes (do/ra/me) properly");

  eval { $enc->(6.2); };
  like($@, qr/integer/, "can't encode floats");

  eval { $enc->("YOUR FACE"); };
  like($@, qr/integer/, "can't encode strings");

  eval { $enc->(-10); };
  like($@, qr/non-negative/, "can't encode negative ints");

  eval { $dec->('doraymi'); };
  like(
    $@,
    qr/multiple/,
    "can't decode a string that's not a multiple of the digit length"
  );

  eval { $dec->('BABELFISHY'); };
  like($@, qr/invalid/, "can't decode a value with unknown digits");
}

eval { n_codec([qw(do ray mi fa so la ti)]); };
like($@, qr/uniform length/, "we can't use digits of varying lengths");
