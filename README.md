# ForceSslMiddleware

Copied from Rails [ActionDispatch::SSL](https://github.com/rails/rails/blob/2468b161a6ada171cceeddaf418b540eb98f2d55/actionpack/lib/action_dispatch/middleware/ssl.rb),
add support for excluded_paths.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'force_ssl_middleware'
```

## Usage

Insert into your middleware from `config/environments/production.rb`:

```ruby
  config.middleware.insert 0, ForceSslMiddleware, excluded_paths: ['/options']
```

Same options as `ActionDispatch::SSL`, with the addition of `excluded_paths`.

`excluded_paths`: An array of:
 * `String` - for matching the start of the path
 * `Regexp` - to match against the path

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/avvo/force_ssl_middleware.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

