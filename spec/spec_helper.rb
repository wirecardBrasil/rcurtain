$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'rcurtain'

RSpec.configure(&:raise_errors_for_deprecations!)
