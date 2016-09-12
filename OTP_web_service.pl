#!/usr/bin/perl
#Author: Rafal Szypulka (rafal.szypulka@pl.ibm.com)
 
use Mojolicious::Lite;

my $DEBUG = 1;
my $seen='';

get '/test' => sub {
	my $self = shift;
	my $device  = $self->param('device');
	
	#use $phone variable if you want to filter by sender phone number
	my $phone  = $self->param('phone');
	my $text  = $self->param('text') if $DEBUG;
	if($text)	{
		$self->render(text => "OTP stored.");
		say scalar(localtime).": OTP was received. OTP content: $text" if $DEBUG;
		$seen = "$text";
	} elsif($seen && !$text) {
    	$self->render(text => "$seen");
		say scalar(localtime).": OTP queried by IBM APM. OTP content: $seen" if $DEBUG;
		say scalar(localtime).": OTP removed from memory" if $DEBUG;
		undef $seen;
	} else {
   		$self->render(text => "No OTP or OTP already used");
		say scalar(localtime).": IBM APM request received, but OTP was already queried." if $DEBUG;
	}
};

app->start;