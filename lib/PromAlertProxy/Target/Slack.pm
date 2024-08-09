package PromAlertProxy::Target::Slack;

use 5.028;
use Moo;
use experimental qw(signatures);

with 'PromAlertProxy::Target';

use Types::Standard qw(Object Str HashRef Int);
use Type::Utils qw(class_type);
use Type::Params qw(compile);

use Defined::KV;
use Slack::Notify;

use Module::Runtime qw(require_module);

use PromAlertProxy::Logger '$Logger';

has hook_url => (
  is       => 'ro',
  isa      => Str, # XXX URL
  required => 1,
);

# overrides the hookurl username
has username => (
  is       => 'ro',
  isa      => Str,
);

# overrides the hookurl channel
has channel => (
  is       => 'ro',
  isa      => Str,
);

# overrides the hookurl icon
has icon_url => (
  is       => 'ro',
  isa      => Str,
);

# overrides the hookurl icon
has icon_emoji => (
  is       => 'ro',
  isa      => Str,
);

has suppress_interval => (
  is      => 'ro',
  isa     => Int,
  default => 60*60,
);

has _seen => (
  is => 'ro',
  isa => HashRef,
  default => sub { {} },
);

sub raise ($self, $alert) {
  state $check = compile(Object, class_type('PromAlertProxy::Alert'));
  $check->(@_);

  # once an alert stops firing, we will remember its key forever. I'm not doing
  # anything about that, because it should be a negligible amount of memory. in
  # the future though, maybe we could have a timer on it -- robn, 2022-02-02 
  # -- adavis copying this comment, 2024-08-9

  my $now_ts = time;

  my $seen = $self->_seen->{$alert->key};

  my $should_fire =                                      # send message if:
    !$seen ||                                            # - never saw it before
    $seen->{ts} + $self->suppress_interval <= $now_ts || # - last saw it a long time ago
    $seen->{active} ^ $alert->is_active;                 # - state changed since we last saw it

  unless ($should_fire) {
    $Logger->log(["alert seen too recently (%d seconds ago), dropping it", $now_ts - $seen->{ts}]);
    return;
  }

  $self->_seen->{$alert->key} = { ts => $now_ts, active => $alert->is_active };

  my $slack = Slack::Notify->new(
    hook_url => $self->hook_url
  );

  my $prefix = 
  $alert->is_active ? "\N{POLICE CARS REVOLVING LIGHT} ALERT"
                    : "\N{WHITE HEAVY CHECK MARK} RESOLVED";

  my $msg = $prefix.': '.$alert->name.': '.$alert->summary . "\n";
  # omit the description on resolve
  $msg = $msg . $alert->annotations->{description} if $alert->is_active;


  $slack->post(
    text => $msg,
    defined_kv(username   => $self->username),
    defined_kv(icon_url   => $self->icon_url),
    defined_kv(icon_emoji => $self->icon_emoji),
    defined_kv(channel    => $self->channel),
  );


  return;
}

1;