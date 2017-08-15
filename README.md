Poker
================

This app solves https://projecteuler.net/problem=54

The app will read an input file poker.txt, containing 1K plays between two players.

https://projecteuler.net/project/resources/p054_poker.txt

The app will determine based off the input file which player wins, and keep count of the score, and determine the winning hand.

Ideas:
- rules engine - input 2 hands and output winner, A or B
- would be helpful to output individual plays to a file, and rank players

Models used:

- PokerGame.new(file.txt)#play_game
  - reads file line by line
  - accumulates tallies of player wins
  - displays output showing how many hands player 1 won.

- PokerRound.new(player_a_hand, player_b_hand)#play_hand
    -returns "a" or "b" as winner
    -logs play to play_audit.txt

- PlayerHand.new()
  - cards[0..4]

- Card
  - suit  String
  - value String

