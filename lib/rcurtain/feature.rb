require 'singleton'

module Rcurtain
  # Controls specific features
  class Feature
    include Singleton

    def initialize
      @redis = Redis.new(url: Rcurtain.configuration.url)
    end

    def add(feature_name, users)
      feature_name = format_name(feature_name)
      users.each do |user|
        @redis.sadd(feature_name, user)
      end
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def remove(feature_name, users)
      feature_name = format_name(feature_name)
      users.each do |user|
        @redis.srem(feature_name, user)
      end
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def delete_users(feature_name)
      @redis.del(format_name(feature_name))
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def update(feature_name, percentage)
      @redis.set(format_name(feature_name, 'percentage'), percentage)
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def describe(feature_name, description)
      @redis.set(format_name(feature_name, 'description'), description)
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def user?(feature_name, user)
      @redis.sismember(format_name(feature_name), user)
    end

    def number(feature_name)
      @redis.get(format_name(feature_name, 'percentage')).to_i || 0
    end

    def description(feature_name)
      @redis.get(format_name(feature_name, 'description')) || ''
    end

    private

    def format_name(feature_name, scope = 'users')
      feature_name_format = Rcurtain.configuration.feature_name_format
      feature_name_format.sub('%name%', feature_name) + scope
    end
  end
end
