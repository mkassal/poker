require_relative "lib/poker_round"

class PokerGame
  attr_accessor :file_name, :player_1_score

  def initialize(file_name)
    @player_1_score = 0
    @file_name = file_name
  end

  def play_game
    File.readlines(file_name).each do |line|
      result = PokerRound.new(line).play_hand

      if result == "Player 1 wins"
        @player_1_score += 1
      end
    end

    puts "Player 1 wins #{@player_1_score} hands"
  end
end