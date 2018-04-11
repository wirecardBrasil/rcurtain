require "singleton"

module Rcurtain
  class Curtain
    include Singleton

    attr_reader :redis

    def initialize
      @redis = Redis.new(:url => Rcurtain.configuration.url)
    end

    def opened?(feature, users = [])
      compare_percentage?(percentage(feature)) || users_enabled?(feature, users)
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
        return false if invalid_users?(users)
        users.all? { |user| redis.sismember("feature:#{feature_name}:users", user) }
      end

      def invalid_users?(users)
        users.nil? || users.empty?
      end

      def percentage(feature_name)
        redis.get("feature:#{feature_name}:percentage") || 0
      end

      def compare_percentage? (percentage)
        rnd = Random.new
        rnd.rand(1..100) <= percentage.to_f
      end
  end
end
