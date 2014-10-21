require_relative 'summoner.rb'
require 'unirest'
class League
  def initialize(summoner_id)
    @id = summoner_id
    @response = Unirest.get "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/#{@id}?api_key=36f1c100-9335-44e9-983c-89f4a9c520c1"
    @json_obj = parse_response_body
    @entries = league_entries
    @current_player_entry = nil
    set_current_player_entry
  end
  
  
  def list_each_entry_in_league
    @entries.each do |entry|
      puts "Player #{entry["playerOrTeamName"]} is in #{player_current_tier} #{entry["division"]} with #{entry["leaguePoints"]} LP"
    end
  end
  
  def solo_league_name
    @json_obj["name"]
  end
  
  def player_current_tier
    @json_obj["tier"]
  end
  
  def type_of_queue
    @json_obj["queue"]
  end
  
  def to_s
    "Your current league is #{solo_league_name} and your rank is #{player_current_tier} #{@current_player_entry["division"]} 
    with #{@current_player_entry["leaguePoints"]} LP in #{type_of_queue}"
  end
  
  private
  
  def parse_response_body
    raise "Player does not have associated ranked league information" if @response.body.empty?
    @response.body[@id.to_s][0]
  end
  
  def league_entries
    @json_obj["entries"]
  end
  
  def set_current_player_entry
    @entries.each do |entry|
      @current_player_entry = entry if entry["playerOrTeamId"].to_i == @id
    end
  end
  
end
