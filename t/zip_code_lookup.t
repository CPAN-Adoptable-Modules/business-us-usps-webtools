#!/usr/bin/perl
# $Id$

# See http://www.usps.com/webtools/htm/Address-Information.htm for
# the test requirements. The headings ( "Good response #1", etc )
# correspond to the USPS test specification

use Test::More;

my $class  = "Business::US::USPS::WebTools::ZipCodeLookup";
my $method = 'lookup_zipcode';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
unless( $ENV{USPS_WEBTOOLS_USERID} and $ENV{USPS_WEBTOOLS_PASSWORD} )
	{
	plan skip_all => 
	"You must set the USPS_WEBTOOLS_USERID and USPS_WEBTOOLS_PASSWORD " .
	"environment variables to run these tests\n";
	}
else
	{
	plan tests => 109;
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
# Good Request #1
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '6406 Ivy Lane',
	City     => 'Greenbelt',  
	State    => 'MD',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>6406 Ivy Lane</Address2><City>Greenbelt</City><State>MD</State></Address></ZipCodeLookupRequest>|,
	"URL for Ivy Lane is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "Response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Address2>6406 IVY LN</Address2><City>GREENBELT</City><State>MD</State><Zip5>20770</Zip5><Zip4>1440</Zip4></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{Address2}, '6406 IVY LN',               'Address2 matches for Ivy Lane' );
is( $hash->{City},     'GREENBELT',                 'City matches for Ivy Lane' );
is( $hash->{State},    'MD',                        'State matches for Ivy Lane' );
is( $hash->{Zip5},     '20770',                     'Zip5 matches for Ivy Lane' );
is( $hash->{Zip4},     '1440',                      'Zip4 matches for Ivy Lane' );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good request 2
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '8 Wildwood Drive',
	City     => 'Old Lyme',  
	State    => 'CT',
	Zip5     => '06371',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>8 Wildwood Drive</Address2><City>Old Lyme</City><State>CT</State></Address></ZipCodeLookupRequest>|,
	"URL for Wildwood Drive is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "Response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Address2>8 WILDWOOD DR</Address2><City>OLD LYME</City><State>CT</State><Zip5>06371</Zip5><Zip4>1844</Zip4></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{FirmName}, '',                          'FirmName matches for Wildwood' );
is( $hash->{Address1}, '',                          'Address1 matches for Wildwood' );
is( $hash->{Address2}, '8 WILDWOOD DR',             'Address2 matches for Wildwood' );
is( $hash->{City},     'OLD LYME',                  'City matches for Wildwood' );
is( $hash->{State},    'CT',                        'State matches for Wildwood' );
is( $hash->{Zip5},     '06371',                     'Zip5 matches for Wildwood' );
is( $hash->{Zip4},     '1844',                      'Zip4 matches for Wildwood' );
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Good request 3
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '4411 Romlon Street',
	City     => 'Beltsville',  
	State    => 'MD',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>4411 Romlon Street</Address2><City>Beltsville</City><State>MD</State></Address></ZipCodeLookupRequest>|,
	"URL for Romlan Street is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "Response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Address2>4411 ROMLON ST</Address2><City>BELTSVILLE</City><State>MD</State><Zip5>20705</Zip5><Zip4>2425</Zip4></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{FirmName}, '',                          'FirmName matches for Romlan' );
is( $hash->{Address1}, '',                          'Address1 matches for Romlan' );
is( $hash->{Address2}, '4411 ROMLON ST',            'Address2 matches for Romlan' );
is( $hash->{City},     'BELTSVILLE',                'City matches for Romlan' );
is( $hash->{State},    'MD',                        'State matches for Romlan' );
is( $hash->{Zip5},     '20705',                     'Zip5 matches for Romlan' );
is( $hash->{Zip4},     '2425',                      'Zip4 matches for Romlan' );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Good request 4
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '3527 Sharonwood Road Apt. 3C',
	City     => 'Laurel',  
	State    => 'MD',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>3527 Sharonwood Road Apt. 3C</Address2><City>Laurel</City><State>MD</State></Address></ZipCodeLookupRequest>|,
	"URL for Sharonwood Road is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( ! $verifier->is_error, "Response is not an error" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Address2>3527 SHARONWOOD RD APT 3C</Address2><City>LAUREL</City><State>MD</State><Zip5>20724</Zip5><Zip4>5920</Zip4></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

my $hash = $verifier->_parse_response;

is( $hash->{FirmName}, '',                          'FirmName matches for Sharonwood' );
is( $hash->{Address1}, '',                          'Address1 matches for Sharonwood' );
is( $hash->{Address2}, '3527 SHARONWOOD RD APT 3C', 'Address2 matches for Sharonwood' );
is( $hash->{City},     'LAUREL',                    'City matches for Sharonwood' );
is( $hash->{State},    'MD',                        'State matches for Sharonwood' );
is( $hash->{Zip5},     '20724',                     'Zip5 matches for Sharonwood' );
is( $hash->{Zip4},     '5920',                      'Zip4 matches for Sharonwood' );

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Error Requests
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Error response #1
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '3527 Sharonwood Road Apt. 3C',
	City     => 'Wilmington',  
	State    => 'DE',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>3527 Sharonwood Road Apt. 3C</Address2><City>Wilmington</City><State>DE</State></Address></ZipCodeLookupRequest>|,
	"URL for Sharonwood Road Error is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( $verifier->is_error, "Error request gets an error response" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Error><Number>-2147219401</Number><Source>SOLServerTest;SOLServerTest.CallAddressDll</Source><Description>That address could not be found.</Description><HelpFile></HelpFile><HelpContext></HelpContext></Error></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

is( $verifier->{error}{number},        -2147219401,                           'Error number matches for Sharonwood error' );
is( $verifier->{error}{source},        'SOLServerTest;SOLServerTest.CallAddressDll', 'Error source matches for Sharonwood error' );
is( $verifier->{error}{description},   'That address could not be found.',    'Error description matches for Sharonwood error' );
is( $verifier->{error}{help_file},     '',                                    'Error help file matches for Sharonwood error' );
is( $verifier->{error}{help_context},  '',                                    'Error help context matches for Sharonwood error' );

my $hash = $verifier->_parse_response;

is( $hash->{FirmName}, '', 'FirmName is empty for Sharonwood error' );
is( $hash->{Address1}, '', 'Address1 is empty for Sharonwood error' );
is( $hash->{Address2}, '', 'Address2 is empty for Sharonwood error' );
is( $hash->{City},     '', 'City is empty for Sharonwood error' );
is( $hash->{State},    '', 'State is empty for Sharonwood error' );
is( $hash->{Zip5},     '', 'Zip5 is empty for Sharonwood error' );
is( $hash->{Zip4},     '', 'Zip4 is empty for Sharonwood error' );

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '1600 Pennsylvania Avenue',
	City     => 'Washington',  
	State    => 'DC',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>1600 Pennsylvania Avenue</Address2><City>Washington</City><State>DC</State></Address></ZipCodeLookupRequest>|,
	"URL for Pennsylvania Avenue Error is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( $verifier->is_error, "Error request gets an error response" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Error><Number>-2147219403</Number><Source>SOLServerTest;SOLServerTest.CallAddressDll</Source><Description>Multiple responses found.  No default address.</Description><HelpFile></HelpFile><HelpContext></HelpContext></Error></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

is( $verifier->{error}{number},        -2147219403,                           'Error number matches for Pennsylvania Avenue error' );
is( $verifier->{error}{source},        'SOLServerTest;SOLServerTest.CallAddressDll', 'Error source matches for Pennsylvania Avenue error' );
is( $verifier->{error}{description},   'Multiple responses found.  No default address.',    'Error description matches for Pennsylvania Avenue error' );
is( $verifier->{error}{help_file},     '',                                    'Error help file matches for Pennsylvania Avenue error' );
is( $verifier->{error}{help_context},  '',                                    'Error help context matches for Pennsylvania Avenue error' );

my $hash = $verifier->_parse_response;

#	print STDERR "In _make_request:\n" . Dumper( $verifier ) . "\n";	

is( $hash->{FirmName}, '', 'FirmName is empty for Pennsylvania Avenue error' );
is( $hash->{Address1}, '', 'Address1 is empty for Pennsylvania Avenue error' );
is( $hash->{Address2}, '', 'Address2 is empty for Pennsylvania Avenue error' );
is( $hash->{City},     '', 'City is empty for Pennsylvania Avenue error' );
is( $hash->{State},    '', 'State is empty for Pennsylvania Avenue error' );
is( $hash->{Zip5},     '', 'Zip5 is empty for Pennsylvania Avenue error' );
is( $hash->{Zip4},     '', 'Zip4 is empty for Pennsylvania Avenue error' );

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Error response #3
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '123 Main Street',
	City     => 'Washington',  
	State    => 'ZZ',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>123 Main Street</Address2><City>Washington</City><State>ZZ</State></Address></ZipCodeLookupRequest>|,
	"URL for Main Street Error is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( $verifier->is_error, "Error request gets an error response" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Error><Number>-2147219402</Number><Source>SOLServerTest;SOLServerTest.CallAddressDll</Source><Description>That State is not valid.</Description><HelpFile></HelpFile><HelpContext></HelpContext></Error></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

is( $verifier->{error}{number},        -2147219402,                           'Error number matches for Main Street error' );
is( $verifier->{error}{source},        'SOLServerTest;SOLServerTest.CallAddressDll', 'Error source matches for Main Street error' );
is( $verifier->{error}{description},   'That State is not valid.',    'Error description matches for Main Street error' );
is( $verifier->{error}{help_file},     '',                                    'Error help file matches for Main Street error' );
is( $verifier->{error}{help_context},  '',                                    'Error help context matches for Main Street error' );

my $hash = $verifier->_parse_response;

#	print STDERR "In _make_request:\n" . Dumper( $verifier ) . "\n";	

is( $hash->{FirmName}, '', 'FirmName is empty for Main Street error' );
is( $hash->{Address1}, '', 'Address1 is empty for Main Street error' );
is( $hash->{Address2}, '', 'Address2 is empty for Main Street error' );
is( $hash->{City},     '', 'City is empty for Main Street error' );
is( $hash->{State},    '', 'State is empty for Main Street error' );
is( $hash->{Zip5},     '', 'Zip5 is empty for Main Street error' );
is( $hash->{Zip4},     '', 'Zip4 is empty for Main Street error' );

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Error response #4
{
my $url = $verifier->_make_url( {
	FirmName => '',
	Address1 => '',
	Address2 => '123 Main Street',
	City     => 'Trenton',  
	State    => 'NJ',
	Zip5     => '',
	Zip4     => '',
	} );
is(
	$url,
	qq|http://testing.shippingapis.com/ShippingAPITest.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest%20USERID="$ENV{USPS_WEBTOOLS_USERID}"%20PASSWORD="$ENV{USPS_WEBTOOLS_PASSWORD}"><Address ID="0"><FirmName></FirmName><Address1></Address1><Address2>123 Main Street</Address2><City>Trenton</City><State>NJ</State></Address></ZipCodeLookupRequest>|,
	"URL for Trenton, NJ Error is correct",
	);

my $response = $verifier->_make_request;
ok( defined $response );
ok( $verifier->is_error, "Error request gets an error response" );

my $expected = <<"XML";
<?xml version="1.0"?>
<ZipCodeLookupResponse><Address ID="0"><Error><Number>-2147219400</Number><Source>SOLServerTest;SOLServerTest.CallAddressDll</Source><Description>That is not a valid city.</Description><HelpFile></HelpFile><HelpContext></HelpContext></Error></Address></ZipCodeLookupResponse>
XML

is( $response, $expected );

is( $verifier->{error}{number},        -2147219400,                           'Error number matches for Trenton, NJ error' );
is( $verifier->{error}{source},        'SOLServerTest;SOLServerTest.CallAddressDll', 'Error source matches for Trenton, NJ error' );
is( $verifier->{error}{description},   'That is not a valid city.',    'Error description matches for Trenton, NJ error' );
is( $verifier->{error}{help_file},     '',                                    'Error help file matches for Trenton, NJ error' );
is( $verifier->{error}{help_context},  '',                                    'Error help context matches for Trenton, NJ error' );

my $hash = $verifier->_parse_response;

#	print STDERR "In _make_request:\n" . Dumper( $verifier ) . "\n";	

is( $hash->{FirmName}, '', 'FirmName is empty for Trenton, NJ error' );
is( $hash->{Address1}, '', 'Address1 is empty for Trenton, NJ error' );
is( $hash->{Address2}, '', 'Address2 is empty for Trenton, NJ error' );
is( $hash->{City},     '', 'City is empty for Trenton, NJ error' );
is( $hash->{State},    '', 'State is empty for Trenton, NJ error' );
is( $hash->{Zip5},     '', 'Zip5 is empty for Trenton, NJ error' );
is( $hash->{Zip4},     '', 'Zip4 is empty for Trenton, NJ error' );

}

__END__
