require 'singleton'

module RCurtain
  # Checks features for users or percentages
  class Curtain
    include Singleton

    def initialize
      @random = Random.new
    end

    def open?(feature_name, users = [])
      percentage_allowed?(feature_name, users) ||
        users_allowed?(feature_name, users)
    end

    def users_allowed?(feature_name, users)
      valid_users?(users) && users.all? do |user|
        RCurtain.feature.user?(feature_name, user)
      end
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    def percentage_allowed?(feature_name, users = [])
      allowed_percentage = RCurtain.feature.number(feature_name)
      rand_percentage = @random.rand(0..100)
      allowed = rand_percentage <= allowed_percentage.to_i
      save_users = RCurtain.configuration.save_users
      RCurtain.feature.add(feature_name, users) if allowed && save_users
      allowed
    rescue Redis::CannotConnectError
      RCurtain.configuration.default_response
    end

    private

    def valid_users?(users)
      !users.nil? && !users.empty?
    end
  end
end
