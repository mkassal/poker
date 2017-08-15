class PokerRound
  attr_accessor :cards, :player_1_hand, :player_2_hand

  def initialize(input_line)
    cards = input_line.split(" ")
    @player_1_hand = PlayerHand.new(cards[0..4])
    @player_2_hand = PlayerHand.new(cards[5..9])
  end

  def play_hand
    case player_1_hand <=> player_2_hand

    # TODO: write to audit log also with extra info
    when -1
      return "Player 1 wins"
    when 0
      raise "Tie occurred - impossible?"
    else
      return "Player 2 wins"
    end
  end

  private

end