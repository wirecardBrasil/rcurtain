require "redis"

require "rcurtain/feature"
require "rcurtain/curtain"
require "rcurtain/configuration"

module Rcurtain

  class << self
    attr_writer :configuration

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
end
