require "singleton"

module Rcurtain
  class Curtain
    include Singleton

    attr_reader :redis

    def initialize
      @redis = Redis.new(:url => Rcurtain.configuration.url)
    end

    def opened? (feature, users = [])
      feat = get_feature(feature)

      return (compare_percentage?(feat.percentage)) || (users.any? { |user| feat.users.include?(user)}) unless users.empty?

      compare_percentage?(feat.percentage)
    rescue Redis::CannotConnectError
      return Rcurtain.configuration.default_response
    end

    def get_users(feature)
      feat = get_feature(feature)
      return feat.users  
    rescue Redis::CannotConnectError
      return Rcurtain.configuration.default_response    
    end

    private
      def get_feature (name)
        percentage = redis.get("feature:#{name}:percentage")
        percentage ||= 0

        users = redis.smembers("feature:#{name}:users")
        users ||= []

        return Feature.new(name, percentage, users)
      end

      def compare_percentage? (percentage)
        rnd = Random.new
        rnd.rand(1..100) <= percentage.to_f
      end

  end
end
