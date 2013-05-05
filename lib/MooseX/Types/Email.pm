package MooseX::Types::Email;
use MooseX::Types
    -declare => [qw/EmailAddress EmailMessage EmailAddresses EmailMessages/];

use MooseX::Types::Moose qw/Object ArrayRef Str/;
use Email::Valid;
use Email::Abstract;

our $VERSION = '0.005';

subtype EmailAddress,
  as Str,
  where { Email::Valid->address($_) },
  message { "Must be a valid e-mail address" };

subtype EmailMessage,
  as Object, where { Email::Abstract->new($_) },
  message { "Must be something Email::Abstract recognizes" };

coerce EmailMessage,
  from Object,
  via { Email::Abstract->new($_) };


subtype EmailAddresses,
  as ArrayRef[EmailAddress],
  message { 'Must be an arrayref of valid e-mail addresses' };

coerce EmailAddresses,
  from Str,
  via { [ $_ ] };

subtype EmailMessages,
  as ArrayRef[Object],
  where { not grep { not Email::Abstract->new($_) } @$_  },
  message { 'Must be an arrayref of something Email::Abstract recognizes' };

# no coercion from Object, as that would also catch existing Email::Abstract
# objects and its subtypes.

1;

=head1 NAME

MooseX::Types::Email - Email address validation type constraints for Moose.

=head1 SYNOPSIS

    package MyClass;
    use Moose;
    use MooseX::Types::Email qw/EmailAddress EmailMessage EmailAddresses EmailMessages/;
    use namespace::autoclean;

    has email => ( isa => EmailAddress, required => 1, is => 'ro' );
    has message => ( isa => EmailMessage, required => 1, is => 'ro' );

    has emails => ( isa => EmailAddresses, required => 1, is => 'ro' );
    has messages => ( isa => EmailMessages, required => 1, is => 'ro' );


=head1 DESCRIPTION

Moose type constraints which uses L<Email::Valid> and L<Email::Abstract> to check
for valid email addresses and messages.  Types that support both single items
and an arrayref of items are available.

Note that C<EmailMessage> must be an object that can be passed to
L<Email::Abstract>. Currently, constraining strings is not supported due to the
leniency of Email::Abstract.

=head1 SEE ALSO

=over

=item L<Moose::Util::TypeConstraints>

=item L<MooseX::Types>

=item L<Email::Valid>

=item L<Email::Abstract>

=back

=head1 AUTHORS

Tomas Doran (t0m) C<< <bobtfish@bobtfish.net> >>

Shamelessly extracted from L<Reaction::Types::Email>.

=head1 CONTRIBUTORS

Chris Nehren C<< <apeiron@cpan.org> >> added support for validing email
messages.

Karen Etheridge C<< <ether@cpan.org> >> added support for lists of email
addresses and messages.

=head1 COPYRIGHT

Copyright 2009 the above L<AUTHORS> and L<CONTRIBUTORS>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut

