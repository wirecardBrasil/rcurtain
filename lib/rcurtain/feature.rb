module Rcurtain
  class Feature

    attr_accessor :name, :percentage, :users

    def initialize (name, percentage, users)
      @name = name
      @percentage = percentage
      @users = users
    end

  end
end
