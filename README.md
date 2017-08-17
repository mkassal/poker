# Poker

This app solves (https://projecteuler.net/problem=54)

The app will read an input file [poker.txt](https://projecteuler.net/project/resources/p054_poker.txt), containing 1K plays between two players.

This program will determine the count of wins of player 1.

== Requirements
I have tested on ruby versions 2.0 and 2.4.1

== Run instructions
To run, open irb, type in following:

require './poker_game'
PokerGame.new("poker.txt").play_game

Output should match following for sample poker text provided:
=> Player 1 wins 376 hands