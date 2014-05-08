require 'json'

# A mixin of helpful methods for Apps
module AppHelpers
  def respond_with data
    JSON.dump(data)
  end

  def get_preferred_version(*args)
    args.last
  end
end
