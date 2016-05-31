module Rcurtain
  class Configuration

    attr_accessor :url, :default_response

    def initialize
      @default_response = false
    end
  end
end
