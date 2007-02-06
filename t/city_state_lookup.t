#!/usr/bin/perl
# $Id$

# See http://www.usps.com/webtools/htm/Address-Information.htm for
# the test requirements. The headings ( "Good response #1", etc )
# correspond to the USPS test specification

use Test::More;

my $class  = "Business::US::USPS::WebTools::CityStateLookup";
my $method = 'lookup_city_state';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
unless( $ENV{USPS_WEBTOOLS_USERID} and $ENV{USPS_WEBTOOLS_PASSWORD} )
	{
	plan skip_all => 
	"You must set the USPS_WEBTOOLS_USERID and USPS_WEBTOOLS_PASSWORD " .
	"environment variables to run these tests\n";
	}
else
	{
	plan tests => 50;
	}
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
use_ok( $class );

my $verifier = $class->new( {
	UserID   => $ENV{USPS_WEBTOOLS_USERID},
	Password => $ENV{USPS_WEBTOOLS_PASSWORD},
	Testing  => 1,
	} );
isa_ok( $verifier, 	$class );

can_ok( $verifier, $method );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good response #1
{
my $url = $verifier->_make_url( {
	Zip5 => 90210,
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=%3CCityStateLookupRequest+USERID%3D%22$ENV{USPS_WEBTOOLS_USERID}%22+PASSWORD%3D%22$ENV{USPS_WEBTOOLS_PASSWORD}%22%3E%3CZipCode+ID%3D%220%22%3E%3CZip5%3E90210%3C%2FZip5%3E%3C%2FZipCode%3E%3C%2FCityStateLookupRequest%3E|,
	"URL for 90210 is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "90210 response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<CityStateLookupResponse><ZipCode ID="0"><Zip5>90210</Zip5><City>BEVERLY HILLS</City><State>CA</State></ZipCode></CityStateLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{City},     'BEVERLY HILLS',  'City matches for 90210' );
is( $hash->{State},    'CA',             'State matches for 90210' );
is( $hash->{Zip5},     '90210',          'Zip5 matches for 90210' );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good response #2
{
my $url = $verifier->_make_url( {
	Zip5     => '20770',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=%3CCityStateLookupRequest+USERID%3D%22$ENV{USPS_WEBTOOLS_USERID}%22+PASSWORD%3D%22$ENV{USPS_WEBTOOLS_PASSWORD}%22%3E%3CZipCode+ID%3D%220%22%3E%3CZip5%3E20770%3C%2FZip5%3E%3C%2FZipCode%3E%3C%2FCityStateLookupRequest%3E|,
	"URL for 20770 is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "20770 response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<CityStateLookupResponse><ZipCode ID="0"><Zip5>20770</Zip5><City>GREENBELT</City><State>MD</State></ZipCode></CityStateLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{City},     'GREENBELT',   'City matches for 20770' );
is( $hash->{State},    'MD',          'State matches for 20770' );
is( $hash->{Zip5},     '20770',       'Zip5 matches for 20770' );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good response #3
{
my $url = $verifier->_make_url( {
	Zip5     => '21113',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=%3CCityStateLookupRequest+USERID%3D%22$ENV{USPS_WEBTOOLS_USERID}%22+PASSWORD%3D%22$ENV{USPS_WEBTOOLS_PASSWORD}%22%3E%3CZipCode+ID%3D%220%22%3E%3CZip5%3E21113%3C%2FZip5%3E%3C%2FZipCode%3E%3C%2FCityStateLookupRequest%3E|,
	"URL for 21113 is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "Response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<CityStateLookupResponse><ZipCode ID="0"><Zip5>21113</Zip5><City>ODENTON</City><State>MD</State></ZipCode></CityStateLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{City},     'ODENTON',  'City matches for 21113' );
is( $hash->{State},    'MD',       'State matches for 21113' );
is( $hash->{Zip5},     '21113',    'Zip5 matches for 21113' );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good response #4
{
my $url = $verifier->_make_url( {
	Zip5     => '21032',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=%3CCityStateLookupRequest+USERID%3D%22$ENV{USPS_WEBTOOLS_USERID}%22+PASSWORD%3D%22$ENV{USPS_WEBTOOLS_PASSWORD}%22%3E%3CZipCode+ID%3D%220%22%3E%3CZip5%3E21032%3C%2FZip5%3E%3C%2FZipCode%3E%3C%2FCityStateLookupRequest%3E|,
	"URL for 21032 is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "21032 response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<CityStateLookupResponse><ZipCode ID="0"><Zip5>21032</Zip5><City>CROWNSVILLE</City><State>MD</State></ZipCode></CityStateLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{City},     'CROWNSVILLE',  'City matches for 21032' );
is( $hash->{State},    'MD',           'State matches for 21032' );
is( $hash->{Zip5},     '21032',        'Zip5 matches for 21032' );

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good response #5
{
my $url = $verifier->_make_url( {
	Zip5     => '21117',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=%3CCityStateLookupRequest+USERID%3D%22$ENV{USPS_WEBTOOLS_USERID}%22+PASSWORD%3D%22$ENV{USPS_WEBTOOLS_PASSWORD}%22%3E%3CZipCode+ID%3D%220%22%3E%3CZip5%3E21117%3C%2FZip5%3E%3C%2FZipCode%3E%3C%2FCityStateLookupRequest%3E|,
	"URL for Sharonwood Road is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "21117 response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<CityStateLookupResponse><ZipCode ID="0"><Zip5>21117</Zip5><City>OWINGS MILLS</City><State>MD</State></ZipCode></CityStateLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{City},  'OWINGS MILLS',  'City matches for 21117' );
is( $hash->{State}, 'MD',            'State matches for 21117' );
is( $hash->{Zip5},  '21117',         'Zip5 matches for 21117' );

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Error Requests
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Error response #1
{
my $url = $verifier->_make_url( {
	Zip5     => '99999',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=%3CCityStateLookupRequest+USERID%3D%22$ENV{USPS_WEBTOOLS_USERID}%22+PASSWORD%3D%22$ENV{USPS_WEBTOOLS_PASSWORD}%22%3E%3CZipCode+ID%3D%220%22%3E%3CZip5%3E99999%3C%2FZip5%3E%3C%2FZipCode%3E%3C%2FCityStateLookupRequest%3E|,
	"URL for Sharonwood Road Error is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( $verifier->is_error, "Error request gets an error response" );

my $expected = <<"XML";
<?xml version="1.0"?>
<CityStateLookupResponse><ZipCode ID="0"><Error><Number>-2147219403</Number><Source>SOLServerTest;SOLServerTest.CallZipCodeDll</Source><Description>Invalid Zip Code.</Description><HelpFile></HelpFile><HelpContext></HelpContext></Error></ZipCode></CityStateLookupResponse>
XML

is( $response, $expected );

is( $verifier->{error}{number},        -2147219403,                           'Error number matches for 99999 error' );
is( $verifier->{error}{source},        'SOLServerTest;SOLServerTest.CallZipCodeDll', 'Error source matches for 99999 error' );
is( $verifier->{error}{description},   'Invalid Zip Code.',    'Error description matches for 99999 error' );
is( $verifier->{error}{help_file},     '',                                    'Error help file matches for 99999 error' );
is( $verifier->{error}{help_context},  '',                                    'Error help context matches for 99999 error' );

my $hash = $verifier->_parse_response;

is( $hash->{City},     '', 'City is empty for Sharonwood error' );
is( $hash->{State},    '', 'State is empty for Sharonwood error' );
is( $hash->{Zip5},     '', 'Zip5 is empty for Sharonwood error' );

}
