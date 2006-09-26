# $Id$
package Business::US::USPS::WebTools::ZipCodeLookup;
use strict;

use base qw(Business::US::USPS::WebTools);

use subs qw();
use vars qw($VERSION);

$VERSION = '0.10_01';

=head1 NAME

Business::USPS::WebTools::ZipCodeLookup - canonicalize a US address

=head1 SYNOPSIS

	use Business::USPS::WebTools::ZipCodeLookup;

	my $looker_upper = Business::USPS::WebTools::ZipCodeLookup->new( {
		UserID   => $ENV{USPS_WEBTOOLS_USERID},
		Password => $ENV{USPS_WEBTOOLS_PASSWORD},
		Testing  => 1,
		} );
		
	my $hash = $looker_upper->lookup_zipcode(
		);

	if( $looker_upper->is_error )
		{
		warn "Oh No! $looker_upper->{error}{description}\n";
		}
	else
		{
		print join "\n", map { "$_: $hash->{$_}" } 
			qw(FirmName Address1 Address2 City State Zip5 Zip4);
		}
		
		
=head1 DESCRIPTION

*** THIS IS ALPHA SOFTWARE ***

This module implements the Zip Code Lookup web service from the
US Postal Service. It is a subclass of Business::USPS::WebTools.

=cut

=over 4

=cut

sub _fields   { qw( FirmName Address1 Address2 City State) }
sub _required { qw( Address2 City State ) }

=item lookup_zipcode( KEY, VALUE, ... )

The C<lookup_zipcode> method takes the following keys, which come
directly from the USPS web service interface:

	Address2	The street address
	City		The name of the city
	State		The two letter state abbreviation
	Zip5		The 5 digit zip code
	Zip4		The 4 digit extension to the zip code
	
It returns an anonymous hash with the same keys, but the values are
the USPS's canonicalized address. If there is an error, the hash
values will be the empty string, and the error flag is set. Check is
with C<is_error>:

	$verifier->is_error;
	
See the C<is_error> documentation in Business::USPS::WebTools for more
details on error information.
	
=cut

sub lookup_zipcode
	{
	my( $self, %hash ) = @_;
	
	$self->_make_url( \%hash );
	
	$self->_make_request;
	
	$self->_parse_response;
	}

	
sub _api_name { "ZipCodeLookup" }

sub _make_query_string
	{
	my( $self, $hash ) = @_;
	
	my $user = $self->userid;
	my $pass = $self->password;
	
	my $xml = 
		qq|API=| . $self->_api_name .
		qq|&XML=<ZipCodeLookupRequest%20USERID="$user"%20PASSWORD="$pass">|  .
		qq|<Address ID="0">|;

	foreach my $field ( $self->_fields )
		{
		$xml .= "<$field>$$hash{$field}</$field>";
		}

	$xml .= qq|</Address></ZipCodeLookupRequest>|;

	$self->{query_string} = $xml;
	}

sub _parse_response
	{
	my( $self ) = @_;
	#require 'Hash::AsObject';
	
	my %hash = ();
	foreach my $field ( $self->_fields, qw( Zip5 Zip4 ) )
		{
		my( $value ) = $self->response =~ m|<$field>(.*?)</$field>|g;
		
		$hash{$field} = $value || '';
		}
	
	bless \%hash, ref $self; # 'Hash::AsObject';
	}

=back

=head1 TO DO

=head1 SEE ALSO

L<Business::USPS::WebTools>

The WebTools API is documented on the US Postal Service's website:

http://www.usps.com/webtools/htm/Address-Information.htm

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut

1;
