package Number::Nary;

use warnings;
use strict;

=head1 NAME

Number::Nary - encode and decode numbers as n-ary strings

=head1 VERSION

version 0.05

 $Id$

=cut

our $VERSION = '0.05';

use Carp qw(croak);
use List::MoreUtils qw(uniq);

use Sub::Exporter -setup => {
  exports => [ qw(n_codec n_encode n_decode) ],
  groups  => {
    default    => [ qw(n_codec) ],
    codec_pair => \&_generate_codec_pair,
  }
};

sub _generate_codec_pair {
  my (undef, undef, $arg, undef) = @_;
  my %pair;
  @pair{qw(encode decode)} = n_codec($arg->{digits});
  return \%pair;
}

=head1 SYNOPSIS

This module lets you convert numbers into strings that encode the number using
the digit set of your choice.

  my ($encode_sub, $decode_sub) = n_codec('01234'); # base five

  my $number = $encode_sub('8675309'); # jenny's number for one-handed folk

=head1 FUNCTIONS

=head2 C<< n_codec($digits) >>

This routine returns a reference to a subroutine which will encode numbers into
the given set of digits and a reference which will do the reverse operation.

This routine will croak if the digit string contains repeated digits.

The encode sub will croak if it is given input other than a non-negative
integer. 

The decode sub will croak if given a string that contains characters not in the
digit string.

=cut

sub n_codec {
	my ($base_string) = @_;

	my @digits = split //, $base_string;
  croak "base string contains repeated characters"
    unless @digits == uniq @digits;

  my $encode_sub = sub {
    my ($value) = @_;

    croak "value isn't an non-negative integer"
      if not defined $value
      or $value !~ /\A\d+\z/
      or ($value < 0);

      my $string = '';
      while (1) {
        my $digit = $value % @digits;
        $value = int($value / @digits);
        $string = "$digits[$digit]$string";
        last unless $value;
      }
    return $string;
  };

  my $i = 0;
  my %digit_value = map { $_ => $i++ } @digits;

  my $decode_sub = sub {
    my ($string) = @_;
    my @found_digits = split //, $string;
    return 0 unless @found_digits;

    my $value    = 0;
    my $position = 0;
    for my $digit (reverse @found_digits) {
      croak "string to decode contains invalid digits"
        unless exists $digit_value{$digit};
      $value += $digit_value{$digit}  *  @digits ** $position++;
    }
    return $value;
  };

  return ($encode_sub, $decode_sub);
}

=head2 C<< n_encode($value, $digits) >>

This encodes the given value into a string using the given digit string.  It is
written in terms of C<n_codec>, above, so it's not efficient at all for
multiple uses in one process.

=head2 C<< n_decode($value, $digits) >>

This is the decoding equivalent to C<n_encode>, above.

=cut

sub n_encode { (n_codec($_[1]))[0]->($_[0]) }
sub n_decode { (n_codec($_[1]))[1]->($_[0]) }

=head1 EXPORTS

C<n_codec> is exported by default.  C<n_encode> and C<n_decode> are exported.

Pairs of routines to encode and decode may be imported by using the
C<codec_pair> group as follows:

  use Number::Nary -codec_pair => { digits => '01234567', -suffix => '8' };

  my $encoded = encode8($number);
  my $decoded = decode8($encoded);

For more information on this kind of exporting, see L<Sub::Exporter>.

=head1 AUTHOR

Ricardo Signes, C<< <rjbs at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-number-nary@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Number-Nary>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SECRET ORIGINS

I originally used this system to produce unique worksheet names in Excel.  I
had a large report generating system that used Win32::OLE, and to keep track of
what was where I'd Storable-digest the options used to produce each worksheet
and then n-ary encode them into the set of characters that were valid in
worksheet names.  Working out that set of characters was by far the hardest
part.

=head1 ACKNOWLEDGEMENTS

Thanks, Jesse Vincent.  When I remarked, on IRC, that this would be trivial to
do, he said, "Great.  Would you mind doing it?"  (Well, more or less.)  It was
a fun little distraction.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Ricardo Signes, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # my ($encode_sub, $decode_sub) = n_codec('8675309'); # jennynary
