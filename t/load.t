# $Id$
BEGIN {
	@classes = qw(
		Business::USPS::WebTools
		Business::USPS::WebTools::AddressStandardization
		Business::USPS::WebTools::ZipCodeLookup
		Business::USPS::WebTools::CityStateLookup
		);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! $class did not compile\n" unless use_ok( $class );
	}
