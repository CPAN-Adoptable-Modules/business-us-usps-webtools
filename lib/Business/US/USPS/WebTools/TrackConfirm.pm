use v5.10;
use utf8;

package Business::US::USPS::WebTools::TrackConfirm;
use strict;
no warnings 'uninitialized';

use parent qw(Business::US::USPS::WebTools);

use subs qw();
use vars qw($VERSION);

use Carp qw(croak carp);

$VERSION = '1.122';

=encoding utf8

=head1 NAME

Business::US::USPS::WebTools::TrackConfirm - track a shipment using the USPS Web Tools

=head1 SYNOPSIS

	use Business::US::USPS::WebTools::TrackConfirm;

	my $tracker = Business::US::USPS::WebTools::TrackConfirm->new( {
		UserID   => $ENV{USPS_WEBTOOLS_USERID},
		Password => $ENV{USPS_WEBTOOLS_PASSWORD},
		Testing  => 1,
		} );

	my $hash = $tracker->track(
		);

	if( $tracker->is_error )
		{
		warn "Oh No! $tracker->{error}{description}\n";
		}
	else
		{
		print join "\n", map { "$_: $hash->{$_}" }
			qw(FirmName Address1 Address2 City State Zip5 Zip4);
		}


=head1 DESCRIPTION

*** THIS IS ALPHA SOFTWARE ***

This module implements the Track & Confirm web service from the
US Postal Service. It is a subclass of Business::US::USPS::WebTools.

=cut

=over 4

=cut

sub _fields   { qw( TrackID DestinationZipCode MailingDate ClientIp SourceId ) }
sub _required { qw( TrackID ) }

=item track( KEY, VALUE, ... )

The C<track> method takes the following keys, which come
directly from the USPS web service interface:

	TrackID	  The tracking number

It returns an anonymous hash with the data from the response. Although
the USPS API allows to make multiple queries in a single request, this
method one queries one.

If you want to see if something went wrong, check:

	$tracker->is_error;

See the C<is_error> documentation in Business::US::USPS::WebTools for more
details on error information.

=cut


sub track {
	my( $self, %hash ) = @_;

	say Dumper( \%hash ); use Data::Dumper;

	foreach my $field ( $self->_required ) {
		next if exists $hash{$field};
		carp "Missing field [$field] for track()";
		return;
		}

	my $tracking_number = $self->is_valid_tracking_number( $hash{'TrackID'} );

	unless( $tracking_number ) {
		carp "String [$hash{'TrackID'}] does not look like a valid USPS tracking number";
		return;
		}

	$self->_make_url( \%hash );

	$self->_make_request;

	$self->_parse_response;
	}

=item tracking_number_regex

Returns the regex that checks a tracking number. I have it in its own
method so you can easily override it if I got it wrong.

The USPS shows the valid forms at

	https://tools.usps.com/go/TrackConfirmAction!input.action

	USPS Tracking®	                      9400 1000 0000 0000 0000 00
	Priority Mail®	                      9205 5000 0000 0000 0000 00
	Certified Mail®	                      9407 3000 0000 0000 0000 00
	Collect on Delivery	                  9303 3000 0000 0000 0000 00
	Global Express Guaranteed®	          82 000 000 00
	Priority Mail Express International™  EC 000 000 000 US
	Priority Mail Express™	              9270 1000 0000 0000 0000 00
                                          EA 000 000 000 US
	Priority Mail International®          CP 000 000 000 US
	Registered Mail™                      9208 8000 0000 0000 0000 00
	Signature Confirmation™               9202 1000 0000 0000 0000 00

=cut

sub tracking_number_regex {
	state $regex = qr/
		\A
		9 [234] [0-9]{20} |
		82      [0-9]{8}  |
		[A-Z]{2}[0-9]{9}US
		\z /x;

	return $regex;
	}

=item is_valid_tracking_number( ID )

Returns a normalized version of the tracking number if ID looks like a
tracking number, based on the regex from C<tracking_number_regex>.
Returns false otherwise.

Normalizing ID merely removes all whitespace. Sometimes the USPS shows
the numbers with whitespace.

=cut

sub is_valid_tracking_number {
	my( $self, $tracking_number ) = @_;

	$tracking_number =~ s/\s+//g;
	return unless $tracking_number =~ $self->tracking_number_regex;

	$tracking_number;
	}

=item service_type( ID )

Returns the service type, based on the examples shown by the USPS and
shown in C<tracking_number_regex>. I know this is wrong because I have
tracking numbers that don't have the same leading characters for
Priority Mail International.

=cut

sub service_type {
	my( $self, $tracking_number );

	return unless $tracking_number =~ $self->tracking_number_regex;

	return do {
		local $_ = $tracking_number;
		   if( / \A 94   /x ) { 'USPS Tracking' }
		elsif( / \A 9205 /x ) { 'Priority Mail' }
		elsif( / \A 9407 /x ) { 'Certified Mail' }
		elsif( / \A 9303 /x ) { 'Collect on Delivery' }
		elsif( / \A 82   /x ) { 'Global Express Guaranteed' }
		elsif( / \A 9270 /x ) { 'Priority Mail Express' }
		elsif( / \A 9208 /x ) { 'Registered Mail' }
		elsif( / \A 9202 /x ) { 'Signature Confirmation' }

		elsif( / \A RA .* US \z /x ) { 'Registered Mail' }
		elsif( / \A EA .* US \z /x ) { 'Priority Mail Express' }
		elsif( / \A EC .* US \z /x ) { 'Priority Mail Express International' }
		elsif( / \A CP .* US \z /x ) { 'Priority Mail International' }

		else { 'Unknown' }
		};

	}

sub _api_name { "TrackV2" }

sub _make_query_xml {
	my( $self, $hash ) = @_;

	my $user = $self->userid;
	my $pass = $self->password;

	my $id     = $hash->{'TrackID'};
	my $ip     = $hash->{'ClientIp'} // '127.0.0.1';
	my $source = $hash->{'SourceId'} // __PACKAGE__;

	my $xml =
		qq|<TrackFieldRequest USERID="$user">| .
		qq|<Revision>1</Revision>|             .
		qq|<ClientIp><![CDATA[ $ip ]]></ClientIp>|     .
		qq|<SourceId><![CDATA[ $source ]]></SourceId>|      .
		qq|<TrackID ID="$id">|;

	foreach my $field ( $self->_fields ) {
		next if $field eq 'TrackID';
		next unless defined $hash->{$field};
		$xml .= "<$field>$$hash{$field}</$field>";
		}

	$xml .= qq|</TrackID></TrackFieldRequest>|;

say "XML is\n$xml\n";

	return $xml;
	}

sub _parse_response {
	my( $self ) = @_;

	my $response = $self->response;

	my( $summary ) = $response =~ m{<TrackSummary>(.*?)</TrackSummary>}s;
	my @details    = $response =~  m{<TrackDetail>(.*?)</TrackDetail>}s;

	my %hash = ();
	$hash{'TrackSummary'} = $summary;
	$hash{'TrackDetail'}  = [ map { $self->_parse_subbits( $_ ) } @details ];

	bless \%hash, ref $self; # 'Hash::AsObject';
	}

sub _parse_subbits {
	state $fields = [ qw(
		EventTime EventDate Event EventCity EventState EventZIPCode
		EventCountry FirmName Name AuthorizedAgent
		) ];

	my( $self, $subbit ) = @_;

	my %hash;
	foreach my $field ( @$fields ) {
		my( $value ) = $subbit =~ m|<$field>(.*?)</$field>|sg;
		$hash{$field} = $value || '';
		}

	return \%hash;
	}

=back

=head1 TO DO

=head1 SEE ALSO

L<Business::US::USPS::WebTools>

The WebTools API is documented on the US Postal Service's website:

	https://www.usps.com/business/web-tools-apis/track-and-confirm-api.htm

=head1 SOURCE AVAILABILITY

This source is in GitHub:

	https://github.com/CPAN-Adoptable-Modules/business-us-usps-webtools

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2006-2018, brian d foy <bdfoy@cpan.org>. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the Artistic License 2.0.

=cut

1;
