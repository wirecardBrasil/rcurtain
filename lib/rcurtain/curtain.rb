# frozen_string_literal: true

require 'singleton'

module Rcurtain
  class Curtain
    include Singleton

    attr_reader :redis

    def initialize
      @redis = Redis.new(url: Rcurtain.configuration.url)
    end

    def opened?(feature, users = [])
      compare_percentage?(percentage(feature)) || users_enabled?(feature, users)
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def get_users(feature)
      get_feature(feature).users
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end
    end

    private

    def get_feature(name)
      percentage = redis.get("feature:#{name}:percentage") || 0

      users = redis.smembers("feature:#{name}:users") || []

      Feature.new(name, percentage, users)
    end


      Feature.new(name, percentage, users)
    end

    def invalid_users?(users)
      users.nil? || users.empty?
    end

    def percentage(feature_name)
      redis.get("feature:#{feature_name}:percentage") || 0
    end

    def compare_percentage?(percentage)
      rnd = Random.new
      rnd.rand(1..100) <= percentage.to_f
    end

    def sample_ttl(days = nil)
      one_day_in_seconds * (days || 1)
    end

    def one_day_in_seconds
      24 * 60 * 60
    end
  end
end
