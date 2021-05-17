# This file is generated by Dist::Zilla::Plugin::CPANFile v6.017
# Do not edit this file directly. To change prereqs, edit the `dist.ini` file.

requires "Carp" => "0";
requires "Date::Parse" => "0";
requires "Digest::SHA" => "0";
requires "Email::Stuffer" => "0";
requires "Getopt::Long::Descriptive" => "0";
requires "IO::Async::Loop" => "0";
requires "JSON::MaybeXS" => "0";
requires "Log::Dispatchouli" => "2.002";
requires "Log::Dispatchouli::Global" => "0";
requires "Module::Runtime" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "Net::Async::HTTP" => "0";
requires "Net::Async::HTTP::Server::PSGI" => "0";
requires "Path::Tiny" => "0";
requires "Plack::App::URLMap" => "0";
requires "Plack::Request" => "0";
requires "Plack::Response" => "0";
requires "Prometheus::Tiny" => "0";
requires "TOML" => "0";
requires "Template::Tiny" => "0";
requires "Type::Params" => "0";
requires "Type::Utils" => "0";
requires "Types::Standard" => "0";
requires "experimental" => "0";
requires "parent" => "0";
requires "perl" => "5.028";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Future" => "0";
  requires "HTTP::Request::Common" => "0";
  requires "HTTP::Response" => "0";
  requires "Plack::Test" => "0";
  requires "Test::Deep" => "0";
  requires "Test::Lib" => "0";
  requires "Test::More" => "0";
  requires "Test::Time" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};
