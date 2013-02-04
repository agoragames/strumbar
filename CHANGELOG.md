# CHANGELOG

## 0.3.0 (2013-02-04)

* Adds wrapper for gauge, set, and count: `Strumbar::Client.(gauge|set|count) key, value, sample_rate = Strumbar.default_rate`.
* Fixes bug with `Strumbar::Client.decrement` adding extraneous '#' to application prefix

## 0.2.0 (2013-02-04)

* Added Mongoid instrument to Strumbar, with controller runtime logging functionality (replaces AR-style db_time reporting if loaded).
