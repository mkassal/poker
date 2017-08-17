require_relative "player_hand"

class PokerRound
  attr_accessor :cards, :player_1_hand, :player_2_hand

  def initialize(input_line)
    cards = input_line.split(" ")
    @player_1_hand = PlayerHand.new(cards[0..4])
    @player_2_hand = PlayerHand.new(cards[5..9])
  end

  def play_hand
    case player_1_hand <=> player_2_hand

    when 1
      return "Player 1 wins"
    when 0
      raise TiedHandError
    else
      return "Player 2 wins"
    end
  end

  class TiedHandError < StandardError; end
end