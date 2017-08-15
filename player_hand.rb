require 'pry'

class PlayerHand
  attr_accessor :cards, :high_card, :face_counts, :suit_counts

  BEST_HANDS_RANKED = [
    :high_card,
    :one_pair,
    :two_pair,
    :three_of_a_kind,
    :straight,
    :flush,
    :full_house,
    :four_of_a_kind,
    :straight_flush,
    :royal_flush
  ]

  CARD_RANKINGS = [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "T",
    "J",
    "Q",
    "K",
    "A"
  ]

  SUITS = [
    "H",
    "C",
    "D",
    "S"
  ]

  def initialize(cards)
    raise InsufficientCardsError if missing_cards?(cards)
    @cards = cards.map { |card| Card.new(card) }
    set_high_card
    set_counts
  end

  def best_hand
    @best_hand ||= check_hands_in_ranked_order
  end

  def <=> other_hand
    if BEST_HANDS_RANKED.index(best_hand) > BEST_HANDS_RANKED.index(other_hand.best_hand)
      return 1
    elsif BEST_HANDS_RANKED.index(best_hand) == BEST_HANDS_RANKED.index(other_hand.best_hand)
      # tied hand - use high card as tie breaker
      # need to check second high card if pair or full house?
      if high_card > other_hand.high_card
        return 1
      elsif high_card < other_hand.high_card
        return -1
      else
        #high card is equal for equal hand, how to handle?
        raise EqualHandError
      end
    else
      #other hand better than this hand
      return -1
    end
  end

  private

  # Check from best - worst what hand we have
  # This ensures we will return the best hand
  def check_hands_in_ranked_order
    BEST_HANDS_RANKED.reverse_each do |current_hand|
      #think of more elegant way to structure this
      puts "check for current_hand #{current_hand}"
      break current_hand if have_current_hand?(current_hand)
    end
  end

  def missing_cards?(cards)
    cards.nil? || !cards.is_a?(Array) || cards.size < 5
  end

  def have_current_hand?(hand)
    method = (hand.to_s + "?").to_sym
    self.send(method)
  end

  def set_high_card
    @high_card = CARD_RANKINGS[0] # initialize high card to lowest ordered card

    cards.each do |card|
      if CARD_RANKINGS.index(card.face) > CARD_RANKINGS.index(high_card)
        @high_card = card.face
      end
    end
  end

  def royal_flush?
    if sequential_ranking? && max_suit_match_count == 5 && high_card == "A"
      return true
    else
      return false
    end
  end

  def straight_flush?
    if sequential_ranking? && max_suit_match_count == 5
      return true
    else
      return false
    end
  end

  def four_of_a_kind?
    if max_face_card_match[1] == 4
      return true
    else
      return false
    end
  end

  def full_house?
    if face_count_values.include?(3) &&
       face_count_values.include?(2)
      return true
    else
      return false
    end
  end

  def flush?
    if max_suit_match_count == 5
      return true
    else
      return false
    end
  end

  def straight?
    if sequential_ranking?
      return true
    else
      return false
    end
  end

  # Use each_cons to breakup sorted cards into tuples of length two
  # and check sequential (http://ruby-doc.org/core-2.1.0/Enumerable.html#method-i-each_cons)
  def sequential_ranking?
    sorted_cards
      .each_cons(2)
      .all? do |a, b|
        CARD_RANKINGS.index(b.face) == CARD_RANKINGS.index(a.face) + 1
      end
  end

  # Since card faces are alphnumeric, sort using rank order instead
  def sorted_cards
    @sorted_cards ||= cards.sort_by do |card|
      CARD_RANKINGS.index(card.face)
    end
  end

  def three_of_a_kind?
    if max_face_card_match[1] == 3
      return true
    else
      return false
    end
  end

  def two_pair?
    if max_face_card_match[1] == 2 && face_pairs_count == 2
      return true
    else
      return false
    end
  end

  def one_pair?
    if max_face_card_match[1] == 2
      return true
    else
      return false
    end
  end

  # assumes this method is checked last
  def high_card?
    return true
  end

  def set_counts
    @face_counts = {}
    @suit_counts = {}

    cards.each do |card|
      if face_counts[card.face].nil?
        @face_counts[card.face] = 1
      else
        @face_counts[card.face] += 1
      end

      if suit_counts[card.suit].nil?
        @suit_counts[card.suit] = 1
      else
        @suit_counts[card.suit] += 1
      end
    end
  end

  # returns one element array of [face_value, match_count]
  def max_face_card_match
    @max_face_card_match ||= face_counts.max_by{ |face_card, match_count| match_count }
  end

  # returns max suit match count
  def max_suit_match_count
    @max_suit_match_count ||= suit_counts.max_by{ |suit_card, match_count| match_count }[1]
  end

  def face_pairs_count
    face_count_values.count(2)
  end

  def face_count_values
    @face_count_values ||= face_counts.values
  end

  class Card
    def initialize(card_str)
      @card_str = card_str
    end

    def face
      @card_str[0]
    end

    def suit
      @card_str[1]
    end
  end

  class InsufficientCardsError < StandardError; end
  class EqualHandError < StandardError; end
  class NoHandFoundException < StandardError; end
end

