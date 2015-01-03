BEGIN {
	@classes = qw(
		Business::US::USPS::WebTools
		Business::US::USPS::WebTools::AddressStandardization
		Business::US::USPS::WebTools::ZipCodeLookup
		Business::US::USPS::WebTools::CityStateLookup
		);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! $class did not compile\n" unless use_ok( $class );
	}
