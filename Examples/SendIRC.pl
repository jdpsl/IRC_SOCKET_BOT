#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::UNIX;

my $unix_socket_path = '/tmp/irc_bot_socket';
my $message = "PRIVMSG #example_channel :Hello from external script!\n";

sub main {
    my $client_socket = IO::Socket::UNIX->new(
        Type => SOCK_STREAM,
        Peer => $unix_socket_path,
    ) or die "Error creating socket: $!";

    eval {
        $client_socket->send($message);
        print "Sent message to IRC bot: $message";
    };
    if ($@) {
        print "Error sending message: $@";
    }
    $client_socket->close();
}

main();
