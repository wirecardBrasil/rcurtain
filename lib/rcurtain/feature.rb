require 'singleton'

module RCurtain
  # Controls features
  class Feature
    include Singleton

    def initialize
      @redis = Redis.new(url: RCurtain.configuration.url)
    end

    def add_users(feature_name, users)
      feature_name = format_name(feature_name, 'users')
      users.each do |user|
        @redis.sadd(feature_name, user)
      end
    end

    def remove_users(feature_name, users)
      feature_name = format_name(feature_name, 'users')
      users.each do |user|
        @redis.srem(feature_name, user)
      end
    end

    def set_percentage(feature_name, percentage)
      feature_name = format_name(feature_name, 'percentage')
      @redis.set(feature_name, percentage)
    end

    def describe(feature_name, description)
      feature_name = format_name(feature_name, 'description')
      @redis.set(feature_name, description)
    end

    def list_users(feature_name)
      feature_name = format_name(feature_name, 'users')
      @redis.smembers(feature_name)
    end

    def user_enabled?(feature_name, user)
      feature_name = format_name(feature_name, 'users')
      @redis.sismember(feature_name, user)
    end

    def percentage(feature_name)
      feature_name = format_name(feature_name, 'percentage')
      @redis.get(feature_name).to_i
    end

    def description(feature_name)
      feature_name = format_name(feature_name, 'description')
      @redis.get(feature_name)
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_description
    end

    private

    def format_name(name, scope)
      feature_name_format = RCurtain.configuration.feature_name_format
      feature_name_format.sub('%name%', name) + scope
    end
  end
end
