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

## Instruments

Strumbar allows middleware-style instruments to be added via the configure block.  These instruments
need only respond to `#load` with an optional hash. Strumbar comes with a few instruments to be added.
Here's an example:

``` ruby
class Guitar
  def self.load options = {}
    Strumbar.subscribe 'query.*' do |client, event|
      client.increment "query.#{event.payload[:query]}", options[:rate]
    end
  end
end

Strumbar.configure do |config|
    # Can pass optional hash of data to controller for access when loading
    config.instruments.use Strumbar::Instrumentation::ActiveRecord, rate: 0.8
    config.instruments.use Strumbar::Instrumentation::ActionController, rate: 1.0

    # Unless passed, `rate` will be passed as the value of Strumbar.default_rate
    config.instruments.use Strumbar::Instrumentation::Redis

    # When passing an array of objects, each element of the array will use the
    # same optional information, and will use the default rate if not supplied

    # Guitar and SnareDrum will receive `{ rate: Strumbar.default_rate }`
    config.instruments.use [Guitar, SnareDrum]

    # SixStringBass and FourStringBass will receive the same hash
    config.instruments.use [SixStringBass, FourStringBass], rate: 0.75
end
```

## Authors

Written by [Andrew Nordman](https://github.com/cadwallion) and [Matthew Wilson](https://github.com/hypomodern)

