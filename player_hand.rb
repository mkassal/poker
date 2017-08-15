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
    @cards = cards
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
      if CARD_RANKINGS.index(card_face(card)) > CARD_RANKINGS.index(high_card)
        @high_card = card_face(card)
      end
    end
  end

  def royal_flush?
    return false
  end

  def straight_flush?
    return false
  end

  def four_of_a_kind?
    return false
  end

  def full_house?
    return false
  end

  def flush?
    return false
  end

  def straight?
    cards.each

    if
      return true
    else
      return false
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

  def set_counts
    @face_counts = {}
    @suit_counts = {}

    cards.each do |card|
      face = card[0]
      suit = card[1]
      if face_counts[face].nil?
        @face_counts[face] = 1
      else
        @face_counts[face] += 1
      end

      if suit_counts[suit].nil?
        @suit_counts[suit] = 1
      else
        @suit_counts[suit] += 1
      end
    end
  end

  # returns one element array of [face_value, match_count]
  def max_face_card_match
    @max_face_card_match ||= face_counts.max_by{|face_card,match_count| match_count}
  end

  def face_pairs_count
    face_counts.values.count(2)
  end

  # assumes this method is checked last
  def high_card?
    return true
  end

  def card_face(card)
    card[0]
  end

  def card_suit(card)
    card[1]
  end

  class InsufficientCardsError < StandardError; end
  class EqualHandError < StandardError; end
  class NoHandFoundException < StandardError; end
end

