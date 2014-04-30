require 'json'

module AppHelpers
  def respond_with data
    JSON.dump(data)
  end
end
