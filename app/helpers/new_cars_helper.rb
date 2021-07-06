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


  def new_card_page?
    if controller_name == 'new_cars' and action_name == 'show'
      true
    else
      false
    end
  end

end
