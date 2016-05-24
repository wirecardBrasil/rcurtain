class Feature

  attr_accessor :name, :percentage, :users

  def initalize (name:, percentage:, users:)
    @name = name
    @percentage = percentage
    @users = users
  end

end
