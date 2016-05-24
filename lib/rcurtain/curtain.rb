require "redis"
require "rcurtain/feature"

module Rcurtain
  class Curtain

    attr_reader :redis

    def initialize (url)
      @redis = Redis.new(:url => url)
    end

    def opened? (feature, users= nil)
      feat = get_feature(feature)

      if users
        (compare_percentage?(feat.percentage)) || (feat.users.any? { |user| users.include?(user)})
      else
        compare_percentage?(feat.percentage)
      end
    end

    def get_feature (name)
      percentage = redis.get("feature:#{name}:percentage")
      percentage = 0 if percentage.nil?

      users = redis.smembers("feature:#{name}:users")
      users = [''] if users.nil?

      feature = Feature.new(name, percentage, users)

      feature
    end

    def compare_percentage? (percentage)
      rnd = Random.new
      rnd.rand(1..100) <= percentage
    end

  end
end
