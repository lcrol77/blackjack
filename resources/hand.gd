class_name Hand
extends Resource

var cards: Array[CardResource] = []
var values: Array[int]

#TODO: this likely is not enough to handle ace logic. i.e if I have 4 aces there are 8 combo's of possible values
# this logic does not take into account that problem
func add_card_to_hand(card_to_add: CardResource) -> void:
	cards.append(card_to_add)
	values = calc_card_value_permutations()

func calc_card_value_permutations() -> Array[int]:
	var base_value: int = 0
	var number_aces: int = 0
	var ans: Array[int] = []
	for card: CardResource in cards:
		if card.rank == Enums.Rank.ACE:
			number_aces += 1
		else:
			base_value += card.value
	_backtrack(base_value, ans, number_aces)
	return ans

func _backtrack(curr: int, ans: Array[int], number_aces: int) -> void:
	if number_aces == 0:
		if not ans.has(curr):
			ans.append(curr)
		return
	for i in [1,11]:
		curr += i
		_backtrack(curr, ans, number_aces - 1)
		curr -= i

func get_non_bust_values() -> Array[int]:
	return values.filter(func(value: int): return value <= Constants.BLACK_JACK)

func is_bust() -> bool:
	return values.all(func(value:int): return value > Constants.BLACK_JACK)
