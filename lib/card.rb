class Card
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