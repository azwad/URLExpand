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
	'http://rss.rssad.jp/rss/artclk/9FLW5bfpNz.D/9f89bf9033eb3da958f467d267c189fa?ul=ViMi4I5OWm9.59KCLdyVO3AmVYYmoiE6YWikVwKxeKhXxbMxuhgTyVLTNwwHFimO1MuRuUv',
);

foreach my $short_url (@short_urls){
	my $long_url = URLExpand->expand($short_url);
	say "$short_url => $long_url";
}
