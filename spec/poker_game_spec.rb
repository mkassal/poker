require_relative '../poker_game'
require_relative '../poker_round'

describe PokerGame do
  it "should raise an error if invalid file received for input" do
    expect {
      PokerGame.new("foo.txt").play_game
    }.to raise_error(/No such file or directory @ rb_sysopen - foo.txt/)
  end

  context "#play_hand" do
    let(:input_line) { "bar" }
    let(:poker_round) { instance_double "PokerRound" }

    before do
      allow(File).to receive(:readlines).with("foo.txt") { [input_line] }
      expect(PokerRound).to receive(:new).with(input_line) { poker_round }
    end

    it "should increment a counter if hand played returns a win for player 1" do
      allow(poker_round).to receive(:play_hand) { "Player 1 wins" }
      pg = PokerGame.new("foo.txt")
      expect(pg.player_1_score).to eq 0

      pg.play_game
      expect(pg.player_1_score).to eq 1
    end

    it "should NOT increment a counter if hand played returns a win for player 2" do
      allow(poker_round).to receive(:play_hand) { "Player 2 wins" }
      pg = PokerGame.new("foo.txt")

      pg.play_game
      expect(pg.player_1_score).to eq 0
    end
  end

end