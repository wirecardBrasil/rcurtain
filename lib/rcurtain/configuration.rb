module Rcurtain
  # Configures Redis connection
  class Configuration
    attr_accessor :url, :default_response, :feature_name_format

    def initialize
      @default_response = false
      @feature_name_format = 'feature:%name%:'
    end
  end
end
