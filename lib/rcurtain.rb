require 'redis'
require 'rcurtain/feature'
require 'rcurtain/curtain'
require 'rcurtain/configuration'

module RCurtain
  class << self
    attr_writer :configuration, :feature

    def instance
      Curtain.instance
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      @configuration = Configuration.new
      yield(configuration)
    end

    def feature
      @feature ||= Feature.instance
    end
  end

  def self.feature
    @feature ||= Feature.instance
  end
end
