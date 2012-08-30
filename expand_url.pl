#!/usr/bin/perl
use strict;
use warnings;
use URLExpand;
use feature qw/say/;
use lib qw(/home/toshi/perl/lib);
use HashDump;

my @short_urls  = (
	'http://htn.to/AYL56j',
	'http://t.co/V5sAbgkK',
	'http://t.co/5sAbgkK',
	'http://j.mp/PueHUZ',
	'http://j.mp/Pu2xe',
	'http://goo.gl/fb/OKlhG',
);

foreach my $short_url (@short_urls){
	my $long_url = URLExpand->expand($short_url);
	say "$short_url => $long_url";
}
