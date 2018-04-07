require 'redis'

require 'rcurtain/feature'
require 'rcurtain/curtain'
require 'rcurtain/configuration'

# Easy way to control your features using redis
module Rcurtain
  class << self
    attr_writer :configuration, :feature

    def instance
      Curtain.instance
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    @configuration = Configuration.new
    yield(configuration)
  end

  def self.feature
    @feature ||= Feature.instance
  end
end
