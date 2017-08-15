require_relative '../player_hand'

describe PlayerHand do
  context "with exception handling" do
    it "should raise an error if nil param received" do
      expect {
        PlayerHand.new(nil)
      }.to raise_error(PlayerHand::InsufficientCardsError)
    end

    it "should raise an error if insufficient cards received" do
      expect {
        PlayerHand.new([1,2,3,4])
      }.to raise_error(PlayerHand::InsufficientCardsError)
    end
  end

  context "#high_card" do
    let(:input_line) { ["8C", "TS", "KC", "9H", "4S"] }
    let(:player_hand) { PlayerHand.new(input_line) }

    it "sets #high_card to 'K'" do
      expect(player_hand.high_card).to eq "K"
    end
  end

  context "#face_counts" do
    let(:input_line) { ["8C", "TS", "TC", "9H", "4S"] }
    let(:player_hand) { PlayerHand.new(input_line) }

    it "sets #face_counts appropriately" do
      expected_counts = {
        "8" => 1,
        "T" => 2,
        "9" => 1,
        "4" => 1
      }
      expect(player_hand.face_counts).to eq expected_counts
    end
  end

  context "#suit_counts" do
    let(:input_line) { ["8C", "TS", "TC", "9H", "4S"] }
    let(:player_hand) { PlayerHand.new(input_line) }

    it "sets #suit_counts appropriately" do
      expected_counts = {
        "C" => 2,
        "S" => 2,
        "H" => 1
      }
      expect(player_hand.suit_counts).to eq expected_counts
    end
  end

  context "#best_hand" do
    let(:player_hand) { PlayerHand.new(input_line) }

    context "with high card as best hand" do
      let(:input_line) { ["8C", "TS", "KC", "9H", "4S"] }

      it "returns :high_card" do
        expect(player_hand.best_hand).to eq :high_card
      end
    end

    context "with one pair as best hand" do
      let(:input_line) { ["8C", "8S", "KC", "9H", "4S"] }

      it "returns :one_pair" do
        expect(player_hand.best_hand).to eq :one_pair
      end
    end

    context "with two pair as best hand" do
      let(:input_line) { ["8C", "8S", "KC", "KH", "4S"] }

      it "returns :two_pair" do
        expect(player_hand.best_hand).to eq :two_pair
      end
    end

    context "with three of a kind as best hand" do
      let(:input_line) { ["8C", "8H", "KC", "KH", "8S"] }

      it "returns :three_of_a_kind" do
        expect(player_hand.best_hand).to eq :three_of_a_kind
      end
    end

    context "with straight as best hand" do
      let(:input_line) { ["8C", "9H", "TC", "JH", "KS"] }

      it "returns :straight" do
        expect(player_hand.best_hand).to eq :straight
      end
    end

  end

end