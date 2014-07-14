# Midnight

A library to parse natural language date/time into a cron expression.

## Installation

Add this line to your application's Gemfile:

    gem 'midnight'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install midnight

## Usage

<pre>Midnight.parse('every 5 minutes').to_s
 => "*/5 * * * *"</pre>

## Contributing

1. Fork it ( http://github.com/bluefuton/midnight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
