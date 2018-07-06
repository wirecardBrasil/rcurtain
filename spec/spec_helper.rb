$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  SimpleCov.minimum_coverage 95
end

require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'rcurtain'

RSpec.configure(&:raise_errors_for_deprecations!)

require 'fakeredis'

def fail_redis(symbol)
  allow_any_instance_of(Redis).to receive(symbol) do
    raise Redis::CannotConnectError, 'Fail for tests'
  end
end
