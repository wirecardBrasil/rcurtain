# RCurtain

Easy way to control your features using [redis](http://redis.io/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rcurtain'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rcurtain

## Usage

* Rcurtain uses redis to control features, which can be checked by a **percentage** or a **set of users**.
```
feature:[name-of-feature]:percentage
```
```
feature:[name-of-feature]:users
```

* To use Rcurtain, first your need to initialize the configuration defining your **redis URL** (password@ip:port/database). Optionally, you can also configure the **default response** when the feature is not found, which by default is false.
```ruby
Rcurtain.configure do |config|
  config.url = 'redis://:p4ssw0rd@10.0.1.1:6380/15'
  # config.default_response = true
end
```

* Consult if the curtain is opened for a feature using the method "opened?", passing the name of the feature you want to check.
```ruby
Rcurtain.opened? 'feature'
```

* You can also pass a set of users to be checked.
```ruby
Rcurtain.opened?('feature', ['user-1','user-2'])
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moip/rcurtain. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it ( https://github.com/moip/rcurtain/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
