# Tilt::React

Use react components as view templates in Sinatra and other frameworks using Tilt.

This new imroved version uses webpack; which means both server and client side render is supported! There are helper functions which will allow single-page-like AJAX re-rendering of the page with History API integration.

Bonus feature: RSpec::React, a helpful framework for writing unit tests for the server generated HTML your components produce.

This is proof-of-concept code, there are some limitations:

* There's some hacky code around the place (search for FIXME)
* There aren't any tests for the actual library…

There's an example of using this library with Sinatra in the `examples` directory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tilt-react'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tilt-react

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/jphastings/tilt-react/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
