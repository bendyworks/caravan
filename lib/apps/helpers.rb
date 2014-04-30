require 'json'

# A mixin of helpful methods for Apps
module AppHelpers
  def respond_with data
    JSON.dump(data)
  end
end
