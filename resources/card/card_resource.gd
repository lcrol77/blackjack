class_name CardResource
extends Resource

@export_category("Data")
@export var suit: Enums.Suit
@export var rank: Enums.Rank

var name: String
var value: int
var skin_coordinates: Vector2i


func _init(r: String ="", s: String="") -> void:
	if r != "":
		suit = Enums.Suit[s]
	if s != "":
		rank = Enums.Rank[r]
	name = get_card_name()
	if rank == Enums.Rank.JACK or rank == Enums.Rank.QUEEN or rank == Enums.Rank.KING:
		value = 10
	elif rank == Enums.Rank.ACE:
		value = 11
	else:
		value = rank + 1 
	skin_coordinates = Vector2i(rank, suit)
	
func _to_string() -> String:
	return name

func get_card_name() -> String:
	return get_rank_name(rank) + " of " + get_suit_name(suit)

func get_suit_name(suit: Enums.Suit) -> String:
	return Enums.Suit.keys()[suit]

func get_rank_name(rank: Enums.Rank) -> String:
	return Enums.Rank.keys()[rank]
