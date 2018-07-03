module RCurtain
  # Configuration for the curtain
  class Configuration
    attr_accessor :url, :default_response, :default_percentage,
                  :default_description, :feature_name_format

    def initialize
      @default_response = false
      @default_percentage = 0
      @default_description = ''
      @feature_name_format = 'feature:%name%:'
    end
  end
end
