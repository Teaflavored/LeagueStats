require_relative 'league.rb'
require_relative 'summoner.rb'

class SummInfo
  
  def initialize(name)
    @name = name
    @summoner = Summoners.new(@name)
    @league = League.new(@summoner.get_summoner_id)
  end
  
  def info
    puts "#{@summoner.to_s}"
    puts "#{@league.to_s}"
  end
  
end

if __FILE__ == $PROGRAM_NAME
  loop do
    begin
      puts "Which player would you like to search up?, enter q to quit"
      input = gets.chomp
      exit if input == 'q'
      raise InvalidInput error unless input.match(/\A\w+(\s\w+)*\z/)
      summinfo = SummInfo.new(input)
      summinfo.info
    rescue => e
      puts e.message
      retry
    end
  end
end