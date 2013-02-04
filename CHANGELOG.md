# CHANGELOG

## 0.2.1 (2013-02-04)

* Adds wrapper for gauge, set, and count: `Strumbar::Client.(gauge|set|count) key, value, sample_rate = Strumbar.default_rate`.

## 0.2.0 (2013-02-04)

* Added Mongoid instrument to Strumbar, with controller runtime logging functionality (replaces AR-style db_time reporting if loaded).
