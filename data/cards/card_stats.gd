class_name CardStats
extends Resource

enum Suit {CLUBS, HEARTS, SPADES,DIAMONDS}
enum Rank {TWO,THREE, FOUR,FIVE, SIX,SEVEN, EIGHT,NINE, TEN, JACK, QUEEN, KING, ACE}

@export var name: String
@export_category("Data")
@export var suit: Suit
@export var rank: Rank
@export var value: int
@export var alt_value: int
@export_category("Visuals")
@export var skin_coordinates: Vector2i

func _to_string() -> String:
	return name
