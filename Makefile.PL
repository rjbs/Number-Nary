use inc::Module::Install;
all_from('lib/Number/Nary.pm');
requires('Carp'            => 0);
requires('Test::More'      => 0);
requires('List::MoreUtils' => 0.09);
requires('Sub::Exporter'   => 0.90);
requires('UDCode'          => 0);
extra_tests;
WriteAll;
