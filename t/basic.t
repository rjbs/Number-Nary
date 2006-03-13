use strict;
use warnings;

use Test::More tests => 10;

BEGIN { use_ok('Number::Nary'); }

{ # base 13
  my ($enc, $dec) = n_codec('0123456789ABC');

  my $meaning = $enc->(6 * 9);

  is($meaning, "42", "encodes base 13 properly");

  my $meaningless = $dec->($meaning);

  is($meaningless, "54", "decodes base 13 properly");

  eval { $enc->(6.2); };
  like($@, qr/integer/, "can't encode floats");

  eval { $enc->("YOUR FACE"); };
  like($@, qr/integer/, "can't encode strings");

  eval { $enc->(-10); };
  like($@, qr/non-negative/, "can't encode negative ints");

  eval { $dec->('BABELFISH'); };
  like($@, qr/invalid/, "can't decode a value with unknown digits");
}

{ # n_encode and n_decode
  is(
    Number::Nary::n_encode(27,"10"),
    '00100',
    "27 into reverse binary"
  );

  is(
    Number::Nary::n_decode('11011',"01"),
    27,
    "27 from normal binary"
  );

}

eval { n_codec('ABCDEE'); };
like($@, qr/repeated/, "you can't build codec with non-unique base string");
