# Poker
This app solves [Project Euler Poker Challenge](https://projecteuler.net/problem=54)

The app will read an input file [poker.txt](https://projecteuler.net/project/resources/p054_poker.txt), containing 1K plays between two players.

This program will determine the count of wins of the first player, with the first half of the input line specifying the first player's hand, and the second half specifying the second player's hand.  Traditional poker rules apply in the game play, with no wildcarding allowed.

## Requirements
I have tested on ruby versions 2.0 and 2.4.1

## Run instructions
To run, open irb, type in following:

```ruby
require './poker_game'

PokerGame.new("poker.txt").play_game
```

Output should match following for sample poker text provided:

```ruby
Player 1 wins 376 hands
```