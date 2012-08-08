# Strumbar [![Build Status](https://secure.travis-ci.org/agoragames/strumbar.png)](http://travis-ci.org/agoragames/strumbar)

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


Configuration (all options shown with default values):

``` ruby
Strumbar.configure do |config|

  # Application name as it should be stored by your Statsd backend.
  config.application = 'statsd_appname'

  # Statsd hostname
  config.host = 'statsd.appname.example'

  # Statsd port
  config.port = 8125

  # Default sample rate for all events.
  config.default_rate = 1

  # Toggles the built-in ActionController instrumentation.
  config.action_controller = false

  # Sample rate for recording ActionController events.
  config.action_controller_rate = 1

  # Toggles the built-in ActiveRecord instrumentation.
  config.active_record = false

  # Sample rate for recording ActiveRecord events.
  config.active_record_rate = 1

  # Toggles the built-in Redis instrumentation.
  config.redis = false

  # Sample rate for recording Redis events.
  config.redis_rate = 1
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

In case you get tired of typing `ActiveSupport::Notifications.instrument` you can use the helpful sugar `Strumbar` provides:

```ruby
Strumbar.strum 'view.render', payload do
  render :text => "I'm monitored!"
end
```


## Default Instruments

Strumbar takes the approach of auto-detecting the libraries being used and
loading default instrumentation subscriptions that you have explicitely enabled
in your Strumbar configuration block.

** This behavior has changed from previous versions inwhich all detected libraries were
automatically used by default.**

## Authors

Written by [Andrew Nordman](https://github.com/cadwallion) and [Matthew Wilson](https://github.com/hypomodern)

