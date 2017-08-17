require_relative '../../lib/poker_round'

describe PokerRound do
  context "#play_hand" do
    let(:input_line) { "1 2 3 4 5 6 7 8 9 0" }
    let(:poker_round) { PokerRound.new(input_line) }
    let(:player_1_hand) { instance_double "PlayerHand" }
    let(:player_2_hand) { instance_double "PlayerHand" }

    before do
      allow(PlayerHand).to receive(:new)
        .with(input_line.split(" ")[0..4])
        .and_return(player_1_hand)
      allow(PlayerHand).to receive(:new)
        .with(input_line.split(" ")[5..9])
        .and_return(player_2_hand)
    end

    context "with player 1 winning" do
      it "should return 'Player 1 wins'" do
        allow(player_1_hand).to receive(:<=>).with(player_2_hand) { 1 }

        expect(poker_round.play_hand).to eq "Player 1 wins"
      end
    end

    context "with player 2 winning" do
      it "should return 'Player 2 wins'" do
        allow(player_1_hand).to receive(:<=>).with(player_2_hand) { -1 }

        expect(poker_round.play_hand).to eq "Player 2 wins"
      end
    end

    context "with tie" do
      it "should raise TiedHandError" do
        allow(player_1_hand).to receive(:<=>).with(player_2_hand) { 0 }

        expect {
          poker_round.play_hand
        }.to raise_error(PokerRound::TiedHandError)
      end
    end
  end
end