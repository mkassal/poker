require_relative "card"

class PlayerHand
  attr_accessor :cards, :face_counts, :suit_counts, :high_card

  HANDS_RANKED = [
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

  FACE_CARDS_RANKED = [
    "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"
  ]

  SUITS = [
    "H", "C", "D", "S"
  ]

  def initialize(cards)
    raise InsufficientCardsError if missing_cards?(cards)
    @cards = cards.map { |card| Card.new(card) }
    @high_card = face_cards_ascending.last
    @face_card_rankings_grouped = []
    set_face_and_suit_counts
  end

  # Compare this player's hand against other hand
  def <=> other_hand
    #puts "check #{face_cards_descending} against other hand #{other_hand.face_cards_descending}"
    if HANDS_RANKED.index(best_hand) > HANDS_RANKED.index(other_hand.best_hand)
      return 1
    elsif HANDS_RANKED.index(best_hand) == HANDS_RANKED.index(other_hand.best_hand)
      # equivalent hand type - use face cards to determine who wins
      #puts "tied hand - check #{face_card_rankings_grouped} against #{other_hand.face_card_rankings_grouped}"
      return face_card_rankings_grouped <=> other_hand.face_card_rankings_grouped
    else
      #other hand lower than this hand
      return -1
    end
  end

  # Return highest hand received regardless of face_card values
  # Value will be one taken from HANDS_RANKED, checked in Rank order
  def best_hand
    @best_hand ||= check_hands_in_ranked_order
  end

  # Group rank order of high cards into array for use as comparator for tie breaker
  # e.g. 8C 8S 8D 5C JS will be grouped as [6, 9, 3]
  # If no groupings found, put high cards in rank order
  def face_card_rankings_grouped
    return @face_card_rankings_grouped if !@face_card_rankings_grouped.empty?

    #iterate pushing four of a kind onto grouped list
    check_for_matching_sets_of(4)
    #iterate checking now for three of a kind
    check_for_matching_sets_of(3)
    #iterate checking now for pairs
    check_for_matching_sets_of(2)

    #now we have grouped list with matches, add remaining face cards to @face_card_rankings_grouped
    face_cards_descending.uniq.each do |fc|
      if !@face_card_rankings_grouped.include?(fc)
        @face_card_rankings_grouped << fc
      end
    end

    #convert cards to ranked number representations to allow integer comparison
    @face_card_rankings_grouped.map! { |card| FACE_CARDS_RANKED.index(card) }
  end


  private

  def face_cards_descending
    @face_cards_descending ||= face_cards_ascending.reverse
  end

  def check_for_matching_sets_of(face_count)
    face_cards_descending.uniq.each do |face_card|
      if face_counts[face_card] == face_count
        @face_card_rankings_grouped << face_card
      end
    end
  end

  # Check from best - worst what hand we have
  # Exit iteration once we find best hand
  # Logic in methods assumes called in best to worst order
  def check_hands_in_ranked_order
    HANDS_RANKED.reverse_each do |current_hand|
      break current_hand if have_current_hand?(current_hand)
    end
  end

  def missing_cards?(cards)
    cards.nil? || !cards.is_a?(Array) || cards.size < 5
  end

  # Dynamically call methods corresponding to elements in
  # HANDS_RANKED in order to determine what hand player has
  def have_current_hand?(hand)
    method = ("#{hand}?").to_sym
    self.send(method)
  end

  def royal_flush?
    sequential_ranking? &&
      max_suit_count == 5 &&
      high_card == "A"
  end

  def straight_flush?
    sequential_ranking? && max_suit_count == 5
  end

  def four_of_a_kind?
    max_face_card_count == 4
  end

  def full_house?
    face_count_values.include?(3) &&
      face_count_values.include?(2)
  end

  def flush?
    max_suit_count == 5
  end

  def straight?
    sequential_ranking?
  end

  def three_of_a_kind?
    max_face_card_count == 3
  end

  def two_pair?
    # with hand of 5 cards, only two pairs should be possible
    face_pairs_count == 2
  end

  def one_pair?
    max_face_card_count == 2
  end

  # all other checks failed, no matches, flushes, or straights found
  def high_card?
    true
  end

  # Use each_cons to breakup sorted cards into tuples of length two
  # and check sequential (http://ruby-doc.org/core-2.1.0/Enumerable.html#method-i-each_cons)
  def sequential_ranking?
    @sequential_ranking ||=
      face_cards_ascending
        .each_cons(2)
        .all? do |a, b|
          FACE_CARDS_RANKED.index(b) == FACE_CARDS_RANKED.index(a) + 1
        end
  end

  # Since card faces are alphanumeric, sort using rank order instead
  def face_cards_ascending
    @face_cards_ascending ||= cards.sort_by do |card|
      FACE_CARDS_RANKED.index(card.face)
    end.map(&:face)
  end

  # sets two hashes,
  # @face_counts is keyed by face_card and num occurrances as value
  # @suit_counts is keyed by suit and num occurrances as value
  def set_face_and_suit_counts
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

  # returns highest count of repeated face cards in hand
  def max_face_card_count
    @max_face_card_count ||= face_counts.max_by{ |face_card, face_card_count| face_card_count }[1]
  end

  # returns highest count of repeated suits in hand
  def max_suit_count
    @max_suit_count ||= suit_counts.max_by{ |suit_card, suit_count| suit_count }[1]
  end

  #count number of pairs occuring in hand
  def face_pairs_count
    face_count_values.count(2)
  end

  def face_count_values
    @face_count_values ||= face_counts.values
  end

  class InsufficientCardsError < StandardError; end
end

