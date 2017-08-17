require_relative '../../lib/card'
require_relative '../../lib/player_hand'

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

  context "#high_card" do
    let(:input_line) { ["8C", "AS", "TC", "TH", "4S"] }
    let(:player_hand) { PlayerHand.new(input_line) }

    it "sets high card appropriately" do
      expect(player_hand.high_card).to eq "A"
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
      let(:input_line) { ["8C", "8H", "KC", "JH", "8S"] }

      it "returns :three_of_a_kind" do
        expect(player_hand.best_hand).to eq :three_of_a_kind
      end
    end

    context "with straight as best hand" do
      let(:input_line) { ["9C", "8H", "TC", "JH", "QS"] }

      it "returns :straight" do
        expect(player_hand.best_hand).to eq :straight
      end
    end

    context "with flush as best hand" do
      let(:input_line) { ["2C", "8C", "TC", "JC", "QC"] }

      it "returns :flush" do
        expect(player_hand.best_hand).to eq :flush
      end
    end

    context "with full house as best hand" do
      let(:input_line) { ["2S", "2H", "2C", "JC", "JH"] }

      it "returns :full_house" do
        expect(player_hand.best_hand).to eq :full_house
      end
    end

    context "with four of a kind as best hand" do
      let(:input_line) { ["2S", "2H", "2C", "2D", "JH"] }

      it "returns :four_of_a_kind" do
        expect(player_hand.best_hand).to eq :four_of_a_kind
      end
    end

    context "with straight flush as best hand" do
      let(:input_line) { ["2S", "3S", "4S", "5S", "6S"] }

      it "returns :straight_flush" do
        expect(player_hand.best_hand).to eq :straight_flush
      end
    end

    context "with royal flush as best hand" do
      let(:input_line) { ["AS", "JS", "QS", "KS", "TS"] }

      it "returns :royal_flush" do
        expect(player_hand.best_hand).to eq :royal_flush
      end
    end
  end

  context "#<=> comparing" do
    let(:hand_str) { ["8C", "TS", "KC", "KH", "4S"] }
    let(:hand) { PlayerHand.new(hand_str) }
    let(:other_hand) { PlayerHand.new(other_hand_str) }

    context "against other hand of lower rank" do
      let(:other_hand_str) { ["8C", "TS", "KC", "9H", "4S"] }

      it "returns 1" do
        expect(hand <=> other_hand).to eq 1
      end
    end

    context "against other hand of greater rank" do
      let(:other_hand_str) { ["8C", "TS", "KC", "KH", "7S"] }

      it "returns -1" do
        expect(hand <=> other_hand).to eq -1
      end
    end

    context "against other hands of equal rank, with different face cards" do

      context "with other hand with face cards of higher rank" do
        let(:other_hand_str) { ["8D", "TC", "KD", "KS", "5H"] }

        it "returns -1" do
          expect(hand <=> other_hand).to eq -1
        end
      end

      context "with other hand with face cards of lower rank" do
        let(:other_hand_str) { ["8C", "TS", "KC", "9H", "4S"] }

        it "returns 1" do
          expect(hand <=> other_hand).to eq 1
        end
      end

      context "with full house hand" do
        let(:hand_str) { ["8C", "8S", "8C", "AH", "AS"] }

        context "against other hand with grouping of 3 face cards ranked higher than current grouping of 3" do
          let(:other_hand_str) { ["KD", "KC", "KD", "5S", "5H"] }

          it "returns -1" do
            expect(hand <=> other_hand).to eq -1
          end
        end

        context "against other hand with grouping of 3 ranked lower than current grouping of 3" do
          let(:other_hand_str) { ["2D", "2C", "2D", "AS", "AH"] }

          it "returns 1" do
            expect(hand <=> other_hand).to eq 1
          end
        end
      end
    end
  end

  context "#face_card_rankings_grouped" do
    let(:hand) { PlayerHand.new(hand_str) }

    context "with high card" do
      let(:hand_str) { ["8C", "TS", "KC", "QH", "4S"] }

      it "returns array with rank of face cards in descending order" do
        expect(hand.face_card_rankings_grouped).to eq [11, 10, 8, 6, 2]
      end
    end

    context "with 4 of a kind" do
      let(:hand_str) { ["8C", "8S", "8H", "8D", "4S"] }

      it "returns grouped array with rank of face cards in descending order" do
        expect(hand.face_card_rankings_grouped).to eq [6, 2]
      end
    end

    context "with full house" do
      let(:hand_str) { ["8C", "8S", "8H", "4D", "4S"] }

      it "returns grouped array with rank of face cards in descending order" do
        expect(hand.face_card_rankings_grouped).to eq [6, 2]
      end
    end

    context "with 3 of a kind" do
      let(:hand_str) { ["8C", "8S", "8H", "3D", "4S"] }

      it "returns grouped array with rank of face cards in descending order" do
        expect(hand.face_card_rankings_grouped).to eq [6, 2, 1]
      end
    end

    context "with two pair" do
      let(:hand_str) { ["JC", "JS", "8H", "8D", "4S"] }

      it "returns grouped array with rank of face cards in descending order" do
        expect(hand.face_card_rankings_grouped).to eq [9, 6, 2]
      end
    end
  end
 end