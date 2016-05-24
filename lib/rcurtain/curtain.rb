require "redis"

module Rcurtain
  class Curtain

    attr_reader :redis

    def initialize(url)
      @redis = Redis.new(:url => url)
    end

    def opened?(feature, user: nil?)
      feat = get_feature(feature)

      (compare_percentage(feat.percentage) || feat.users.include? user)
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

    def compare_percentage? (percentage)
      random = Random.new
      random.rand(1..100)

      (random <= percentage)
    end

  end
end
