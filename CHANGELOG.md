# CHANGELOG

## 0.4.0 (2013-02-09)

#### /!\ Breaks Backwards Compatibility /!\

* instrumentation is no longer loaded by default.
* `Strumbar::Configuration#instrumentation &block` is now gone: use the new `config.instruments.use MyInstrument` syntax instead.
* default values for options are now stored on the configuration object instead of the `Strumbar` module.

## 0.3.0 (2013-02-04)

* Adds wrapper for gauge, set, and count: `Strumbar::Client.(gauge|set|count) key, value, sample_rate = Strumbar.default_rate`.
* Fixes bug with `Strumbar::Client.decrement` adding extraneous '#' to application prefix

## 0.2.0 (2013-02-04)

* Added Mongoid instrument to Strumbar, with controller runtime logging functionality (replaces AR-style db_time reporting if loaded).
