require "singleton"

module Rcurtain
  class Curtain
    include Singleton

    attr_reader :redis

    def initialize
      @redis = Redis.new(:url => Rcurtain.configuration.url)
    end

    def opened? (feature, users = [])
      feature_percentage = compare_percentage?(percentage(feature))
      return feature_percentage || users_enabled?(feature, users) unless users.empty?
      feature_percentage
    rescue Redis::CannotConnectError
      return Rcurtain.configuration.default_response
    end

    def get_users(feature)
      get_feature(feature).users
    rescue Redis::CannotConnectError
        Rcurtain.configuration.default_response
    end

    private
      def get_feature (name)
        percentage = redis.get("feature:#{name}:percentage") || 0

        users = redis.smembers("feature:#{name}:users") || []

        return Feature.new(name, percentage, users)
      end

      def users_enabled?(feature_name, users = [])
        users.all? { |user| redis.sismember(feature_name, user) }
      end

      def percentage(feature_name)
        redis.get("feature:#{name}:percentage") || 0
      end

      def compare_percentage? (percentage)
        rnd = Random.new
        rnd.rand(1..100) <= percentage.to_f
      end

  end
end
