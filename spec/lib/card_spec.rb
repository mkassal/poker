require_relative '../../lib/card'

describe Card do
  it "should raise an error if constructed without a card string" do
    expect {
      Card.new("")
    }.to raise_error(Card::EmptyCardError)
  end

  let(:card_str) { "AC" }
  let(:card) { Card.new(card_str) }

  context "#face" do
    it "should return the first character representing the face value" do
      expect(card.face).to eq "A"
    end
  end

  context "#suit" do
    it "should return the second character representing the suit of the card" do
      expect(card.suit).to eq "C"
    end
  end

end