require "redis"

require "rcurtain/feature"
require "rcurtain/curtain"

module Rcurtain

  class << self

    def new(url)
      Curtain.new(url)
    end

  end
end
