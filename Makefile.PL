require 5.006;
use strict;
use warnings;

my $github    = 'https://github.com/briandfoy/';
my $main_file = 'lib/';

my %WriteMakefile = (
	'NAME'	        => 'Business::US::USPS::WebTools',
	'VERSION_FROM'  => 'lib/WebTools.pm',
	'ABSTRACT_FROM' => $main_file;	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',

	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker' => '6.64',
		},

	'BUILD_REQUIRES' => {
		},

	'TEST_REQUIRES' => {
		'Test::More' => '0.94',
		},

	'PREREQ_PM'     => {
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url  => "$github.git",
				web  => $github,
				},
			bugtraker => {
				web    => "$github/issues",
				},
			homepage => $github,
			},
		},
	'PREREQ_PM'    => {
		'Test::More'     => '0',
		'Hash::AsObject' => '0',
		'Test::Manifest' => 1.14,
		'LWP::Simple'    => '0',
		'URI'            => '0',
		},

	'PM'           => {
		'lib/WebTools.pm'               => '$(INST_LIBDIR)/WebTools.pm',
		'lib/AddressStandardization.pm' => '$(INST_LIBDIR)/WebTools/AddressStandardization.pm',
		'lib/ZipCodeLookup.pm'          => '$(INST_LIBDIR)/WebTools/ZipCodeLookup.pm',
		'lib/CityStateLookup.pm'        => '$(INST_LIBDIR)/WebTools/CityStateLookup.pm',
		},

	'MAN3PODS'     => {
		'lib/WebTools.pm'               => '$(INST_MAN3DIR)/Business::US::USPS::WebTools.3',
		'lib/AddressStandardization.pm' => '$(INST_LIBDIR)/Business::US::USPS::WebTools::AddressStandardization.3',
		'lib/ZipCodeLookup.pm'          => '$(INST_LIBDIR)/Business::US::USPS::WebTools::ZipCodeLookup.3',
		'lib/CityStateLookup.pm'        => '$(INST_LIBDIR)/Business::US::USPS::WebTools::CityStateLookup.3',
		},

	clean  => { FILES    => q|Business-*| },

	);

print <<"HERE" unless( $ENV{USPS_WEBTOOLS_USERID} and $ENV{USPS_WEBTOOLS_PASSWORD} );
----------------------------------------------------------------------------

To use these modules, you need a User ID and Password from the US Postal
Service. See the USPS website for details:

http://www.usps.com/webtools/htm/Address-Information.htm

Set the USPS_WEBTOOLS_USERID and USPS_WEBTOOLS_PASSWORD environment
variables.

----------------------------------------------------------------------------
HERE

sub arguments { \%WriteMakefile }

do_it() unless caller;
sub do_it {
	require File::Spec;
	my $MM ='ExtUtils::MakeMaker';
	my $MM_version =
		eval{ "$MM " . $WriteMakefile{'CONFIGURE_REQUIRES'}{'ExtUtils::MakeMaker'} }
			//
		"$MM 6.64";
	eval "use $MM_version";
	eval "use Test::Manifest 1.21" 
		if -e File::Spec->catfile( qw(t test_manifest) );
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
