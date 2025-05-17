@tool
class_name CardResource
extends Resource

@export_category("Data")
@export var suit: Enums.Suit: set = _set_suit
@export var rank: Enums.Rank: set = _set_rank

var name: String: get = get_card_name
var value: int
var skin_coordinates: Vector2i = Vector2i.ZERO

func _set_suit(curr_suit: Enums.Suit) -> void:
	suit = curr_suit
	skin_coordinates.y = curr_suit

func _set_rank(curr_rank: Enums.Rank) -> void:
	rank = curr_rank
	if rank == Enums.Rank.JACK or rank == Enums.Rank.QUEEN or rank == Enums.Rank.KING:
		value = 10
	elif rank == Enums.Rank.ACE:
		value = 11
	else:
		value = rank + 1 
	skin_coordinates.x = curr_rank

func _to_string() -> String:
	return name

func get_card_name() -> String:
	return get_rank_name(rank) + " of " + get_suit_name(suit)

func get_suit_name(s: Enums.Suit) -> String:
	return Enums.Suit.keys()[s]

func get_rank_name(r: Enums.Rank) -> String:
	return Enums.Rank.keys()[r]
