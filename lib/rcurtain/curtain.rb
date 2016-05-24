require "redis"

module Rcurtain
  class Curtain

    attr_reader :redis

    def initialize(url)
      @redis = Redis.new(:url => url)
    end

    def opened?(feature, mpa = [])

      return nil

    end
  end
end
