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

    def get_users_sample(feature)
      users = get_feature_sample(feature).users

      return users unless users.empty?

      users = get_feature(feature).users
      percentage = get_feature_sample_percentage(feature)
      ttl_in_days = get_feature_sample_ttl(feature)&.to_i

      sample_number = users.size * (percentage.to_f / 100)
      users_sample = users.sample(sample_number.to_i)

      persist_users_sample(feature, users_sample, ttl_in_days)

      users_sample
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    private

    def get_feature(name)
      percentage = redis.get("feature:#{name}:percentage") || 0

      users = redis.smembers("feature:#{name}:users") || []

      Feature.new(name, percentage, users)
    end

    def get_feature_sample(name)
      percentage = get_feature_sample_percentage(name)

      users = redis.smembers("feature:#{name}:users:session:sample") || []

      Feature.new(name, percentage, users)
    end

    def persist_users_sample(name, users, ttl = nil)
      options = { ex: ttl }.compact

      redis.set("feature:#{name}:users:session:sample", users, options)
    end

    def get_feature_sample_percentage(name)
      redis.get("feature:#{name}:users:session:percentage") || 0
    end

    def get_feature_sample_ttl(name)
      redis.get("feature:#{name}:users:session:ttl_in_days")
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
