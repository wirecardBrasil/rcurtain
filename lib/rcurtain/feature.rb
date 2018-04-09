require 'singleton'

module Rcurtain
  # Controls specific features
  class Feature
    include Singleton

    def initialize
      @redis = Redis.new(url: Rcurtain.configuration.url)
    end

    def add(feature_name, users)
      feature_name = feature_name_formatted(feature_name)
      users.each do |user|
        @redis.sadd(feature_name, user)
      end
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def remove(feature_name, users)
      feature_name = feature_name_formatted(feature_name)
      users.each do |user|
        @redis.srem(feature_name, user)
      end
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def update(feature_name, percentage)
      @redis.set(feature_name_formatted(feature_name, 'percentage'), percentage)
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def array(feature_name)
      @redis.smembers(feature_name_formatted(feature_name)) || []
    end

    def number(feature_name)
      @redis.get(feature_name_formatted(feature_name, 'percentage')).to_i || 0
    end

    private

    def feature_name_formatted(feature_name, scope = 'users')
      feature_name_format = Rcurtain.configuration.feature_name_format
      feature_name_format.sub('%name%', feature_name) + scope
    end
  end
end
