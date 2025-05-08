class_name Hand
extends Resource

var cards: Array[CardResource] = []
# NOTE: Implementation wise treat value as having 
var value: int = 0
# NOTE: want to display the highest one unless its bust??
var alt_value: int = 0
var has_ace_in_hand: bool

#TODO: this likely is not enough to handle ace logic. i.e if I have 4 aces there are 8 combo's of possible values
# this logic does not take into account that problem
func add_card_to_hand(card_to_add: CardResource) -> void:
	if card_to_add.rank == Enums.Rank.ACE:
		has_ace_in_hand = true
		alt_value += 1
	else:
		alt_value += card_to_add.value
	value += card_to_add.value
	
func is_bust() -> bool:
	var comparator = value
	if has_ace_in_hand:
		comparator = alt_value
	return comparator > Constants.BLACK_JACK
