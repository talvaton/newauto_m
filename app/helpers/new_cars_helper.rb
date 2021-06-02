module NewCarsHelper
  require 'net/http'

  # REFACTOR!!!
  def self.working_url?(url_str)
    uri = URI.parse(url_str)
    Net::HTTP.get_response(uri).code == '200'
  end

  def working_url?(url_str)
    uri = URI.parse(url_str)
    Net::HTTP.get_response(uri).code == '200'
  end
end
