require 'unirest'
REGION = "na"
name = "rflegendary"
url = "https://community-league-of-legends.p.mashape.com/api/v1.0/#{REGION}/summoner/retrieveInProgressSpectatorGameInfo/#{name}"

response = Unirest.get "https://na.api.pvp.net/api/lol/#{REGION}/v1.4/summoner/by-name/#{name}?api_key=36f1c100-9335-44e9-983c-89f4a9c520c1"
response2 = Unirest.get(url, headers:{ "X-Mashape-Key" => "q8rpseF8KLmshX1oPtPoCWPqNuWHp1gUKTPjsnspYRUw3J3FZT"} )
