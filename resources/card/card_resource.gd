class_name CardResource
extends Resource

@export var name: String
@export_category("Data")
@export var suit: Enums.Suit
@export var rank: Enums.Rank
@export var value: int
@export_category("Visuals")
@export var skin_coordinates: Vector2i

func _init(r: String, s: String) -> void:
	suit = Enums.Suit[s]
	rank= Enums.Rank[r]
	name = get_card_name()
	if rank == Enums.Rank.JACK or rank == Enums.Rank.QUEEN or rank == Enums.Rank.KING:
		value = 10
	elif rank == Enums.Rank.ACE:
		value = 11
	else:
		value = rank 
	skin_coordinates = Vector2i(rank, suit)
	
func _to_string() -> String:
	return name

func get_card_name() -> String:
	return get_rank_name(rank) + " of " + get_suit_name(suit)

# TODO: fix this shit
func get_suit_name(suit: Enums.Suit) -> String:
	var suit_name: String
	match suit:
		Enums.Suit.SPADES:
			suit_name= "Spades"
		Enums.Suit.CLUBS:
			suit_name= "Clubs"
		Enums.Suit.HEARTS:
			suit_name= "Hearts"
		Enums.Suit.DIAMONDS:
			suit_name= "Diamonds"
		_:
			suit_name = "Invalid Suit"
	return suit_name


func get_rank_name(rank: Enums.Rank) -> String:
	var rank_name: String
	match rank:
		Enums.Rank.TWO:
			rank_name= "Two"
		Enums.Rank.THREE:
			rank_name= "Three"
		Enums.Rank.FOUR:
			rank_name= "Four"
		Enums.Rank.FIVE:
			rank_name= "Five"
		Enums.Rank.SIX:
			rank_name= "Six"
		Enums.Rank.SEVEN:
			rank_name= "Seven"
		Enums.Rank.EIGHT:
			rank_name= "Eight"
		Enums.Rank.NINE:
			rank_name= "Nine"
		Enums.Rank.TEN:
			rank_name= "Ten"
		Enums.Rank.JACK:
			rank_name= "Jack"
		Enums.Rank.QUEEN:
			rank_name= "Queen"
		Enums.Rank.KING:
			rank_name= "King"
		Enums.Rank.ACE:
			rank_name= "Ace"
	return rank_name
