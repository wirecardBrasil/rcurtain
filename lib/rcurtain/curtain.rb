require 'singleton'

module Rcurtain
  # Responsible to check features for users or percentages
  class Curtain
    include Singleton

    def initialize
      @redis = Redis.new(url: Rcurtain.configuration.url)
      @random = Random.new
    end

    def opened?(feature_name, users = [])
      percentage_allowed?(feature_name) || users_allowed?(feature_name, users)
    end

    private

    def users_allowed?(feature_name, users = [])
      allowed_users = Rcurtain.feature.array(feature_name)
      valid_users?(users) && users.all? { |user| allowed_users.include?(user) }
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def percentage_allowed?(feature_name)
      allowed_percentage = Rcurtain.feature.number(feature_name)
      rand_percentage = @random.rand(1..100)
      rand_percentage <= allowed_percentage
    rescue Redis::CannotConnectError
      Rcurtain.configuration.default_response
    end

    def valid_users?(users)
      !users.nil? && !users.empty?
    end
  end
end
