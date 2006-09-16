#!/usr/bin/perl

use Business::USPS::WebTools::AddressStandardization;

my $verifier = Business::USPS::WebTools::AddressStandardization->new( {
	UserID   => $ENV{USPS_WEBTOOLS_USERID},
	Password => $ENV{USPS_WEBTOOLS_PASSWORD},
	Testing  => 1,
	} );

my $hash = $verifier->verify_address(
	FirmName => '',
	Address1 => '',
	Address2 => '6406 Ivy Lane',
	City     => 'Greenbelt',  
	State    => 'MD',
	Zip5     => '',
	Zip4     => '',
	);

if( $verifier->is_error )
	{
	warn "Oops!\n":
	}
else
	{
	print <<"HERE";
$hash->{FirmName}
$hash->{Address1}
$hash->{Address2}
$hash->{City}   
$hash->{State}  
$hash->{Zip5}   
$hash->{Zip4}  
HERE
	}
