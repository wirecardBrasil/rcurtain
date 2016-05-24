require "redis"

module Rcurtain
  class Curtain

    attr_reader :redis

    def initialize(url)
      @redis = Redis.new(:url => url)
    end

    def opened?(feature, users = [])
      return nil
    end

    def get_feature (name)
      percentage = @redis.get("feature:#{name}:percentage")
      percentage = 0 if percentage.nil?
  ​
      users = @redis.smembers("feature:#{name}:users")
  ​
      feature = Feature.new(name, percentage, users)
  ​
      feature
    end

  end
end
