require 'singleton'

module RCurtain
  # Controls features
  class Feature
    include Singleton

    def initialize
      @redis = Redis.new(url: RCurtain.configuration.url)
    end

    def add(feature_name, users)
      feature_name = format_name(feature_name, 'users')
      users.each do |user|
        @redis.sadd(feature_name, user)
      end
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def remove(feature_name, users)
      feature_name = format_name(feature_name, 'users')
      users.each do |user|
        @redis.srem(feature_name, user)
      end
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def update(feature_name, percentage)
      feature_name = format_name(feature_name, 'percentage')
      @redis.set(feature_name, percentage)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def describe(feature_name, description)
      feature_name = format_name(feature_name, 'description')
      @redis.set(feature_name, description)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def list(feature_name)
      feature_name = format_name(feature_name, 'users')
      @redis.smembers(feature_name)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def user?(feature_name, user)
      feature_name = format_name(feature_name, 'users')
      @redis.sismember(feature_name, user)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def number(feature_name)
      feature_name = format_name(feature_name, 'percentage')
      @redis.get(feature_name)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_percentage
    end

    def description(feature_name)
      feature_name = format_name(feature_name, 'description')
      @redis.get(feature_name)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_description
    end

    def format_name(name, scope)
      feature_name_format = RCurtain.configuration.feature_name_format
      feature_name_format.sub('%name%', name) + scope
    end
  end
end
