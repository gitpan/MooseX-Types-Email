package MooseX::Types::Email;
BEGIN {
  $MooseX::Types::Email::AUTHORITY = 'cpan:BOBTFISH';
}
{
  $MooseX::Types::Email::VERSION = '0.006';
}
# git description: 2a8e05c

# ABSTRACT: Email address validation type constraints for Moose.

use MooseX::Types
    -declare => [qw/EmailAddress EmailMessage EmailAddresses EmailMessages/];

use MooseX::Types::Moose qw/Object ArrayRef Str/;
use Email::Valid;
use Email::Abstract;

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

__END__

=pod

=encoding UTF-8

=head1 NAME

MooseX::Types::Email - Email address validation type constraints for Moose.

=head1 VERSION

version 0.006

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

=head1 ORIGIN

Shamelessly extracted from L<Reaction::Types::Email>.

=head1 ACKNOWLEDGEMENTS

Chris Nehren C<< <apeiron@cpan.org> >> added support for validating email
messages.

Karen Etheridge C<< <ether@cpan.org> >> added support for lists of email
addresses and messages.

=head1 AUTHOR

Tomas Doran (t0m) <bobtfish@bobtfish.net

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Tomas Doran (t0m).

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
