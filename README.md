# Strumbar

Strumbar is a wrapper around ActiveSupport::Notifications with preconfigurations
for basic instrumentation to be sent to statsd.

## Installation

Add this line to your application's Gemfile:

    gem 'strumbar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strumbar

## Usage


Configuration:

``` ruby
Strumbar.configure do |config|
  config.port = 80
  config.host = 'instrument.majorleaguegaming.com'
  config.application = 'instrument'
end
```

Adding this alone causes basic instrumentation data to be sent to the Statsd
server broken down by your application and will be visible in the dashboard.
If you are happy with that, you're done.  Adding custom instrumentation that is
specific to your application is incredibly simple.  Strumbar is a wrapper around
ActiveSupport::Notifications.

``` ruby
Strumbar.subscribe /something_cool/ do |client, event|
  client.increment 'something_cool_counter'
end
```

Client is an instance of `Strumbar::Client` and wraps around Statsd::Client for
namespacing and syntactic sugar.

By default, it will subscribe to runtime data for `process_action.action_controller`
and the sql load time in `sql.active_record`.
