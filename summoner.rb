require 'net/http'
require 'uri'
require 'json'

class BadRequest < StandardError
end
class Unauthorized < StandardError
end
class SummonerNotFound < StandardError
end
class RateLimitExceeded < StandardError
end
class InternalServerError < StandardError
end
class ServiceUnavailable < StandardError
end


class Summoners
  attr_reader :parsed_summ_hash
  
  URL = "https://na.api.pvp.net"
  REGION = "na"
  def initialize(name)
    @name = name
    @url = URI.parse(URL)
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
    @summ_hash = nil
    @parsed_summ_hash = {}
    set_json_obj(name)
    process_summ_hash
  end
  
  def to_s
    "Summoner: #{get_summoner_name}\nSummoner_ID: #{get_summoner_id}\nLevel: #{get_summoner_level}\n"
  end
  
  def get_summoner_id
    @parsed_summ_hash[:id]
  end
  
  def get_summoner_name
    @parsed_summ_hash[:name]
  end
  
  def get_prof_icon_id
    @parsed_summ_hash[:profileIconId]
  end
  
  def get_summoner_level
    @parsed_summ_hash[:summonerLevel]
  end
  
  def get_revision_date
    @parsed_summ_hash[:revisionDate]
  end
    
  private
  
  def check_response_error!(code)
    case code
    when "400"
      raise BadRequest.new("Bad Request, URL invalid")
    when "401"
      raise Unauthorized.new("Unauthorized.")
    when "404"
      raise SummonerNotFound.new("Can't find summoner with that name.")
    when "429"
      raise RateLimitExceeded.new("Made more than 10 requests/second.")
    when "500"
      raise InternalServerError.new("Riot's server's problem.")
    when "503"
      raise ServiceUnavailable.new("API down.")
    else
      puts "Request OK!"
    end
  end
  
  def return_http_response(name)
    req = Net::HTTP::Get.new("/api/lol/#{REGION}/v1.4/summoner/by-name/#{name}?api_key=36f1c100-9335-44e9-983c-89f4a9c520c1")
    response = @http.request(req)
    check_response_error!(response.code)
    
    response
  rescue => e
    puts e.message
    exit
  end
  
  def set_json_obj(name)
    @summ_hash = JSON.parse(return_http_response(name).body)[name]
  end
  
  def process_summ_hash
    @summ_hash.each do |key, value|
      @parsed_summ_hash[key.to_sym] = value
    end
  end
end

test = Summoners.new("kidvanilla")
puts test.to_s