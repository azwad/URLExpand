package URLExpand;
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use JSON 'decode_json';
use feature qw/say/;
use WebService::Bitly;
use Config::Pit;

sub new {
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub expand {
	my $self = shift;
	my $short_url = shift;
	my $expand_url ='';
	if ($short_url =~  /^http:\/\/htn\.to/ ) {
		$expand_url =  _expand_hatena($short_url);
	}elsif ( $short_url =~ /^http:\/\/bit\.ly/  ||  $short_url =~ /^http:\/\/j\.mp/ ) {
		$expand_url =  _expand_bitly($short_url);
	}elsif ( $short_url =~ /^http:\/\/goo\.gl/ ) {
		$expand_url =  _expand_googl($short_url);
	}elsif ( $short_url =~ /^http:\/\/t\.co/ ) {
		$expand_url =  _expand_else($short_url);
	}else{
		$expand_url = _expand_else($short_url);
	}

	if ($expand_url =~ /^http:\/\/feeds\.feedburner\.com/){
		$expand_url = _expand_else($expand_url);
		return $expand_url;
	}else{
		return $expand_url;
	}
}

sub _expand_hatena {
	my $short_url = shift;
	my $query_url = 'http://b.hatena.ne.jp/api/htnto/expand?shortUrl=' . $short_url;
	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new( GET => $query_url);
	my $res = $ua->request($req);
	my $content = $res->content;
	my $json = decode_json($content);
	my $expand_url = $json->{data}->{expand}->[0]->{long_url};
	if (defined $expand_url ){
		return $expand_url;
	}else{
#		say "can't find expand url in htnto";
		$expand_url = _expand_else($short_url);
		return $expand_url;
	}
}

sub _expand_bitly {
	my $short_url = shift;
	my $expand_url;
	my $pit_bitly = Config::Pit::pit_get('bit.ly',require => {
			'user_name'		 => 'bitly user _name',
			'user_api_key' => 'bitlu user api key',
		}
	);
	my $bitly = WebService::Bitly->new(
			'user_name'		 => $pit_bitly->{user_name},
			'user_api_key' => $pit_bitly->{user_api_key},
	);
	my $expand = $bitly->expand(
			'short_urls' => [$short_url],
	);

	$expand_url = $expand->results->[0]->long_url;

	if (defined $expand_url){
		return $expand_url;
	}else{
#		say "can't find expand url in bit.ly";
		$expand_url = _expand_else($short_url);
		return $expand_url;
	}
}


sub _expand_googl {
	my $short_url = shift;
	my $expand_url;
	my $pit_googl = Config::Pit::pit_get('GoogleSimpleAPIAccess',require => {
			'api_key' => 'Google Simple API key',
		}
	);
	my $user_api_key = $pit_googl->{api_key};
	my $query_url = 'https://www.googleapis.com/urlshortener/v1/url?key=' . $user_api_key . '&shortUrl=' . $short_url;

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new( GET => $query_url);
	my $res = $ua->request($req);
	my $content = $res->content;

	my $json = decode_json($content);
	$expand_url = $json->{longUrl};

	if (defined $expand_url ){
		return $expand_url;
	}else{
#		say "can't find expand url in googl";
		$expand_url = _expand_else($short_url);
		return $expand_url;
	}
}

sub _expand_else {
	my $short_url = shift;
	my $query_url =  $short_url;
	my $ua = LWP::UserAgent->new;
	my $res = $ua->head($query_url);
	my $expand_url = $res->request->uri;
	if (defined $expand_url ){
		return $expand_url;
	}else{
		return $short_url;
	}
}
1;
