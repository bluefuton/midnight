# Midnight

A library to parse natural language date/time into a cron expression.

[![Build Status](https://travis-ci.org/bluefuton/midnight.svg?branch=master)](https://travis-ci.org/bluefuton/midnight)

## Installation

Add this line to your application's Gemfile:

    gem 'midnight', ">= 1.0.0"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install midnight

## Usage

<pre>Midnight.parse('every 5 minutes').to_s
 => "*/5 * * * *"</pre>

### Supported phrases

A full list of supported natural language phrases can be found in <a href="https://github.com/bluefuton/midnight/blob/master/test/test_parsing.rb">test_parsing.rb</a>.

In the future there'll be support for more complex repetitions - a wishlist can be found in <a href="https://github.com/bluefuton/midnight/blob/master/todo.txt">todo.txt</a>.

## Credits

My tokeniser code is based on the excellent <a href="https://github.com/yb66/tickle">Tickle</a> gem, which in turn relies on <a href="https://github.com/mojombo/chronic">Chronic</a> for date parsing.

Author: Chris Rosser <chris@bluefuton.com>

## Contributing

1. Fork it ( http://github.com/bluefuton/midnight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new pull request
