require 'json'

# A mixin of helpful methods for Apps
module AppHelpers
  class UnsupportedVersion < Exception ; end

  def respond_with data
    JSON.dump(data)
  end

  def get_preferred_version(*args)
    version = request.accept.first.params.fetch('v', args.first)
    raise UnsupportedVersion,
      "Version #{version} is not a supported version" unless args.include? version
    version
  end
end
