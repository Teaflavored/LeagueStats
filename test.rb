#36f1c100-9335-44e9-983c-89f4a9c520c1
require 'net/http'
require 'uri'
require 'json'

url = URI.parse("https://na.api.pvp.net")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
#setup

req = Net::HTTP::Get.new("/api/lol/na/v1.4/summoner/20872618/masteries?api_key=36f1c100-9335-44e9-983c-89f4a9c520c1")
response = http.request(req)
mastery = JSON.parse(response.body)

id_to_rank = Hash.new

first_page = mastery["20872618"]["pages"].first["masteries"]
first_page.each do |mastery|
  id_to_rank[mastery["id"]] = mastery["rank"]
end


mastery_desc = []

id_to_rank.each do |id, rank| 
  request = Net::HTTP::Get.new("/api/lol/static-data/na/v1.2/mastery/#{id}?masteryData=ranks&api_key=36f1c100-9335-44e9-983c-89f4a9c520c1")
  mastery_desc << JSON.parse(http.request(request).body)
end


mastery_desc.each do |mastery|
  puts "Name is #{mastery["name"]}"
  rank = id_to_rank[mastery["id"]]
  puts "Current rank is #{rank}"
  puts "Current desc is #{mastery["description"][rank - 1]}"
end