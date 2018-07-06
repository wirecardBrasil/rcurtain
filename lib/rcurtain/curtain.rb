require 'singleton'

module RCurtain
  # Checks features for users or percentages
  class Curtain
    include Singleton

    def initialize
      @random = Random.new
    end

    def open?(feature_name, users = [])
      percentage_allowed?(feature_name) ||
        users_allowed?(feature_name, users)
    end

    private

    def users_allowed?(feature_name, users)
      valid_users?(users) && users.all? do |user|
        RCurtain.feature.user_enabled?(feature_name, user)
      end
    end

    def percentage_allowed?(feature_name, users = [])
      allowed_percentage = allowed_percentage(feature_name).to_i
      rand_percentage = @random.rand(0..100)
      rand_percentage <= allowed_percentage
    end

    def allowed_percentage(feature_name)
      allowed_percentage = RCurtain.feature.percentage(feature_name)
      default_percentage = RCurtain.configuration.default_percentage
      allowed_percentage.nil? ? default_percentage : allowed_percentage
    end

    def valid_users?(users)
      !users.nil? && !users.empty?
    end
  end
end
