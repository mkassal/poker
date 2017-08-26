class Card

  FACE_CARDS_RANKED = [
    "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"
  ]

  def initialize(card_str)
    raise EmptyCardError if card_str.nil? || card_str.empty?
    @card_str = card_str
  end

  def face
    @card_str[0]
  end

  def suit
    @card_str[1]
  end

  class EmptyCardError < StandardError; end
end